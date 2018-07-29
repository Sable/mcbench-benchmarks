function PlotInExcel
   x= {1:10};
   a= cell2mat(x);
   y= {1:10};
   b= cell2mat(y);
   %............plotting..............................................................................................
   plot(a,b);
   xlabel('X Values');
   ylabel('Y Values');
   print -dmeta;   %.................Copying to clipboard

   FILE  = 'C:\test_plot.xls';
   Range ='J20';
   %.............excel COM object............................................................................
         Excel = actxserver ('Excel.Application');
 Excel.Visible = 1;

 if ~exist(FILE,'file')
       ExcelWorkbook=Excel.Workbooks.Add;
       ExcelWorkbook.SaveAs(FILE);
       ExcelWorkbook.Close(false);
 end
 invoke(Excel.Workbooks,'Open',FILE); %Open the file
 ActiveSheet  = Excel.ActiveSheet;
 ActiveSheetRange  = get(ActiveSheet,'Range',Range);
 ActiveSheetRange.Select;
 ActiveSheetRange.PasteSpecial; %.................Pasting the figure to the selected location
 
%-----------------------------------end of function"PlotInExcel--------------------------------------
 

