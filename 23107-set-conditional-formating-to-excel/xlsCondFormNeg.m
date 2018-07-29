function xlsCondFormNeg(filename,sheetname,varargin)

%put conditional format that change the negative numbers to red 
%

% xlsfont(filename,sheetname,range)
%
%Example:
%a=randn(100,1)
%xlswrite('a',a)
%xlsCondFormNeg('a','Sheet1','A1:A50')

options = varargin;

    range = varargin{1};
    options = varargin(2:end);




[fpath,file,ext] = fileparts(char(filename));
if isempty(fpath)
    fpath = pwd;
end
Excel = actxserver('Excel.Application');


set(Excel,'Visible',0);
Workbook = invoke(Excel.Workbooks, 'open', [fpath filesep file ext]);


sheet = get(Excel.Worksheets, 'Item',sheetname);
invoke(sheet,'Activate');


ExAct = Excel.Activesheet;
ExActRange = get(ExAct,'Range',range);
ExActRange.Select;


xlExpression=2;
Excel.Selection.FormatConditions.Delete;
Excel.Selection.FormatConditions.Add(xlExpression, [], ['=' range '<0']);
Excel.Selection.FormatConditions.Item(1).Font.ColorIndex = 3;


invoke(Workbook, 'Save');
invoke(Excel, 'Quit');
delete(Excel);

