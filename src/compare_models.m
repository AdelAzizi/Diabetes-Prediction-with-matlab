function bestModelName = compare_models(X_train, Y_train, X_test, Y_test)
    % COMPARE_MODELS مقایسه مدل‌ها با نام‌های استاندارد
    
    disp('-----------------------------------------');
    disp('🥊 مرحله ۴: لیگ انتخابی (Model Selection)');
    disp('-----------------------------------------');
    
    % نام‌های استاندارد و کوتاه (کلید حل مشکل)
    modelNames = {'KNN', 'Tree', 'NB', 'SVM', 'Ensemble'};
    accuracies = zeros(1, 5);
    
    %% ۱. آموزش و تست
    % KNN
    mdl = fitcknn(X_train, Y_train, 'NumNeighbors', 5);
    accuracies(1) = get_acc(mdl, X_test, Y_test);
    
    % Decision Tree (Tree)
    mdl = fitctree(X_train, Y_train, 'MinLeafSize', 5);
    accuracies(2) = get_acc(mdl, X_test, Y_test);
    
    % Naive Bayes (NB)
    mdl = fitcnb(X_train, Y_train);
    accuracies(3) = get_acc(mdl, X_test, Y_test);
    
    % SVM
    mdl = fitcsvm(X_train, Y_train, 'KernelFunction', 'linear', 'Standardize', true);
    accuracies(4) = get_acc(mdl, X_test, Y_test);
    
    % Ensemble (Random Forest)
    mdl = fitcensemble(X_train, Y_train, 'Method', 'Bag');
    accuracies(5) = get_acc(mdl, X_test, Y_test);
    
    %% نمایش نتایج
    fprintf('\n%-15s | %-10s\n', 'Model', 'Accuracy');
    disp('--------------------------');
    for i = 1:5
        fprintf('%-15s | %.2f%%\n', modelNames{i}, accuracies(i));
    end
    
    %% انتخاب برنده
    [maxAcc, idx] = max(accuracies);
    bestModelName = char(modelNames{idx}); % تبدیل قطعی به رشته متنی
    
    fprintf('--------------------------\n');
    fprintf('🏆 مدل برنده: %s (دقت: %.2f%%)\n', bestModelName, maxAcc);
end

function acc = get_acc(model, X, Y)
    Y_pred = predict(model, X);
    acc = sum(Y_pred == Y) / length(Y) * 100;
end