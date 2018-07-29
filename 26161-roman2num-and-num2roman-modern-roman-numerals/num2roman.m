function s=num2roman(n)
%NUM2ROMAN Roman numerals.
%   NUM2ROMAN(N) returns modern Roman numeral form of integer N, which can
%	be scalar (returns a string), vector or matrix (returns a cell array of
%	strings, same size as N).
%
%	The function uses strict rules whith substractive notation and commonly
%	found 'MMMM' form for 4000. It includes also parenthesis notation for 
%	large numbers (multiplication by 1000). It considers only the integer
%	part of N.
%
%	Examples:
%		num2roman(1968)
%		num2roman(10.^(0:7))
%		reshape(num2roman(1:100),10,10)
%
%	See also ROMAN2NUM.
%
%	Author: François Beauducel <beauducel@ipgp.fr>
%	  Institut de Physique du Globe de Paris
%	Created: 2005
%	Modified: 2009-12-22

%	Copyright (c) 2005-2009, François Beauducel, covered by BSD License.
%	All rights reserved.
%
%	Redistribution and use in source and binary forms, with or without 
%	modification, are permitted provided that the following conditions are 
%	met:
%
%	   * Redistributions of source code must retain the above copyright 
%	     notice, this list of conditions and the following disclaimer.
%	   * Redistributions in binary form must reproduce the above copyright 
%	     notice, this list of conditions and the following disclaimer in 
%	     the documentation and/or other materials provided with the distribution
%	                           
%	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%	ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%	LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%	SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%	POSSIBILITY OF SUCH DAMAGE.

error(nargchk(1,1,nargin))
if ~isnumeric(n)
	error('N must be numeric array (scalar, vector or matrix).')
end

s = cell(size(n));

for k = 1:numel(n)
	m = max(floor((log10(n(k)) - log10(5000))/3) + 1,0);
	for i = m:-1:0
		ss = roman(fix(n(k)/10^(3*i)));
		if i == m
			s{k} = ss;
		else
			s{k} = ['(',s{k},')',ss];
		end
		n(k) = mod(n(k),10^(3*i));
	end
end

% converts to string if n is a scalar
if numel(n) == 1
	s = s{1};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x=roman(n)
% this subfunction converts numbers up to 4999

r = reshape('IVXLCDM   ',2,5);	% the 3 last blank chars are to avoid error for n >= 1000
x = '';

m = floor(log10(n)) + 1;	% m is the number of digit

% n is processed sequentially for each digit
for i = m:-1:1
	ii = fix(n/10^(i-1));	% ii is the digit (0 to 9)
	% Roman numeral is a concatenation of r(1:2,i) and r(1,i+1)
	% combination with regular rules (exception for 4000 = MMMM)
	% Note: the expression uses REPMAT behavior which returns empty
	% string for N <= 0
	x = [x,repmat(r(1,i),1,ii*(ii < 4 | (ii==4 & i==4)) + (ii == 9) + (ii==4 & i < 4)), ...
		   repmat([r(2,i),repmat(r(1,i),1,ii-5)],1,(ii >= 4 & ii <= 8 & i ~= 4)), ...
		   repmat(r(1,i+1),1,(ii == 9))];
	n = n - ii*10^(i-1);	% substract the most significant digit
end
