%PNMTEST Test program for the PNM Toolbox.
%   PNMTEST is a test program for the PNM Toolbox. It is not really
%   intended for end users. It checks the most important read/write
%   functionality to see if the PNM Toolbox behaves as expected.
%
%   See also PNMDEMO.

%   Author:      Peter J. Acklam
%   Time-stamp:  1998-05-11 17:15:29
%   E-mail:      jacklam@math.uio.no (Internet)
%   URL:         http://www.math.uio.no/~jacklam

more off;
echo on;
home; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PPM test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% Read PPM image as an RGB image.
%

[ r, g, b ] = ppmread( 'logo5' );

%pause

%
% Simplify color map and display image to see if it appears to be OK.
%

[ x, map ] = im2ind( r, g, b );

figure( gcf ); clf;
colormap( map ); image( x ); axis image;

pause

%
% Write an ascii and a binary encoded version from indexed data.
%

ppmwrite( x, map, 'logo5_asc', 'ascii' );
ppmwrite( x, map, 'logo5_bin', 'binary' );

%pause

%
% Read them as indexed images and compare them.
%

[ x1, map1 ] = ppmread( 'logo5_asc' );
[ x2, map2 ] = ppmread( 'logo5_bin' );

if any( any( map1(x1(:),:) ) ~= any( map2(x2(:),:) ) )
   error( 'Test failed.' );
end

%pause

%
% Read them as RGB images and compare them.
%

[ r1, g1, b1 ] = ppmread( 'logo5_asc' );
[ r2, g2, b2 ] = ppmread( 'logo5_bin' );

if any( r1(:) ~= r2(:) ) | any( g1(:) ~= g2(:) ) | any( b1(:) ~= b2(:) )
   error( 'Test failed.' );
end

%pause

%
% The indexed and RGB images should be identical.
%

if any( any( map1(x1(:),:) ~= [ r(:) g(:) b(:) ] ) )
   error( 'Test failed.' );
end

%pause

%
% Write an ascii and a binary encoded version from RGB data.
%

ppmwrite( r, g, b, 'logo5_asc', 'ascii' );
ppmwrite( r, g, b, 'logo5_bin', 'binary' );

%pause

%
% Read them as indexed images and compare them.
%

[ x1, map1 ] = ppmread( 'logo5_asc' );
[ x2, map2 ] = ppmread( 'logo5_bin' );

if any( any( map1(x1(:),:) ~= map2(x2(:),:) ) )
   error( 'Test failed.' );
end

%pause

%
% Read them as RGB images and compare them.
%

[ r1, g1, b1 ] = ppmread( 'logo5_asc' );
[ r2, g2, b2 ] = ppmread( 'logo5_bin' );

if any( r1(:) ~= r2(:) ) | any( g1(:) ~= g2(:) ) | any( b1(:) ~= b2(:) )
   error( 'Test failed.' );
end

%pause

%
% The indexed and RGB images should be identical.
%

if any( any( map1(x1(:),:) ~= [ r(:) g(:) b(:) ] ) )
   error( 'Test failed.' );
end

%pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PGM test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pgmwrite( x, map, 'logo5', 'binary' );
i = pgmread( 'logo5' );

%pause

%
% Simplify color map and display image to see if it appears to be OK.
%

[ x, map ] = im2ind( i );

figure( gcf ); clf;
colormap( map ); image( x ); axis image;

pause

%
% Write an ascii and a binary encoded version from indexed data.
%

pgmwrite( x, map, 'logo5_asc', 'ascii' );
pgmwrite( x, map, 'logo5_bin', 'binary' );

%pause

%
% Read them as indexed images and compare them.
%

[ x1, map1 ] = pgmread( 'logo5_asc' );
[ x2, map2 ] = pgmread( 'logo5_bin' );

if any( any( map1(x1(:),:) ~= map2(x2(:),:) ) )
   error( 'Test failed.' );
end

%pause

%
% Read them as intensity images and compare them.
%

i1 = pgmread( 'logo5_asc' );
i2 = pgmread( 'logo5_bin' );

if any( i1(:) ~= i2(:) )
   error( 'Test failed.' );
end

%pause

%
% The indexed and intensity images should be identical.
%

if any( any( map1(x1(:),:) ~= [ i(:) i(:) i(:) ] ) )
   error( 'Test failed.' );
end

%pause

%
% Write an ascii and a binary encoded version from intensity data.
%

pgmwrite( i, 'logo5_asc', 'ascii' );
pgmwrite( i, 'logo5_bin', 'binary' );

%pause

%
% Read them as indexed images and compare them.
%

[ x1, map1 ] = pgmread( 'logo5_asc' );
[ x2, map2 ] = pgmread( 'logo5_bin' );

if any( any( map1(x1(:),:) ~= map2(x2(:),:) ) )
   error( 'Test failed.' );
end

%pause

%
% Read them as intensity images and compare them.
%

i1 = pgmread( 'logo5_asc' );
i2 = pgmread( 'logo5_bin' );

if any( i1(:) ~= i2(:) )
   error( 'Test failed.' );
end

%pause

%
% The indexed and intensity images should be identical.
%

if any( any( map1(x1(:),:) ~= [ i(:) i(:) i(:) ] ) )
   error( 'Test failed.' );
end

%pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PBM test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pbmwrite( x, map, 'logo5', 'binary' );
i = pbmread( 'logo5' );

%pause

%
% Simplify color map and display image to see if it appears to be OK.
%

[ x, map ] = im2ind( i );

figure( gcf ); clf;
colormap( map ); image( x ); axis image;

pause

%
% Write an ascii and a binary encoded version from indexed data.
%

pbmwrite( x, map, 'logo5_asc', 'ascii' );
pbmwrite( x, map, 'logo5_bin', 'binary' );

%pause

%
% Read them as indexed images and compare them.
%

[ x1, map1 ] = pbmread( 'logo5_asc' );
[ x2, map2 ] = pbmread( 'logo5_bin' );

if any( any( map1(x1(:),:) ~= map2(x2(:),:) ) )
   error( 'Test failed.' );
end

%pause

%
% Read them as intensity images and compare them.
%

i1 = pbmread( 'logo5_asc' );
i2 = pbmread( 'logo5_bin' );

if any( i1(:) ~= i2(:) )
   error( 'Test failed.' );
end

%pause

%
% The indexed and intensity images should be identical.
%

if any( any( map1(x1(:),:) ~= [ i(:) i(:) i(:) ] ) )
   error( 'Test failed.' );
end

%pause

%
% Write an ascii and a binary encoded version from intensity data.
%

pbmwrite( i, 'logo5_asc', 'ascii' );
pbmwrite( i, 'logo5_bin', 'binary' );

%pause

%
% Read them as indexed images and compare them.
%

[ x1, map1 ] = pbmread( 'logo5_asc' );
[ x2, map2 ] = pbmread( 'logo5_bin' );

if any( any( map1(x1(:),:) ~= map2(x2(:),:) ) )
   error( 'Test failed.' );
end

%pause

%
% Read them as intensity images and compare them.
%

i1 = pbmread( 'logo5_asc' );
i2 = pbmread( 'logo5_bin' );

if any( i1(:) ~= i2(:) )
   error( 'Test failed.' );
end

%pause

%
% The indexed and intensity images should be identical.
%

if any( any( map1(x1(:),:) ~= [ i(:) i(:) i(:) ] ) )
   error( 'Test failed.' );
end

%pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Miscellaneous testing.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% PPMREAD should be able to read a PGM image as an indexed image.
%

[ x1, map1 ] = ppmread( 'logo5_bin.pgm' );
[ x2, map2 ] = pgmread( 'logo5_bin.pgm' );

if any( x1(:) ~= x2(:) ) | any( map1(:) ~= map2(:) )
   error( 'Test failed.' );
end

%
% PPMREAD should be able to read a PGM image as RGB image.
%

[ r, g, b ] = ppmread( 'logo5_bin.pgm' );
i           = pgmread( 'logo5_bin.pgm' );

if any( r(:) ~= i(:) ) | any( g(:) ~= i(:) ) | any( b(:) ~= i(:) )
   error( 'Test failed.' );
end

%
% PPMREAD should be able to read a PBM image as indexed image.
%

[ x1, map1 ] = ppmread( 'logo5_bin.pbm' );
[ x2, map2 ] = pbmread( 'logo5_bin.pbm' );

if any( x1(:) ~= x2(:) ) | any( map1(:) ~= map2(:) )
   error( 'Test failed.' );
end

%
% PPMREAD should be able to read a PBM image as an RGB image.
%

[ r, g, b ] = ppmread( 'logo5_bin.pbm' );
i           = pbmread( 'logo5_bin.pbm' );

if any( r(:) ~= i(:) ) | any( g(:) ~= i(:) ) | any( b(:) ~= i(:) )
   error( 'Test failed.' );
end

%
% PGMREAD should be able to read a PBM image as an indexed image.
%

[ x1, map1 ] = pgmread( 'logo5_bin.pbm' );
[ x2, map2 ] = pbmread( 'logo5_bin.pbm' );

if any( x1(:) ~= x2(:) ) | any( map1(:) ~= map2(:) )
   error( 'Test failed.' );
end

%
% PGMREAD should be able to read PBM a image as an intensity image.
%

i1 = pgmread( 'logo5_bin.pbm' );
i2 = pbmread( 'logo5_bin.pbm' );

if any( i1(:) ~= i2(:) )
   error( 'Test failed.' );
end

%
% That should be all for now, so clean up.
%

delete logo5.pgm logo5.pbm
delete logo5_asc.ppm logo5_asc.pgm logo5_asc.pbm
delete logo5_bin.ppm logo5_bin.pgm logo5_bin.pbm

echo off

fprintf( '\nPassed all tests.\n\n' );
