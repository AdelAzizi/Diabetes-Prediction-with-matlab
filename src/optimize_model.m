function finalModel = optimize_model(modelName, X_train, Y_train)
    % OPTIMIZE_MODEL بهینه‌سازی پارامترها
    
    disp(' ');
    disp('-----------------------------------------');
    disp(['🔧 مرحله ۵: تقویت مدل ' modelName]);
    disp('   (در حال پیدا کردن بهترین تنظیمات...)');
    disp('-----------------------------------------');
    
    % تنظیمات: تعداد تکرار را روی ۱۰ می‌گذاریم که سریع باشد
    opts = struct('Optimizer', 'bayesopt', 'ShowPlots', false, ...
                  'MaxObjectiveEvaluations', 10, 'Verbose', 0);
    
    switch modelName
        case 'KNN'
            finalModel = fitcknn(X_train, Y_train, ...
                'OptimizeHyperparameters', {'NumNeighbors', 'Distance'}, ...
                'HyperparameterOptimizationOptions', opts);
                
        case 'Tree'
            finalModel = fitctree(X_train, Y_train, ...
                'OptimizeHyperparameters', {'MinLeafSize', 'MaxNumSplits'}, ...
                'HyperparameterOptimizationOptions', opts);
                
        case 'SVM'
            finalModel = fitcsvm(X_train, Y_train, ...
                'OptimizeHyperparameters', {'BoxConstraint'}, ...
                'KernelFunction', 'linear', 'Standardize', true, ...
                'HyperparameterOptimizationOptions', opts);
                
        case 'Ensemble'
            % تنظیمات مخصوص رندوم فارست (تعداد درخت‌ها و اندازه برگ‌ها)
            finalModel = fitcensemble(X_train, Y_train, 'Method', 'Bag', ...
                'OptimizeHyperparameters', {'NumLearningCycles', 'MinLeafSize'}, ...
                'HyperparameterOptimizationOptions', opts);
                
        otherwise
            % برای NB یا موارد پیش‌بینی نشده
            disp('⚠️ این مدل نیاز به تنظیم خاصی ندارد.');
            finalModel = fitcnb(X_train, Y_train);
    end
    
    disp('✅ بهینه‌سازی تمام شد.');
end