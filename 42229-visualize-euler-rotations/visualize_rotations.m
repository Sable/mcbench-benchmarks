function [hl,ht,hp,ha] = visualize_rotations(rotorder,rotangle_deg,axhandle)

% FUNCTION
%   [hl,ht,hp,ha] = visualize_rotations(rotorder,rotangle_deg,axhandle)
%
% DESCRIPTION
%   Visualize Euler rotation sequences by displaying rotated axes systems {E_r}
%   and rotation planes, where {E_r} is the orthonormal set of vectors [i_r; j_r; k_r]
%
% INPUT ARGUMENTS
%   rotorder = string containing order of rotations, e.g. 'zxy' or 'xyx'
%   rotangle_deg = vector of rotation angles corresponding to rotorder [degrees]
%   axhandle = optional handle to existing axes
%
% OUTPUT ARGUMENTS
%   hl = 3-by-n+1 matrix of line handles for the x,y,z-axes for E0 to En
%   ht = same for axis text labels
%   hp = 3-by-n matrix of handles to the colored patches
%   ha = handle to annotation
%
% EXAMPLE:
%   visualize_rotations('xzxyz',[25 25 -25 45 10]) 
%   
%   or call the function without input arguments to show an example
%
%
% Author: D.J. van Gerwen
% Created: 22-Feb-2011
% Revised: 13-Jun-2013

% Process input arguments
if nargin<2
    rotangle_deg = [25 35 -35]; % [deg]
end
if nargin<1
    rotorder = 'yzx';
end

% Parameters
lw = 1;
fs = 9;
bgc = 'none';
xyztxt = 'xyz';
xlim = [-1 1];
ylim = xlim;
zlim = xlim;
azel = [135,30]; % Azimuth and elevation of view

% Convert angles
rotangle_rad = rotangle_deg/180*pi; % [-]

% Define rotation matrices for {E_i+1}=[R]{E_i} as inline functions (based on right-hand rule)
Rx = inline('[1 0 0; 0 cos(x) sin(x); 0 -sin(x) cos(x)]'); % Rotation about x-axis by angle x
Ry = inline('[cos(y) 0 -sin(y); 0 1 0; sin(y) 0 cos(y)]'); % Rotation about y-axis by angle y
Rz = inline('[cos(z) sin(z) 0; -sin(z) cos(z) 0; 0 0 1]'); % Rotation about z-axis by angle z

% Define global reference system
E = [1 0 0;  % i0
     0 1 0;  % j0
     0 0 1]; % k0 (could use eye(3), but that is less informative)

% Apply transformations: {E1}=[R1]{E0}, {E2}=[R2]{E1}=[R2][R1]{E0}, etc
for r = 1:length(rotorder)
    switch rotorder(r)
        case 'x'
            % Evaluate rotation matrix
            Rr(:,:,r) = Rx(rotangle_rad(r));
            % Define patch
            pv(:,:,r) = [[0 1 0].*Rr(2,:,r); Rr(2,:,r); [0 0 1].*Rr(2,:,r);
                [0 0 1].*Rr(3,:,r); Rr(3,:,r); [0 1 0].*Rr(3,:,r)]; % NOTE: to show triangles, set the third and sixth row to zero
        case 'y'
            % Evaluate rotation matrix
            Rr(:,:,r) = Ry(rotangle_rad(r));
            % Define patch
            pv(:,:,r) = [[1 0 0].*Rr(1,:,r); Rr(1,:,r); [0 0 1].*Rr(1,:,r);
                [0 0 1].*Rr(3,:,r); Rr(3,:,r); [1 0 0].*Rr(3,:,r)]; % NOTE: to show triangles, set the third and sixth row to zero
        case 'z'
            % Evaluate rotation matrix
            Rr(:,:,r) = Rz(rotangle_rad(r));
            % Define patch
            pv(:,:,r) = [[1 0 0].*Rr(1,:,r); Rr(1,:,r); [0 1 0].*Rr(1,:,r);
                [0 1 0].*Rr(2,:,r); Rr(2,:,r); [1 0 0].*Rr(2,:,r)]; % NOTE: to show triangles, set the third and sixth row to zero
    end
    % Transformation to E0
    E(:,:,r+1) = Rr(:,:,r)*E(:,:,r);
end

% Initialize figure
if ~exist('axhandle','var')
    figure('color','white','numbertitle','off','name','Visualize Euler rotation sequence')
    set(gca,'xlim',xlim,'ylim',ylim,'zlim',zlim,'projection','orthographic') % NOTE: projection is either 'orthographic' or 'perspective'
    view(azel)
    axis off
    title(sprintf(['Rotation sequence: %s (%3.0f\\circ' repmat(',%3.0f\\circ',1,length(rotorder)-1) ')'],rotorder,rotangle_deg))
else
    axes(axhandle)
end
%cmp = colormap(lines);
cmp = [1 0 0; 0 0.5 0; 0 0 1; 1 1 0; 0 1 1; 1 0 1];

% Display global reference system {E0} and rotated reference systems {E.}
for r = 1:length(rotorder)+1
    for i = 1:3
        % Axis and label
        hl(i,r) = line([0 E(i,1,r)],[0 E(i,2,r)],[0 E(i,3,r)],'color','k','linewidth',lw);
        ht(i,r) = text('position',E(i,:,r),'string',sprintf('%s_%u',xyztxt(i),r-1),'fontsize',fs,'backgroundcolor',bgc);
        % Create patches
        if r<=length(rotorder)
            pvr = pv(:,:,r);
            for rr = r-1:-1:1
                pvr = pvr*Rr(:,:,rr); % Transform patch vector from local to global reference
            end
            hp(i,r) = patch(pvr(:,1),pvr(:,2),pvr(:,3),cmp(r,:),'edgecolor','none','facealpha',0.1);
        end
    end
end

% Correct axis labels for the rotation axes
for i = 1:3
    for r = strfind(rotorder,xyztxt(i))
        str1 = get(ht(i,r),'string');
        str2 = get(ht(i,r+1),'string');
        set(ht(i,r+1),'string',[str1 ',' str2])
    end
end

% Text
ha = annotation('textbox',[0.4 0 0.6 0.14],'string',{'Colored patches represent components of the local rotation matrix in the plane of rotation. Definitions are according to right-hand rule.'},'edgecolor','none');