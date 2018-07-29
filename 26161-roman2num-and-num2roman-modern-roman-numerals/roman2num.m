function n=roman2num(x)
%ROMAN2NUM Roman numerals conversion.
%   ROMAN2NUM(X) converts to scalar the string X (or cell array of strings)
%	of modern Roman numerals (lower and upper case).
%
%	The function considers strict rules with parenthesis notation for
%	numbers larger than 4999. Invalid characters will produce NaN.
%
%	Examples:
%		num2roman('MMMMDCCCLXXXVIII')
%		num2roman('(CCCXIV)CLIX')
%
%	See also NUM2ROMAN.
%
%	Author: François Beauducel <beauducel@ipgp.fr>
%	  Institut de Physique du Globe de Paris
%	Created: 2009-12-19
%	Modified: 2009-12-22

%	Copyright (c) 2009, François Beauducel, covered by BSD License.
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
if ischar(x)
	x = {x};
end
if ~iscellstr(x)
	error('X must be string or cell array of string.')
end

x = upper(x);	% allows lower case forms (thanks to Oleg Komarov)

r = 'IVXLCDM()';
a = [1, 5, 10, 50, 100, 500, 1000, 0, 0]; % values of each Roman numerals

n = zeros(size(x));

for k = 1:numel(x)
	nn = 0;
	ss = x{k};
	if all(ismember(ss,r))
		for i = 1:length(ss)
			switch ss(i)
				case '('
				case ')'
					% closing parenthesis = multiplication by 1000
					nn = nn*1e3;
				otherwise
					% value of the char
					v0 = a(findstr(r,ss(i)));
					nn = nn + v0;
					if i < length(ss)
						% if the following char is greater, subtract the value
						if v0 < a(findstr(r,ss(i+1)))
							nn = nn - 2*v0;
						end
					end
			end
		end
		n(k) = nn;
	else
		n(k) = NaN;
	end
end
