function xlsx2matfile(pathxlsx, pathmat)
% xlsx2matfile(pathxlsx)
% xlsx2matfile(pathxlsx, pathmat)
% path is the path of .xlsx file
% varargin is the path for target fold to save the .mat files
% linrenwen@gmail.com
% 把xlsx文件中的表批量转换为mat文件 
file = pathxlsx;
if nargin == 2
    if pathmat(end) ~= '\' 
        pathmat = [pathmat, '\']; 
    end 
end

%
try
    Excel = actxserver('excel.application');
catch exc   %#ok<NASGU>
    warning(message('MATLAB:xlsread:ActiveX'));
end

% open workbook
Excel.DisplayAlerts = 0; 
% cleanUp = onCleanup(@()xlsCleanup(Excel, file));
ExcelWorkbook = Excel.workbooks.Open(file,0,true);

format = ExcelWorkbook.FileFormat;
if  strcmpi(format, 'xlCurrentPlatformText') == 1
    error(message('MATLAB:xlsread:FileFormat', file));
end

nsheet = Excel.ActiveWorkbook.Sheets.Count;

Excel.DisplayAlerts = false; 
for jj = 1:nsheet

    ExcelWorkbook.Sheets.Item(jj).Activate()
    
    sname = ExcelWorkbook.Sheets.Item(jj).name;
    if nargin == 1
        filename = [ sname, '.mat']; 
    elseif nargin == 2
        filename = [pathmat sname, '.mat']; 
    end
    
    DataRange = Excel.ActiveSheet.UsedRange;
    raw = DataRange.Value;
    
    save(filename, 'raw');
    % [data,text] = parse_data(rawData); 
end

ExcelWorkbook.Close; 
Excel.Quit; 
Excel.delete();
clear Excel;
clear Workbook;
return;
end
% %%
% % Activate default worksheet.
% activate_sheet(Excel,Sheet);
% 
% % Select range of occupied cells in active sheet.
% DataRange = Excel.ActiveSheet.UsedRange;
% 
% % get the values in the used regions on the worksheet.
% rawData = DataRange.Value;
% % parse data into numeric and string arrays
