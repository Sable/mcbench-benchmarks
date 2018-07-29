function struct2xls(filename,s,varargin)
%STRUC2XLS Writes the contents os a simple structure into an Excel file
% STRUC2XLS (FILE,S) writes the contents of structure S to a excel file
% named FILE. The name of the structure can be followed by parameter/value 
% pairs to specify additional properties. 
% 
% The name of the worksheet can be specified as (...,'Sheet',WSHEET) 
% where WSHEET is a character string. If it does not exist it will be added 
% to the excel file. The starting row and column can be specified as 
% (...,'Row',R) and (...,'Col',C) respectively. R must be a non-negative 
% integer, and C must be a capital letter from 'A' to 'Z'. Field names will 
% be written in column C starting at row R. The contents of the structure 
% will be written adjacent to each field name.
% 
% EXAMPLE: 
%	s= struct('one',[1,2],'two',[10,20,30],'three',[100,200,300,400]);
%	struct2xls('s2xls',s,'Row',4,'Col','D')
%
%	Jan-31-2008


%Defaults
sheet= 'Sheet1';
col= 'A';
fstrow= 1;

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
			otherwise
				error ('Unrecognized argument name');
		end
	end
end

%Transform to cell
c= struct2cell(s);

%Field names
f= fieldnames(s);

%write
for j= 1:size(f,1)
	m= cell2mat(c(j));
	rangeA= [col,num2str(j+fstrow-1)];
	rangeB= [char(double(col+1)),num2str(j+fstrow-1)];
	xlswrite(filename,f(j),sheet,rangeA);
	xlswrite(filename,m,sheet,rangeB);
end
