function evaluate_model(model, X_test, Y_test)
    % EVALUATE_MODEL ارزیابی تخصصی با معیارهای پزشکی و نمودار ROC
    
    disp(' ');
    disp('-----------------------------------------');
    disp('📊 مرحله ۳: ارزیابی فنی و تخصصی (Technical Evaluation)');
    disp('-----------------------------------------');
    
    %% ۱. پیش‌بینی (هم کلاس و هم احتمال)
    % مدل‌های پیشرفته علاوه بر ۰ و ۱، درصد اطمینان (Score) هم می‌دهند
    [Y_pred, scores] = predict(model, X_test);
    
    %% ۲. استخراج اعداد ماتریس خطا
    cm = confusionmat(Y_test, Y_pred);
    % چیدمان ماتریس در متلب:
    % [TN  FP]
    % [FN  TP]
    TN = cm(1,1); % سالم درست
    FP = cm(1,2); % سالم اشتباه (هشدار غلط)
    FN = cm(2,1); % بیمار اشتباه (خطرناک!)
    TP = cm(2,2); % بیمار درست
    
    %% ۳. محاسبات ریاضی (Formulas)
    
    % الف) دقت کل (Accuracy): چقدر کلاً درست گفتیم؟
    accuracy = (TP + TN) / sum(cm(:));
    
    % ب) حساسیت یا فراخوانی (Recall / Sensitivity): از بین بیماران، چند تا رو گرفتیم؟
    % فرمول: TP / (TP + FN)
    recall = TP / (TP + FN);
    
    % ج) دقتِ پیش‌بینی مثبت (Precision): وقتی میگیم مریضه، چقدر احتمال داره واقعاً مریض باشه؟
    % فرمول: TP / (TP + FP)
    precision = TP / (TP + FP);
    
    % د) ویژگی (Specificity): توانایی تشخیص سالم‌ها
    % فرمول: TN / (TN + FP)
    specificity = TN / (TN + FP);
    
    % هـ) معیار F1-Score: میانگین هارمونیک بین Precision و Recall
    % (بهترین معیار وقتی داده‌ها نامتوازن هستند)
    f1_score = 2 * (precision * recall) / (precision + recall);
    
    %% ۴. نمایش گزارش متنی
    fprintf('%-25s | %-10s\n', 'Metric', 'Value');
    disp('---------------------------------------');
    fprintf('%-25s | %.2f%%\n', 'Accuracy (دقت کل)', accuracy * 100);
    fprintf('%-25s | %.2f%%\n', 'Recall (قدرت کشف بیمار)', recall * 100);
    fprintf('%-25s | %.2f%%\n', 'Specificity (تشخیص سالم)', specificity * 100);
    fprintf('%-25s | %.2f%%\n', 'Precision (اطمینان)', precision * 100);
    fprintf('%-25s | %.2f%%\n', 'F1-Score (امتیاز فنی)', f1_score * 100);
    disp('---------------------------------------');
    fprintf('⚠️ خطای نوع دوم (False Negative): %d بیمار تشخیص داده نشدند.\n', FN);
    
    %% ۵. رسم نمودار ROC (Receiver Operating Characteristic)
    % این نمودار نشان‌دهنده عملکرد مدل در آستانه‌های مختلف است
    % هرچقدر خط آبی به گوشه بالا-چپ نزدیک‌تر باشد، مدل بهتر است.
    
    % محاسبه نقاط نمودار
    [Xroc, Yroc, ~, AUC] = perfcurve(Y_test, scores(:,2), 1);
    
    figure('Name', 'Evaluation Plots', 'Color', 'w', 'Position', [100, 100, 1000, 500]);
    
    % نمودار سمت چپ: Confusion Matrix
    subplot(1, 2, 1);
    confusionchart(Y_test, Y_pred, ...
        'Title', ['Confusion Matrix (Acc: ' num2str(accuracy*100, '%.1f') '%)'], ...
        'RowSummary', 'row-normalized');
        
    % نمودار سمت راست: ROC Curve
    subplot(1, 2, 2);
    plot(Xroc, Yroc, 'LineWidth', 2.5, 'Color', [0, 0.4470, 0.7410]);
    hold on;
    plot([0, 1], [0, 1], '--k'); % خط تصادفی (شیر یا خط)
    xlabel('False Positive Rate (1 - Specificity)');
    ylabel('True Positive Rate (Sensitivity)');
    title(['ROC Curve (AUC = ' num2str(AUC, '%.2f') ')']);
    grid on;
    legend(['AUC: ' num2str(AUC, '%.2f')], 'Random Guess', 'Location', 'SouthEast');
    
    disp('✅ نمودارهای تخصصی (ROC و Confusion Matrix) رسم شدند.');
end