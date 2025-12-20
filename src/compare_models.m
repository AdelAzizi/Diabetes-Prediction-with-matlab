function bestModelName = compare_models(X_train, Y_train, X_test, Y_test)
    % COMPARE_MODELS مقایسه مدل‌ها با نام‌های استاندارد
    % استفاده از هم دقت و هم حساسیت برای انتخاب مدل
    
    disp('-----------------------------------------');
    disp('🥊 مرحله ۴: لیگ انتخابی (Model Selection)');
    disp('-----------------------------------------');
    
    % نام‌های استاندارد و کوتاه (برای جلو گیری از  مشکل)
    modelNames = {'KNN', 'Tree', 'NB', 'SVM', 'Ensemble'};
    accuracies = zeros(1, 5);
    sensitivities = zeros(1, 5);
    
    %% ۱. آموزش و تست
    % KNN
    mdl = fitcknn(X_train, Y_train, 'NumNeighbors', 5);
    [accuracies(1), sensitivities(1)] = get_metrics(mdl, X_test, Y_test);
    
    % Decision Tree (Tree)
    mdl = fitctree(X_train, Y_train, 'MinLeafSize', 5);
    [accuracies(2), sensitivities(2)] = get_metrics(mdl, X_test, Y_test);
    
    % Naive Bayes (NB)
    mdl = fitcnb(X_train, Y_train);
    [accuracies(3), sensitivities(3)] = get_metrics(mdl, X_test, Y_test);
    
    % SVM
    mdl = fitcsvm(X_train, Y_train, 'KernelFunction', 'linear', 'Standardize', true);
    [accuracies(4), sensitivities(4)] = get_metrics(mdl, X_test, Y_test);
    
    % Ensemble (Random Forest)
    mdl = fitcensemble(X_train, Y_train, 'Method', 'Bag');
    [accuracies(5), sensitivities(5)] = get_metrics(mdl, X_test, Y_test);
    
    %% نمایش نتایج
    fprintf('\n%-15s | %-10s | %-10s\n', 'Model', 'Accuracy', 'Sensitivity');
    disp('----------------------------------------');
    for i = 1:5
        fprintf('%-15s | %.2f%%     | %.2f%%\n', modelNames{i}, accuracies(i), sensitivities(i));
    end
    
    %% انتخاب برنده با ترکیب دقت و حساسیت
    % در تشخیص دیابت، حساسیت (قدرت کشف بیماران) بسیار مهم است
    % بنابراین به حساسیت وزن بیشتری (0.6) می‌دهیم و به دقت (0.4)
    weights = [0.4, 0.6]; % [دقت, حساسیت]
    combined_scores = weights(1) * accuracies/100 + weights(2) * sensitivities/100;
    
    [maxScore, idx] = max(combined_scores);
    bestModelName = char(modelNames{idx}); % تبدیل قطعی به رشته متنی
    
    fprintf('----------------------------------------\n');
    fprintf('🏆 مدل برنده: %s\n', bestModelName);
    fprintf('   دقت: %.2f%% | حساسیت: %.2f%% | امتیاز ترکیبی: %.3f\n', ...
        accuracies(idx), sensitivities(idx), maxScore);
end

function [acc, sens] = get_metrics(model, X, Y)
    Y_pred = predict(model, X);
    
    % محاسبه دقت
    acc = sum(Y_pred == Y) / length(Y) * 100;
    
    % محاسبه حساسیت (Recall)
    % ایجاد ماتریس درهم‌ریختگی
    cm = confusionmat(Y, Y_pred);
    % [TN  FP]
    % [FN  TP]
    if size(cm, 1) >= 2 && size(cm, 2) >= 2
        TN = cm(1,1); FP = cm(1,2);
        FN = cm(2,1); TP = cm(2,2);
        
        % حساسیت = TP / (TP + FN)
        if (TP + FN) > 0
            sens = (TP / (TP + FN)) * 100;
        else
            sens = 0; % اگر TP + FN = 0 باشد
        end
    else
        sens = 0; % اگر ماتریس درهم‌ریختگی به درستی ایجاد نشود
    end
end