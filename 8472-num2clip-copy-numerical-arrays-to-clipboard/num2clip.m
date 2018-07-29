function arraystring = num2clip(array)
%NUM2CLIP copies a numerical-array to the clipboard
%   
%   ARRAYSTRING = NUM2CLIP(ARRAY)
%   
%   Copies the numerical array ARRAY to the clipboard as a tab-separated
%   string.  This format is suitable for direct pasting to Excel and other
%   programs.
%   
%   The tab-separated result is returned as ARRAYSTRING.  This
%   functionality has been included for completeness.
%   
%Author: Grigor Browning
%Last update: 02-Sept-2005

%convert the numerical array to a string array
%note that num2str pads the output array with space characters to account
%for differing numbers of digits in each index entry
arraystring = num2str(array); 
arraystring(:,end+1) = char(10); %add a carrige return to the end of each row
%reshape the array to a single line
%note that the reshape function reshape is column based so to reshape by
%rows one must use the inverse of the matrix
arraystring = reshape(arraystring',1,prod(size(arraystring))); %reshape the array to a single line

arraystringshift = [' ',arraystring]; %create a copy of arraystring shifted right by one space character
arraystring = [arraystring,' ']; %add a space to the end of arraystring to make it the same length as arraystringshift

%now remove the additional space charaters - keeping a single space
%charater after each 'numerical' entry
arraystring = arraystring((double(arraystring)~=32 | double(arraystringshift)~=32) & ~(double(arraystringshift==10) & double(arraystring)==32) );

arraystring(double(arraystring)==32) = char(9); %convert the space characters to tab characters

clipboard('copy',arraystring); %copy the result to the clipboard ready for pasting