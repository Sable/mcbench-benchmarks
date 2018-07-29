function Y = posterize(varargin)
%
% POSTERIZE   Reduces number of colors in an image.
%
%    Y = POSTERIZE(X,N) creates the image Y by reduncing the number
%    of different colors of X to N. The N color values of Y are evenly
%    spaced in the same range as the values of X, however Y has only N 
%    different values. The values of X are rounded to the closet allowed
%    values of Y.
%    
%    Y = POSTERIZE(X,N,[MIN MAX]) scales the N allowed values of Y so 
%    that they have the new [MIN MAX] range.
%
%    Y = POSTERIZE(X,N,'noint') allows non integer values on Y. By default,
%    the allowed values of Y are rounded to the closest integer so that they
%    are evenly spaced. If using the 'noint' parameter this rounding is not
%    performed.
%
%    Y = POSTERIZE(X,N,'img') uses [MIN MAX] = [0 255], do not allow non
%    integer values on Y and returns Y as UINT8.
%
%    Y = POSTERIZE(x) uses N=64 and the 'img' parameter.
%

[x,N,I,frac] = parse_inputs(varargin{:});

if ~isa(x,'double')
   x = double(x);
end


M = max(x(:));
m = min(x(:));

Y = round((x-m)/(M-m) * (N-1)); % Separetes in N levels from 0 toa N-1

Y = Y/(N-1); % Scales to 0 - 1

Y = Y*(I(2)-I(1))+I(1);  % Scale to MIN, MAX

if frac==0
   Y = round(Y); % Rounds
end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x,N,I,frac] = parse_inputs(varargin)
switch nargin
case 0
   error('Too few inputs!')
   return
   
case 1
   x = varargin{1};
   I = [0 255];
   frac = 0;
   N=64;
   
case 2
   x = varargin{1};
   if strcmp(varargin{2},'img')
      I = [0 255];
      frac = 0;
      N=64;
   else
      N = varargin{2};
      I = [min(x(:)) max(x(:))]; % ??? round ???
      frac = 0;
   end

case 3
   x = varargin{1};
   N = varargin{2};
   if strcmp(varargin{3},'noint')
      frac = 1;
      I = [min(x(:)) max(x(:))];
   elseif strcmp(varargin{3},'img')
      I = [0 255];
      frac = 0;
   else
      I = varargin{3};
      frac = 0;
   end
   
case 4
   x = varargin{1};
   N = varargin{2};
   if strcmp(varargin{3},'noint')
      frac = 1;
      I = varargin{4};
   else
      if strcmp(varargin{4},'noint')
         frac = 1;
         I = varargin{3};
      else
         error('Invalid parameter!')
         return
      end
   end

case 5
   error('Too many inputs!')
   return
end

