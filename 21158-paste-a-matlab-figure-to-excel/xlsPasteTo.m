function xlsPasteTo(filename,sheetname,width, height,varargin)

%Paste current figure to selected Excel sheet and cell
%
%
% xlsPasteTo(filename,sheetname,width, height,range)
%Example:
%xlsPasteTo('File.xls','Sheet1',200, 200,'A1')
% this will paset into A1 at Sheet1 at File.xls the current figure with
% width and height of 200
%
% tal.shir@hotmail.com

options = varargin;

    range = varargin{1};
    




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
    pos=get(gcf,'Position');
    set(gcf,'Position',[ pos(1:2) width height])
    print -dmeta

invoke(Excel.Selection,'PasteSpecial');

invoke(Workbook, 'Save');
invoke(Excel, 'Quit');
delete(Excel);

