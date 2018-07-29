% This files demos creating a interactive html file from a triangular mesh 
% and a second set of deformed vertices

% Written by Benjamin Irving 2013/03/25

%From example 1 a mesh can be plotted in matlab as follows:
%Creating the mesh
[x,y,z,v] = flow;
fv=isosurface(x,y,z,v,-3);

% Creating a second set of vertices from the first set... and setting the
% second and third dimensions of the vertices to 0 as one example of a
% mesh transformation
fv2=fv;
fv2.vertices(:,2)=0;
fv2.vertices(:,3)=0;

% running the html creating function 
x3mesh_deform(fv.faces, fv.vertices, fv2.vertices, 'name', 'Example1')
disp('Mesh exported to html. File is in htmlfigs subfolder')

