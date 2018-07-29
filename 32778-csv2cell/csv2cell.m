% csv2cell() - Imports the contents of a character delimited spreadsheet 
%              text file as a 2D cell array, csv_matrix.  
%
% Usage:
%  >> csv_matrix=csv2cell(csv_fname,delimiter);
%
% Required Input:
%   csv_fname - The name of the text file to import.  If a path is not
%               included in the name, the current working directory will 
%               be used.
%
% Optional Input:
%   delimiter - The character that marks cell boundaries in the text file.
%               {default: ','}
%
% Output:
%   csv_matrix - 2D cell array of strings. csv_matrix{x,y} corresponds to
%                the cell in the xth row and yth column in the spreadsheet.
%
% Note, be sure not to use the delimiting character in the text file as 
% anything but a cell boundary marker.
%
% Example:
%  >> demo_dat=round(rand(5,3)*10);
%  >> fid=fopen('demo.csv','w');
%  >> for a=1:5, for b=1:3, fprintf(fid,'%d,',demo_dat(a,b)); end; fprintf(fid,'\n'); end;
%  >> fclose(fid);
%  >> csv_matrix=csv2cell('demo.csv',',');
%
% Author: 
%  David Groppe
%  9/3/2011
%  Mehtalab
%  Cushing Neuroscience Institutes
%  New Hyde Park, New York

function csv_matrix=csv2cell(csv_fname,delimiter)

if nargin<1,
    help csv2cell
end

if nargin<2,
    delimiter=',';
else
    if ~ischar(delimiter)
        error('Specified delimiter needs to be a character.');
    elseif length(delimiter)>1
        error('Delimiter needs to be a single character.');
    end
end

[fid, msg]=fopen(csv_fname,'r');
if fid==-1,
   error('Cannot open %s because: %s.\n',csv_fname,msg); 
end

csv_matrix=cell(1,1);
row_ct=1;
col_ct=1;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end

    while ~isempty(tline),
        [t, tline]=parse_by_char(tline,delimiter);
        csv_matrix{row_ct,col_ct}=t;
        col_ct=col_ct+1;
    end
    col_ct=1;
    row_ct=row_ct+1;
end
fclose(fid);


function [pre, post]=parse_by_char(str,delimiter)

char_ids=find(str==delimiter);
if isempty(char_ids),
    pre=str;
    post=[];
else
    pre=str(1:char_ids(1)-1);
    post=str(char_ids(1)+1:end);
end