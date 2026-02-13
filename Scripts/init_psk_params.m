%% init_psk_params.m
% Инициализация параметров для модели PSK модуляции
% Вызывается из run_ber_sweep.m перед началом симуляции

clear global;  % очистка глобальных переменных (на всякий случай)

%% Параметры симуляции (общие)
sim_params.stop_time = '1e5';      % количество бит/символов для симуляции
sim_params.solver = 'FixedStep';
sim_params.step_size = '1';

%% Параметры передатчика
tx_params.bernoulli_prob = 0.5;    % вероятность нуля
tx_params.sample_time = 1;         % время дискретизации
tx_params.phase_offset = 0;     % стандартный сдвиг для QPSK/8-PSK

%% Параметры канала (умолчания)
channel_params.mode = 'Eb/No (dB)';
channel_params.input_power = 1;    % нормированная мощность

%% Параметры приемника
rx_params.output_type = 'Bit';
rx_params.decision_type = 'Hard decision';
rx_params.receive_delay = 0;       % для Error Rate Calculation

%% Параметры визуализации
viz_params.constellation_samples = 5000;  % количество отображаемых точек
viz_params.eye_samples_per_symbol = 4;    % для глазковых диаграмм
viz_params.eye_snr_preview = 15;          % SNR для предпросмотра глазков

%% Параметры сбора данных
sim_sweep_params.num_bits_min = 1e5;      % минимум бит для достоверной оценки
sim_sweep_params.min_errors = 100;         % минимум ошибок для остановки
sim_sweep_params.max_snr = 12;            % максимальное SNR для sweep'а

%% Применение параметров в workspace
% Передатчик
assignin('base', 'bern_prob', tx_params.bernoulli_prob);
assignin('base', 'Ts', tx_params.sample_time);
assignin('base', 'phase_offset', tx_params.phase_offset);

% Канал
assignin('base', 'chan_mode', channel_params.mode);
assignin('base', 'chan_power', channel_params.input_power);

% Приемник
assignin('base', 'rx_out_type', rx_params.output_type);
assignin('base', 'rx_dec_type', rx_params.decision_type);
assignin('base', 'rx_delay', rx_params.receive_delay);

% Визуализация
assignin('base', 'const_samples', viz_params.constellation_samples);
assignin('base', 'eye_sps', viz_params.eye_samples_per_symbol);
assignin('base', 'eye_snr', viz_params.eye_snr_preview);

% Параметры симуляции
set_param('psk_model', 'StopTime', sim_params.stop_time);
set_param('psk_model', 'Solver', sim_params.solver);
set_param('psk_model', 'FixedStep', sim_params.step_size);

%% Вывод информации
fprintf('========================================\n');
fprintf('Параметры PSK модели инициализированы:\n');
fprintf('========================================\n');
fprintf('Время симуляции: %s отсчетов\n', sim_params.stop_time);
fprintf('Сдвиг фазы: %.2f rad\n', tx_params.phase_offset);
fprintf('SNR для предпросмотра глазков: %d dB\n', viz_params.eye_snr_preview);
fprintf('========================================\n\n');

%% Дополнительные проверки
% Проверка наличия Communications Toolbox
if ~license('test', 'communication_toolbox')
    warning('Communications Toolbox не установлен. Некоторые функции могут быть недоступны.');
end

% Создание папки для результатов, если её нет
if ~exist('Results', 'dir')
    mkdir('Results');
    fprintf('Создана папка Results/ для сохранения графиков\n');
end

%% Сохранение структуры параметров (опционально)
save('D:/MODEL/Scripts/psk_params_backup.mat', 'sim_params', 'tx_params', ...
     'channel_params', 'rx_params', 'viz_params', 'sim_sweep_params');

fprintf('Параметры сохранены в Scripts/psk_params_backup.mat\n');
fprintf('----------------------------------------\n');