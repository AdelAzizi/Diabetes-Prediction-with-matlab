# توضیح فایل `load_data.m`

این تابع مسئول **بارگذاری داده‌ها از فایل CSV** و تبدیل آن به یک جدول منظم در متلب است. همچنین امکان **دانلود خودکار داده‌ها** در صورت عدم وجود فایل را فراهم می‌کند.

---

## ورودی و خروجی

- **ورودی (`filePath`)**: مسیر فایل `diabetes.csv` (مثلاً `data/diabetes.csv`).
- **خروجی (`dataTable`)**: یک جدول متلب که هر سطر آن یک بیمار و هر ستون آن یک ویژگی (قند خون، فشار خون، سن، ... ) است.

---

## مرحله‌به‌مرحله چه کار می‌کند؟

### ۱. بررسی وجود فایل
- با `isfile(filePath)` چک می‌کند که فایل واقعاً در آن مسیر هست یا نه.
- اگر نبود، دستور `download_data(...)` اجرا می‌شود و فایل از اینترنت دانلود می‌شود.

### ۲. نمایش پیام وضعیت
- با `fprintf` اعلام می‌کند که «در حال خواندن داده‌ها از: ...» تا بدانیم برنامه در چه مرحله‌ای است.

### ۳. خواندن داده‌ها با `readtable`
- با `readtable(filePath)` کل فایل CSV را به شکل جدول (Table) می‌خواند.

### ۴. چاپ خلاصه ابعاد داده
- در انتها تعداد سطرها و ستون‌های داده چاپ می‌شود.

---

## توضیح خط به خط کد

```matlab
function dataTable = load_data(filePath)
```
**خط ۱:** تعریف تابع. نام تابع `load_data` است. یک ورودی (`filePath`) می‌گیرد و یک خروجی (`dataTable`) برمی‌گرداند.

```matlab
    % LOAD_DATA فایل CSV را می‌خواند و در صورت نیاز داده‌ها را دانلود می‌کند.
```
**خط ۲:** یک کامنت توضیحی که می‌گوید این تابع چه کاری انجام می‌دهد.

```matlab
    % بررسی وجود فایل و دانلود در صورت نیاز
    if ~isfile(filePath)
        fprintf('فایل داده یافت نشد. در حال دانلود...\n');
        download_data(filePath);
    end
```
**خط ۴-۷:** 
- `isfile(filePath)` چک می‌کند که آیا فایل در مسیر مشخص شده وجود دارد یا نه.
- `~` یعنی "نه" یا "معکوس". پس `~isfile` یعنی "اگر فایل وجود نداشت".
- اگر فایل نبود، تابع `download_data(...)` فراخوانی می‌شود.

```matlab
    fprintf('در حال خواندن داده‌ها از: %s ...\n', filePath);
```
**خط ۹:** نمایش پیام وضعیت.

```matlab
    % خواندن مستقیم فایل با هدرهای موجود
    dataTable = readtable(filePath);
```
**خط ۱۱:** خواندن فایل CSV با `readtable` که هدرها را خودکار تشخیص می‌دهد.

```matlab
    fprintf('داده‌ها با موفقیت بارگذاری شدند. ابعاد: %d سطر و %d ستون.\n', ...
            height(dataTable), width(dataTable));
```
**خط ۱۳-۱۴:** چاپ ابعاد داده‌های بارگذاری شده.

---

## تابع `download_data`

تابعی که فایل داده را از اینترنت دانلود می‌کند:

```matlab
function download_data(filePath)
    % دانلود فایل داده از لینک عمومی
    url = 'https://raw.githubusercontent.com/jbrownlee/Datasets/master/pima-indians-diabetes.data.csv';
    
    fprintf('در حال دانلود فایل از: %s\n', url);
    
    websave(filePath, url);
    fprintf('فایل داده با موفقیت دانلود شد.\n');
    
    % اضافه کردن هدر به فایل دانلود شده
    add_headers_to_file(filePath);
end
```

- از URL عمومی فایل داده را دانلود می‌کند
- با `websave` فایل ذخیره می‌شود
- تابع `add_headers_to_file` هدرهای مناسب را اضافه می‌کند

---

## تابع `add_headers_to_file`

تابعی که هدرهای مناسب را به فایل CSV اضافه می‌کند:

```matlab
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
```

- فایل را می‌خواند و هدر مناسب را در ابتدای آن اضافه می‌کند
- این کار برای فایل دانلود شده انجام می‌شود که هدر ندارد

---

## اگر کد را به زبان ساده بخواهیم بگوییم

- اول مطمئن می‌شود فایل وجود دارد یا نه. اگر نبود، خودش دانلود می‌کند.
- بعد فایل را می‌خواند و به شکل یک جدول منظم درمی‌آورد.
- در پایان به شما می‌گوید: «این‌قدر سطر و این‌قدر ستون داده با موفقیت خواندم.»
