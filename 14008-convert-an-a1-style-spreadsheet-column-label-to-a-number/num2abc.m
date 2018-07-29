function ABCtranslate = num2abc(D)
%NUM2ABC returns spreadsheet string equivalent to the specified integer.
%  NUM2ABC(D) returns a string corresponding to the column label in the
%  format commonly employed by spreadsheet programs, such as Calc and
%  Microsoft Excel. The specified integer, D, must be greater than one.
%
%  Example:
%        x = 45;
%        num2abc(x);
%
%        ans =
%            AS
%
%  See also MAT2STR, INT2STR, STR2NUM, NUM2STR, SPRINTF, FPRINTF

alphabetStrings = ['A' 'B' 'C' 'D' 'E' 'F' 'G'...
                   'H' 'I' 'J' 'K' 'L' 'M' 'N'...
                   'O' 'P' 'Q' 'R' 'S' 'T' 'U'...
                   'V' 'W' 'X' 'Y' 'Z'];
               
B = length(alphabetStrings);
value = D;

S = '';
while (value >= 0)
    %if (flag), value = value-1; end
    if (mod(value,B)==0)
        S = ['Z' S];
    else
        S = [alphabetStrings(ceil(mod(value,B))) S];
    end
    value = (value / B) - 1;
    if value <= 0, break; end
end

ABCtranslate = S;

%==========================================================================
%num2abc.m
%Function that converts an integer to an equivalent spreadsheet label.
%--------------------------------------------------------------------------
%author:  David Sedarsky
%date:    February, 2012

%% Testing code
% The following script is for testing the function over a specified range.

% for i=1:18279
%     if (abc2num(num2abc(i))~=i)
%         disp(['Error --  index: ' num2str(i)]);
%         disp(['            abc: ' num2abc(i)]);
%         disp(['            num: ' num2str(abc2num(num2abc(i)))]);
%     end
% end
