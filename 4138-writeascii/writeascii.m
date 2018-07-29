function varargout = writeascii(outfile,data,dataformat,outperm)
% Easy function to write ASCII files
%
% USAGE:
%   show = writeascii(outfile,data,dataformat,outperm)
%
% DESCRIPTION:
%   Saves vector, matrix (up to 3 dimensions), string, 
%   or cell array data into an ASCII file.
%
% INPUT VARIABLES:
%   outfile = Name of out-file
%       default 'data.asc'
%   data = Vector, matrix (up to 3 dimensions), string, 
%       or cell array data
%   dataformat = format used for all columns of numeric data
%           e.g.  '%5.6f   ', ' %2g\t'
%           default is calculated using the highest decimal or
%               used in each column of data or 8 which ever is lower
%               if the data is a string, '%s' is used as the format
%       or delimiter to be used between columns
%           e.g.  '  ', '\t'
%           default '\t' %tab, helps makes it easier to import to excel
%   outperm = Permision for out-file used with fopen
%       e.g. 'a', 'w+'
%       default 'w'
%
% OUTPUT VARIABLES:
%   show = string saying the name of the out-file and
%       where it was saved
%
% VALID INPUT FORMATS:
%   writeascii(data)
%   writeascii(outfile,data)
%   writeascii(outfile,data,dataformat)
%   writeascii(outfile,data,dataformat,outperm)
%
%Copy-Left, Alejandro Sanchez

if nargin==1
    data = outfile; 
    outfile = 'data.asc';
end %if
if nargin<4
    outperm = 'w'; 
end %if

fid = fopen(outfile,outperm);

if ~iscell(data)
    data = {data};
end

N = numel(data);

if nargin>2
    if isempty(findstr('%',dataformat))
        d = dataformat;
        dataformat = [];
    end
else
    dataformat = [];
    d = ','; 
end

for c=1:N
    [m,n,p] = size(data{c});
    if isnumeric(data{c})
        if isempty(dataformat)
            fileformat = getformat(data{c},d);
        else
            fileformat = dataformat;
            nf = length(findstr('%',dataformat));
            if nf==1              
                for k=2:n
                    fileformat = [fileformat, dataformat];
                end %for k
            end
            if isempty(findstr('\n',fileformat))
                fileformat = [fileformat,'\n'];
            end
        end %if   
    elseif iscell(data{c})
        fileformat = '%s\n';
        data{c} = char(data{c});
        m = size(data{c},1);
    else %is string
        fileformat = '%s\n';
    end %if
    for b=1:p
        for k=1:m
            fprintf(fid,fileformat,data{c}(k,:,b));
        end %for k
%         fprintf(fid,'\n'); %line skip between outputs
    end %for b
end %for c

fclose(fid);
[pathstr,name,ext] = fileparts(outfile);
if isempty(pathstr)
    pathstr = pwd;
end
show = sprintf(['%s saved in: \n%s \n',...
        'with format: \n%s'],...
        [name,ext],pathstr,fileformat);

if nargout>0
    varargout{1} = show;
end

%------------------------------------------
function [f,dig,dec] = getformat(x,delim,maxdec,flag,convchar)
%Gets the format of a data matrix
%
% USAGE:
%   [f,dig,dec]=getformat(x,delim,maxdec,flag,convchar)
%
% DESCRIPTION:
%   Obtains the format for the data
%   array x which may contain NaN's
%   and gives the format and allows
%   for the specificaiton of the 
%   delimeter, maximum number of 
%   decimal places, the flag which 
%   controls the alignment
%   and the conversion character
%
% VARIABLES:
%   x - [mxn] matrix of data
%   delim - delimeter 
%       default -> space = ' '
%       e.g. ',' , '\t',
%   maxdec - maximum number of 
%       decimal places allowed
%   flag - flag to control the data alignment
%       default -> ''
%       either '+','-' or '0'
%   convchar - conversion character which
%       specifies the notation of the output
%      
% EXAMPLES:
%   f = getformat(data,' ',6,'0','f')
%   f = getformat(data,',',10,'+','g')
%
%Alejandro Sanchez, 2006
if nargin<2
    delim = ',';
end
if nargin<3
    maxdec = 7;
end
if nargin<4
    flag = '';
end
if nargin<5
    convchar = 'f';
end
c = size(x,2);
dig = zeros(c,1);
dec = dig;
f = [];
nr = min(size(x,1),10000); %for extreme large files
for k=1:c
    xx = x(1:nr,k);
    xx = xx(isfinite(xx));
    n = 1;
    xn = xx;
    xn(xx<0) = -10*xx(xx<0); %adds a digit
    r = all(xn/10 < 1);
    while r==0 
        n = n + 1;
        r = all(xn/10^n<1);
    end
    dig(k) = n;
    g = round(xx*10^maxdec)/10^maxdec;
    for n=maxdec-1:-1:0
        s = round(xx*10^(n-1))/10^(n-1);
        if any(any(g~=s))
            break
        end
        g = s;
    end  
    dec(k) = n;
    if k<c
        f = [f,'%',flag,num2str(dig(k)), ...
            '.',num2str(dec(k)),convchar,delim];
    else
        f = [f,'%',flag,num2str(dig(k)), ...
            '.',num2str(dec(k)),convchar];
    end
end
f = [f,'\n'];
return

%===================================================

