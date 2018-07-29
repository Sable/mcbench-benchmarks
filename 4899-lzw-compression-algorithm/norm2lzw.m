function [output,table] = norm2lzw(vector)
%NORM2LZW   LZW Data Compression (encoder)
%   For vectors, NORM2LZW(X) is the compressed vector of X using the LZW algorithm.
%   [...,T] = NORM2LZW(X) returns also the table that the algorithm produces.
%
%   For matrices, X(:) is used as input.
%
%   Input must be of uint8 type, while the output is a uint16.
%   Table is a cell array, each element containig the corresponding code.
%
%   This is an implementation of the algorithm presented in the article
%   http://www.dogma.net/markn/articles/lzw/lzw.htm
%
%   See also LZW2NORM


%   $Author: Giuseppe Ridino' $
%   $Revision: 1.0 $  $Date: 10-May-2004 14:16:08 $


% How it encodes:
%
% STRING = get input character
% WHILE there are still input characters DO
%     CHARACTER = get input character
%     IF STRING+CHARACTER is in the string table then
%         STRING = STRING+character
%     ELSE
%         output the code for STRING
%         add STRING+CHARACTER to the string table
%         STRING = CHARACTER
%     END of IF
% END of WHILE
% output the code for STRING


% ensure to handle uint8 input vector
if ~isa(vector,'uint8'),
	error('input argument must be a uint8 vector')
end

% vector as uint16 row
vector = uint16(vector(:)');

% initialize table (don't use cellstr because char(10) will be turned to empty!!!)
table = cell(1,256);
for index = 1:256,
	table{index} = uint16(index-1);
end

% initialize output
output = vector;

% main loop
outputindex = 1;
startindex = 1;
for index=2:length(vector),
	element = vector(index);
	substr = vector(startindex:(index-1));
	code = getcodefor([substr element],table);
	if isempty(code),
		% add it to the table
		output(outputindex) = getcodefor(substr,table);
		[table,code] = addcode(table,[substr element]);
		outputindex = outputindex+1;
		startindex = index;
	else,
		% go on looping
	end
end

substr = vector(startindex:index);
output(outputindex) = getcodefor(substr,table);

% remove not used positions
output((outputindex+1):end) = [];


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
