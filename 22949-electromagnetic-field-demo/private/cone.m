function hCones = cone(P1,P2,scale,varargin)
% CONE - Create cone surface object between specified points
% -------------------------------------------------------------------------
% Abstract: This function will create a a cone between the specified points
%           using a surface plot.
%
% Syntax:
%           hCones = cone(P1,P2)
%           hCones = cone(P1,P2,scale)
%           hCones = cone(P1,P2,scale,...)
%           hCones = cone(P1,P2,[length diameter])
%           hCones = cone(P1,P2,[length diameter],...)
%
% Inputs:
%           P1 - first point [x y] or [x y z] (center of cone base)
%           P2 - second point [x y] or [x y z] (tip of cone)
%           scale - optional scaling factor
%           length - length of cylinder
%           diameter - diameter of cylinder
%           ... - property/value pairs can be applied to the cone objects
%
% Outputs:
%           hCones - handle to a patch object displaying the cones
%
% Examples:
%           figure('WindowStyle','docked')
%           axis square
%           axis([-1 1 -1 1 -1 1])
%           grid on
%           xlabel x
%           ylabel y
%           zlabel z
%
%           P1 = [0.5 1 0.1; -0.5 1 0.1];
%           P2 = [0.8 0.8 0.2; -0.8 0.8 0.2];
%
%           cone(P1,P2);
%           cone(P1,P2,0.5);
%           cone(P1,P2,'FaceVertexCData',[1 0 0],'FaceLighting','Phong');
%
% Notes:
%   - The optional "scale" input is a multiplier for the length of the cone
%     from base to tip.  The cone length will always be centered upon the
%     line segment defined by P1 and P2 vectors.  A scale of 1 will draw a
%     cone that is the entire length of the vector.
%   - Instead of specifying a single "scale" factor, you can instead
%     specify the exact length and base diameter of the cone using the
%     format [length diameter] in place of the "scale" input.
%   
%

% Copyright 2008 - 2009 The MathWorks, Inc.
%
% Auth/Revision:
%   The MathWorks Consulting Group
%   $Author: rjackey $
%   $Revision: 39 $  $Date: 2008-10-07 10:23:50 -0400 (Tue, 07 Oct 2008) $
% -------------------------------------------------------------------------

% Verify at least 2 input arguments
error(nargchk(2,inf,nargin,'struct'));

% Verify size of input arguments
if ~any(size(P1,2)==[2 3]) || ndims(P1)~=2 || ~all(size(P1)==size(P2))
    error('P1 and P2 must be Nx2 or Nx3 matrices of equivalent size.');
end
if ~any(numel(scale)==[1 2])
    error('scale must be a 1 or 2 element array.');
end

% Verify varargin is in property/value pairs
if mod(numel(varargin),2)
    error('Incorrect specification of property/value pairs.');
end

% For the Nx2 case, expand P1 and P2
if size(P1,2)==2
    P1(:,3) = zeros(size(P1,1),1);
    P2(:,3) = zeros(size(P2,1),1);
end

% How many cones are we plotting?
NumCones = size(P1,1);

% Constants
NumSurf = 10; % Number of surfaces around the cone
CylDLRatio = 0.25; % Ratio of cone base diameter to length


%% Generate a normalized cone surface

% Generate the surface data for rendering
[TempX,TempY,TempZ] = cylinder([1 0], NumSurf);

% Scale and shift the cylinder
TempZ = (TempZ-0.5);

% Gather the vertices and faces
VertTemplate = [TempZ(:),TempY(:),TempX(:)];
FaceTemplate = convhulln(VertTemplate);


%% Generate vertices and faces for each cone, and draw a patch object

% Calculate the midpoint and vectors from points P1 to points P2
Q = P2-P1;
P1 = P1+Q/2;

% Calculate diameter of the cone base
if numel(scale)==1
    ConeLen = scale * sqrt(dot(Q,Q,2));
    BaseDiam = scale * CylDLRatio * mean(ConeLen) / 2;
else
    ConeLen = scale(1) * ones(NumCones,1);
    BaseDiam = scale(2)/2;
end

% Preallocate matrices for speed
Vertices = zeros(size(VertTemplate));
R = zeros(3,3);
hCones = zeros(NumCones,1);

% Get autoscaling data for the cones
ThisLen = norm(diff([min(P1,[],1); max(P1,[],1)],1)) / sqrt(NumCones);

% Loop through each cone and find correct vertices and faces
for i = 1:NumCones

    % Scale this cone's vertices by the length of the vector
    Vertices(:,1) = VertTemplate(:,1) * ConeLen(i);
    Vertices(:,2) = VertTemplate(:,2) * BaseDiam;
    Vertices(:,3) = VertTemplate(:,3) * BaseDiam;

    % Autoscale the data
    if numel(scale)==1
        ThisMaxLen = norm(Q(i,:)/ThisLen);
        if ThisLen>0 && ThisMaxLen>0
            Vertices = Vertices / ThisMaxLen;
        end
    end

    % Find an orthogonal basis to rotate this cone's vertices
    R(:,1) = Q(i,:)/norm(Q(i,:));
    TmpRCross = cross(R(:,1),[1 0 0]);
    if all(TmpRCross==0)
        R(:,2) = [0 0 0]';
    else
        R(:,2) = TmpRCross/norm(TmpRCross);
    end
    R(:,3) = cross(R(:,1),R(:,2));

    % Rotate this cone's vertices to the proper vector direction
    if ~all(TmpRCross==0)
        Vertices = Vertices * R';
    end

    % Translate this cone's vertices in XYZ space
    Vertices(:,1) = Vertices(:,1) + P1(i,1);
    Vertices(:,2) = Vertices(:,2) + P1(i,2);
    Vertices(:,3) = Vertices(:,3) + P1(i,3);

    % Draw patch to represent the cone
    hCones(i) = patch('Faces',FaceTemplate,'Vertices',Vertices,...
        'FaceVertexCData',[0 0 1],'FaceColor','Flat','EdgeColor','None');

end

% Apply any specified property/value pairs to the cones
for i=2:2:numel(varargin)
    set(hCones,varargin{i-1},varargin{i});
end
