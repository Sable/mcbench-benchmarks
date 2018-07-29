function [trix,triy] = minboundtri(x,y)
% minboundtri: Compute the minimum area bounding triangle of points in the plane
% usage: [trix,triy] = minboundtri(x,y)
%
% arguments: (input)
%  x,y - vectors of points, describing points in the plane as
%        (x,y) pairs. x and y must be the same size.
%
%
% arguments: (output)
%  trix,triy - 4x1 vectors of points that define the minimum
%        area bounding triangle.
%
%
% Example usage:
%  x = randn(50,1);
%  y = randn(50,1);
%  [tx,ty] = minboundtri(x,y);
%  plot(x,y,'ro',tx,ty,'b-')
%
%
% See also: minboundcircle, minboundrect
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
  error 'x and y must be the same sizes'
end

% start out with the convex hull of the points to
% reduce the problem dramatically. Note that any
% points in the interior of the convex hull are
% never needed, so we drop them.
xy = [x,y];
if n>3
  edges = convhulln(xy,{'Qt'});  % 'Pp' will silence the warnings
  
  % exclude those points inside the hull as not relevant
  % also sorts the points into their convex hull as a
  % closed polygon
  [junk,I,J] = unique(edges(:));
  xy = xy(edges(I),:);
  edges = reshape(J,size(edges));
  
elseif n==3
  % its a triangle already
  edges = [1 2;2 3;3 1];
elseif n==2
  % its a single edge
  trix = xy([1 2 1 1],1);
  triy = xy([1 2 1 1],2);
  return
elseif n==1
  % its a single point
  trix = xy([1 1 1 1],1);
  triy = xy([1 1 1 1],2);
  return
else
  % empty begets empty
  trix = [];
  triy = [];
  return
end
nedges = size(edges,1);

% now we must find the bounding triangle of those
% that remain.

% special case small numbers of points. If we trip any
% of these cases, then we are done, so return.
if nedges == 3
  trix = xy([1 2 3 1],1);
  triy = xy([1 2 3 1],2);
  return
end
% more than 3 points.

% get the angle of each edge of the hull polygon.
edgeangles = atan2(xy(edges(:,2),2) - xy(edges(:,1),2), ...
  xy(edges(:,2),1) - xy(edges(:,1),1));

edgelen = sqrt((xy(edges(:,2),2) - xy(edges(:,1),2)).^2 + ...
  (xy(edges(:,2),1) - xy(edges(:,1),1)).^2);

[edgelen,tags] = sort(edgelen,1,'descend');
edges = edges(tags,:);
edgeangles = edgeangles(tags);

% Will need a 2x2 rotation matrix through an angle theta
Rmat = @(theta) [cos(theta) sin(theta);-sin(theta) cos(theta)];

% Loop over each edge of the hull - I'll contend that the minimum
% area triangle will contain at least one edge of the convex hull.
% In fact, often the triangle will contain up to 6 points from the
% convex hull - i.e., 3 edges.
area = inf;
nxy = size(xy,1);
opts = optimset('fminsearch');
opts.MaxFunEvals = 600;
opts.Display = 'none';
for i = 1:nedges
  % rotate the data through (pi/2 - theta)
  rot = Rmat(pi/2 - edgeangles(i));
  % around the center of the i'th edge
  xy0 = (xy(edges(i,1),:) + xy(edges(i,2),:))/2;
  xyt = (xy - repmat(xy0,nxy,1))*rot;
  if (max(xyt(:,1))/(max(xyt(:,1)) - min(xyt(:,1)))) > 1e-13
    % swap the edge orientation
    rot = Rmat(-pi/2 - edgeangles(i));
    xyt = -xyt;
  end
  
  % find the point which minimizes the triangle area
  minxt = min(xyt(:,1));
  xy3 = [.5*minxt,mean(xyt(:,2))];
  
  [xy3,A_i] = fminsearch(@trifun,xy3,opts);
  
  % new metric value for the current interval. Is it better?
  if A_i<area
    % keep this one
    [area,tpoly] = trifun(xy3);
    
    tpoly = tpoly*rot' + repmat(xy0,4,1);
  end
end
trix = tpoly(:,1);
triy = tpoly(:,2);

% all done

% =================================
% nested function
  function [area,txy] = trifun(xy3)
    % 
    xy3(1) = -abs(xy3(1)) + minxt*1.000001;
    
    slopes = (xyt(:,2) - xy3(2))./(xyt(:,1) - xy3(1));
    yint = xy3(2) - slopes*xy3(1);
    y2 = max(yint);
    y1 = min(yint);
    
    % negative of the triangle area
    area = -xy3(1)*(y2-y1)/2;
    
    txy = [0 y1;0 y2;xy3;0 y1];
    
  end % trifun
% =================================
end % mainline end


