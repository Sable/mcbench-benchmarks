function [A,p_all] = buildSystemMatrix(r1_max,u_max,v_list,nuv,vpRatio)
%BUILDSYSTEMMATRIX    Setup system matrix for 3D parallel beam tomography
%
% [A,p_all] = formA_orthog(r1_max,u_max,v_list,nuv,vpRatio)
%
% Compute system matrix A for threedimensional parallel beam tomography.
% The image is a cube which is discretized into (2*r1max+1)^3 voxels.
% v_list is an m times 3 matrix, where m is the number of projections, with 
% a unit vector in each row specifying a projection direction. In total 
% there are m projections, each orthogonal to the projection direction.
% Each projection is a square 2D image discretized into (2*u_max+1)^2
% pixels. The images are aligned so that the center voxel is mapped to each
% of the center pixels. nuv is an array with two elements specifying the
% number of subpixels in each direction of the image. Default is [1 1].
% Each subpixel specifies the starting point of a ray for which the line
% integral through the 3D image is computed. The pixel value is then the
% averaged of the nuv(1)*nuv(2) total line integral from rays within the
% pixel. vpRatio is the voxel-to-pixel ratio. It is a scalar that specifies
% the ratio of the side length of a voxel to a pixel. Default is 1 (same
% side length). Higher vpRatio can be used to reconstruct the 3D image on a
% coarser grid than the projections. The output p_all is
% threedimensional array where the k'th layer p_all(:,:,k) holds the x,y,z
% coordinates of the k'th projection plane pixel centers.

% Jakob Heide Jørgensen (jakj@imm.dtu.dk)
% Department of Informatics and Mathematical Modelling (IMM)
% Technical University of Denmark (DTU)
% August 2010

% This code is released under the Gnu Public License (GPL). 
% For more information, see
% http://www.gnu.org/copyleft/gpl.html


% Input checks
if r1_max<1, ...
        error('r1_max must be a positive integer'), end
if u_max<1, ...
        error('u_max must be a positive integer'), end
if size(v_list,1) < 1 || size(v_list,2) ~= 3, ...
        error('v_list must three columns and at least one row'), end

% Cube 3D image and square 2D projections
r2_max   = r1_max; 
r3_max   = r1_max;
v_max    = u_max;
r1_range = r1_max*2 + 1;
r2_range = r2_max*2 + 1;
r3_range = r3_max*2 + 1;
u_range  = u_max*2 + 1;
v_range  = v_max*2 + 1;

% Aux. variables
mnk3  = r1_range+r2_range+r3_range+3;   % Max number of voxels hit by a ray
uvmax = u_range*v_range;                % Number of pixels in reflection

% Lists to hold output from traceRays for later generation of A by function
% sparse
nr_refl   = size(v_list,1);
voxelList = zeros(nr_refl*uvmax*(r1_range+r2_range+r3_range-1),1);
valList   = voxelList;
rowList   = voxelList;
liststart = 1; 


%% Consider fixed u_range x v_range projection plane in the yz plane.
%% Compute pixel center coordinates, allowing for subpixels

% Default subpixels
if nargin < 4
    nu = 1;
    nv = 1;
else
    nu = nuv(1);    % odd number
    nv = nuv(2);    % odd number
end

% Spacing between pixel centers
du      = 1/nu;
dv      = 1/nv;

% Pixel center coordinates
usub = repmat(u_max+du*(nu-1)/2:-du:-u_max-du*(nu-1)/2,v_range*nv,1);
vsub = repmat((-v_max-dv*(nv-1)/2:dv:v_max+dv*(nv-1)/2)',1,u_range*nu);
usub = usub(:);
vsub = vsub(:);

% Combine x, y, z pixel center coordinates into array with 3 rows
xyz = [zeros(1,u_range*v_range*nu*nv);
       reshape(usub,1,u_range*v_range*nu*nv);
       reshape(vsub,1,u_range*v_range*nu*nv)];

% Adjust for case where vpRatio is not 1
if nargin < 5, vpRatio = 1; end
xyz = xyz/vpRatio;

% Aux. variable
Imod  = repmat(0:mnk3:(uvmax*nu*nv-1)*mnk3,mnk3,1);   % See traceRays doc.

% Initialize array to hold pixel center coordinates
p_all = zeros(3,u_range*v_range*nu*nv,size(v_list,1));


%% Loop over reflections. For each reflection, rotate the fixed plane to be
%% orthogonal to the current direction vector from v_list. Use traceRays to
%% compute path lengths of rays through voxels and store values in a list.
for refl_nr=1:size(v_list,1)
    tic
    fprintf('Building A for reflection number %d\n',refl_nr)
    
    % Current projection direction
    v1=v_list(refl_nr,:);
    
    % From rectangular coordinates v_list get spherical coordinates
    r      = sqrt( sum(v1.^2) );
    thetat = -acos(v1(3)/r) + pi/2;
    phit   = atan2(v1(2),v1(1));
    
    % Set up first rotation
    Rz   = @(ang) [cos(ang), -sin(ang), 0; sin(ang), cos(ang),  0; 0, 0, 1];
    
    % Set up second rotation, for theta around new y-axis
    uxyz = Rz(phit)*[0,1,0]';
    ux   = uxyz(1);
    uy   = uxyz(2);
    uz   = uxyz(3);
    c = cos(-thetat);
    s = sin(-thetat);
    R2 = [ux^2 + (1-ux^2)*c, ux*uy*(1-c) - uz*s, ux*uz*(1-c) + uy*s;
        ux*uy*(1-c) + uz*s, uy^2 + (1-uy^2)*c, uy*uz*(1-c) - ux*s;
        ux*uz*(1-c) - uy*s, uy*uz*(1-c) + ux*s, uz^2 + (1-uz^2)*c];
    
    % Do the rotations
    p_sample2 = R2*Rz(phit)*xyz;
    
    % Store the pixel center coordinates
    p_all(:,:,refl_nr) = p_sample2;
    
    % Trace the rays: Get the voxels that are hit by each ray, the voxel
    % value and the row in A it should be inserted into. Inputs are x,y,z
    % coordinates of reflection in sample coordinates, direction vector v1,
    % the dimensions of the cube and the aux. index array Imod, see
    % documentation of traceRays. traceRays assumes coordinates in
    % [0,r1_range], so shift from origo by r1_range/2.
    [voxels, vals, rows] = traceRays(p_sample2(1,:)+r1_range/2,...
                                     p_sample2(2,:)+r2_range/2,...
                                     p_sample2(3,:)+r3_range/2,...
                                     v1,[r1_range r2_range r3_range],Imod);
    
    % Store voxels, vals and rows in lists for later generation of matrix A
    numVoxels       = length(voxels);
    listend         = liststart + numVoxels - 1;
    list            = liststart:listend;
    voxelList(list) = voxels;
    valList(list)   = vals;
    rowList(list)   = rows + u_range*v_range*nu*nv*(refl_nr-1);
    liststart       = listend + 1;
    
    % End timer
    toc
end

% Truncate lists and generate matrix A with single call to function sparse
voxelList = voxelList(1:liststart-1);
valList   = valList(1:liststart-1);
rowList   = rowList(1:liststart-1);
A     = sparse(rowList,voxelList,valList,nr_refl*u_range*v_range*nu*nv,...
                   r1_range*r2_range*r3_range);

disp('Finish building A')