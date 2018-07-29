function [qx,qy,quadarea] = minboundquad(x,y)
% minboundquad: Compute the minimum area bounding quadrilateral of points in the plane
% usage: [qx,qy] = minboundquad(x,y)
%
% arguments: (input)
%  x,y - vectors of points, describing points in the plane as
%        (x,y) pairs. x and y must be the same size.
%
% arguments: (output)
%  qx,qy - 5x1 vectors of points that define the minimum
%        area bounding quadrilateral.
%
% WARNING: Most 2-d convex hulls are fairly small.
% However, this code will be O(N^4), where N is the
% number of distinct edges in the convex hull of
% your data. So finding the bounding quadrilateral
% of 1000 points around the perimeter of a circle 
% will take much time.
%
% Example usage:
%  x = randn(50,1);
%  y = randn(50,1);
%  [qx,qy] = minboundquad(x,y);
%  plot(x,y,'ro',qx,qy,'b-')
%
%
% See also: minboundcircle, minboundrect, minboundtri
%
%
% Author: John D'Errico
% E-mail: woodchips@rochester.rr.com
% Release: 1.0
% Release date: 3/14/07

% preprocess data
x=x(:);
y=y(:);

% not many error checks to worry about
n = length(x);
if n~=length(y)
  error('MINBOUNDQUAD:size','x and y must be the same sizes')
end

% start out with the convex hull of the points to
% reduce the problem dramatically. Note that any
% points in the interior of the convex hull are
% never needed, so we drop them.
xy = [x,y];
if n>3
  edges = convhull(x,y,{'Qt'});  % 'Pp' will silence any warnings
  % convhull returns a list of points around
  % the perimeter. I prefer the convhulln form,
  % where I have an explicit list of edges.
  % Make it so.
  edges = [edges(1:(end-1)),edges(2:end)];
elseif n==3
  % it is a triangle. I don't care how we
  % traverse it. Replicate a vertex into
  % a quadrilateral.
  qx = xy([1 2 3 3 1],1);
  qy = xy([1 2 3 3 1],2);
  quadarea = polyarea(qx,qy);
  return
elseif n==2
  % a single edge
  qx = xy([1 2 2 2 1],1);
  qy = xy([1 2 2 2 1],2);
  % no area to be found
  quadarea = 0;
  return
elseif n==1
  % a single point
  qx = xy([1 1 1 1 1],1);
  qy = xy([1 1 1 1 1],2);
  quadarea = 0;
  return
else
  % empty begets empty
  qx = [];
  qy = [];
  quadarea = 0;
  return
end
nedges = size(edges,1);

% now we must find the bounding quadrilateral of those
% that remain.

% special case small numbers of points. If we trip any
% of these cases, then we are done, so return.
if nedges == 3
  qx = xy([1 2 3 1],1);
  qy = xy([1 2 3 1],2);
  return
elseif nedges == 4
  qx = xy([1 2 3 4 1],1);
  qy = xy([1 2 3 4 1],2);
  return
end
% more than 4 points.

% get the angle of each edge of the hull polygon
edgeangles = atan2(xy(edges(:,2),2) - xy(edges(:,1),2), ...
  xy(edges(:,2),1) - xy(edges(:,1),1));

% (These next two steps are probably superfluous.)
% work with all positive angles
k = edgeangles < 0;
edgeangles(k) = edgeangles(k) + 2*pi;
% sort the edges into increasing order of angle
[edgeangles,tags] = sort(edgeangles);
edges = edges(tags,:);

% Look for consecutive edges that have the same
% angles. This test will generally only trip if
% the data set has multiple collinear points
% around the perimeter.
angletol = eps*100;
k = diff(edgeangles) < angletol;
edges(k,:) = [];
edgeangles(k) = [];

% there are nchoosek(nedges,4) sets of edges to
% worry about
edgelist = nchoosek(1:nedges,4);

% The edges are now sorted in counter-clockwise
% order around the convex hull. We can toss out any
% combination of edges where the last edge angle
% minus the first is less than 180 degrees
% (i.e., pi radians.)
k = (edgeangles(edgelist(:,4)) - edgeangles(edgelist(:,1)) <= pi);
edgelist(k,:) = [];

% how many edges remain that can form a valid
% quadrilateral?
nquads = size(edgelist,1);

% test each set of 4 edges
quadarea = inf;
qxi = zeros(1,5);
qyi = zeros(1,5);
qx = qxi;
qy = qyi;
for i = 1:nquads
  % find the intersections of each consecutive
  % pair of edges.
  edgeind = edgelist(i,:);
  edgesi = edges(edgeind([1 2 3 4 1]),:);
  
  if any(diff(edgeangles(edgeind)) > pi)
    % if one of the consecutive angles is too
    % large, then this set of edges will be a
    % failed quadrilateral.
    continue
  end
  
  for j = 1:4
    % Does this pair of edges share a node from
    % the convex hull?
    jplus1 = j + 1;
    shared = intersect(edgesi(j,:),edgesi(jplus1,:));
    if ~isempty(shared)
      % there was a shared node between these edges
      qxi(j) = xy(shared,1);
      qyi(j) = xy(shared,2);
    else
      % no shared node, so we must find the
      % intersection of the edges by extrapolation
      % of the lines that contain these edges to
      % see where they intersect.
      A = xy(edgesi(j,1),:);
      B = xy(edgesi(j,2),:);
      C = xy(edgesi(jplus1,1),:);
      D = xy(edgesi(jplus1,2),:);
      
      % solve for the line parameters that correspond
      % to the intersection point
      ts = [(A-B)',(D-C)']\(A-C)';
      % recover the intersection point
      Q = A + (B-A)*ts(1);
      
      qxi(j) = Q(1);
      qyi(j) = Q(2);
    end
  end
  % wrap the polygon
  qxi(5) = qxi(1);
  qyi(5) = qyi(1);
  
  % compute the area. Simplest is to use polyarea.
  % I might want to test to see if it is faster
  % to compute the area using other methods though.
  A_i = polyarea(qxi,qyi);
  
  if (A_i < quadarea)
    % keep this one
    quadarea = A_i;
    
    qx = qxi;
    qy = qyi;
  end
  
  % plot the points, the current quad, and the best quad
%  plot(xy(:,1),xy(:,2),'ko')
%  hold on
%  plot([xy(edgesi(1:4,1),1),xy(edgesi(1:4,2),1)]', ...
%    [xy(edgesi(1:4,1),2),xy(edgesi(1:4,2),2)]','g*-','linewidth',8)
%  plot(qx,qy,'b-',qxi,qyi,'r:')
%  hold off
end

% plot the points and the quad
plot(xy(:,1),xy(:,2),'r.',qx,qy,'b-')
