function num = sci2num(str)
%% FUNCTION sci2num
% Converts a string to a number.  String may contain an SI prefix which must be
% used in converting back to an absolute number.
%
%
% Examples:
%
% num = sci2num('14.5 m') returns num = 0.0145
% num = sci2num('14.5') returns num = 14.5
% num = sci2num({'14.5m','85.2'}) returns num = [0.0145 85.2]
%
% See also: str2double
%
%
% Written By: Jason Kaeding
%       Date: 07/10/09

%% REVISION INFORMATION:
%

%% Check inputs
if ~ischar(str) && ~iscellstr(str)
    if iscell(str)
        num = repmat(NaN,size(str));
    else
        num = NaN;
    end
    return;
end

%% Execute replacement of prefixes
% Convert the letter to 10e(x) where x corresponds to the power
% str2double will convert the exponentials naturally
str = regexprep(str,...
    strcat('(?<=[\d\.])\s?',{'y','z','a','f','p','n','u','m',...
    'k','M','G','T','P','E','Z','Y'}),...
    {'e-24','e-21','e-18','e-15','e-12','e-9','e-6','e-3',...
    'e3','e6','e9','e12','e15','e18','e21','e24'});

%% Convert to numbers
num = str2double(str);