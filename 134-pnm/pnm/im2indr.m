function [X,map] = im2indr(R,G,B)
%IM2INDR  Convert image to indexed image with unique colors in map.
%
%   IM2INDR converts an RGB, intensity or indexed image to an indexed
%   image with a color map where duplicates and unused colors are
%   removed. No color quantization is done as with CMUNIQUE in the image
%   processing toolbox. The number of rows in the returned color map is
%   the number of unique colors in the image.
%
%   [X,MAP] = IM2INDR(R,G,B) converts the RGB image in the matrices R, G
%   and B to an indexed image X with color map MAP.
%
%   [X,MAP] = IM2INDR(I) converts the intensity image I to an indexed
%   image X with color map MAP.
%
%   [Y,NEWMAP] = IM2INDR(X,MAP) converts the indexed image X with color
%   map MAP to an indexed image Y with color map NEWMAP.
%
%   The conversion is done by successively adding to the color map the
%   first color in the image which is not already in the map and then
%   removing all pixels in the image with that color.
%
%   See also IM2IND, IM2INDS, IM2INDD.

%   Author:      Peter J. Acklam
%   Time-stamp:  1998-04-15 13:45:49
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
   pixels = rows * cols;        % Number of pixels in image.
   idx = 1:pixels;              % Initialize temporary index matrix.
   X = zeros( rows, cols );     % Initialize output index matrix.
   map = [];                    % Initialize color map.

   colors = 0;                  % Initialize color counter.
   while ~isempty( idx )
      colors = colors+1;        % Increment counter.
      color = R(idx(1));        % Get next color not in map.
      map = [ map ; color ];    % Append color to map.
      k = ( R(idx) == color );
      X(idx(k)) = colors(ones(size(idx(k))));
      idx(k) = [];
   end

   map = map(:,ones(1,3));      % Duplicate first column.

elseif nargin == 2              % IM2IND(X,MAP)

   [ rows, cols ] = size( R );  % Size of image.
   pixels = rows * cols;        % Number of pixels in image.
   colors = size( G, 1 );       % Number of colors in map.

   if max( R(:) ) > colors
      error( 'Maximum index value exceeds number of colors in map.' );
   end

   idx = 1:pixels;              % Initialize temporary index matrix.
   X = zeros( rows, cols );     % Initialize output index matrix.
   map = [];                    % Initialize color map.

   colors = 0;                          % Initialize color counter.
   while ~isempty( idx )
      colors = colors+1;                % Increment counter.
      color = [ G(R(idx(1)),1) G(R(idx(1)),2) G(R(idx(1)),3) ];
      map = [ map ; color ];            % Append color to map.
      k = ( G(R(idx),1) == color(1) ) & ...
          ( G(R(idx),2) == color(2) ) & ...
          ( G(R(idx),3) == color(3) );
      X(idx(k)) = colors(ones(size(idx(k))));
      idx(k) = [];
   end

else                            % IM2IND(R,G,B)

   [ rows, cols ] = size( R );  % Size of image.
   pixels = rows * cols;        % Number of pixels in image.
   idx = 1:pixels;              % Initialize temporary index matrix.
   X = zeros( rows, cols );     % Initialize output index matrix.
   map = [];                    % Initialize color map.

   colors = 0;                          % Initialize color counter.
   while ~isempty( idx )
      colors = colors+1;                % Increment counter.
      color = [ R(idx(1)) G(idx(1)) B(idx(1)) ];
      map = [ map ; color ];            % Append color to map.
      k = ( R(idx) == color(1) ) & ...
          ( G(idx) == color(2) ) & ...
          ( B(idx) == color(3) );
      X(idx(k)) = colors(ones(size(idx(k))));
      idx(k) = [];
   end

end
