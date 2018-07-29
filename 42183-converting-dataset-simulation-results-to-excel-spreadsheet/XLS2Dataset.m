function DATA = XLS2Dataset(filename)
%XLS2DATASET - Read Dataset format from EXCEL File
% This function wil help you to read simulation inputs from Excel files.
% INPUTS:
% Filename - File that contains the inputs. 
% The format is as follows:
%    SheetName - The name of the signal to be added.
%    Sheet Values in cells: The first Column contains the time values.
%                           Other Columns contain the values of the
%                           parameter (vector or matrix)
% usage:
% 1. Run this function: XLS2Dataset('test.xlsx');
% 2. Read into Simulink, using the model 'example_ReadDS'
%
if (nargin ~= 1)
    error('### No filename supplied ###');
end
if ~ischar(filename)
    error('Illegal file name');
end

DATA = Simulink.SimulationData.Dataset;
[~, sheetNames] = xlsfinfo(filename);
disp('### Reading from file ###')
for i = 1:length(sheetNames)
    fprintf('### Reading element #%d ###\n',i);
    locSig = xlsread(filename,sheetNames{i});
    DATA = DATA.addElement(i,timeseries(locSig(:,2:end),locSig(:,1),'Name', sheetNames{i}));
end
fprintf('### Finished Reading %d elements from file ###\n',i);

    