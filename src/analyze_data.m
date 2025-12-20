function analyze_data(data)
    % ANALYZE_DATA تحلیل آماری و بصری سریع داده‌ها
    
    disp('-----------------------------------------');
    disp('📊 مرحله ۲: تحلیل اکتشافی داده‌ها (EDA)');
    disp('-----------------------------------------');

    
    %% ۱. رسم نمودار توزیع (Histograms)
    figure('Name', 'Data Distribution', 'Color', 'w');
    features = data.Properties.VariableNames(1:end-1);
    
    for i = 1:length(features)
        subplot(3, 3, i);
        histogram(data{:, i}, 'FaceColor', [0.2, 0.6, 0.8]);
        title(features{i});
        axis tight;
    end
    sgtitle('توزیع ویژگی‌ها (قبل از پیش‌پردازش)');
    drawnow; % رسم فوری

    %% ۲. رسم نمودار BoxPlot
    figure('Name', 'Box Plot Analysis', 'Color', 'w');
    features = data.Properties.VariableNames(1:end-1);
    
    % رسم BoxPlot برای تمام ویژگی‌ها
    subplot(2, 1, 1);
    boxplot(data{:, 1:end-1});
    title('Box Plot کلیه ویژگی‌ها');
    xlabel('ویژگی‌ها');
    ylabel('مقادیر');
    xticklabels(features);
    xtickangle(45);
    
    % رسم BoxPlot جداگانه برای هر ویژگی
    subplot(2, 1, 2);
    for i = 1:length(features)
        subplot(3, 3, i);
        boxplot(data{:, i});
        title(features{i});
        axis tight;
    end
    sgtitle('Box Plotهای جداگانه برای هر ویژگی');
    drawnow;

    %% ۳. رسم ماتریس همبستگی (Correlation)
    figure('Name', 'Correlation Matrix', 'Color', 'w');
    % محاسبه فقط برای ستون‌های عددی
    corrMatrix = corr(data{:, 1:end});
    
    heatmap(data.Properties.VariableNames, data.Properties.VariableNames, ...
            corrMatrix, 'Colormap', parula, 'CellLabelFormat', '%0.2f');
    title('نقشه حرارتی همبستگی بین ویژگی‌ها');
    drawnow;
    
    disp('✅ نمودارهای تحلیل داده رسم شدند.');
    disp(' ');
end