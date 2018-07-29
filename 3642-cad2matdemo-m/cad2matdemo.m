function cad2matdemo(filename)
% CAD2MATDEMO, a demonstration of importing 3D CAD data into Matlab.
% To get CAD data into Matlab, the process is:
%
% 1) Export the 3D CAD data as an ASCII STL (or Pro/E render SLP) file.
% 2) This Matlab routine reads the CAD data
% 3) Once read, the CAD data is rotated around a bit.
%
% Program has been tested with: AutoCAD, Cadkey, and Pro/Engineer.
% Should work with most any CAD programs that can export STL.
% 
% Format Details:  STL is supported, and the color version of STL
% that Pro/E exports, called 'render.'  The render (SLP) is just 
% like STL but with color added.
% 
% Note: This routine has both the import function and some basic
% manipulation for testing.  The actual reading mechanism is located
% at the end of this file.
  
if nargin == 0    
   filename = 'hook.stl'; % a simple demo part
   warning(['No file specified, using demo file: ' filename]);
end
%
% Read the CAD data file:
[F, V, C] = rndread(filename);
clf;
  p = patch('faces', F, 'vertices' ,V);
    %set(p, 'facec', 'b');              % Set the face color (force it)
    set(p, 'facec', 'flat');            % Set the face color flat
    set(p, 'FaceVertexCData', C);       % Set the color (from file)
    %set(p, 'facealpha',.4)             % Use for transparency
    set(p, 'EdgeColor','none');         % Set the edge color
    %set(p, 'EdgeColor',[1 0 0 ]);      % Use to see triangles, if needed.
    light                               % add a default light
    daspect([1 1 1])                    % Setting the aspect ratio
    view(3)                             % Isometric view
    xlabel('X'),ylabel('Y'),zlabel('Z')
    title(['Imported CAD data from ' filename])
    drawnow                             %, axis manual
    %
    disp(['CAD file ' filename ' data is read, will now show object rotating'])
    pause(1) 
    %
    % Move it around.
    % To use homogenous transforms, the n by 3 Vertices will be turned to 
    % n by 4 vertices, then back to 3 for the set command.
    % Note: n by 4 needed for translations, not used here, but could, using tl(x,y,z)
    V = V';
    V = [V(1,:); V(2,:); V(3,:); ones(1,length(V))];
    %
    vsize = maxv(V); %attempt to determine the maximum xyz vertex. 
    AXIS([-vsize vsize -vsize vsize -vsize vsize]);
    %
for ang = 0:1:90
    nv = rx(ang)*V;
    set(p,'Vertices',nv(1:3,:)')       
    drawnow
end
for ang1 = 0:2:90
    nv1 = ry(ang1)*nv;
    set(p,'Vertices',nv1(1:3,:)')     
    drawnow
end
for ang2 = 0:3:90
    nv2= rz(ang2)*nv1;
    set(p,'Vertices',nv2(1:3,:)')      
    drawnow
end
for ang3 = 0:5:180
    nv3 = rx(ang3)*ry(ang3)*rz(ang3)*nv2;
    set(p,'Vertices',nv3(1:3,:)')      
    drawnow
end
%
% End of main routine, here are the functions used:
% Homogeneous manipulation functions follow:
%
function Rx = rx(THETA)
% ROTATION ABOUT THE X-AXIS
%
% Rx = rx(THETA)
%
% This is the homogeneous transformation for
% rotation about the X-axis.
%
%	    NOTE:  The angle THETA must be in DEGREES.
%
THETA = THETA*pi/180;  % Note: THETA in radians.
c = cos(THETA);
s = sin(THETA);
Rx = [1 0 0 0; 0 c -s 0; 0 s c 0; 0 0 0 1];
%
function Ry = ry(THETA)
% ROTATION ABOUT THE Y-AXIS
%
% Ry = ry(THETA)
%
% This is the homogeneous transformation for
% rotation about the Y-axis.
%
%		NOTE: The angel THETA must be in DEGREES.
%
THETA = THETA*pi/180;  %Note: THETA is in radians.
c = cos(THETA);
s = sin(THETA);
Ry = [c 0 s 0; 0 1 0 0; -s 0 c 0; 0 0 0 1];
%
function Rz = rz(THETA)
% ROTATION ABOUT THE Z-AXIS
%
% Rz = rz(THETA)
%
% This is the homogeneous transformation for
% rotation about the Z-axis.
%
%		NOTE:  The angle THETA must be in DEGREES.
%
THETA = THETA*pi/180;  %Note: THETA is in radians.
c = cos(THETA);
s = sin(THETA);
Rz = [c -s 0 0; s c 0 0; 0 0 1 0; 0 0 0 1];
%
function T = tl(x,y,z)
% TRANSLATION ALONG THE X, Y, AND Z AXES
%
% T = tl(x,y,z)
%
% This is the homogeneous transformation for
% translation along the X, Y, and Z axes.
%
T = [1 0 0 x; 0 1 0 y; 0 0 1 z; 0 0 0 1];
%
function vsize = maxv(V)
%
% Look at the xyz elements of V, and determine the maximum
% values during some simple rotations.
    vsize = max(max(V));
    % Rotate it a bit, and check for max and min vertex for viewing.
    for ang = 0:10:360
        vsizex = rx(ang)*V;
        maxv = max(max(vsizex));
        if maxv > vsize, vsize = maxv; end
        vsizey = ry(ang)*V;
        maxv = max(max(vsizey));
        if maxv > vsize, vsize = maxv; end
        vsizez = rz(ang)*V;
        maxv = max(max(vsizez));
        if maxv > vsize, vsize = maxv; end
        vsizev = rx(ang)*ry(ang)*rz(ang)*V;
        maxv = max(max(vsizev));
        if maxv > vsize, vsize = maxv; end
    end
    %
function [fout, vout, cout] = rndread(filename)
% Reads CAD STL ASCII files, which most CAD programs can export.
% Used to create Matlab patches of CAD 3D data.
% Returns a vertex list and face list, for Matlab patch command.
% 
% filename = 'hook.stl';  % Example file.
%
fid=fopen(filename, 'r'); %Open the file, assumes STL ASCII format.
if fid == -1 
    error('File could not be opened, check name or path.')
end
%
% Render files take the form:
%   
%solid BLOCK
%  color 1.000 1.000 1.000
%  facet
%      normal 0.000000e+00 0.000000e+00 -1.000000e+00
%      normal 0.000000e+00 0.000000e+00 -1.000000e+00
%      normal 0.000000e+00 0.000000e+00 -1.000000e+00
%    outer loop
%      vertex 5.000000e-01 -5.000000e-01 -5.000000e-01
%      vertex -5.000000e-01 -5.000000e-01 -5.000000e-01
%      vertex -5.000000e-01 5.000000e-01 -5.000000e-01
%    endloop
% endfacet
%
% The first line is object name, then comes multiple facet and vertex lines.
% A color specifier is next, followed by those faces of that color, until
% next color line.
%
CAD_object_name = sscanf(fgetl(fid), '%*s %s');  %CAD object name, if needed.
%                                                %Some STLs have it, some don't.   
vnum=0;       %Vertex number counter.
report_num=0; %Report the status as we go.
VColor = 0;
%
while feof(fid) == 0                    % test for end of file, if not then do stuff
    tline = fgetl(fid);                 % reads a line of data from file.
    fword = sscanf(tline, '%s ');       % make the line a character string
% Check for color
    if strncmpi(fword, 'c',1) == 1;    % Checking if a "C"olor line, as "C" is 1st char.
       VColor = sscanf(tline, '%*s %f %f %f'); % & if a C, get the RGB color data of the face.
    end                                % Keep this color, until the next color is used.
    if strncmpi(fword, 'v',1) == 1;    % Checking if a "V"ertex line, as "V" is 1st char.
       vnum = vnum + 1;                % If a V we count the # of V's
       report_num = report_num + 1;    % Report a counter, so long files show status
       if report_num > 249;
           disp(sprintf('Reading vertix num: %d.',vnum));
           report_num = 0;
       end
       v(:,vnum) = sscanf(tline, '%*s %f %f %f'); % & if a V, get the XYZ data of it.
       c(:,vnum) = VColor;              % A color for each vertex, which will color the faces.
    end                                 % we "*s" skip the name "color" and get the data.                                          
end
%   Build face list; The vertices are in order, so just number them.
%
fnum = vnum/3;      %Number of faces, vnum is number of vertices.  STL is triangles.
flist = 1:vnum;     %Face list of vertices, all in order.
F = reshape(flist, 3,fnum); %Make a "3 by fnum" matrix of face list data.
%
%   Return the faces and vertexs.
%
fout = F';  %Orients the array for direct use in patch.
vout = v';  % "
cout = c';
%
fclose(fid);