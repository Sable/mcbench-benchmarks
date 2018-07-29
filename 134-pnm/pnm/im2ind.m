function [X,map] = im2ind(R,G,B)
%IM2IND   Convert image to indexed image with unique colors in map.
%
%   IM2IND converts an RGB, intensity or indexed image to an indexed
%   image with a color map where duplicates and unused colors are
%   removed. No color quantization is done as with CMUNIQUE in the image
%   processing toolbox. The number of rows in the returned color map is
%   the number of unique colors in the image.
%
%   [X,MAP] = IM2IND(R,G,B) converts the RGB image in the matrices R, G
%   and B to an indexed image X with color map MAP.
%
%   [X,MAP] = IM2IND(I) converts the intensity image I to an indexed
%   image X with color map MAP.
%
%   [Y,NEWMAP] = IM2IND(X,MAP) converts the indexed image X with color
%   map MAP to an indexed image Y with color map NEWMAP.
%
%   The conversion is done by sorting and comparing consecutive
%   elements. IM2IND is much faster than IM2INDS but uses more memory.
%
%   See also IM2INDS, IM2INDD.

%   Author:      Peter J. Acklam
%   Time-stamp:  1998-04-25 01:16:55
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
% The code below uses some recycling of variables to save memory.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 1                  % IM2IND(I)

   [ rows, cols ] = size( R );  % Size of image.
   pixels = rows * cols;        % Number of pixels in image.

   [ R, idx ] = sort( R(:) );   % Sort intensity values.

   % This vector contains ones where the unique intensity values are.
   isunique = logical( ones( pixels, 1 ) );
   isunique(2:pixels) = R(1:pixels-1) ~= R(2:pixels);

   % Build color map.
   map = R(isunique);           % Color map with unique intensity
   map = map(:,ones(1,3));      %    values.
   clear R;                     % Free some memory.

   % Build index matrix.
   X = zeros( rows, cols );     % Initialize output index matrix.
   X(idx) = cumsum( isunique ); % Fill indices into matrix.

elseif nargin == 2              % IM2IND(X,MAP)

   [ rows, cols ] = size( R );  % Size of image.
   pixels = rows * cols;        % Number of pixels in image.
   colors = size( G, 1 );       % Number of colors in map.

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % See if the indexed image is valid.
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   if max( R(:) ) > colors
      error( 'Maximum index value exceeds number of colors in map.' );
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Rename variables. It might have saved some memory using R and G
   % directly rather than X and map, but it would be more confusing.
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   X   = R;  clear R;
   map = G;  clear G;

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Sort the color map and build index vectors.
   %   idx:     original color map  ->  sorted color map
   %   idxinv:  sorted color map    ->  original color map
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   % Color of pixel (i,j):   map( X(i,j) , : )

   % Find index vector that maps from original to sorted color map.
   [ dummy, ind ] = sort( map(  : , 3 ) ); idx = ind;
   [ dummy, ind ] = sort( map( idx, 2 ) ); idx = idx(ind);
   [ dummy, ind ] = sort( map( idx, 1 ) ); idx = idx(ind);

   % Sort color map and find the "inverse" index vector.
   map = map(idx,:);
   idxinv = zeros(size(idx));
   idxinv(idx) = 1:colors;

   % Color of pixel (i,j):  map( idxinv( X(i,j) ) , : )

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Remove duplicate colors from color map.
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   % This vector contains ones where the unique colors are.
   isunique = logical( ones( colors, 1 ) );
   isunique(2:colors) = map(1:colors-1,1) ~= map(2:colors,1) ...
                       | map(1:colors-1,2) ~= map(2:colors,2) ...
                       | map(1:colors-1,3) ~= map(2:colors,3);

   map = map(isunique,:);               % Remove duplicates.

   % This "index reduction vector" creates a new index vector with the
   % smalles possible values, e.g., [ 2 2 5 8 8 8 ] -> [ 1 1 2 3 3 3 ].
   idxrdc = ( 1:colors )' - cumsum( ~isunique );

   X(:) = idxrdc(idxinv(X));            % Fill in the indices.

   % Color of pixel (i,j):   map( X(i,j) , : )

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Remove unused colors from color map. CMUNIQUE actually calls
   % IMHIST to help with this job, and IMHIST calls a MEX program!
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   colors = size( map, 1 );            % Number of colors in new map.
   v = logical( zeros( colors, 1 ) );  % Initialize to zero.
   v(X) = 1;                            % Mark used colors.

   map = map(v,:);                      % Remove unused colors.
   v = cumsum(v);                       % Make an index mapping vector.
   X = v(X);                            % New index matrix.

else                            % IM2IND(R,G,B)

   [ rows, cols ] = size( R );  % Size of image.
   pixels = rows * cols;        % Number of pixels in image.

   G = [ R(:) G(:) B(:) ];      % Create a giant color map.
   clear R B;                   % Free some memory.

   % Sort the rows in the color map.
   [ dummy, ind ] = sort( G(  : , 3 ) );
   idx = ind;
   [ dummy, ind ] = sort( G( idx, 2 ) );
   idx = idx(ind);
   [ dummy, ind ] = sort( G( idx, 1 ) );
   idx = idx(ind);
   G = G(idx,:);

   clear dummy ind;             % Free some memory.

   % This vector contains ones where the unique colors are.
   isunique = logical( ones( pixels, 1 ) );
   isunique(2:pixels) =   G(1:pixels-1,1) ~= G(2:pixels,1) ...
                        | G(1:pixels-1,2) ~= G(2:pixels,2) ...
                        | G(1:pixels-1,3) ~= G(2:pixels,3);

   % Build color map.
   map = G(isunique,:);         % Color map with unique colors.
   clear G;                     % Free some memory.

   % Build index matrix.
   X = zeros( rows, cols );     % Initialize output index matrix.
   X(idx) = cumsum( isunique ); % Fill indices into matrix.

end
