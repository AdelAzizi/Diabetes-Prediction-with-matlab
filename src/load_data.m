function dataTable = load_data(filePath)
    % LOAD_DATA فایل CSV را می‌خواند و هدرهای مناسب را به آن اختصاص می‌دهد.
    %
    % ورودی:
    %   filePath: مسیر فایل CSV (رشته متنی)
    %
    % خروجی:
    %   dataTable: جدول داده‌های بارگذاری شده در متلب
    
    % ۱. بررسی وجود فایل
    if ~isfile(filePath)
        error('خطا: فایل داده در مسیر زیر پیدا نشد:\n%s', filePath);
    end
    
    fprintf('در حال خواندن داده‌ها از: %s ...\n', filePath);

    % ۲. تعریف نام ستون‌ها (چون فایل اصلی هدر ندارد یا ممکن است ناقص باشد)
    varNames = {'Pregnancies', 'Glucose', 'BloodPressure', 'SkinThickness', ...
                'Insulin', 'BMI', 'DiabetesPedigree', 'Age', 'Outcome'};

    % ۳. خواندن فایل با readtable
    % نکته: 'ReadVariableNames', false یعنی سطر اول داده است، نه تیتر
    opts = detectImportOptions(filePath);
    opts.VariableNamesLine = 0; % فایل هدر ندارد
    opts.PreserveVariableNames = true;
    
    dataTable = readtable(filePath, opts);
    
    % ۴. اطمینان از اینکه تعداد ستون‌ها با نام‌ها برابر است
    if width(dataTable) == length(varNames)
        dataTable.Properties.VariableNames = varNames;
    else
        warning('تعداد ستون‌های فایل با تعداد نام‌های تعریف شده همخوانی ندارد.');
    end
    
    fprintf('داده‌ها با موفقیت بارگذاری شدند. ابعاد: %d سطر و %d ستون.\n', ...
            height(dataTable), width(dataTable));
end