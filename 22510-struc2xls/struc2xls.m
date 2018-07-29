function struc2xls(filename,s,varargin)
%STRUC2XLS Saves a data structure to an Excel file
% STRUC2XLS (FILE,S) writes the data structure S to an Excel workbook named
% FILE in the current directory. FILE can also be entered using path
% notation to specify a different output directory. If the file does not
% exist, it will be created in the current directory. If it does exists,
% **it will be overwritten or modified without warning!** If the output
% file exists, it cannot be open in Excel. The name of the structure can
% include indexing values to export only a subset of the structure.
%
% Optional output parameters: (...,'Sheet',SHEETNAME) specifies the name of
% the worksheet. SHEETNAME mustbe a character string. If it does not exist
% in the Excel workbook it will be added. Default is 'Sheet1'.
%
% (...,'Col',C) and (...,'Row',R) specifiy the starting column and row of
% in Excel, respectively. R must be a positive integer, and C must be a
% capital letter index from 'A' to 'IV' using the Excel's column indexing
% format. See Excel if clarification is needed. Default is column A, row 1
% (cell A1 in Excel).
%
% (...,'Orientataion','O') specifies orientation of output. O is entered as
% 'V' for vertical or 'H' for horizontal. When V is entered, field names
% appear as column headers beginning in row R beginning at column C, and
% the contents of the structure are written in the rows below them. When H
% is entered, field names appear in column C beginning at row R and the
% contents of the structure are written in the columns to the right.
% Default is V.
%
% EXAMPLES:
%   Create a sample structure 's' with two fields:
%	s=%	struct('Name',{'Jon','Jonathan','Johnny'},'Score',[85,100,75]);
%
%   Basic output to file 'demo.xls' in current directory:
%	struc2xls('demo',s)
%
%   Output beginning in cell D4 of Excel file:
%	struc2xls('demo',s,'Col','D','Row',4)
%
%   Output to worksheet 'Students':
%	struc2xls('demo',s,'Sheet','Students')
%
%   Output horizontal data (header row, data in columns):
%   struc2xls('demo',s,'Orientation','H')
%
%   Output to alternate directory
%   structxls('C:\Users\Johnny\Desktop\demo',s)
%
%
%   Modified from struct2xls.m by Francisco de Castro:
%   http://www.mathworks.com/matlabcentral/fileexchange/18530
%
%   Jeff Evans Dec-22-2008


%Defaults
sheet= 'Sheet1';
col= 'A';
fstrow= 1;
orient= 'V';

%Optional arguments
if ~isempty(varargin)
    for j= 1:2:length(varargin)
        switch varargin{j}
            case 'Sheet'
                sheet= varargin{j+1};
            case 'Col'
                col= varargin{j+1};
            case 'Row'
                fstrow= varargin{j+1};
            case 'Orientation'
                orient= varargin{j+1};
            otherwise
                error ('Unrecognized argument name');
        end
    end
end

%Output range
rangeOut=strcat(col,num2str(fstrow));

%Transform to cell
c= struct2cell(s);

%Field names
names= fieldnames(s);

%Concatenate field names and data. Create output dataset in vertical or
%horizontal orientation.
if strmatch(orient,'V')==1
    out=[names';c'];
elseif strmatch(orient,'H')==1
    out=[names, c];
end
%write
xlswrite(filename,out,sheet,rangeOut);
