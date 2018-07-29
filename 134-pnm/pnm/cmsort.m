function [y,newmap] = cmsort(x,map,opt)
%CMSORT   Sort color map.
%
%   NEWMAP = CMSORT(MAP) sorts the color map MAP by luminance.
%
%   NEWMAP = CMSORT(MAP,OPT) where OPT is one of the strings 'red',
%   'green', 'blue', 'hue', 'saturation', 'value' and 'luminance', sorts
%   the map according to the specified criterion.
%
%   [Y,NEWMAP] = CMSORT(X,MAP) and [Y,NEWMAP] = CMSORT(X,MAP,OPT) also
%   changes the index matrix so the image remains unchanged after the
%   sorting of the color map.
%
%   The case of the option string does not matter and the string may be
%   truncated since only the first letter is used internally.

%   Author:      Peter J. Acklam
%   Time-stamp:  1998-04-15 13:42:03
%   E-mail:      jacklam@math.uio.no (Internet)
%   URL:         http://www.math.uio.no/~jacklam

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check and identify input arguments.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ( nargin < 1 )
   error( 'Not enough input arguments.' );
elseif ( nargin == 1 )          % CMSORT(MAP)
   map = x;
   opt = 'lum';
   index_given = 0;
elseif ( nargin == 2 )
   if ischar(map)               % CMSORT(MAP,OPT)
      map = x;
      opt = map;
      index_given = 0;
      if ( nargout > 1 )
         error( 'Too many output arguments.' );
      end
   else                         % CMSORT(X,MAP)
      opt = 'lum';
      index_given = 1;
   end
elseif ( nargin == 3 )          % CMSORT(X,MAP,OPT)
   index_given = 1;
else
   error( 'Too many input arguments.' );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now create the key by which the color map is sorted.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

swtch = lower( opt(1) );

if strcmp( swtch, 'r' )         % Red.
   key = map(:,1);
elseif strcmp( swtch, 'g' )     % Green.
   key = map(:,2);
elseif strcmp( swtch, 'b' )     % Blue.
   key = map(:,3);
elseif strcmp( swtch, 'h' )     % Hue.
   hsv = rgb2hsv( map );
   key = hsv(:,1);
elseif strcmp( swtch, 's' )     % Saturation.
   hsv = rgb2hsv( map );
   key = hsv(:,2);
elseif strcmp( swtch, 'v' )     % Value.
   hsv = rgb2hsv( map );
   key = hsv(:,3);
elseif strcmp( swtch, 'l' )     % Luminance.
   w = [ 0.298936 ; 0.587043 ; 0.114021 ];      % RGB weights.
   key = map*w;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sort color map and fix index matrix (if given).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ dummy, idx ] = sort( key );   % Sort the keys.
newmap = map(idx,:);            % Rearrange color map.

if index_given
   n = length( idx );           % Number of colors.
   xdi = zeros( n, 1 );
   xdi(idx) = 1:n;
   y = zeros( size( x ) );
   y(:) = xdi(x);
else
   y = map;
end
