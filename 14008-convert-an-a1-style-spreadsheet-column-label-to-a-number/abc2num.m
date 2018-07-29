function ABCtranslate = abc2num(S)
%ABC2NUM convert a spreadsheet label string to corresponding column number.
%   ABC2NUM(S) returns the number corresponding to the spreadsheet column
%   represented by the string, S.
%
%   The input string, S, may contain the ascii letters A-Z, in the format
%   commonly employed  by spreadsheet programs such as Calc and Microsoft
%   Excel. Other characters, including lower case letters, a-z, are
%   ignored.
%
%   Examples
%       S = 'CS';
%       abc2num(S)  returns  97
%
%     See also num2abc, num2str, str2num, char.

alphabetStrings = ['[A,B,C,D,E,F,G,'...
                   'H,I,J,K,L,M,N,'...
                   'O,P,Q,R,S,T,U,'...
                   'V,W,X,Y,Z]'];

n = regexp(S,alphabetStrings,'start');
ascii = zeros(size(n));
for i=1:length(n)
    ascii(i) = double(S(n(i)));
end
digits = ascii - 64;

ABCtranslate = polyval(flipdim(digits,1),26);

%==========================================================================
%abc2num.m
%Function that converts a spreadsheet column label to a number.
%--------------------------------------------------------------------------
%author:  David Sedarsky
%date:    February, 2012