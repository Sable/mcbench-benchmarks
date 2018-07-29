function [rotmat,cornerpoints,volume,surface,edgelength] = minboundbox(x,y,z,metric,level)
% minboundbox: Compute the minimal bounding box of points in 3d
% usage: [rotmat,cornerpoints,volume,surface,edgelength] = minboundbox(x,y,z,metric,level)
%
% arguments: (input)
%  x,y,z - vectors of points, describing points in 3d as
%        (x,y,z) pairs. x, y and z must be the same lengths.
%
%  metric - (OPTIONAL) - single letter character flag which
%        denotes the use of minimal volume, surface or sum of edges as the
%        metric to be minimized. metric may be either 'v', 's' or 'e',
%        capitalization is ignored.
%
%        DEFAULT: 'v'    ('volume')
%
%  level - (OPTIONAL) - either 1, 2, 3 or 4. This denotes the level of
%       reliability of the resulting minimal bounding box.
%       '1' denotes the search for a bounding box, where one side of the
%           box coincides with a face of the convex hull. (fast)
%       '2' like '1', but also incorporates a search through each pair of edges
%           which form a plane which coincides with one side of the box (slow)
%       '3' like '1', but also incorporates a search through each edge which is
%           parallel to an edge of the box (reasonably fast)
%       '4' like '1', '2' and '3' together. (slowest) (Never needed that.)
%
%       It depends on the application, what should be chosen here.
%       See the example at the end for the effects of this parameter.
%
%        DEFAULT: '3'    
%
% arguments: (output)
%  rotmat - (3x3) rotation matrix for mapping of the pointcloud into a
%                 box which is axis-parallel (use inv(rotmat) for inverse
%                 mapping).
%
%  cornerpoints - (8x3) the cornerpoints of the bounding box.
%
%  volume - (scalar) volume of the minimal box itself.
%
%  surface - (scalar) surface of the minimal box as found.
%
%  edgelength - (scalar) sum of the edgelengths of the minimal box as found.
%
% Thanks to John d'Errico for providing the solution to the 2d version of
% this problem via minboundrect from the FEX. I took a huge amount of his 
% syntax, organisation and comments for this submission. (Hope he wont sue
% me, though.)
%
% Thanks to Roger Stafford and John d'Errico for helpful discussions and
% suggestions.
%
% The algorithm is still not proven to produce the smallest possible
% enclosing box. But i never found any counterexamples for the 'best'
% algorithm with level 4, whilst the second example below shows, there are
% differences between the levels. I would be happy to have a proof that
% level 3 suffices for each case.
%
% Example usage:
%
% (1)
%      x = rand(100,1);
%      y = rand(100,1);
%      z = rand(100,1);
%      [rotmat,cornerpoints,volume,surface] = minboundbox(x,y,z);
%      plot3(x,y,z,'b.');hold on;plotminbox(cornerpoints,'r');
%
% (2)
%      x=[1,0,0.1,1];y=[0,1,0.1,1];z=[0,0,0.9,1];
%      [nerd,cornerpoints1,nerd,nerd] = minboundbox(x,y,z,'v',1);
%      [nerd,cornerpoints2,nerd,nerd] = minboundbox(x,y,z,'v',2);
%      [nerd,cornerpoints3,nerd,nerd] = minboundbox(x,y,z,'v',3);
%      plot3(x,y,z,'bo','LineWidth',5);hold on;
%      plotminbox(cornerpoints1,'b');hold on;
%      plotminbox(cornerpoints2,'m');hold on;
%      plotminbox(cornerpoints3,'r');axis equal;grid on;hold off;
%
%
% See also: minboundcircle, minboundtri, minboundsphere, minboundrect
%
%
% Author: Johannes Korsawe
% E-mail: johannes.korsawe@volkswagen.de
% Release: 1.0
% Release date: 09/01/2008

% default for metric
if (nargin<4) || isempty(metric)
  metric = 'v';
elseif ~ischar(metric)
  error 'metric must be a character flag if it is supplied.'
else
  % check for 'v', 's' or 'e'
  metric = lower(metric(:)');
  ind = strmatch(metric,{'volume','surface','edges'});
  if isempty(ind)
    error 'metric does not match either ''volume'', ''surface'' or ''edges''.'
  end
  % just keep the first letter.
  metric = metric(1);
end

% default for level
if (nargin<5 || isempty(level)),
    level=4;
elseif ~isnumeric(level) || (level~=1 && level~=2 && level~=3 && level~=4),
        error 'metric does not match either ''1'', ''2'', ''3'' or ''3''.'
end

% preprocess data
x = x(:);
y = y(:);
z = z(:);

% not many error checks to worry about
n1 = length(x);n2 = length(y);n3 = length(z);
if n1 ~= n2 || n1 ~= n3 || n2 ~= n3,
  error 'x, y and z must be the same sizes'
end

% start out with the convex hull of the points to
% reduce the problem dramatically. Note that any
% points in the interior of the convex hull are
% never needed, so we drop them.

try
 K = convhulln([x,y,z],{'Qt'});  % 'Pp' will silence the warnings

  % exclude those points inside the hull as not relevant
  % also sorts the points into their convex hull as a
  % closed polygon
  
 Ki = unique(K(:));
 [tf,loc] = ismember(K(:),Ki);K = reshape(loc,size(K));
 x = x(Ki);
 y = y(Ki);
 z = z(Ki);
 n1 =length(x);
 
catch
    error 'The number and/or distribution of given points does not allow the construction of a convex hull.'
end

% now we must find the bounding box of those points that remain 

% get the angle of each face of the hull polygon.
% calculate local coordinate system
% x,y and z values of faces' cornerpoints
fx = [x(K(:,1)),x(K(:,2)),x(K(:,3))];                   
fy = [y(K(:,1)),y(K(:,2)),y(K(:,3))];
fz = [z(K(:,1)),z(K(:,2)),z(K(:,3))];
% faces' edges
v1 = [fx(:,2)-fx(:,1),fy(:,2)-fy(:,1),fz(:,2)-fz(:,1)];
v1 = v1./(repmat(sqrt(sum(v1.^2,2)),1,3));
v2 = [fx(:,3)-fx(:,1),fy(:,3)-fy(:,1),fz(:,3)-fz(:,1)];
v2 = v2-repmat(dot(v1,v2,2),1,3).*v1;
v2 = v2./(repmat(sqrt(sum(v2.^2,2)),1,3));
% faces' normals
nv = cross(v1,v2,2);
% faces' orientations measured in Euler angles
[alpha,beta,gamma]=euler123(v1,v2,nv);

nang = size(alpha,1);
d = inf;        % this will be the minimal value
rotmat=[];minmax=[];
xyz = [x,y,z];
if level==1 || level==3,    % check each face of the hull
    for i = 1:nang,
      % check current orientation
      % receive minimal value, rotation matrix and dimensions of the enclosing box
      [d, rotmat, minmax] = checkbox(alpha(i),beta(i),gamma(i),xyz,metric,d,rotmat,minmax);
    end
end

if level>1,
    e = edgelist(K);ne = size(e,1); % get a sorted list of edges
end

if level==2 || level==4,    % check each set of two edges of the convex hull (which obviously includes case '1' above)
    for i = 1:ne,   % go through edge list
        va = xyz(e(i,1),:)-xyz(e(i,2),:);
        va = va/norm(va);
        for j = i+1:ne, % go through remaining edge list
            vb = xyz(e(j,1),:)-xyz(e(j,2),:);
            vb = vb - dot(va,vb)*va; % orthogonaylize second edge wrt first
            nv = cross(va,vb);  % normal to plane formed by the two edges
            if sum(abs(nv))>0,
                vb = vb/norm(vb);nv = nv/norm(nv);
                [alp,bet,gam]=euler123(va,vb,nv);
                [d, rotmat, minmax] = checkbox(alp,bet,gam,xyz,metric,d,rotmat,minmax);
            end
        end
    end
end

if level==3 || level==4,    % check edge as parallel to one edge of the bounding box
    for i = 1:ne, % go through edge list
        % calculate rhs with edge as one of the axes
        va = xyz(e(i,1),:)-xyz(e(i,2),:);
        vb = [va(2),-va(1),0];if sum(abs(vb))==0,vb = [va(3),0,-va(1)];end
        va = va/norm(va);vb = vb/norm(vb);
        nv = cross(va,vb);
        % check all combinations of possible rhs
        [alp,bet,gam]=euler123(va,vb,nv);
        [d, rotmat, minmax] = checkbox(alp,bet,gam,xyz,metric,d,rotmat,minmax);
        [alp,bet,gam]=euler123(vb,nv,va);
        [d, rotmat, minmax] = checkbox(alp,bet,gam,xyz,metric,d,rotmat,minmax);
        [alp,bet,gam]=euler123(nv,va,vb);
        [d, rotmat, minmax] = checkbox(alp,bet,gam,xyz,metric,d,rotmat,minmax);
    end
end

% get the output values
h = [minmax(1,1),minmax(1,2),minmax(1,3);    % xmin,ymin,zmin
     minmax(2,1),minmax(1,2),minmax(1,3);    % xmax,ymin,zmin
     minmax(2,1),minmax(2,2),minmax(1,3);    % xmax,ymax,zmin
     minmax(1,1),minmax(2,2),minmax(1,3);    % xmin,ymax,zmin
     minmax(1,1),minmax(1,2),minmax(2,3);    % xmin,ymin,zmax
     minmax(2,1),minmax(1,2),minmax(2,3);    % xmax,ymin,zmax
     minmax(2,1),minmax(2,2),minmax(2,3);    % xmax,ymax,zmax
     minmax(1,1),minmax(2,2),minmax(2,3);    % xmin,ymax,zmax
     ];

cornerpoints = h*inv(rotmat); % minimal boxes' cornerpoints
h = minmax(2,:)-minmax(1,:);
volume = h(1)*h(2)*h(3);
surface = 2*(h(1)*h(2)+h(2)*h(3)+h(3)*h(1));
edgelength = 4*sum(h);

% all done

end % mainline end

function [alpha,beta,gamma]=euler123(v1,v2,nv)
% calculate Euler angles for the x, y', z'' Euler sequence
% see also
% http://en.wikipedia.org/wiki/Euler_angles
% http://de.wikipedia.org/wiki/Eulersche_Winkel

% --> beta
beta = asin(sign(nv(:,1)).*min(1,abs(nv(:,1))));
% --> alpha
alpha=0*beta;
i1 = find(nv(:,1)==1);i2 = setdiff(1:size(nv,1),i1);
if ~isempty(i1), 
    alpha(i1) = asin(sign(v2(i1,3)).*min(1,abs(v2(i1,3))));
end
if ~isempty(i2),
    alpha(i2) = acos(sign(nv(i2,3)./cos(beta(i2))).*min(1,abs(nv(i2,3)./cos(beta(i2)))));
    i3 = find(sign(nv(i2,2)) ~= sign(-sin(alpha(i2)).*cos(beta(i2))));
    alpha(i2(i3)) = -alpha(i2(i3));
end
% --> gamma
gamma = 0*alpha;
if ~isempty(i2),
    singamma = -v2(i2,1)./cos(beta(i2));
    i21 = find(v1(i2,1)>=0);i22=setdiff(1:length(i2),i21);
    gamma(i2(i21)) = asin(sign(singamma(i21)).*min(1,abs(singamma(i21))));
    gamma(i2(i22)) = -pi-asin(sign(singamma(i22)).*min(1,abs(singamma(i22))));
end

end % function euler123

function [d, rotmat, minmax] = checkbox(alpha,beta,gamma,xyz,metric,d,rotmat,minmax)

% will need a 3x3 rotation matrix through (Euler X, Y', Z'')-angles alpha, beta and gamma
Rmat = @(alpha,beta,gamma) [cos(beta)*cos(gamma) -cos(beta)*sin(gamma) sin(beta)
                            sin(alpha)*sin(beta)*cos(gamma)+cos(alpha)*sin(gamma) -sin(alpha)*sin(beta)*sin(gamma)+cos(alpha)*cos(gamma) -sin(alpha)*cos(beta)
                            -cos(alpha)*sin(beta)*cos(gamma)+sin(alpha)*sin(gamma) cos(alpha)*sin(beta)*sin(gamma)+sin(alpha)*cos(gamma) cos(alpha)*cos(beta)];

rot = Rmat(alpha,beta,gamma);
xyz_i = xyz*rot;                      % now the actual face is in the x-y plane

x_i = xyz_i(:,1);y_i = xyz_i(:,2);          % .. so take only the x and y values
rot2 = minrect(x_i,y_i,metric);             % find the optimal rotation around z-axis
rot = rot*[[rot2,[0;0]];[0,0,1]];           % combine that with the formar rotation
xyz_i = xyz*rot;                            % now again the xyz_i values, but in optimal axisparallel shape

xyzmin = min(xyz_i,[],1);
xyzmax = max(xyz_i,[],1);
h = xyzmax-xyzmin;

if metric == 'v',       % smallest volume
    d_i = h(1)*h(2)*h(3);
elseif metric == 's',   % smallest surface
    d_i = h(1)*h(2)+h(2)*h(3)+h(3)*h(1);
else,                   % smallest sum of edges
    d_i = sum(h);
end

if d_i < d,
    d = d_i;
    rotmat = rot;
    minmax = [xyzmin;xyzmax];
end

end % function checkbox

function rot = minrect(x,y,metric)
% see comments from minboundrect of John d'Errico
% i am only interested in the additional rotation matrix around [0,0,1]
edges = convhull(x,y,{'Qt'});
x = x(edges);y = y(edges);
ind = 1:length(x)-1;
Rmat = @(theta) [cos(theta) sin(theta);-sin(theta) cos(theta)];
edgeangles = atan2(y(ind+1) - y(ind),x(ind+1) - x(ind));edgeangles = unique(mod(edgeangles,pi/2));
nang = length(edgeangles);
area = inf;perimeter = inf;met = inf;xy = [x,y];
for i = 1:nang
  rot_i = Rmat(-edgeangles(i));xyr = xy*rot_i;
  xymin = min(xyr,[],1);xymax = max(xyr,[],1);
  A_i = prod(xymax - xymin);P_i = 2*sum(xymax-xymin);
  if metric=='v', M_i = A_i;else, M_i = P_i;end
  if M_i<met, rot = rot_i;met = M_i;end
end

end % function minrect

function e = edgelist(K)
% generate an edgelist from the convex body K
e = [K(:,1),K(:,2)];e = [e;K(:,2),K(:,3)];e = [e;K(:,1),K(:,3)];
e = [min(e,[],2),max(e,[],2)];ne = size(e,1);
e = [e,e(:,2)+ne*e(:,1)];
[nerd,I] = sort(e(:,3));
e = e(I(1:2:end),:);

end % edgelist
