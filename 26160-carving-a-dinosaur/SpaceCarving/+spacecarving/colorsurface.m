function colorsurface( ptch, cameras )
%COLORSURFACE: color in a surface based on image data
%
%   COLORSURFACE(PTCH,CAMERAS) colors-in each vertex of the patch PTCH
%   using the nearest image pixel in one of the cameras in CAMERAS.

%   Copyright 2005-2009 The MathWorks, Inc.
%   $Revision: 1.0 $    $Date: 2006/06/30 00:00:00 $

error( nargchk( 2, 2, nargin ) );

if ~ishandle( ptch ) || ~strcmpi( get( ptch, 'Type' ), 'patch' )
    error( 'COLORSURFACE:BadPatch', 'First argument must the handle to a patch object created using the PATCH command' );
end

vertices = get( ptch, 'Vertices' );
normals = get( ptch, 'VertexNormals' );
num_vertices = size( vertices, 1 );

% Get the view vector for each camera
num_cameras = numel( cameras );
cam_normals = zeros( 3, num_cameras );
for ii=1:num_cameras
    cam_normals(:,ii) = spacecarving.getcameradirection( cameras(ii) );
end

% For each vertex, use the normal to find the best camera and then lookup
% the value.
vertexcdata = zeros( num_vertices, 3 );
for ii=1:num_vertices
    % Use the dot product to find the best camera
    angles = normals(ii,:)*cam_normals./norm(normals(ii,:));
    [~,cam_idx] = min( angles );
    % Now project the vertex into the chosen camera
    [imx,imy] = spacecarving.project( cameras(cam_idx), ...
        vertices(ii,1), vertices(ii,2), vertices(ii,3) );
    vertexcdata(ii,:) = double( cameras(cam_idx).Image( round(imy), round(imx), : ) )/255;
end

% Set it into the patch
set( ptch, 'FaceVertexCData', vertexcdata, 'FaceColor', 'interp' );