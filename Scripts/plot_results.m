%% plot_results.m
% Профессиональное оформление графиков BER/SER
% Теория: пунктирная линия
% Симуляция: маркеры + сплошная линия

%% Общие настройки (стиль для всех графиков)
set(0, 'DefaultAxesFontSize', 12);
set(0, 'DefaultAxesFontName', 'Times New Roman');
set(0, 'DefaultTextFontSize', 12);
set(0, 'DefaultTextFontName', 'Times New Roman');
set(0, 'DefaultLineLineWidth', 1.5);
set(0, 'DefaultLineMarkerSize', 10);

% Цветовая палитра (Colorblind-friendly)
colors = {
    [0 0.4470 0.7410];  % синий
    [0.8500 0.3250 0.0980]; % красный
    [0.4660 0.6740 0.1880]; % зелёный
    };

markers = {'o', 's', '^', 'd'};

%% ============= FIGURE 1: BER SUBPLOT =============
figure(1);
set(gcf, 'Position', [100, 100, 1400, 900]);
set(gcf, 'Color', 'white');

for mod_idx = 1:3
    subplot(2,2,mod_idx);
    
    % СИМУЛЯЦИЯ: маркеры + сплошная линия
    h_sim = semilogy(EbNo_dB, all_ber_sim(mod_idx,:), ...
        [markers{mod_idx} '-'], 'Color', colors{mod_idx}, ...
        'MarkerFaceColor', colors{mod_idx}, ...
        'MarkerEdgeColor', 'k', ...
        'LineWidth', 1.5, 'MarkerSize', 9);
    hold on;
    
    % ТЕОРИЯ: пунктирная линия (БЕЗ маркеров)
    h_theory = semilogy(EbNo_dB, ber_theory_all{mod_idx}, ...
        '--', 'Color', colors{mod_idx}, ...
        'LineWidth', 2);
    
    hold off;
    
    % Сетка
    grid on;
    grid minor;
    set(gca, 'GridAlpha', 0.3, 'MinorGridAlpha', 0.1);
    
    % Подписи
    xlabel('E_b/N_0 (dB)', 'FontSize', 13, 'FontWeight', 'bold');
    ylabel('Bit Error Rate (BER)', 'FontSize', 13, 'FontWeight', 'bold');
    
    % Заголовок
    title(sprintf('%s модуляция', mod_names{mod_idx}), ...
        'FontSize', 15, 'FontWeight', 'bold');
    
    % Легенда
    legend([h_sim, h_theory], {'Симуляция', 'Теория'}, ...
        'Location', 'southwest', 'FontSize', 12, ...
        'Box', 'off', 'NumColumns', 2);
    
    % Оси
    ylim([1e-6, 1]);
    xlim([EbNo_dB(1), EbNo_dB(end)]);
    set(gca, 'XTick', EbNo_dB(1):2:EbNo_dB(end));
end

% Общий заголовок
sgtitle('Помехоустойчивость PSK модуляций (BER)', ...
    'FontSize', 18, 'FontWeight', 'bold', 'Color', 'k');

% Сохранение
exportgraphics(gcf, 'Results/BER_subplot.png', 'Resolution', 300);
exportgraphics(gcf, 'Results/BER_subplot.pdf', 'ContentType', 'vector');

%% ============= FIGURE 2: SER SUBPLOT =============
figure(2);
set(gcf, 'Position', [150, 150, 1400, 900]);
set(gcf, 'Color', 'white');

for mod_idx = 1:3
    subplot(2,2,mod_idx);
    
    % СИМУЛЯЦИЯ: маркеры + сплошная
    h_sim = semilogy(EbNo_dB, all_ser_sim(mod_idx,:), ...
        [markers{mod_idx} '-'], 'Color', colors{mod_idx}, ...
        'MarkerFaceColor', colors{mod_idx}, ...
        'MarkerEdgeColor', 'k', ...
        'LineWidth', 1.5, 'MarkerSize', 9);
    hold on;
    
    % ТЕОРИЯ: пунктирная линия
    h_theory = semilogy(EbNo_dB, ser_theory_all{mod_idx}, ...
        '--', 'Color', colors{mod_idx}, ...
        'LineWidth', 2);
    
    hold off;
    
    grid on; grid minor;
    set(gca, 'GridAlpha', 0.3, 'MinorGridAlpha', 0.1);
    
    xlabel('E_b/N_0 (dB)', 'FontSize', 13, 'FontWeight', 'bold');
    ylabel('Symbol Error Rate (SER)', 'FontSize', 13, 'FontWeight', 'bold');
    
    title(sprintf('%s модуляция', mod_names{mod_idx}), ...
        'FontSize', 15, 'FontWeight', 'bold');
    
    legend([h_sim, h_theory], {'Симуляция', 'Теория'}, ...
        'Location', 'southwest', 'FontSize', 12, ...
        'Box', 'off', 'NumColumns', 2);
    
    ylim([1e-6, 1]);
    xlim([EbNo_dB(1), EbNo_dB(end)]);
    set(gca, 'XTick', EbNo_dB(1):2:EbNo_dB(end));
end

sgtitle('Помехоустойчивость PSK модуляций (SER)', ...
    'FontSize', 18, 'FontWeight', 'bold', 'Color', 'k');

exportgraphics(gcf, 'Results/SER_subplot.png', 'Resolution', 300);
exportgraphics(gcf, 'Results/SER_subplot.pdf', 'ContentType', 'vector');

%% ============= FIGURE 3: BER COMPARISON (ЛЕГЕНДА БЕЗ ДУБЛЕЙ) =============
figure(3);
set(gcf, 'Position', [200, 200, 1000, 700]);
set(gcf, 'Color', 'white');

% Очищаем hold, чтобы случайно не захватить старые линии
cla reset;
hold on;

h_lines = gobjects(1, 3);
for mod_idx = 1:3
    h_lines(mod_idx) = semilogy(EbNo_dB, all_ber_sim(mod_idx,:), ...
        [markers{mod_idx} '-'], 'Color', colors{mod_idx}, ...
        'MarkerFaceColor', colors{mod_idx}, ...
        'MarkerEdgeColor', 'k', ...
        'LineWidth', 2, 'MarkerSize', 10);
end
hold off;

grid on; 
grid minor;
set(gca, 'YScale', 'log');
set(gca, 'GridAlpha', 0.3, 'MinorGridAlpha', 0.1);

xlabel('E_b/N_0 (dB)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Bit Error Rate (BER)', 'FontSize', 14, 'FontWeight', 'bold');
title('Сравнение BER для PSK модуляций', ...
    'FontSize', 16, 'FontWeight', 'bold');

% ЛЕГЕНДА - ТОЛЬКО ПО УНИКАЛЬНЫМ ЛИНИЯМ!
legend(h_lines, mod_names, 'Location', 'southwest', ...
    'FontSize', 13, 'Box', 'off');

ylim([1e-6, 1]);
xlim([EbNo_dB(1), EbNo_dB(end)]);
set(gca, 'XTick', EbNo_dB(1):2:EbNo_dB(end));

exportgraphics(gcf, 'Results/BER_comparison_log.png', 'Resolution', 300);
exportgraphics(gcf, 'Results/BER_comparison_log.pdf', 'ContentType', 'vector');

%% ============= FIGURE 4: SER COMPARISON (ЛЕГЕНДА БЕЗ ДУБЛЕЙ) =============
figure(4);
set(gcf, 'Position', [250, 250, 1000, 700]);
set(gcf, 'Color', 'white');

cla reset;
hold on;

h_lines = gobjects(1, 3);
for mod_idx = 1:3
    h_lines(mod_idx) = semilogy(EbNo_dB, all_ser_sim(mod_idx,:), ...
        [markers{mod_idx} '-'], 'Color', colors{mod_idx}, ...
        'MarkerFaceColor', colors{mod_idx}, ...
        'MarkerEdgeColor', 'k', ...
        'LineWidth', 2, 'MarkerSize', 10);
end
hold off;

grid on; 
grid minor;
set(gca, 'YScale', 'log');
set(gca, 'GridAlpha', 0.3, 'MinorGridAlpha', 0.1);

xlabel('E_b/N_0 (dB)', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Symbol Error Rate (SER)', 'FontSize', 14, 'FontWeight', 'bold');
title('Сравнение SER для PSK модуляций', ...
    'FontSize', 16, 'FontWeight', 'bold');

% ЛЕГЕНДА - ТОЛЬКО ПО УНИКАЛЬНЫМ ЛИНИЯМ!
legend(h_lines, mod_names, 'Location', 'southwest', ...
    'FontSize', 13, 'Box', 'off');

ylim([1e-6, 1]);
xlim([EbNo_dB(1), EbNo_dB(end)]);
set(gca, 'XTick', EbNo_dB(1):2:EbNo_dB(end));

exportgraphics(gcf, 'Results/SER_comparison_log.png', 'Resolution', 300);
exportgraphics(gcf, 'Results/SER_comparison_log.pdf', 'ContentType', 'vector');

%% ============= FIGURE 5: BER + SER ВМЕСТЕ (ЛЕГЕНДА БЕЗ ДУБЛЕЙ) =============
figure(5);
set(gcf, 'Position', [300, 300, 1400, 600]);
set(gcf, 'Color', 'white');

% ---- BER (ЛОГАРИФМИЧЕСКИЙ МАСШТАБ) ----
subplot(1,2,1);
cla reset;
hold on;

h_ber_lines = gobjects(1, 3);
for mod_idx = 1:3
    h_ber_lines(mod_idx) = semilogy(EbNo_dB, all_ber_sim(mod_idx,:), ...
        [markers{mod_idx} '-'], 'Color', colors{mod_idx}, ...
        'MarkerFaceColor', colors{mod_idx}, ...
        'MarkerEdgeColor', 'k', ...
        'LineWidth', 2, 'MarkerSize', 9);
end
hold off;

grid on; 
grid minor;
set(gca, 'YScale', 'log');
xlabel('E_b/N_0 (dB)', 'FontSize', 13, 'FontWeight', 'bold');
ylabel('Bit Error Rate (BER)', 'FontSize', 13, 'FontWeight', 'bold');
title('BER: Сравнение модуляций', 'FontSize', 15, 'FontWeight', 'bold');

% ЛЕГЕНДА - ТОЛЬКО УНИКАЛЬНЫЕ ЛИНИИ!
legend(h_ber_lines, mod_names, 'Location', 'southwest', ...
    'FontSize', 12, 'Box', 'off');

ylim([1e-6, 1]);
xlim([EbNo_dB(1), EbNo_dB(end)]);
set(gca, 'XTick', EbNo_dB(1):2:EbNo_dB(end));

% ---- SER (ЛОГАРИФМИЧЕСКИЙ МАСШТАБ) ----
subplot(1,2,2);
cla reset;
hold on;

h_ser_lines = gobjects(1, 3);
for mod_idx = 1:3
    h_ser_lines(mod_idx) = semilogy(EbNo_dB, all_ser_sim(mod_idx,:), ...
        [markers{mod_idx} '-'], 'Color', colors{mod_idx}, ...
        'MarkerFaceColor', colors{mod_idx}, ...
        'MarkerEdgeColor', 'k', ...
        'LineWidth', 2, 'MarkerSize', 9);
end
hold off;

grid on; 
grid minor;
set(gca, 'YScale', 'log');
xlabel('E_b/N_0 (dB)', 'FontSize', 13, 'FontWeight', 'bold');
ylabel('Symbol Error Rate (SER)', 'FontSize', 13, 'FontWeight', 'bold');
title('SER: Сравнение модуляций', 'FontSize', 15, 'FontWeight', 'bold');

% ЛЕГЕНДА - ТОЛЬКО УНИКАЛЬНЫЕ ЛИНИИ!
legend(h_ser_lines, mod_names, 'Location', 'southwest', ...
    'FontSize', 12, 'Box', 'off');

ylim([1e-6, 1]);
xlim([EbNo_dB(1), EbNo_dB(end)]);
set(gca, 'XTick', EbNo_dB(1):2:EbNo_dB(end));

sgtitle('PSK модуляции: BER и SER', ...
    'FontSize', 16, 'FontWeight', 'bold');

exportgraphics(gcf, 'Results/BER_SER_combined_log.png', 'Resolution', 300);
exportgraphics(gcf, 'Results/BER_SER_combined_log.pdf', 'ContentType', 'vector');
fprintf('✅ Все графики сохранены:\n');
fprintf('   - Figures 1-4: PNG + PDF (300 dpi)\n');
fprintf('   - Figure 5: BER+SER совместно\n');
fprintf('   - Теория: пунктир, Симуляция: маркеры+сплошная\n');