function [X,map] = im2indd(R,G,B)
%IM2INDD  Convert image to indexed image (direct conversion).
%
%   IM2INDD converts an RGB, intensity or indexed image to an indexed
%   image with a color map that has one row for each pixel in the image.
%   No attempt is made so reduce the size of the color map; use IM2IND
%   or CMUNIQUE in the image processing toolbox for that.
%
%   [Y,NEWMAP] = IM2INDD(R,G,B) converts the RGB image in the matrices
%   R, G and B to an indexed image X with color map MAP.
%
%   [Y,NEWMAP] = IM2INDD(I) converts the intensity image I to an indexed
%   image X with color map MAP.
%
%   [Y,NEWMAP] = IM2INDD(X,MAP) converts the indexed image to a new
%   indexed image where the indices are in ascending order. That is,
%   Y(:) is identical to the vector [1:PROD(SIZE(Y))]'.
%
%   See also IM2IND, IM2INDS.

%   Author:      Peter J. Acklam
%   Time-stamp:  1998-04-15 13:44:06
%   E-mail:      jacklam@math.uio.no (Internet)
%   URL:         http://www.math.uio.no/~jacklam

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check input arguments.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error( nargchk( 1, 3, nargin ) );

if nargin == 2                  % IM2IND2(X,MAP)
   if size( G, 2 ) ~= 3
      error( 'Color map must have three columns.' );
   end
elseif nargin == 3              % IM2IND2(R,G,B)
   if any( size(R) ~= size(G) ) | any( size(G) ~= size(B) )
      error( 'R, G, and B must have the same size' );
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert image.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ rows, cols ] = size( R );     % Size of image.
pixels  = rows*cols;            % Number of pixels in image.
colors = size( G, 1 );         % Number of colors in map.

X    = zeros( rows, cols );     % Initialize output index matrix.
X(:) = 1:pixels;                % Fill indices into matrix.

if nargin == 1                  % IM2IND2(I)

   map = R(:);
   map = map(:,ones(1,3));

elseif nargin == 2              % IM2IND2(X,MAP)

   if max( R(:) ) > colors
      error( 'Maximum index value exceeds number of colors in map.' );
   end

   map = G(R(:),:);

else                            % IM2IND2(R,G,B)

   map = [ R(:) G(:) B(:) ];

end
