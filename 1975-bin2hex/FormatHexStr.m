function out = FormatHexStr(Str,format)

% FormatHexStr(Str,format)
%
% Formats a hex string with either spaces between each word, or puts each word to a cell.
%
% Example:
%
% FormatHexStr('FF1B07',1)   % Spaces...
%
% ans =
%
% FF 1B 07
%
%
% FormatHexStr('FF1B07',2)   % Cells...
%
% ans =
%
% 'FF'  '1B'  '07'
%
%
% Author: Richard Medlock 2002

nbytes = length(Str);
out = [];
c = 0;
for i = 1:2:nbytes
    
    if format == 1
        
        out = [out Str(i:i+1) ' '];
        
    elseif format == 2
        c = c+1;
        out{c} = Str(i:i+1);
        
    else
        
        error('Unrecognised Format. Use: 1 = Spaces, 2 = Cells')
        
    end
    
end   