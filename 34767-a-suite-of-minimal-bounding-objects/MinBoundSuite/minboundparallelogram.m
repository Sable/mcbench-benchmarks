function [pgx,pgy,area,perim] = minboundparallelogram(x,y,metric)
% minboundparallelogram: Compute the minimal bounding parallelogram of points in the plane
% usage: [pgx,pgy,area,perimeter] = minboundparallelogram(x,y,metric)
%
% While minboundrect allows you to choose between a minimal area or
% perimeter, it turns out that the minimal area paralellogram is not
% always unique. However, there will exist a unique parallelogram of
% minimal perimeter.
%
% arguments: (input)
%  x,y - vectors of points, describing points in the plane as
%        (x,y) pairs. x and y must be the same lengths.
%
%  metric - (OPTIONAL) - single letter character flag which
%        denotes the use of minimal area or perimeter as the
%        metric to be minimized. metric may be either 'a' or 'p',
%        capitalization is ignored. Any other contraction of 'area'
%        or 'perimeter' is also accepted.
%
%        DEFAULT: 'a'    ('area')
%
% arguments: (output)
%  pgx,pgy - 5x1 vectors of points that define the minimal
%        bounding parallelogram.
%
%  area - (scalar) area of the minimal parallelogram itself.
%
%  perimeter - (scalar) perimeter of the minimal parallelogram as found
%
%
% Example usage:
%  x = rand(50000,1);
%  y = rand(50000,1);
%  tic,[px,py,area,perim] = minboundparallelogram(x,y);toc
%
%  Elapsed time is 0.083340 seconds.
%
% [px,py]
% ans =
%       8.73336658824275e-05      3.51448852413649e-05
%           1.00002616513798       3.7428827532671e-05
%          0.999923888887252         0.999977663164396
%      -1.49425848464391e-05         0.999975379222104
%       8.73336658824275e-05      3.51448852413649e-05
%
% area
% area =
%          0.999879069698332
% 
% perim
% perim =
%            3.9997581420842
%
%
% See also: minboundcircle, minboundtri, minboundrect
%
%
% Author: John D'Errico
% E-mail: woodchips@rochester.rr.com
% Release: 1.0
% Release date: 8/19/2010

% default for metric
if (nargin<3) || isempty(metric)
  metric = 'a';
elseif ~ischar(metric)
  error('metric must be a character flag if it is supplied.')
else
  % check for 'a' or 'p'
  metric = lower(metric(:)');
  ind = strmatch(metric,{'area','perimeter'});
  if isempty(ind)
    error('metric does not match either ''area'' or ''perimeter''')
  end
  
  % just keep the first letter.
  metric = metric(1);
end

% preprocess data
x=x(:);
y=y(:);

% not many error checks to worry about
n = length(x);
if n~=length(y)
  error('x and y must be the same sizes')
end

% start out with the convex hull of the points to
% reduce the problem dramatically. Note that any
% points in the interior of the convex hull are
% never needed, so we drop them.
if n>3
  edges = convhull(x,y);  % 'Pp' will silence the warnings

  % exclude those points inside the hull as not relevant
  % also sorts the points into their convex hull as a
  % closed polygon
  
  x = x(edges(1:(end-1)));
  y = y(edges(1:(end-1)));
  
  % probably fewer points now, unless the points are fully convex
  nedges = length(x) - 1;
  
elseif n > 1
  % n must be 2 or 3
  nedges = n;
  x(end+1) = x(1);
  y(end+1) = y(1);
else
  % n must be 0 or 1
  nedges = n;
end

% now we must find the bounding parallelogram of those
% that remain.

% special case small numbers of points. If we trip any
% of these cases, then we are done, so return.
switch nedges
  case 0
    % empty begets empty
    pgx = [];
    pgy = [];
    area = [];
    perimeter = [];
    return
  case 1
    % with one point, the rect is simple.
    pgx = repmat(x,1,5);
    pgy = repmat(y,1,5);
    area = 0;
    perimeter = 0;
    return
  case 2
    % only two points. also simple.
    pgx = x([1 2 2 1 1]);
    pgy = y([1 2 2 1 1]);
    area = 0;
    perimeter = 2*sqrt(diff(x).^2 + diff(y).^2);
    return
end
% 3 or more points.

% will need a 2x2 rotation matrix through an angle theta
Rmat = @(theta) [cos(theta) sin(theta);-sin(theta) cos(theta)];

% get the angle of each edge of the hull polygon.
nx = length(x);
ind1 = 1:nx;
ind2 = circshift(ind1,[0 -1]);
edgeangles = atan2(y(ind2) - y(ind1),x(ind2) - x(ind1));
% move the angle to be in [0,pi).
edgeangles = mod(edgeangles,pi);

% now just check each edge of the convex hull
nang = length(edgeangles);
area = inf;
perim = inf;
met = inf;
xy = [x,y];
for i = 1:nang
  % line that defines the base of the parallelogram
  p1 = xy(i,:);
  
  % we will rotate and translate the points so this
  % edge lies on the x axis. The rotation matrix is...
  rot = Rmat(-edgeangles(i));
  xyr = (xy - repmat(p1,nx,1))*rot;
  
  % the height of the parallelogram is
  if max(xyr(:,2)) >= max(-xyr(:,2))
    pgheight = max(xyr(:,2));
  else
    pgheight = min(xyr(:,2));
  end
  
  % rotate everything, but keep the angles in the interval [0,pi)
  anglesr = mod(edgeangles - edgeangles(i),pi);
  
  % what are the smallest and largest possible angles of the
  % remaining edges? This will define the limits of where the
  % secondary sides of the bounding parallelogram may lie.
  anglesr(i) = [];
  anglesr(anglesr == 0) = [];
  anglebounds = [min(anglesr), max(anglesr)];
  
  % use fminbnd to search over the family of parallelograms with
  % the given base.
  sideang = fminbnd(@(ang) pgramobj(ang,xyr,pgheight),anglebounds(1),anglebounds(2));
  
  % get the final parallelogram
  [pmin,amin,pgxy] = pgramobj(sideang,xyr,pgheight);
  
  if metric=='a'
    M_i = amin;
  else
    M_i = pmin;
  end
  
  % A new metric value for the current interval.
  % Is it better than the previous best?
  if M_i < met
    % keep this one
    met = M_i;
    area = amin;
    perim = pmin;
    
    % recover the parallelogram in the original coordinate system
    pgxy = pgxy*rot' + repmat(p1,5,1);
    
    pgx = pgxy(:,1);
    pgy = pgxy(:,2);
    
%    plot(x,y,'kx',pgx,pgy,'-ro')
%    title(num2str([perim,area]))
%    axis equal
%    pause
    
  end
end

% all done
% plot(x,y,'kx',pgx,pgy,'-ro')
% title(num2str([perim,area]))
% axis equal

% =================================================================
function [perim,area,pgxy] = pgramobj(ang,xyr,pgheight)
%  For a given angle (in radians) computes the bounding
%  parallelogram where the base is assumed to lie on the
%  x axis. Thus the upper face must be parallel to the x axis.

% ang will always be in the open interval (0,pi)

% The vector that points along the sides will be
sidevec = [cos(ang),sin(ang)];

% for this value of ang, what is the normal vector to
% that side of the parallelogram? It always points in
% the positive x direction, by the way it is constructed.
nvec = [sin(ang);-cos(ang)];

% What is the left most point that a side will hit against?
% The rightmost? get that information from a dot product of
% the points with the normal vector of the sides.
dp = xyr*nvec;
leftmost = min(dp);
rightmost = max(dp);

% a point on the line that contains the left side of the
% parallelogram is 
leftpoint = leftmost*nvec.';

% and the right hand side line passes through this point.
rightpoint = rightmost*nvec.';

% we can define each line by the parametric equations
%  Pleft(t) = leftpoint + t*sidevec
%  Pright(t) = rightpoint + s*sidevec
% 
% now find the values of s and t, such that those lines
% intersect the x axis (thus y == 0)
t0 = -leftpoint(2)./sidevec(2);
s0 = -rightpoint(2)./sidevec(2);

% the actual x axis intercepts are at
x1 = leftpoint(1) + t0*sidevec(1);
x2 = rightpoint(1) + s0*sidevec(1);

% the length of a side of the parallelogram is given by the
% definition of the trig function from triangle sides.
sidelength = pgheight./cos(pi/2 - ang);
baselength = abs(x2 - x1);

% so the perimeter of the parallellogram is given by
perim = 2*(abs(sidelength) + baselength);

% don't bother to do these unless necessary
if nargout > 1
  % the area is also trivial to compute, as
  area = abs(pgheight)*baselength;
  
  % and the vertices of the parallelogram are
  pgxy = [[x1,0]; [x2,0]; ...
    [x2,0] + sidelength*sidevec ; ...
    [x1,0] + sidelength*sidevec ; ...
    [x1,0]];
  
end




