%% Очистка
clear; clc; close all;

%% Загрузка параметров
run('D:/MODEL/Scripts/init_psk_params.m');

%% Настройки симуляции
EbNo_dB = 0:1:15;
M_values = [2, 4, 8];
mod_names = {'BPSK', 'QPSK', '8-PSK'};
colors = {'b', 'r', 'g'};

%% Массивы результатов
all_ber_sim = zeros(length(M_values), length(EbNo_dB));
all_ser_sim = zeros(length(M_values), length(EbNo_dB));

%% Цикл по модуляциям
for mod_idx = 1:length(M_values)
    
    M = M_values(mod_idx);
    assignin('base', 'M', M);
    
    ber_sim = zeros(size(EbNo_dB));
    ser_sim = zeros(size(EbNo_dB));
    
    for snr_idx = 1:length(EbNo_dB)
        
        EbNo_curr = EbNo_dB(snr_idx);
        assignin('base', 'EbNo_curr', EbNo_curr);
        
        sim('psk_model');
        
        ber_out = evalin('base', 'ber_out');
        ser_out = evalin('base', 'ser_out');
        
        ber_sim(snr_idx) = ber_out(1);
        ser_sim(snr_idx) = ser_out(1);
        
        fprintf('%s: Eb/No = %d dB, BER = %.2e, SER = %.2e\n', ...
                mod_names{mod_idx}, EbNo_dB(snr_idx), ber_sim(snr_idx), ser_sim(snr_idx));
    end
    
    all_ber_sim(mod_idx, :) = ber_sim;
    all_ser_sim(mod_idx, :) = ser_sim;
    
    %% Теория
    ber_theory_all{mod_idx} = psk_theory(EbNo_dB, M, 'ber');
    ser_theory_all{mod_idx} = psk_theory(EbNo_dB, M, 'ser');
end

%% Построение графиков
run('D:/MODEL/Scripts/plot_results.m');