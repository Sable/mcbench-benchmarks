function [X,map] = im2inds(R,G,B)
%IM2INDS  Convert image to indexed image with unique colors in map.
%
%   IM2INDS converts an RGB, intensity or indexed image to an indexed
%   image with a color map where duplicates and unused colors are
%   removed. No color quantization is done as with CMUNIQUE in the image
%   processing toolbox. The number of rows in the returned color map is
%   the number of unique colors in the image.
%
%   [X,MAP] = IM2INDS(R,G,B) converts the RGB image in the matrices R, G
%   and B to an indexed image X with color map MAP.
%
%   [X,MAP] = IM2INDS(I) converts the intensity image I to an indexed
%   image X with color map MAP.
%
%   [Y,NEWMAP] = IM2INDS(X,MAP) converts the indexed image X with color
%   map MAP to an indexed image Y with color map NEWMAP.
%
%   The conversion is done by comparing each new pixel individually
%   against the color map and adding only those colors that aren't in
%   the map already. IM2INDS is much slower that IM2IND but requires
%   less memory.
%
%   See also IM2IND, IM2INDD.

%   Author:      Peter J. Acklam
%   Time-stamp:  1998-04-15 13:48:02
%   E-mail:      jacklam@math.uio.no (Internet)
%   URL:         http://www.math.uio.no/~jacklam

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check input arguments.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error( nargchk( 1, 3, nargin ) );

if nargin == 2                  % IM2IND(X,MAP)
   if size( G, 2 ) ~= 3
      error( 'Color map must have three columns.' );
   end
elseif nargin == 3              % IM2IND(R,G,B)
   if any( size(R) ~= size(G) ) | any( size(G) ~= size(B) )
      error( 'R, G, and B must have the same size' );
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For each pixel in the image, check if the color is in the map. If the
% color is not in the image, append it to the end of the map.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 1                  % IM2IND(I)

   [ rows, cols ] = size( R );  % Size of image.
   X = zeros( rows, cols );     % Initialize output index matrix.
   map = [ R(1) ];              % Initialize color map.
   ucolors = 1;                % Number of unique colors.

   for i = 1:rows
      for j = 1:cols
         match = map(:,1) == R(i,j);
         if any( match )
            idx = find( match );
         else
            map = [ map ; R(i,j) ];
            ucolors = ucolors + 1;
            idx = ucolors;
         end
         X(i,j) = idx;
      end
   end

   map = map(:,ones(1,3));      % Duplicate first column.

elseif nargin == 2              % IM2IND(X,MAP)

   [ rows, cols ] = size( R );  % Size of image.
   colors = size( G, 1 );      % Number of colors in map.

   X = zeros( rows, cols );     % Initialize output index matrix.
   map = G(R(1,1),:);           % Initialize output color map.
   ucolors = 1;                % Number of unique colors.

   for i = 1:rows
      for j = 1:cols
         if R(i,j) > colors
            error( [ 'Maximum index value exceeds number of ' ...
                     'colors in map.' ] );
         end
         match = ( map(:,1) == G(R(i,j),1) ) & ...
                 ( map(:,2) == G(R(i,j),2) ) & ...
                 ( map(:,3) == G(R(i,j),3) );
         if any( match )
            idx = find( match );
         else
            map = [ map ; G(R(i,j),:) ];
            ucolors = ucolors + 1;
            idx = ucolors;
         end
         X(i,j) = idx;
      end
   end

else                            % IM2IND(R,G,B)

   [ rows, cols ] = size( R );  % Size of image.
   X = zeros( rows, cols );     % Initialize output index matrix.
   map = [ R(1) G(1) B(1) ];    % Initialize output color map.
   ucolors = 1;                % Number of unique colors.

   for i = 1:rows
      for j = 1:cols
         match = ( map(:,1) == R(i,j) ) & ...
                 ( map(:,2) == G(i,j) ) & ...
                 ( map(:,3) == B(i,j) );
         if any( match )
            idx = find( match );
         else
            map = [ map ; R(i,j) G(i,j) B(i,j) ];
            ucolors = ucolors + 1;
            idx = ucolors;
         end
         X(i,j) = idx;
      end
   end

end
