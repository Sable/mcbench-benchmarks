function xlsheets(sheetnames,varargin)

%XLSHEETS creates or opens existing Excel file and names sheets
%
% xlsheets(sheetnames,filename)
% xlsheets(sheetnames)
%
% xlsheets  : Creates new excel file (or opens it if file exists)
%               and name the sheets as listed in (sheetnames)
%               and saves the workbook as (filename).
%
%       sheetnames:     List of sheet names (cell array).
%       filename:       Name of excel file.
% 
% NOTE: Follow the following rules when naming your sheets:
%       1- Make sure the name you entered does not exceed 31 characters.
%       2- Make sure the name does not contain any of the following characters:  :  \  /  ?  *  [  or  ]
%       3- Make sure you did not leave the name blank.
%       4- Make sure each sheet name is a character string.
%       5- Make sure you do not have two sheets or more with the same name.
%
% Example:
% 
%      sheetnames = {'Mama','Papa','Son','Daughter','Dog'};
%      filename = 'family.xls';          % can be named without '.xls'
%      xlsheets(sheetnames,filename);
%      xlsheets(sheetnames);            % Will leave file open
%

%   Copyright 2004 Fahad Al Mahmood
%   Version: 1.0 $  $Date: 12-Feb-2004
%   Version: 1.5 $  $Date: 16-Feb-2004  (Open exisiting file feature)
%   Version: 2.0 $  $Date: 26-Feb-2004  (Fixed [Group] problem + Making process invisible)
%   Version: 2.1 $  $Date: 27-Feb-2004  (Fixed replacing existing sheets problem)
%   Version: 2.5 $  $Date: 15-Mar-2004  (Fixed filename problem)
%   Version: 3.0 $  $Date: 04-Apr-2004  (Fixed Naming to an existing sheetnames problem + Fixed Opening Multiple Excel Programs Problem)
%   Version: 3.1 $  $Date: 10-Apr-2004  (Added more help about the rules of naming Excel sheets)
%   Version: 3.2 $  $Date: 10-Apr-2004  (Supporting Full or Partial Path)

    
% Making sure the names of the sheets are according to Excel rules.
for n=1:length(sheetnames)
%  (1) Making sure each sheetname entered does not exceed 31 characters.    
    if length(sheetnames{n})>31
        error(['sheet (' sheetnames{n} ') exceeds 31 characters! (see xlsheets help)'])
    end
%  (2) Making sure each sheetname does not contain any illegal character.
    if any(ismember([':','\','/','?','*'],sheetnames{n})) | ismember('[',sheetnames{n}(1))
        error(['sheet (' sheetnames{n} ') contains an illegal character! (see xlsheets help)'])
    end
%  (3) Making sure each sheetname is not blank.
    if isempty(sheetnames{n})
        error(['sheet ' int2str(n) ' is empty! (see xlsheets help)'])
    end
%  (4) Making sure each sheetname is a character string.
    if ~ischar(sheetnames{n})
        error(['sheet (' int2str(n) ') is NOT a character string! (see xlsheets help)'])
    end
end

%  (5) Making sure two or more sheets do not have the same name.
if length(sheetnames)>length(unique(sheetnames))
    error('Two or more sheets have the same name!')

end

% Opening Excel
target_num_sheets = length(sheetnames);
Excel = actxserver('Excel.Application');
if nargin==2
    filename = varargin{1};
    [fpath,fname,fext] = fileparts(filename);
    if isempty(fpath)
        out_path = pwd;
    elseif fpath(1)=='.'
        out_path = [pwd filesep fpath];
    else
        out_path = fpath;
    end
    filename = [out_path filesep fname fext];
    if ~exist(filename,'file')
        % The following case if file does not exist (Creating New Workbook)
        Workbook = invoke(Excel.Workbooks,'Add');
        % getting the number of sheets in new workbook      
        numsheets = get(Excel,'SheetsInNewWorkbook');    
        new=1;
    else
        % The following case if file does exist (Opening Workbook)
        Workbook = invoke(Excel.Workbooks, 'open', filename);
        % getting the number of sheets in new workbook  
        workSheets = Excel.sheets;
        for i = 1:workSheets.Count
            sheet = get(workSheets,'item',i);
            description{i} = sheet.Name;
            if ~isempty(sheet.UsedRange.value)
                indexes(i) = true;
            else
                indexes(i) = false;
            end
        end
        descr = description(indexes);
        numsheets = length(descr);
        new=0;
    end
    leave_file_open = 0;
else
    % The following case if file does not exist (Creating New Workbook)
    Workbook = invoke(Excel.Workbooks,'Add');
    % getting the number of sheets in new workbook      
    numsheets = get(Excel,'SheetsInNewWorkbook');    
    new=1;
    leave_file_open = 1;
end

% making Excel visible only if workbook name is not specified or new workbook is created. 
if nargin==1
    set(Excel,'Visible', 1);
end

if target_num_sheets > numsheets
    
    % Activating Last sheet of new (filename)
    Sheets = Excel.ActiveWorkBook.Sheets;
    sheet = get(Sheets, 'Item', numsheets);
    invoke(sheet, 'Activate');
    
    % Adding sheets to match the number of (sheetnames) specified.
    for i=1:target_num_sheets-numsheets
        invoke(Excel.Sheets,'Add');
    end
    
elseif target_num_sheets < numsheets
    
    % Deleting sheets to match the number of (sheetnames) specified.
    for i=numsheets-target_num_sheets:-1:1
        sheet = get(Excel.ActiveWorkBook.Sheets, 'Item', i);
        invoke(sheet, 'Delete');
    end
end

% Renaming sheets to temporary names
for i=1:target_num_sheets
    Sheets = Excel.Worksheets;
    sheet = get(Sheets, 'Item', i);
    invoke(sheet, 'Activate');
    Activesheet = Excel.Activesheet;
    temp_name = ['temp_' int2str(i)];
    set(Activesheet,'Name',temp_name);
end

% Renaming sheets to the designated names
for i=1:target_num_sheets
    Sheets = Excel.Worksheets;
    sheet = get(Sheets, 'Item', i);
    invoke(sheet, 'Activate');
    Activesheet = Excel.Activesheet;
    set(Activesheet,'Name',char(sheetnames(i)));
end

if nargin>1
    if new invoke(Workbook, 'SaveAs', filename);
    else invoke(Workbook, 'Save'); end
end

if ~leave_file_open invoke(Excel, 'Quit'); end
delete(Excel);
