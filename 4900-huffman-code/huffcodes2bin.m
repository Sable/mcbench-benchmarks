function [Words,Simbols] = huffcodes2bin(huffcodes)
%HUFFCODES2BIN   Convert huffcodes to binary representation
%   [W,S] = HUFFCODES2BIN(HC) returns the Huffman representation returned
%      by the function NORM2HUFF to the corresponding binary string of '0' and '1'
%   W is a cell array of binary strings,
%   S is a double array containing the corresponding simbols
%
%   REMARK: the first bit of each binary strings B is B(end)
%
%   See also HUFF2NORM, NORM2HUFF


%   $Author: Giuseppe Ridino' $
%   $Revision: 1.0 $  $Date: 25-May-2004 14:26:00 $


% get number of simbols
Nsimbols = nnz(huffcodes);

% initialize output
Words = cell(Nsimbols,1);
% Simbols = cell(Nsimbols,1);

% gte code words
CodeWords = find(not(huffcodes==0));

% convert words
for index=1:Nsimbols,
	Words{index} = Double2BinStr(CodeWords(index));
end

% return simbols
Simbols = full(huffcodes(CodeWords));


% #############################################################
function BinString = Double2BinStr(Word)
BinString = dec2bin(Word);
if not(BinString(1)=='1'),
	error('wrong codeword');        % most significat bit must always be "1"
else,
	BinString = BinString(2:end);   % remove stop bit
end
