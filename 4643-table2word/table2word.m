function table2word(titles,m,varargin)

%TABLE2WORD creates or appends a table in Microsoft Word.
%
% table2word(titles,m)
% table2word(titles,m,table_title)
% table2word(titles,m,style)
% table2word(titles,m,style,table_title)
% table2word(titles,m,filename)
% table2word(titles,m,filename,table_title)
% table2word(titles,m,style,filename)
% table2word(titles,m,style,filename,table_title)
%
%
%       titles:         Column titles (cell array).
%       m:              matrix of numbers.
%       filename:       Name of excel file.
%       style:          Table Style (from the list below).
%       table_title:    Title of Table to be displayed on top of table.
% 
%   STYLE:
%
%   Table 3D effects 1	    Table Contemporary	Table List 5
%   Table 3D effects 2	    Table Elegent	    Table List 6
%   Table 3D effects 3	    Table Grid	        Table List 7
%   Table Classic 1	        Table Grid 1	    Table List 8
%   Table Classic 2	        Table Grid 2	    Table Normal
%   Table Classic 3	        Table Grid 3	    Table Professional
%   Table Classic 4	        Table Grid 4	    Table Simple 1
%   Table Colorful 1	    Table Grid 5	    Table Simple 2
%   Table Colorful 2	    Table Grid 6	    Table Simple 3
%   Table Colorful 3	    Table Grid 7	    Table Subtle 1
%   Table Columns 1	        Table Grid 8	    Table Subtle 2
%   Table Columns 2	        Table List 1	    Table Theme
%   Table Columns 3	        Table List 2	    Table Web 1
%   Table Columns 4	        Table List 3	    Table Web 2
%   Table Columns 5	        Table List 4	    Table Web 3
%
%
% Examples:
%      titles = {'1st','2nd','3rd','4th','5th','6th','7th','8th','9th','10th'};
%      m = magic(10);
%      table2word(titles,m);
%      table2word(titles,m,'Table Professional');
%      table2word(titles,m,'table.doc');
%      table2word(titles,m,'Table List 1','table.doc');
%      table2word(titles,m,'Table List 1','table.doc','My Table Title');
%
%   See also MSOPEN
%
%   Copyright 2004 Fahad Al Mahmood
%   Version: 1.0 $  $Date: 17-Mar-2004
%   Version: 1.5 $  $Date: 18-Mar-2004  (Appends New Tables to Top of
%                                       Document)
%   Version: 2.0 $  $Date: 07-Apr-2004  (Appends New Tables to End of
%                                       Document + table title option added)

styles={'Table 3D effects 1','Table Contemporary','Table List 5',...
  'Table 3D effects 2','Table Elegent','Table List 6',...
  'Table 3D effects 3','Table Grid','Table List 7',...
  'Table Classic 1','Table Grid 1','Table List 8',...
  'Table Classic 2','Table Grid 2','Table Normal',...
  'Table Classic 3','Table Grid 3','Table Professional',...
  'Table Classic 4','Table Grid 4','Table Simple 1',...
  'Table Colorful 1','Table Grid 5','Table Simple 2',...
  'Table Colorful 2','Table Grid 6','Table Simple 3',...
  'Table Colorful 3','Table Grid 7','Table Subtle 1',...
  'Table Columns 1','Table Grid 8','Table Subtle 2',...
  'Table Columns 2','Table List 1','Table Theme',...
  'Table Columns 3','Table List 2','Table Web 1',...
  'Table Columns 4','Table List 3','Table Web 2',...
  'Table Columns 5','Table List 4','Table Web 3'};

if ~isempty(varargin)
    if length(varargin)==3
        style = varargin{1};
        filename = varargin{2};
        table_title = varargin{3};
    elseif length(varargin)==2
        x = findstr(varargin{1},'.doc');
        if ~isempty(x) filename = varargin{1}; table_title = varargin{2};
        else
            style = varargin{1};
            x = findstr(varargin{2},'.doc');
            if ~isempty(x) filename = varargin{2};
            else table_title = varargin{2}; end
        end
    else
        x = findstr(char(varargin),'.doc');
        if ~isempty(x) filename = varargin{1};
        elseif ~isempty(intersect(styles,varargin{1})) style = varargin{1};
        else table_title = varargin{1}; end
    end
end

nc = size(m,2);
nr = size(m,1);


% Opening Excel
Excel = actxserver('Excel.Application');
set(Excel,'Visible',0);
Workbook = invoke(Excel.Workbooks,'Add');

% Opening Word
Doc = actxserver('Word.Application');
if ~exist('filename','var')
    set(Doc,'Visible',1);
    MS = invoke(Doc.Documents,'Add');
    new = 1;
else
    [fpath,fname,fext]=fileparts(filename);
    if isempty(fpath) fpath = pwd; end
    if isempty(fext) fext = '.doc'; end
    filename = [fpath filesep fname fext];
    set(Doc,'Visible',0);
    if exist(filename,'file')
        MS = invoke(Doc.Documents, 'Open', filename);
        new = 0;
    else
        MS = invoke(Doc.Documents,'Add');
        new = 1;
    end
end


invoke(Doc.Selection,'EndKey',6);           % To place cursor at End of Doc (6 = 'wdStory')


% Copying Table to Excel
LastCol = localComputLastCol('A',nc);
ExAct = get(Excel,'Activesheet');
ExActRange = get(ExAct,'Range','A1',[LastCol '1']);
set(ExActRange,'Value',titles);
ExActRange = get(ExAct,'Range',['A2:' LastCol int2str(size(m,1)+1)]);
set(ExActRange,'Value',m);

% Selecing Table from Excel and Copying
ExActRange = get(ExAct,'Range',['A1:' LastCol int2str(size(m,1)+1)]);
invoke(ExActRange,'Select');
invoke(Excel.Selection,'Copy');

% Pasting Selection to Word & assigning style
if exist('table_title','var')
    invoke(Doc.Selection,'TypeParagraph');
    set(Doc.Selection,'Text',table_title)
    %set(Doc.Selection.ParagraphFormat,'Alignment',1);    % Centering Title
    set(Doc.Selection.Font,'Bold',1)
    invoke(Doc.Selection,'MoveDown');
    invoke(Doc.Selection,'TypeParagraph');
end
invoke(Doc.Selection,'Paste');
invoke(Doc.Selection,'TypeParagraph');
invoke(Doc.Selection,'MoveUp');
invoke(Doc.Selection,'MoveUp');
if exist('style','var') set(Doc.Selection,'Style',style);
else set(Doc.Selection,'Style','Table Normal'); end
%TB = invoke(Doc.Selection.Tables,'Item',1);
%set(TB.Rows,'Alignment',1);      % Centering Table
invoke(Doc.Selection,'MoveDown');

% Saving if filename is specified
if exist('filename','var')
    if new
        invoke(MS,'SaveAs',filename);
        invoke(Doc,'Quit');
        delete(Doc);
    else
        invoke(MS,'Save');
        invoke(Doc,'Quit');
        delete(Doc);
    end
end

invoke(Workbook, 'SaveAs', [pwd filesep 'temp.xls']);
invoke(Excel, 'Quit');
delete(Excel);
delete temp.xls;
clear Excel;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  This function is a carbon copy from (xlswrite)  %%%%%%
%%%%%%              written by (Scott Hirsch)           %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function LastCol = localComputLastCol(FirstCol,nc);
% Comput the name of the last column where we will place data
%Input
%  FirstCol  (string) name of first column
%  nc        total number of columns to write

%Excel's columns are named:
% A B C ... A AA AB AC AD .... BA BB BC ...
FirstColOffset = double(FirstCol) - double('A');    %Offset from column A
if nc<=26-FirstColOffset       %Easy if single letter
    %Just convert to ASCII code, add the number of needed columns, and convert back
    %to a string
    LastCol = char(double(FirstCol)+nc-1);
else
    ng = ceil(nc/26);       %Number of groups (of 26)
    rm = rem(nc,26)+FirstColOffset;        %How many extra in this group beyond A
    LastColFirstLetter = char(double('A') + ng-2);
    LastColSecondLetter = char(double('A') + rm-1);
    LastCol = [LastColFirstLetter LastColSecondLetter];
end;
