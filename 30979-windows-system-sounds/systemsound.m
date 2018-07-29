function systemsound(string)
% systemsound v 1.0.0
% Programmed by Drew Weymouth
%
% Plays a Microsoft Windows system sound specified by an input string.
%   string may be an exact filename of a .wav file in the C:\Windows\Media directory
%   or a string with the "Windows" prefix removed from the filename.
%   Input string is case insensitive, and need not include '.wav' extension.
% Examples: 
%   systemsound('critical stop')
%   systemsound('exclamation')
% Please Note: 'notify' and 'windows notify' are different sounds
%   likewise, 'recycle' and 'windows recycle', 'ringin' and 'windows ringin', 
%   and 'ding' and 'windows ding' are different.
% Tested with Windows 7, results may vary for older versions.


dir= 'C:\Windows\Media\';
string= lower(string);
try [y,fs]= wavread(sprintf('%s%s',dir,string));
catch
    try [y,fs]= wavread(sprintf('%swindows %s',dir,string));
    catch, error('Invalid selection.')
    end
end
sound(y,fs,16)

end