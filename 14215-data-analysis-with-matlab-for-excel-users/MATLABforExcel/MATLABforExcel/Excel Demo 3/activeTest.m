%% Test the MATLAB ActiveX Server Interface
% MATLAB (on Windows) can function as an activex server, as well as client.
% This allows you to drive MATLAB from Visual Basic, or inturn, drive Microsoft
% applications from MATLAB. This is a part of basic MATLAB and requires no additional
% products. More information is available in our help:
% http://www.mathworks.com/access/helpdesk/help/techdoc/matlab_external/f27470.html
% Copyright 2006-2009 The MathWorks, Inc.

%% Open Excel
hExcel = actxserver('excel.application');
hExcel.Visible = 1;

%% Create a workbook
hExcel.Workbooks.Add;

%% Inspect all the properties
inspect(hExcel);
pause(3);%give the inspector a moment to load the data from Excel

%% Fill a range of cells with data
hExcelRange = Range(hExcel,'A1:D4');
hExcelRange.Value = rand(4);

%% Open a more complicated example that ships with MATLAB
run ([docroot '/techdoc/matlab_external/examples/actx_excel'])
cd  ([docroot '/techdoc/matlab_external/examples'           ])
edit([docroot '/techdoc/matlab_external/examples/actx_excel'])
