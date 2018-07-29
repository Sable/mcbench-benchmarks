function Dataset2XLS(DATA, filename)
%DATASET2XLS - Save Dataset format to EXCEL File
% This function wil help you to save simulation results to Excel files.
% INPUTS:
% DATA - The data to be saved, in DataSet format (Simulink).
% Filename - optional file name to save in. if not supplied, will use
% example_Dataset.xlsx.
% usage:
% 1. Run a Simulink model, and save the result in a Dataset format. The
% defaults filename is 'logsout'.
% 2. Run this function: Dataset2XLS(logsout, 'test.xls');
%

%% Check inputs:
if (nargin < 1 || nargin >3)
    error('Wrong number of arguments. Enter Dataset parameter Name');
end
if nargin < 2
    filename = 'example_Dataset.xlsx';
    warning('### No filename supplied, using example_Dataset.xlsx instead ###');
end
if ~ischar(filename)
    error('Illegal file name');
end
if isempty(DATA)
    error('Illegal Data to save');
end
if ~isa(DATA,'Simulink.SimulationData.Dataset')
    error('Data is not in Simulink.SimulationData.Dataset Format');
end
if ~exist(filename,'file')
    existingFile = 0;
else
    existingFile = 1;
end

%% Write data to file:
disp('### Writing to file ###')
warning('off'); %#ok<*WNOFF>
for i = 1:DATA.numElements
    fprintf('### Writing element #%d ###\n',i);
    locSig = DATA.getElement(i);
    stat = xlswrite(filename, [locSig.Values.Time locSig.Values.Data], locSig.Name);
    if ~stat
        error('Problem writing to file, check if it''s not open');
    end
end
warning('on'); %#ok<*WNON>
fprintf('### Finished writing to file %s ###\n',filename)

%% Delete unwanted excel sheets (If file did not exist beforehand):
if ~existingFile
    disp('### Removing extra sheets ###')
    % Retrieve sheet names
    [~, sheetNames] = xlsfinfo(filename);
    % Open Excel as a COM Automation server
    hExcel = actxserver('Excel.Application');
    % Open Excel workbook
    Workbook = hExcel.Workbooks.Open(fullfile(pwd,filename));
    % Clear the content of the sheets (from the second onwards)
    cellfun(@(x) hExcel.ActiveWorkBook.WorkSheets.Item(x).Delete, sheetNames(1:3));
    % Now save/close/quit/delete
    Workbook.Save;
    hExcel.Workbook.Close;
    hExcel.Quit;
    hExcel.delete;
end