function ptch = showsurface( voxels )
%SHOWSURFACE: draw a surface based on some voxels
%
%   SHOWSURFACE(VOXELS) tries to render the supplied voxel structure as a
%   surface using MATLAB's ISOSURFACE command.
%
%   PTCH = SHOWSURFACE(VOXELS) also returns handles to the patches
%   created.

%   Copyright 2005-2009 The MathWorks, Inc.
%  $Revision: 1.0 $    $Date: 2006/06/30 00:00:00 $

% First grid the data
ux = unique(voxels.XData);
uy = unique(voxels.YData);
uz = unique(voxels.ZData);

% Expand the model by one step in each direction
ux = [ux(1)-voxels.Resolution; ux; ux(end)+voxels.Resolution];
uy = [uy(1)-voxels.Resolution; uy; uy(end)+voxels.Resolution];
uz = [uz(1)-voxels.Resolution; uz; uz(end)+voxels.Resolution];

% Convert to a grid
[X,Y,Z] = meshgrid( ux, uy, uz );

% Create an empty voxel grid, then fill only those elements in voxels
V = zeros( size( X ) );
N = numel( voxels.XData );
for ii=1:N
    ix = (ux == voxels.XData(ii));
    iy = (uy == voxels.YData(ii));
    iz = (uz == voxels.ZData(ii));
    V(iy,ix,iz) = voxels.Value(ii);
end

% Now draw it
ptch = patch( isosurface( X, Y, Z, V, 0.5 ) );
isonormals( X, Y, Z, V, ptch )
set( ptch, 'FaceColor', 'g', 'EdgeColor', 'none' );

set(gca,'DataAspectRatio',[1 1 1]);
xlabel('X');
ylabel('Y');
zlabel('Z');
view(-140,22)
lighting( 'gouraud' )
camlight( 'right' )
axis( 'tight' )
