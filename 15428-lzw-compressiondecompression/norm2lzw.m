function [output, table] = norm2lzw (vector, maxTableSize, restartTable)
%NORM2LZW   LZW Data Compression Encoder
%   For vectors, NORM2LZW(X) is the compressed vector of X using the LZW algorithm.
%   [...,T] = NORM2LZW(X) returns also the table that the algorithm produces.
%
%   For matrices, X(:) is used as input.
%
%   maxTableSize can be used to set a maximum length of the table. Default
%   is 4096 entries, use Inf for unlimited. Usual sizes are 12, 14 and 16
%   bits.
%
%	If restartTable is specified, then the table is flushed when it reaches
%	its maximum size and a new table is built.
%
%   Input must be of uint8 type, while the output is a uint16.
%   Table is a cell array, each element containing the corresponding code.
%
%   This is an implementation of the algorithm presented in the article
%   http://www.dogma.net/markn/articles/lzw/lzw.htm
%
%   See also LZW2NORM


%   $Author: Giuseppe Ridino' $
%   $Revision: 1.0 $  $Date: 10-May-2004 14:16:08 $
%
%   Revision:
%       Change the code table structure to improve the performance.
%       date: 22-Apr-2007
%       by:   Haiyong Xu (haiyeong@gmail.com)
%
%		Rework the code table completely to get reasonable performance.
%		date: 24-Jun-2007
%		by:   Duncan Barclay (dmlb@dmlb.org)

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

% Ensure to handle uint8 input vector and convert
% to a double row to make maths work
if ~isa(vector,'uint8'),
	error('input argument must be a uint8 vector')
end
vector = double(vector(:)');

if (nargin < 2)
	maxTableSize = 4096;
	restartTable = 0;
end;
if (nargin < 3)
	restartTable = 0;
end;

	function code = findCode(lastCode, c)
		% Look up code value

		% if (isempty(lastCode))
		% 	fprintf('findCode: ---- + %02x = ', c);
		% else
		% 	fprintf('findCode: %04x + %02x = ', lastCode, c);
		% end;

		if (isempty(lastCode))
			code = c+1;
			%fprintf('%04x\n', code);
			return;
		else
			ii = table.codes(lastCode).prefix;
			jj = find([table.codes(ii).c] == c);
			code = ii(jj);
			% 	if (isempty(code))
			% 		fprintf('----\n');
			% 	else
			% 		fprintf('%04x\n', code);
			% 	end;
			return;
		end;
		code = [];
		return;
	end

	function [] = addCode(lastCode, c)
		% Add a new code to the table

		e.c = c;	% NB using variable in parent to avoid allocation cost
		e.lastCode = lastCode;
		e.prefix = [];
		e.codeLength = table.codes(lastCode).codeLength + 1;
		table.codes(table.nextCode) = e;
		table.codes(lastCode).prefix = [table.codes(lastCode).prefix table.nextCode];
		table.nextCode = table.nextCode + 1;

		% if (isempty(lastCode))
		% 	fprintf('addCode   : ---- + %02x = %04x\n', c, table.nextCode-1);
		% else
		% 	fprintf('addCode   : %04x + %02x = %04x\n', lastCode, c, table.nextCode-1);
		% end;
	end

	function [] = newTable
		% Build the initial table consisting of all codes of length 1. The strings
		% are stored as prefixCode + character, so that testing is very quick. To
		% speed up searching, we store a list of codes that each code is the prefix
		% for.
		e.c = 0;
		e.lastCode = -1;
		e.prefix = [];
		e.codeLength = 1;
		table.nextCode = 2;
		if (~isinf(maxTableSize))
			table.codes(1:maxTableSize) = e; % Pre-allocate for speed
		else
			table.codes(1:65536) = e; % Pre-allocate for speed
		end;
		for c = 1:255
			e.c = c;
			e.lastCode = -1;
			e.prefix = [];
			e.codeLength = 1;
			table.codes(table.nextCode) = e;
			table.nextCode = table.nextCode + 1;
		end;
	end
%
% Main loop
%
e.c = 0;
e.lastCode = -1;
e.prefix = [];
e.codeLength = 1;

newTable;
output = vector;
outputIndex = 1;
lastCode = [];
tic;
for index=1:length(vector),
	% 	if mod(index, 1000) == 0
	% 		fprintf('Index: %5d, Time %.1fs, Table Length %4d, Ratio %.1f%%\n', index, toc, table.nextCode-1, outputIndex/index*100); %*ceil(log2(size(table, 2)))/8);
	% 		tic;
	% 	end;

	code = findCode(lastCode, vector(index));
	if ~isempty(code)
		lastCode = code;
	else
		output(outputIndex) = lastCode;
		outputIndex = outputIndex+1;
		%fprintf('output****: %04x\n', lastCode);
		if (table.nextCode <= maxTableSize)
			addCode(lastCode, vector(index));
			if (restartTable && table.nextCode == maxTableSize+1)
				% fprintf('New table\n');
				newTable;
			end;
		end;
		lastCode = findCode([], vector(index));
	end;
end;

output(outputIndex) = lastCode;
output((outputIndex+1):end) = [];
output = uint16(output);
table.codes = table.codes(1:table.nextCode-1);

end