function evaluate_model(model, X_test, Y_test)
    % EVALUATE_MODEL نسخه تمیز و نهایی
    % خروجی: فقط جدول شاخص‌ها و نمودارهای استاندارد
    
    disp('=======================================================');
    disp('📊 مرحله ۶: ارزیابی نهایی و تخصصی (Final Evaluation)');
    disp('=======================================================');
    
    %% ۱. پیش‌بینی
    [Y_pred, scores] = predict(model, X_test);
    cm = confusionmat(Y_test, Y_pred);
    
    % استخراج مقادیر ماتریس
    TN = cm(1,1); FP = cm(1,2);
    FN = cm(2,1); TP = cm(2,2);
    
    %% ۲. محاسبات شاخص‌ها
    accuracy    = (TP + TN) / sum(cm(:));
    sensitivity = TP / (TP + FN);   % قدرت تشخیص بیمار
    specificity = TN / (TN + FP);   % قدرت تشخیص سالم
    precision   = TP / (TP + FP);
    f1_score    = 2 * (precision * sensitivity) / (precision + sensitivity);
    
    % محاسبه AUC (سطح زیر نمودار)
    [Xroc, Yroc, ~, AUC] = perfcurve(Y_test, scores(:,2), 1);

    %% ۳. نمایش جدول تمیز
    fprintf('| %-15s | %-10s |\n', 'Metric', 'Value');
    fprintf('=================================\n');
    fprintf('| %-15s | %6.2f%%    |\n', 'Accuracy', accuracy*100);
    fprintf('| %-15s | %6.2f%%    |\n', 'Sensitivity', sensitivity*100);
    fprintf('| %-15s | %6.2f%%    |\n', 'Specificity', specificity*100);
    fprintf('| %-15s | %6.2f%%    |\n', 'F1-Score', f1_score*100);
    fprintf('| %-15s | %6.4f     |\n', 'AUC Score', AUC);
    fprintf('---------------------------------\n');
    fprintf('⚠️ تعداد بیماران تشخیص داده نشده (FN): %d نفر\n', FN);
    
    %% ۴. رسم نمودارها
    figure('Name', 'Final Evaluation', 'Color', 'w', 'Position', [100, 100, 900, 400]);
    
    % الف) ماتریس خطا
    subplot(1, 2, 1);
    confusionchart(cm, {'Healthy', 'Diabetic'});
    title('Confusion Matrix');
    
    % ب) نمودار ROC
    subplot(1, 2, 2);
    plot(Xroc, Yroc, 'b-', 'LineWidth', 2); hold on;
    plot([0,1], [0,1], 'k--', 'LineWidth', 1); % خط شانس
    fill([Xroc; 1; 0], [Yroc; 0; 0], 'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
    title(sprintf('ROC Curve (AUC = %.2f)', AUC));
    xlabel('False Positive Rate'); 
    ylabel('True Positive Rate');
    grid on;
    
    disp('✅ نمودارها رسم شدند.');
end