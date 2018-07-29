function getdata (option)
global A opt leg label

[fname,pname] = uigetfile({'*.csv';'*.xls';'*.txt'},'Select File');
dbfile= strcat(pname,fname);
if length(dbfile) == 0 return; end

% Check if the file IS there
d= dir(fname);
if isempty(d.name) 
	errordlg ('Sorry, don''t find that file','Error'); 
	return; 
end

% Open the file
fdata= fopen(fname,'rt');
A= [];
leg= {};

% Put a comma before first column. This is required to use tblread, get 
% propper reading of column names but avoid that the user has to 
% include it
fileout= fopen('Qdata.csv','wt');
while 1
	s = fgets(fdata);
	if ~ischar(s), break, end
	fprintf(fileout,'%s%s',',',s);
end
fclose(fdata);
fname= 'Qdata.csv';

% Read it
switch option
	case 1
		[A,leg]= tblread(fname,'comma');
	case 2
		[A,leg]= xlsread(dbfile);
	case 3
		[A,leg]= xlsread(dbfile,-1)
end

%Generate cell string array fot title if there aren't any
if isempty(leg) leg= cellstr( num2str( flipud(rot90([1:size(A,2)])) ) ); end

% Choosing default x-y-z columns
opt.xc= 1;
switch size(A,2)
	case 1
		opt.yc= 1;
		opt.ec= 1;
		opt.zc= 1;
	case 2
		opt.yc= 2;
		opt.ec= 2;
		opt.zc= 2;
	otherwise
		opt.yc= [2:size(A,2)-1];
		opt.ec= [fix(size(A,2)/2):size(A,2)];
		opt.zc= [3:size(A,2)];
end

return
