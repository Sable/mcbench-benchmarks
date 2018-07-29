function voxels = makevoxels(xlim,ylim,zlim,N)
%MAKEVOXELS  create a basic grid of voxels ready for carving
%
%   VOXELS = MAKEVOXELS(N) makes a grid of voxels of size NxNxN in a
%   pre-defined volume.

%   Copyright 2005-2009 The MathWorks, Inc.
%   $Revision: 1.0 $    $Date: 2006/06/30 00:00:00 $

error( nargchk( 4, 4, nargin ) );


% We need to create cube-shaped voxels, so choose a resolution to give
% roughly N voxels
volume = diff( xlim ) * diff( ylim ) * diff( zlim );
voxels.Resolution = power( volume/N, 1/3 );
x = xlim(1) : voxels.Resolution : xlim(2);
y = ylim(1) : voxels.Resolution : ylim(2);
z = zlim(1) : voxels.Resolution : zlim(2);


[X,Y,Z] = meshgrid( x, y, z );
voxels.XData = X(:);
voxels.YData = Y(:);
voxels.ZData = Z(:);
voxels.Value = ones(numel(X),1);
