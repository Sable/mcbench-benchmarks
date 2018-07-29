function [data, headerText] = load_ascii(filename,delimiter,header,nlines,offset) 

% This function loads data from a tab delimited or csv ascii file similar 
% to dlmread/importdata. If the file has fixed width columns and an offset 
% is desired, it uses this information to quickly scan to desired area 
% (making it significantly faster in those scenarios). Useful when working 
% with very large ascii files that cannot be entirely loaded into memory at 
% one time. If a file is loaded in with no offset, load_ascii is comparable 
% to dlmread (faster/slower depends on delimiter). Importdata is many times 
% slower than both.
% 
% Inputs:
% 
% filename: absolute or relative file path
% header: number of lines for header (defaults to 0)
% nlines: number of lines to read in (defaults to inf)
% offset: number of lines to skip (defaults to 0) (assumes data is 
% written with a fixed field width. If this is not the
% case, offset option will not work.
% delimiter: delimiter in ascii file (defaults to tab)
% 
% outputs:
% data: matrix of data in file
% headerText: text of header as specified by header input
% 
% Example usage:
% Consider scenario where we have a very large ascii file (fixed width tab 
% delimited, 24 header lines). We are only interested in a section of 2e6 
% lines, 20e6 past the end of the header.
% %syntax
% %[data,headerText] = load_ascii(filename,delimiter,header,nlines,offset)
% tic;data = load_ascii(filename,'\t',24,2e6,20e6);toc;
% tic;data2 = dlmread(filename,'\t',[20e6+24 0 12e6+23 2]);toc;
% Elapsed time is 3.838641 seconds.
% Elapsed time is 21.537717 seconds.



% initialize some things
if nargin<3, header = 0;end
if nargin<4, nlines = inf;end
if nargin<5, offset = 0;end
if nargin<2, delimiter = '\t';end

fid = fopen(filename);
headerCell = cell(header,1);
for i=1:header
    headerCell{i} = fgets(fid);
end
headerText = char(headerCell);

% First line of Data...
fline = fgets(fid);

% determine number of columns
delKey = double(sprintf(delimiter));
ncols = sum(fline == delKey)+1;

% determine number of bytes per line
bytesPerLine = length(fline);

% skip offset
fseek(fid,bytesPerLine*(offset-1),0);

% read data and keep native format
d = fread(fid,bytesPerLine*nlines,'char=>char');

%convert format to matrix
format = ['%f' delimiter];
if ~strcmp(delimiter,'\t'),format = repmat(['%f' delimiter],1,ncols);format = format(1:end-1);end
data = sscanf(d,format,[ncols,nlines])';

fclose(fid);
end