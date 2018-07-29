function rgbVector = str2rgb(colorString)
%STR2RGB   Converts a string representation of a color to an RGB triple.
%   X = STR2RGB(STR) converts the string STR into a three-element row
%   vector X (an RGB triple). STR can be one of three string
%   representations of colors that MATLAB uses (see ColorSpec help): a full
%   color name ('yellow'), a single character ('y'), or a string of numbers
%   within the range of 0 and 1 ('[1 1 0]' or '1 1 0').
%
%   If the string STR does not represent a valid string representation of a
%   color, STR2RGB(STR) returns NaN.
%
%   NOTE: STR2RGB does not use eval.
%
%   Examples:
%      str2rgb('yellow')        returns [1 1 0]
%      str2rgb('y')             returns [1 1 0]
%      str2rgb('[1 1 0]')       returns [1 1 0]
%      str2rgb('1 1 0')         returns [1 1 0]
%      str2rgb('[1; 1; 0]')     returns [1 1 0]
%      str2rgb('[0 0.5 0.91]')  returns [0 0.5000 0.9100]
%      str2rgb('purple')        returns NaN
%      str2rgb('[1 2]')         returns NaN

% Author: Ken Eaton
% Last modified: 4/2/08
%--------------------------------------------------------------------------

  if (nargin == 0),
    error('str2rgb:notEnoughInputs','Not enough input arguments.');
  end
  if (~ischar(colorString)),
    error('str2rgb:badArgumentType',...
          'Input argument should be of type char.');
  end
  expression = {'^\s*yellow\s*$','^\s*magenta\s*$','^\s*cyan\s*$',...
                '^\s*red\s*$','^\s*green\s*$','^\s*blue\s*$',...
                '^\s*white\s*$','^\s*black\s*$','^\s*y\s*$','^\s*m\s*$',...
                '^\s*c\s*$','^\s*r\s*$','^\s*g\s*$','^\s*b\s*$',...
                '^\s*w\s*$','^\s*k\s*$','[\[\]\;\,]'};
  replace = {'[1 1 0]','[1 0 1]','[0 1 1]','[1 0 0]','[0 1 0]',...
             '[0 0 1]','[1 1 1]','[0 0 0]','[1 1 0]','[1 0 1]',...
             '[0 1 1]','[1 0 0]','[0 1 0]','[0 0 1]','[1 1 1]',...
             '[0 0 0]',' '};
  rgbVector = sscanf(regexprep(colorString,expression,replace),'%f').';
  if ((numel(rgbVector) ~= 3) || any((rgbVector < 0) | (rgbVector > 1))),
    rgbVector = nan;
  end

end