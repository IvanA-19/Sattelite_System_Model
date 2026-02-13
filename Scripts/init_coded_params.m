%% init_coded_params.m
% Инициализация параметров для модели с кодеками
% Вызывается из run_coded_sweep.m

clear global;
close all;

%% ============= ПАРАМЕТРЫ СИМУЛЯЦИИ =============
sim_params.stop_time = '1e5';
sim_params.solver = 'FixedStep';
sim_params.step_size = '1';

%% ============= ПАРАМЕТРЫ ПЕРЕДАТЧИКА =============
tx_params.bernoulli_prob = 0.5;
tx_params.sample_time = 1;
tx_params.phase_offset = pi/4;
tx_params.modulator_output = 'Complex';
tx_params.integer_output = 'on';

%% ============= ПАРАМЕТРЫ КАНАЛА =============
channel_params.mode = 'Eb/No (dB)';
channel_params.input_power = 1;

%% ============= ПАРАМЕТРЫ КОДИРОВАНИЯ =============
coding_params.frame_size = 1024;      % размер кадра для LDPC/Turbo
coding_params.trellis_conv = poly2trellis(7, [171 133]);
coding_params.trellis_turbo = poly2trellis(4, [13 15], 13);
coding_params.ldpc_matrix = dvbs2ldpc(1/2);
coding_params.interleaver = randperm(coding_params.frame_size) - 1;
coding_params.turbo_iter = 6;
coding_params.viterbi_traceback = 42;

% Задержки кодеров (в битах)
coding_delays.Conv = 7;
coding_delays.LDPC = coding_params.frame_size;
coding_delays.Turbo = coding_params.frame_size * 2;
coding_delays.None = 0;

% Скорости кода
coding_rates.Conv = 1/2;
coding_rates.LDPC = 1/2;
coding_rates.Turbo = 1/3;
coding_rates.None = 1;

%% ============= ПАРАМЕТРЫ ПРИЕМНИКА =============
rx_params.demod_type = 'Bit';
rx_params.decision_type = 'Hard decision';
rx_params.receive_delay = 0;  % будет переопределено в цикле

%% ============= ПАРАМЕТРЫ ВИЗУАЛИЗАЦИИ =============
viz_params.constellation_samples = 5000;
viz_params.eye_samples_per_symbol = 4;
viz_params.eye_snr_preview = 15;

%% ============= ПАРАМЕТРЫ СБОРА ДАННЫХ =============
sweep_params.EbNo_dB = 0:2:12;
sweep_params.M_values = [2, 4, 8];
sweep_params.coding_schemes = {'None', 'Conv', 'LDPC', 'Turbo'};
sweep_params.coding_names = {'Без кодирования', 'Сверточный (1/2)', ...
                             'LDPC (1/2)', 'Turbo (1/3)'};
sweep_params.min_errors = 100;
sweep_params.max_snr = 12;

%% ============= ПРИМЕНЕНИЕ ПАРАМЕТРОВ В WORKSPACE =============

% Передатчик
assignin('base', 'bern_prob', tx_params.bernoulli_prob);
assignin('base', 'Ts', tx_params.sample_time);
assignin('base', 'phase_offset', tx_params.phase_offset);
assignin('base', 'M', 2);  % значение по умолчанию

% Кодирование
assignin('base', 'FrameSize', coding_params.frame_size);
assignin('base', 'trellis_conv', coding_params.trellis_conv);
assignin('base', 'trellis_turbo', coding_params.trellis_turbo);
assignin('base', 'ldpc_matrix', coding_params.ldpc_matrix);
assignin('base', 'interleaver', coding_params.interleaver);
assignin('base', 'turbo_iter', coding_params.turbo_iter);
assignin('base', 'traceback', coding_params.viterbi_traceback);

% Задержки и скорости - сохраняем структуры целиком
assignin('base', 'coding_delays', coding_delays);
assignin('base', 'coding_rates', coding_rates);
assignin('base', 'CodingScheme', 'None');  % по умолчанию

% Канал
assignin('base', 'chan_mode', channel_params.mode);
assignin('base', 'chan_power', channel_params.input_power);
assignin('base', 'EbNo_curr', 10);  % по умолчанию

% Приемник
assignin('base', 'rx_decision', rx_params.decision_type);

% Визуализация
assignin('base', 'const_samples', viz_params.constellation_samples);
assignin('base', 'eye_sps', viz_params.eye_samples_per_symbol);
assignin('base', 'eye_snr', viz_params.eye_snr_preview);

%% ============= ПРИМЕНЕНИЕ ПАРАМЕТРОВ МОДЕЛИ =============
try
    set_param('psk_model_coded', 'StopTime', sim_params.stop_time);
    set_param('psk_model_coded', 'Solver', sim_params.solver);
    set_param('psk_model_coded', 'FixedStep', sim_params.step_size);
catch
    warning('Модель psk_coded_model.slx не открыта. Параметры будут применены при открытии.');
end

%% ============= ПРОВЕРКА ТУЛБОКСОВ =============
if ~license('test', 'communication_toolbox')
    error('Communications Toolbox не установлен! Необходим для работы кодеров.');
end

if ~license('test', 'signal_processing_toolbox')
    warning('Signal Processing Toolbox не установлен. Некоторые функции могут быть недоступны.');
end

%% ============= СОЗДАНИЕ ПАПОК =============
if ~exist('Results/coded', 'dir')
    mkdir('Results/coded');
    fprintf('✓ Создана папка Results/coded/\n');
end

if ~exist('Results/base', 'dir')
    mkdir('Results/base');
    fprintf('✓ Создана папка Results/base/\n');
end

%% ============= ФУНКЦИЯ ДЛЯ ПОЛУЧЕНИЯ ПАРАМЕТРОВ КОДЕКА =============
% Эта функция будет доступна в workspace
coding_utils.get_rate = @(scheme) coding_rates.(scheme);
coding_utils.get_delay = @(scheme) coding_delays.(scheme);
coding_utils.get_name = @(scheme) sweep_params.coding_names{ ...
    find(strcmp(sweep_params.coding_schemes, scheme)) };

assignin('base', 'coding_utils', coding_utils);

%% ============= ВЫВОД ИНФОРМАЦИИ =============
fprintf('\n========================================\n');
fprintf('🚀 ПАРАМЕТРЫ КОДИРОВАННОЙ МОДЕЛИ\n');
fprintf('========================================\n');
fprintf('📊 Симуляция: %s отсчетов\n', sim_params.stop_time);
fprintf('🎚️  Сдвиг фазы: %.2f rad\n', tx_params.phase_offset);
fprintf('📦 Размер кадра: %d бит\n', coding_params.frame_size);
fprintf('\n📈 Доступные кодеки:\n');
for i = 1:length(sweep_params.coding_schemes)
    rate = coding_rates.(sweep_params.coding_schemes{i});
    delay = coding_delays.(sweep_params.coding_schemes{i});
    fprintf('  • %s: R = %.2f, задержка = %d бит\n', ...
        sweep_params.coding_names{i}, rate, delay);
end
fprintf('========================================\n\n');

%% ============= СОХРАНЕНИЕ ПАРАМЕТРОВ =============
save('Results/coded/coded_params_backup.mat', ...
    'sim_params', 'tx_params', 'channel_params', ...
    'coding_params', 'coding_delays', 'coding_rates', ...
    'rx_params', 'viz_params', 'sweep_params');

fprintf('✓ Параметры сохранены в Results/coded/coded_params_backup.mat\n');
fprintf('========================================\n');