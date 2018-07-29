function [output,table] = lzw2norm(vector)
%LZW2NORM   LZW Data Compression (decoder)
%   For vectors, LZW2NORM(X) is the uncompressed vector of X using the LZW algorithm.
%   [...,T] = LZW2NORM(X) returns also the table that the algorithm produces.
%
%   For matrices, X(:) is used as input.
%
%   Input must be of uint16 type, while the output is a uint8.
%   Table is a cell array, each element containig the corresponding code.
%
%   This is an implementation of the algorithm presented in the article
%   http://www.dogma.net/markn/articles/lzw/lzw.htm
%
%   See also NORM2LZW


%   $Author: Giuseppe Ridino' $
%   $Revision: 1.0 $  $Date: 10-May-2004 14:16:08 $


% How it decodes:
%
% Read OLD_CODE
% output OLD_CODE
% CHARACTER = OLD_CODE
% WHILE there are still input characters DO
%     Read NEW_CODE
%     IF NEW_CODE is not in the translation table THEN
%         STRING = get translation of OLD_CODE
%         STRING = STRING+CHARACTER
%     ELSE
%         STRING = get translation of NEW_CODE
%     END of IF
%     output STRING
%     CHARACTER = first character in STRING
%     add translation of OLD_CODE + CHARACTER to the translation table
%     OLD_CODE = NEW_CODE
% END of WHILE


% ensure to handle uint8 input vector
if ~isa(vector,'uint16'),
	error('input argument must be a uint16 vector')
end

% vector as a row
vector = vector(:)';

% initialize table (don't use cellstr because char(10) will be turned to empty!!!)
table = cell(1,256);
for index = 1:256,
	table{index} = uint16(index-1);
end

% initialize output
output = uint8([]);

code = vector(1);
output(end+1) = code;
character = code;
for index=2:length(vector),
	element = vector(index);
	if (double(element)+1)>length(table),
		% add it to the table
		string = table{double(code)+1};
		string = [string character];
	else,
		string = table{double(element)+1};
	end
	output = [output string];
	character = string(1);
	[table,code] = addcode(table,[table{double(code)+1} character]);
	code = element;
end


% ###############################################
function code = getcodefor(substr,table)
code = uint16([]);
if length(substr)==1,
	code = substr;
else, % this is to skip the first 256 known positions
	for index=257:length(table),
		if isequal(substr,table{index}),
			code = uint16(index-1);   % start from 0
			break
		end
	end
end


% ###############################################
function [table,code] = addcode(table,substr)
code = length(table)+1;   % start from 1
table{code} = substr;
code = uint16(code-1);    % start from 0
