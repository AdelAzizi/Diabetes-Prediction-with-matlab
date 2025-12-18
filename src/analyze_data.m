function analyze_data(data)
    % ANALYZE_DATA تحلیل آماری و بصری سریع داده‌ها
    
    disp('-----------------------------------------');
    disp('📊 مرحله ۰: تحلیل اکتشافی داده‌ها (EDA)');
    disp('-----------------------------------------');

    %% ۱. نمایش خلاصه آماری
    % نمایش میانگین، انحراف معیار و... در کامند ویندو
    summary(data);
    
    %% ۲. رسم نمودار توزیع (Histograms)
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