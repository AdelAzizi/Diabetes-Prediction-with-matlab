%% فایل اصلی پروژه هوشمند تشخیص دیابت (Final Release)
clc; clear; close all;
addpath('src'); 

dataFilePath = fullfile('data', 'diabetes.csv');

disp('==================================================');
disp('   سیستم هوشمند تشخیص دیابت (Machine Learning)    ');
disp('==================================================');

try
    %% ۱. بارگذاری داده‌ها
    data = load_data(dataFilePath);
    
    %% ۲. تحلیل داده‌ها (EDA) 
    % نمایش نمودارها قبل از دستکاری داده‌ها
    analyze_data(data);
    
    %% ۳. پیش‌پردازش هوشمند (Smart Preprocessing)
    % حذف نویز، پر کردن جاهای خالی با میانه، نرمال‌سازی
    [X_train, Y_train, X_test, Y_test] = preprocess(data);
    
    %% ۴. انتخاب بهترین مدل (Model Selection League)
    % مقایسه ۵ الگوریتم و انتخاب برنده
    bestName = compare_models(X_train, Y_train, X_test, Y_test);
    
    %% ۵. تقویت مدل (Hyperparameter Optimization)
    % بهینه‌سازی پارامترهای مدل برنده برای حداکثر کارایی
    finalModel = optimize_model(bestName, X_train, Y_train);
    
    %% ۶. ارزیابی نهایی و تخصصی (Final Evaluation)
    % محاسبه AUC، F1-Score و رسم ROC
    evaluate_model(finalModel, X_test, Y_test);
    
    disp('🎉 پروژه با موفقیت و بالاترین دقت ممکن به پایان رسید.');
    
catch ME
    disp(['❌ خطا: ', ME.message]);
    disp(ME.stack(1));
end