%created by: Quan Quach
%date: 11/6/07
%this function erases any empty sheets in an excel document
 
function deleteEmptyExcelSheets(fileName)
 
%the input fileName is the entire path of the file
%for example, fileName = 'C:\Documents and Settings\matlab\myExcelFile.xls'
 
 
excelObj = actxserver('Excel.Application');
%opens up an excel object 
excelWorkbook = excelObj.workbooks.Open(fileName);
worksheets = excelObj.sheets;
%total number of sheets in workbook
numSheets = worksheets.Count;
 
count=1;
for x=1:numSheets
    %stores the current number of sheets in the workbook
    %this number will change if sheets are deleted
    temp = worksheets.count;
 
    %if there's only one sheet left, we must leave it or else 
    %there will be an error.
    if (temp == 1) 
        break; 
    end
 
    %this command will only delete the sheet if it is empty
    worksheets.Item(count).Delete;
 
    %if a sheet was not deleted, we move on to the next one 
    %by incrementing the count variable
    if (temp == worksheets.count)
        count = count + 1;
    end
end
excelWorkbook.Save;
excelWorkbook.Close(false);
excelObj.Quit;
delete(excelObj);
     