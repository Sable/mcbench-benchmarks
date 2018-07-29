% More complex example

% Written by Benjamin Irving 2013/03/25

% CREATING THE MATLAB EXAMPLE SURFACE
[X, Y, Z] = peaks;
Z=Z/2;
colormap hsv;

% example plot in matlab (just to illustrate the matlab output)
surf(X,Y,Z)
axis equal;

% CONVERT SURFACE TO A PATCH (faces and vertices)
fvc=surf2patch(X, Y, Z, Z, 'triangles');

%CONVERT THE COLORMAP INTO A COLORMAP FOR THE VERTICES (optional if you
%want to include color)
cmap=colormap;
%getting cdata
cdata=fvc.facevertexcdata;
%normalising cdata rangle
cdata=(cdata-min(cdata));cdata=cdata/max(cdata);
%scaling by cmap range and converting to integers
cdata=round(cdata.*(size(cmap,1)-1));
%getting cdata values
cdata=cmap(cdata+1,:);

% Create a second set of vertices with z positions inverted (as an example
% of a deformation)
fvc2=fvc;
fvc2.vertices(:,3)=-fvc2.vertices(:,3);
                        
% EXPORT THE MESH TO HTML USING X3MESH
x3mesh_deform(fvc.faces, fvc.vertices, fvc2.vertices, 'name', 'Example2', 'color', cdata, 'speed', 5)
