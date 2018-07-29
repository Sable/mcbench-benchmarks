function filename_final=mesh2vrml(X, Y, Z)

% Transforming data into VRML. Remember Z axis is pointing out of the
% screen towards you. X axis to the right and Y Axis is upwards.
xDimension=length(X(1,:));
xSpacing=abs(X(1,2)-X(1,1));
zDimension=length(Y(1,:));
zSpacing=abs(Y(2,1)-Y(1,1));
filename='myshape.wrl';
filename_final='elevation.wrl';
fid = fopen(filename, 'w+','n','UTF-8');
fprintf(fid,'#VRML V2.0 utf8');
fprintf(fid, '\n Transform { \n');
fprintf(fid,' \n translation %8.4f %8.4f %8.4f\n', -(max(max(X))-min(min(X)))/2, 0, -(max(max(Y))-min(min(Y)))/2);
fprintf(fid,' \n  rotation 0 0 1 0\n');
fprintf(fid,' \n  center %8.4f %8.4f %8.4f\n', -(max(max(X))+min(min(X)))/2, -(max(max(Z))+min(min(Z)))/2, 0);
fprintf(fid,' \n  scale 1 1 1\n');
fprintf(fid, '\n children Shape {\n');
fprintf(fid,'\n appearance	Appearance {\n');
fprintf(fid,'\n material	Material {}\n');
fprintf(fid,'\n	}\n');
fprintf(fid, '\n geometry	ElevationGrid { \n');
fprintf(fid, '\n xDimension %d\n', xDimension);
fprintf(fid, '\n xSpacing %d\n', xSpacing);
fprintf(fid, '\n zDimension %d\n', zDimension);
fprintf(fid, '\n zSpacing %d\n', zSpacing);
fprintf(fid,' height [');
for j=1:1:zDimension
    for i=1:1:xDimension
        fprintf(fid,'%f', Z(i,j));
        if (i==xDimension && j==zDimension)
        else
            fprintf(fid,',');
        end
    end
    fprintf(fid,'\n');
end
fprintf(fid,']\n');
fprintf(fid,'\n color NULL\n');
fprintf(fid,'\n colorPerVertex TRUE\n');
fprintf(fid,'\n normal NULL\n');
fprintf(fid,'\n normalPerVertex TRUE\n');
fprintf(fid, '\n texCoord NULL \n');
fprintf(fid, '\n ccw TRUE\n');
fprintf(fid, '\n solid FALSE\n');
fprintf(fid, '\n creaseAngle 0.0\n');
fprintf(fid,'		}\n');
fprintf(fid,'		}\n');
fprintf(fid,'		}\n');
fclose(fid);
copyfile(filename,filename_final, 'f');
delete(filename);

% Visualization code
figure_height=400;
view_width=350;
corner_x=20;
corner_y=10;
clearance=20;
fig=figure('Name', 'Preview', 'Position',[100 450 2*view_width+3*clearance figure_height+clearance]);
% Create the MATLAB GUI with two views of the aircraft
% First create the vrcanvas object for the first view. Specify the location
% and size of the view in pixels
% Create the plot of the translational coordinates of the aircraft
h = axes('Units', 'pixels', 'OuterPosition',[corner_x+view_width+3*clearance corner_y view_width figure_height]);
set(h, 'Position', [corner_x+clearance corner_y view_width figure_height]);
set(h, 'FontSize', 8);
surf(X,Y,Z);
hold on;
grid on;
title('Surface in MATLAB');
xlabel(h, 'x')
ylabel(h, 'y')
zlabel(h, 'z')
set(h, 'Units', 'normalized');
view(h, [90 0]);
world=vrworld(filename_final);
open(world);
c1 = vr.canvas(world, fig,[corner_x++view_width+3*clearance corner_y+clearance view_width-2*clearance  figure_height-2*clearance]);
set(c1, 'Units', 'normalized');

