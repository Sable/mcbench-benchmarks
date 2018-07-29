
% This file demo the mesh to html export
% The file uses matlabs demo mesh as an example. 
% For the example mesh used see Example 1:
% http://www.mathworks.com/help/matlab/ref/isosurface.html

% This file exports 3 example meshes to html.
% Example 1: An interactive mesh with a single color
% Example 2: An interactive mesh with a different color defined for each vertex
% Example 3: An interactive mesh that automatically rotates

% Written by Benjamin Irving 2013/03/25

%From example 1 a mesh can be plotted in matlab as follows:
%Creating the mesh
[x,y,z,v] = flow;
fv=isosurface(x,y,z,v,-3);

%Plotting the mesh in matlab
p = patch(fv);
set(p,'FaceColor','red','EdgeColor','none');
daspect([1,1,1]); view(3); axis tight; camlight; lighting gouraud;

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~ EXAMPLE 1 ~~~~~~~~~~~~~~~~~~~~~~~~~~

% This same mesh is exported to html using the following
x3mesh(fv.faces, fv.vertices, 0.3, 'name', 'Example1', 'color', [0.5 0 1], ... 
    'subheading', 'Click and drag to rotate. Scroll to zoom.')
disp('Mesh exported to html. File is in htmlfigs subfolder')

%% ~~~~~~~~~~~~~~~~~~~~~~~ EXAMPLE 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% % set individual color to each vertex
% 
% just creating an example color array based on vertex position
% the color array must be the same size as the vertex array with values
% from 0 to 1
cc=(fv.vertices(:,3) - min(fv.vertices(:,3)));
cc=cc/max(cc);
col1=zeros(size(fv.vertices)); col1(:,1)=1-cc; col1(:,3)=cc;
% Setting a unique color to each face
x3mesh(fv.faces, fv.vertices, 1, 'name', 'Example2', ... 
    'subheading', '... a few more colors', 'color', col1)
disp('Mesh exported to html. File is in htmlfigs subfolder')


% Then simply open the file called Matlab_flow in the htmlfigs subdirectory in a web browser. 
% Note that internet explorer does not support 3d rendering. Use a recent version of firefox, chrome or safari.  


%% ~~~~~~~~~~~~~~~~~~~~~~ EXAMPLE 3 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~`
% add rotation by setting 'rotation' to 1

x3mesh(fv.faces, fv.vertices, 1, 'name', 'Example3', ... 
    'subheading', 'Click and drag to rotate. Scroll to zoom.', 'color', col1, 'rotation', 1)
disp('Mesh exported to html. File is in htmlfigs subfolder')