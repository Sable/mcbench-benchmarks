function xlswrite(m,header,colnames,filename,sheetname)
% xlswrite     Easily create an Excel spreadsheet from MATLAB
%
%  xlswrite(m,header,colnames,filename) creates a Microsoft Excel spreadsheet using
%  the MATLAB ActiveX interface.  Microsoft Excel is required.
%
%Inputs:
%    m          Matrix to write to file
% (Optional):
%    header     String of header information.  Use cell array for multiple lines
%                  DO NOT USE multiple row character arrays!!
%    colnames   (Cell array of strings) Column headers.  One cell element per column
%    filename   (string) Name of Excel file.  If not specified, contents will
%                  be opened in Excel.
%    sheetname:  Name of sheet to write data to . The default is 'Sheet1'
%                       if specified, a sheet with the specified name must
%                       exist
%
% ex:
%   m = rand(100,4);
%   header = 'my data';
%   %header{1} = 'first line';      %This will give
%   %header{2} = 'second line';     % 2 header lines
%   colnames = {'Ch1','Ch2','Ch3','Ch4'};
%
%   xlswrite(m,header,colnames,'myfile.xls');
%        will save the spreadsheet as myfile.xls.  The user
%           will never see Excel
%   xlswrite(m,header,colnames);
%        will open Excel with these contents in a new spreadsheet.
%
% ex 2:
%      filename = 'family.xls';          % can be named without '.xls'
%      sheetname = 'Sheet2';
%      header = 'Who Let The Dogs Out?';
%      %header{1} = 'first line';      %This will give
%      %header{2} = 'second line';     % 2 header lines
%      colnames = {'1st','2nd','3rd','4th','5th'};
%      m = rand(10,5);
%      xlswrite(m,header,colnames,filename,sheetname)


% Scott Hirsch
% The MathWorks
% This is provided free, no warranty, ...
%
% Copied from ActiveX example in documentation
%
% In collaboration with:
% Fahad Al Mahmood fahad@al-mahmood.com
% Fahad developed the capabilities for writing to multiple sheets
%
% Dragon.  dragon5645995@sina.com.cn
% Dragon fixed a bug when writing out 52 or more columns
% 

% Parse inputs
if nargin<2
    header = [];
end;

if nargin<3
    colnames = {};
end;

if nargin<4 || isempty(filename)
    visible = 1;    % Not saving to a file, so make Excel visible
    filename = '';
else
    visible = 0;    % Saving to a file.  Keep Excel hidden
end;

if nargin < 5 || isempty(sheetname)
    sheetname = 'Sheet1';
end;

[nr,nc] = size(m);
if nc>256
    error('Matrix is too large.  Excel only supports 256 columns');
end;

% Open Excel, add workbook, change active worksheet, 
% get/put array, save.
% First, open an Excel Server.
Excel = actxserver('Excel.Application');

% Three cases:
% * Open a new workbook, but don't save (filename is empty)
% * Open a new workbook, save with given file name
% * Open an existing workbook
if isempty(filename)
    % Insert a new workbook.
    op = invoke(Excel.Workbooks, 'Add');
    
elseif exist(filename,'file')==0
    % The following case if file does not exist (Creating New File)
    op = invoke(Excel.Workbooks,'Add');
    invoke(op, 'SaveAs', [pwd filesep filename]);
    new = 1;	% Flag to check during debugging, apparently.
else
    % The following case if file does exist (Opening File)
    disp(['Opening Excel File ...(' filename ')']);
    op = invoke(Excel.Workbooks, 'open', [pwd filesep filename]);
    new = 0;	% Flag to check during debugging, apparently.
end

%If the user does not specify a filename, we'll make Excel visible
%If they do, we'll just save the file and quit Excel without ever making
% it visible
set(Excel, 'Visible', visible);      %You might want to hide this if you autosave the file



% Make the specified sheet active.
try 
    Sheets = Excel.ActiveWorkBook.Sheets;
    target_sheet = get(Sheets, 'Item', sheetname);
catch
    % Error if the sheet doesn't exist.  It would be nice to create it, but
    % I'm too lazy.
    % The alternative to try/catch is to call xlsfinfo to see if the sheet exists, but
    % that's really slow.
    error(['Sheet ' sheetname ' does not exist!']);
end;

invoke(target_sheet, 'Activate');

[nr,nc] = size(m);
if nc>256
    error('Matrix is too large.  Excel only supports 256 columns');
end;



%Write header
Activesheet = Excel.Activesheet;
if isempty(header)
    nhr=0;
elseif iscell(header)
    nhr = length(header);       %Number header rows
    for ii=1:nhr
        ActivesheetRange = get(Activesheet,'Range',['A' num2str(ii)],['A' num2str(ii)]);
        set(ActivesheetRange, 'Value', header{ii});
    end;
else
    nhr = 1;                   %Number header rows
    ActivesheetRange = get(Activesheet,'Range','A1','A1');
    set(ActivesheetRange, 'Value', header);
end;


%Add column names

if ~isempty(colnames)
    nhr = nhr + 1;      %One extra column name
    ncolnames = length(colnames);
    for ii=1:ncolnames
        colname = localComputLastCol('A',ii);
        %    cellname = [char(double('A')+ii-1) num2str(nhr+1)];
        cellname = [colname num2str(nhr)];
        ActivesheetRange = get(Activesheet,'Range',cellname,cellname);
        set(ActivesheetRange, 'Value', colnames{ii});
    end;
end;


% Put a MATLAB array into Excel.
FirstRow = nhr+1;           %You can change the first data row here.  I start right after the headers
LastRow = FirstRow+nr-1;
FirstCol = 'A';         %You can change the first column here
LastCol = localComputLastCol(FirstCol,nc);
ActivesheetRange = get(Activesheet,'Range',[FirstCol num2str(FirstRow)],[LastCol num2str(LastRow)]);
set(ActivesheetRange, 'Value', m);



% If user specified a filename, save the file and quit Excel

% If user specified a filename, save the file and quit Excel
if ~isempty(filename)
    [pathstr,name,ext] = fileparts(filename);
    if isempty(pathstr)
        pathstr = pwd;
    end;
    
invoke(op, 'Save');
%     invoke(Workbook, 'SaveAs', [pathstr filesep name ext]);
    invoke(Excel, 'Quit');
    
    [pathstr,name,ext] = fileparts(filename);
    disp(['Excel file ' name '.xls has been created.']);
end;

%Delete the ActiveX object
delete(Excel)

% localComputLastCol - Computes the last column that will have data written to it
% in Excel, given the letter(s) of the first column and the number of columns to write.
% Modification of Scott Hirsch's code 
% by Mark Hayworth, The Procter & Gamble Company, September 2006.
function LastColumnLetters = localComputLastCol(FirstCol, numberOfColumnsToWrite)
	% Convert to upper case.
	FirstCol = upper(FirstCol);
	
	if length(FirstCol) == 1 
		FirstColOffset = double(FirstCol) - double('A');    %Offset from column A
	else
		% Fix for starting columns having double letters
		% provided by Mark Hayworth, Procter & Gamble
		firstLetter = FirstCol(1);
		secondLetter = FirstCol(2);
		FirstColOffset = 26 * (double(firstLetter) - double('A') + 1) + (double(secondLetter) - double('A'));    %Offset from column A
	end
	
	% Compute the numerical column number where the last data will reside.
	lastColumnNumber = FirstColOffset + numberOfColumnsToWrite;
	if lastColumnNumber > 256
		% Excel (STILL!) can handle only 256 columns.
		% Set it to 256 if it exceeds this, just to avoid an error.
		lastColumnNumber = 256;
	end
	
	% Compute the column header letters.  It will either be one letter in the range of A-Z
	% or two letters, like AA, AB, . . . IV.  IV is the most Excel can handle.
	if lastColumnNumber <= 26
		% It needs just a single letter.
		% Just convert to ASCII code, add the number of needed columns, 
		% and convert back to a string.
		LastColumnLetters = char(double(FirstCol) + numberOfColumnsToWrite - 1);
	else
		% It needs a double letter.
		
		% This block fixes Scott Hirsch's code (which has a bug for high 
		% column letters and/or high numbers of columns to write).
		% Fixed by Mark Hayworth, The Procter & Gamble Company.
		
		% Get which group of 26 it's in: A-Z, AA-AZ, BA-BZ, ... HA-HZ, or IA-IV
		% A* = group #0, B* = group #1, I* = group #8.
		groupNumber = ceil(lastColumnNumber / 26) - 2;  
		
		% Find out what the offset is for the last column with that group of 26.
		% In other words, how many columns beyond the last group of 26 is it?
		groupOffset = rem(lastColumnNumber - 1, 26);
		% The above line maps ranges 27-52, 53-78, 79-104, 105-130, 106-156, 
		% 157-182, 183-208, 209-234, and 235-260 into the range 0-25.
		
		LastColFirstLetter  = char(double('A') + groupNumber);
		LastColSecondLetter = char(double('A') + groupOffset);
		% Append first and last letters together to get combined double letter.
		LastColumnLetters = [LastColFirstLetter LastColSecondLetter];
	end
	return;
