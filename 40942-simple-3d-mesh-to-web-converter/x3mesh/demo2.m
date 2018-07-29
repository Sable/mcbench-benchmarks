% demo 2 shows how to export a surface mesh 
% into a mesh defined by faces and vertices 
% and then export the mesh to html

% Written by Benjamin Irving 2013/03/25

% CREATING THE MATLAB EXAMPLE SURFACE
% (http://www.mathworks.co.uk/help/matlab/ref/mesh.html)
[X,Y] = meshgrid(-8:.5:8); 
R = sqrt(X.^2 + Y.^2) + eps;
Z = 10*sin(R)./R;
% plotting mesh (not required)
figure; surf(X,Y,Z);
colormap hsv
axis equal;

% CONVERT SURFACE TO A PATCH (faces and vertices)
fvc=surf2patch(X, Y, Z, Z, 'triangles');
%figure; patch(fvc); 
%shading faceted; view(3)

%CONVERT THE COLORMAP INTO A COLORMAP FOR THE VERTICES
cmap=colormap;
%getting cdata
cdata=fvc.facevertexcdata;
%normalising cdata rangle
cdata=(cdata-min(cdata));cdata=cdata/max(cdata);
%scaling by cmap range and converting to integers
cdata=round(cdata.*(size(cmap,1)-1));
%getting cdata values
cdata=cmap(cdata+1,:);
                        
% EXPORT THE MESH TO HTML USING X3MESH
x3mesh(fvc.faces, fvc.vertices, 1, 'name', 'Example4', 'color', cdata, 'rotation', 1)

%remove rotation by using
%x3mesh(fvc.faces, fvc.vertices, 1, 'name', 'Example4', 'color', I)