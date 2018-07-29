function S=rbb3select(X,Y,Z)
% RBB3SELECT(X,Y,Z) selects points on 3D plot using rubberband box.
% X, Y and Z are vectors or matrices of points coordinates.
% X, Y and Z must be the same size.
% Returns logical array with the same size as input matrices
% containing 1, if a point is inside rbbox, and 0, if outside.
% Points on boundaries are included into selection.

%   Written by Yuri Kotliarov, NIH/NCI/NOB
%   Revision: 1.0  Date: 2005/03/18

%%
if nargin < 3
    error('Not enough input arguments.')
end
if ~isnumeric([X Y Z])
    error('Arguments must be numeric arrays.')
end
if size(X)~=size(Y) | size(X) ~=size(Z)
    error('Arguments must be the same size.')
end

[m,n]=size(X);
T=view; % transformation matrix for current view

%% get rbbox points 
% (from rbbox example)
k = waitforbuttonpress;
point1 = get(gca,'CurrentPoint');    % button down detected
finalRect = rbbox;                   % return figure units
point2 = get(gca,'CurrentPoint');    % button up detected

%% get upper points and convert to screen projection
P1 = T*[point1(1,:), 1]';
P2 = T*[point2(1,:), 1]';

%% get rbbox limits
XXmin = min(P1(1),P2(1));
XXmax = max(P1(1),P2(1));
YYmin = min(P1(2),P2(2));
YYmax = max(P1(2),P2(2));

%% convert X,Y,Z to screen projection
XYZ = T*[X(:),Y(:),Z(:),ones(m*n,1)]';
% get new coordinates
XX = reshape(XYZ(1,:),m,n);
YY = reshape(XYZ(2,:),m,n);

%% Select the points
S = XX>=XXmin & XX<=XXmax & YY>=YYmin & YY<=YYmax;
