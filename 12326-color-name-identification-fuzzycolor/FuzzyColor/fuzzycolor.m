function [iscolor,colornames]=fuzzycolor(RGB,colorquery)
% fuzzycolor: identify a color name for any RGB color 
% usage: [iscolor,colornames]=fuzzycolor(RGB)
% usage: [iscolor,colornames]=fuzzycolor(RGB,colorquery)
%
% Note: because fuzzycolor must initially load a large
% (persistent) dataset, the first call to this function 
% will take extra time. Successive calls will be faster.
% If you change the database file, make sure you issue a
% "clear functions" command before calling it again.
%
% arguments: (input)
%  RGB - [1x3] vector, or nx3 array, or nxmx3 array
%       of colors. Each color in this list will be tested
%       against the potential colornames specified by
%       colorquery.
%
%       Note: RGB is assume to be scaled as an RGB intensity,
%       in the interval [0,1]. It can also be a uint8 array,
%       scaled as [0,255].
%
%  colorquery - (OPTIONAL) - allows you to specify which
%       colorname to test for. colorquery must be either
%       empty, the string 'all', or a character string
%       containing the name of a single colorname from this
%       list of colornames:
%
%       'red' 'green' 'blue' 'neutral' 'pastel' 'yellow'
%       'flesh' 'cyan' 'magenta' 'black' 'white' 'purple'
%       'brown'
%
%       DEFAULT: colorquery = 'all'
%
%       If 'all' is specified, then all colors on the
%       list will be tested for, for each row of RGB.
%
%       Any single color name may be specified, or any
%       unambiguous contraction of that name. 'Thus 'g',
%       'gr', 'gre', etc., are all valid contractions for
%       'green'.
%
% arguments: (output)
%  iscolor - double array, indicating if I think that
%       each given color triad is the color in question.
%
%       == 0 --> it does not appear to be the color in question
%       == 1 --> it does appear to be the color in question
%       0<iscolor<1 --> means this color was right on the edge.
%
%  colornames - cell array of the color names tested for
%
% Example:
%  What color is [1 1 0.1]?
%  [iscolor,cn]=fuzzycolor([1 1 0.1])
%
% iscolor =
%    0  0  0  0  0  1  0  0  0  0  0  0  0
%
% cn = 
%   Columns 1 through 8
%    'red' 'green' 'blue' 'neutral' 'pastel' 'yellow' 'flesh' 'cyan'
%   Columns 9 through 13
%     'magenta' 'black' 'white' 'purple' 'brown'
%
%  Fuzzycolor correctly predicts that [1 1 0.1] is a yellow.
%
% Example:
%  Is [1 1 0.1] a red?
%  iscolor = fuzzycolor([1 1 0.1],'red')
%
%  ans =
%      0
%
%  Fuzzycolor correctly predicts that [1 1 0.1] is not red.
%
% Author: John D'Errico
% e-mail: woodchips@rochester.rr.com
% Release: 1.0
% Release date: 9/18/06

% have we loaded in the fuzzycolordata array yet?
persistent FuzzyColorData
if isempty(FuzzyColorData)
  % not yet loaded.
  load FuzzyColorData
end
ncolors = FuzzyColorData.ncolors;

% default for colorquery?
if (nargin<2) || isempty(colorquery)
  colorquery = 'all';
  colorind = 1:ncolors;
else
  % which color name was requested?
  colorquery = lower(colorquery);
  if strcmp(colorquery,'all')
    % all was requested, so
    colorind = 1:ncolors;
  else
    % must have been a color name
    colornames = FuzzyColorData.colornames;
    colorind = find(strncmp(colorquery,colornames,length(colorquery)));
    if isempty(colorind)
      error 'colorquery is not a match for any color name in the database'
    elseif length(colorind)>1
      error 'colorquery is an ambiguous color name'
    end
  end
end

% verify that RGB is a valid color or set of colors
if mod(numel(RGB),3)~=0
  error 'RGB array must be a 1x3 vector, a nx3 or an nxmx3 array'
end
if isa(RGB,'uint8')
  RGB = double(RGB)/255;
else
  if (max(RGB(:))<0) || (min(RGB(:))>1)
    error 'RGB array does not appear to be scaled as [0,1] intensity'
  end
end

RGB = reshape(RGB,[],3);
np = size(RGB,1);

% initialize the result array
iscolor = zeros(np,length(colorind));

for i = 1:length(colorind)
  iscolor(:,i) = interp3(FuzzyColorData.rnodes, ...
     FuzzyColorData.gnodes,FuzzyColorData.bnodes,...
     FuzzyColorData.colorlut{colorind(i)},RGB(:,1),RGB(:,2),RGB(:,3),'linear');
end

% return the list of colonames tested for
colornames = FuzzyColorData.colornames(colorind);






