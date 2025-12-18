function [X_train, Y_train, X_test, Y_test] = preprocess(data)
    % PREPROCESS نسخه حرفه‌ای (Smart Version)
    % بر اساس نتایج تحلیل داده‌ها (EDA)
    
    disp('... در حال پیش‌پردازش هوشمند (Smart Preprocessing) ...');

    %% ۱. انتخاب ویژگی (Feature Selection) - بر اساس هیت‌مپ
    % در تحلیل دیدیم که فشار خون و ضخامت پوست رابطه کمی با بیماری دارند.
    % حذف آن‌ها باعث می‌شود نویز کمتر شود و مدل روی قند و انسولین تمرکز کند.
    
    weakFeatures = {'BloodPressure', 'SkinThickness'};
    data = removevars(data, weakFeatures);
    
    fprintf('✅ ویژگی‌های ضعیف حذف شدند: %s\n', strjoin(weakFeatures, ', '));

    %% ۲. مدیریت داده‌های نامعتبر (Imputation) - بر اساس باکس‌پلات
    % ستون‌هایی که هنوز ممکن است صفر داشته باشند (به جز آنهایی که حذف کردیم)
    colsToClean = {'Glucose', 'Insulin', 'BMI'};
    
    for i = 1:length(colsToClean)
        colName = colsToClean{i};
        colData = data.(colName);
        
        % تبدیل ۰ به NaN
        colData(colData == 0) = NaN;
        
        % تغییر مهم: استفاده از میانه (Median) به جای میانگین (Mean)
        % چرا؟ چون در نمودار BoxPlot داده‌های پرت زیادی دیدیم.
        % میانگین به شدت تحت تاثیر داده پرت است، اما میانه مقاوم است.
        fillVal = median(colData, 'omitnan');
        
        colData(isnan(colData)) = fillVal;
        data.(colName) = colData;
    end
    disp('✅ مقادیر صفر با "میانه" (Median) جایگزین شدند (مقاوم در برابر داده پرت).');

    %% ۳. جدا کردن ویژگی‌ها و هدف
    % ستون Outcome هدف است
    X = data{:, 1:end-1}; 
    Y = data{:, end};

    %% ۴. نرمال‌سازی (Normalization)
    % استانداردسازی (Z-Score) برای هم‌وزن کردن انسولین و سن
    X = normalize(X);
    disp('✅ داده‌ها نرمال‌سازی شدند.');

    %% ۵. تقسیم داده‌ها
    % استفاده از HoldOut (70% آموزش - 30% تست)
    % تنظیم seed برای اینکه نتایج هر بار عوض نشود (قابل تکرار باشد)
    rng(42); 
    cv = cvpartition(Y, 'HoldOut', 0.3);
    
    X_train = X(training(cv), :);
    Y_train = Y(training(cv), :);
    
    X_test = X(test(cv), :);
    Y_test = Y(test(cv), :);
    
    fprintf('✅ تقسیم‌بندی نهایی: %d آموزش، %d تست.\n', length(Y_train), length(Y_test));
end