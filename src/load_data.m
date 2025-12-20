function dataTable = load_data(filePath)
    % LOAD_DATA فایل CSV را می‌خواند و در صورت نیاز داده‌ها را دانلود می‌کند
    
    % بررسی وجود فایل و دانلود در صورت نیاز
    if ~isfile(filePath)
        fprintf('فایل داده یافت نشد. در حال دانلود...\n');
        download_data(filePath);
    end
    
    fprintf('در حال خواندن داده‌ها از: %s ...\n', filePath);
    
    % خواندن مستقیم فایل با هدرهای موجود
    dataTable = readtable(filePath);
    
    fprintf('داده‌ها با موفقیت بارگذاری شدند. ابعاد: %d سطر و %d ستون.\n', ...
            height(dataTable), width(dataTable));
end

function download_data(filePath)
    % دانلود فایل داده از لینک عمومی
    url = 'https://raw.githubusercontent.com/jbrownlee/Datasets/master/pima-indians-diabetes.data.csv';
    
    fprintf('در حال دانلود فایل از: %s\n', url);
    
    websave(filePath, url);
    fprintf('فایل داده با موفقیت دانلود شد.\n');
    
    % اضافه کردن هدر به فایل دانلود شده
    add_headers_to_file(filePath);
end

function add_headers_to_file(filePath)
    % اضافه کردن هدر به فایل CSV
    fid = fopen(filePath, 'r');
    data = textscan(fid, '%s', 'Delimiter', '\n');
    fclose(fid);
    
    % اضافه کردن هدر در ابتدای داده‌ها
    header = 'Pregnancies,Glucose,BloodPressure,SkinThickness,Insulin,BMI,DiabetesPedigree,Age,Outcome';
    newData = [header; data{1}];
    
    fid = fopen(filePath, 'w');
    for i = 1:length(newData)
        fprintf(fid, '%s\n', newData{i});
    end
    fclose(fid);
end