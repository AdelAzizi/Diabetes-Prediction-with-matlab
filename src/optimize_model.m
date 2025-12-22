function finalModel = optimize_model(modelName, X_train, Y_train)
    % OPTIMIZE_MODEL نسخه بدون باگ و اصلاح شده
    
    disp(' ');
    disp(['🔧 در حال تیونینگ مدل ' modelName ' با استراتژی سخت‌گیرانه...']);
    
    %% ۱. ساخت مدل پایه (Benchmark)
    % ابتدا مدل استاندارد را می‌سازیم
    baseModel = fitcensemble(X_train, Y_train, 'Method', 'Bag');
    cvBase = crossval(baseModel, 'KFold', 5);
    baseLoss = kfoldLoss(cvBase);
    fprintf('   📊 خطای مدل پایه (Standard): %.4f\n', baseLoss);

    %% ۲. تنظیمات جستجوی پارامترها
    opts = struct('Optimizer', 'bayesopt', ...
                  'ShowPlots', false, ...      
                  'Verbose', 0, ...            
                  'AcquisitionFunctionName', 'expected-improvement-plus', ...
                  'MaxObjectiveEvaluations', 30); 

    if contains(modelName, 'Ensemble')
        
        % --- اصلاح مهم: تعریف جداگانه متغیرها برای جلوگیری از خطای ابعاد ---
        
        % ۱. تعداد درخت‌ها
        v1 = optimizableVariable('NumLearningCycles', [50, 500], 'Type', 'integer', 'Transform', 'log');
        
        % ۲. اندازه برگ (محدود شده برای جلوگیری از ساده‌سازی)
        v2 = optimizableVariable('MinLeafSize', [1, 5], 'Type', 'integer', 'Transform', 'none');
        
        % ۳. تعداد ویژگی‌ها (استفاده از size به جای width برای سازگاری با ماتریس)
        numFeats = size(X_train, 2); 
        v3 = optimizableVariable('NumVariablesToSample', [1, numFeats], 'Type', 'integer', 'Transform', 'none');
        
        % ترکیب نهایی پارامترها
        params = [v1, v2, v3];
        
        % -------------------------------------------------------------
        
        % شروع جستجو
        resultsObj = fitcensemble(X_train, Y_train, ...
            'Method', 'Bag', ...
            'OptimizeHyperparameters', params, ...
            'HyperparameterOptimizationOptions', opts, ...
            'Learners', templateTree('Reproducible', true));
        
        bestParams = resultsObj.HyperparameterOptimizationResults.XAtMinObjective;
        minError = resultsObj.HyperparameterOptimizationResults.MinObjective;
        
        disp('💎 بهترین پارامترهای جدید:');
        disp(bestParams);
        
        %% ۳. تصمیم‌گیری نهایی (The Smart Choice)
        % مقایسه خطای مدل جدید با مدل پایه
        
        if minError < baseLoss
            disp('✅ مدل تیون شده عملکرد بهتری دارد. در حال ساخت مدل بهینه...');
            finalModel = fitcensemble(X_train, Y_train, ...
                'Method', 'Bag', ...
                'NumLearningCycles', bestParams.NumLearningCycles, ...
                'Learners', templateTree('MinLeafSize', bestParams.MinLeafSize), ...
                'NPrint', 0);
        else
            disp('⚠️ مدل تیون شده نتوانست مدل استاندارد را شکست دهد.');
            disp('↩️ بازگشت به مدل استاندارد (چون نتیجه بهتری دارد).');
            finalModel = baseModel;
        end
            
    else
        % برای مدل‌های غیر Ensemble (مثل SVM)
        finalModel = fitcsvm(X_train, Y_train, 'Standardize', true);
    end
    
    disp('✅ مدل نهایی آماده شد.');
    disp('------------------------------------');
end