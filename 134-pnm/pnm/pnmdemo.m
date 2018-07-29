%PNMDEMO Demonstration of portable bitmap utilities.

%   Author:      Peter J. Acklam
%   Time-stamp:  1998-05-11 16:39:20
%   E-mail:      jacklam@math.uio.no (Internet)
%   URL:         http://www.math.uio.no/~jacklam

more off;
echo on;
home; clc;
%
% First, read the portable pixelmap with the Matlab logo.
%
% The image may be read as an RGB image.
%

[ r, g, b ] = ppmread( 'logo5' );

pause

%
% The image may also be read as an indexed image.
%

[ x, map ] = ppmread( 'logo5' );

pause

%
% Since PPMREAD does not simplify the color map automatically, the number
% of colors in the map equals the number of pixels in the image.
%

pixels_in_image = prod( size(x) )
colors_in_map  = size( map, 1 )

pause

%
% Use IM2IND to convert intensity images, indexed images and RGB images
% to indexed images with the smallest possible color map.
%

[ x, map ] = im2ind( x, map );

pause

%
% Now we see the number of unique colors in the image. The number of
% colors in the map has been reduced significantly.
%

colors_in_map = size( map, 1 )

pause

%
% Display the image.
%

figure( gcf ); clf;
colormap( map ); image( x ); axis image;

pause

%
% Write the image as a portable graymap.
% PGMWRITE automatically converts color images to grayscale images.
% For speed, we use binary (raw) encoding.
%

pgmwrite( x, map, 'logo5', 'binary' );

pause

%
% Read the image. We can use both PGMREAD and PPMREAD for this.
% PGMREAD can read the image as an intensity image or an indexed image.
% We choose the latter.
%

[ x, map ] = pgmread( 'logo5' );

pause

%
% Display the image.
%

figure( gcf ); clf;
colormap( map ); image( x ); axis image;

pause

%
% As with PPMREAD, PGMREAD does not simplify the color map
% automatically, so the number of colors in the map may be larger than
% the number of colors used in the image.
%

colors_in_map = size( map, 1 )

pause

%
% Again, we use IM2IND to get the indexed image with the smallest
% possible color map.
%

[ x, map ] = im2ind( x, map );

pause

%
% Now we see the number of unique colors in the image.
%

colors_in_map = size( map, 1 )

pause

%
% Now write the image as a portable bitmap.
% PBMWRITE automatically converts color images and grayscale images to
% black and white images. For speed, we use binary (raw) encoding.
%

pbmwrite( x, map, 'logo5', 'binary' );

pause

%
% Read the image. We can use both PBMREAD, PGMREAD and PPMREAD to this.
% PBMREAD can read the image as a black and white image or as an indexed
% image. We choose the latter.
%

[ x, map ] = pbmread( 'logo5' );

pause

%
% Display the image.
%

figure( gcf ); clf;
colormap( map ); image( x ); axis image;

pause

%
% That should be all for now, so clean up.
%

delete logo5.pgm logo5.pbm
