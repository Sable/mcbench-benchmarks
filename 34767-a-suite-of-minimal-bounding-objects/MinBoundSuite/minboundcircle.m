function [center,radius] = minboundcircle(x,y,hullflag)
% minboundcircle: Compute the minimum radius enclosing circle of a set of (x,y) pairs
% usage: [center,radius] = minboundcircle(x,y,hullflag)
%
% arguments: (input)
%  x,y - vectors of points, describing points in the plane as
%        (x,y) pairs. x and y must be the same size. If x and y
%        are arrays, they will be unrolled to vectors.
%
%  hullflag - boolean flag - allows the user to disable the
%        call to convhulln. This will allow older releases of
%        matlab to use this code, with a possible time penalty.
%        It also allows minboundellipse to call this code
%        efficiently.
% 
%        hullflag = false --> do not use the convex hull
%        hullflag = true  --> use the convex hull for speed
%
%        default: true
%
%
% arguments: (output)
%  center - 1x2 vector, contains the (x,y) coordinates of the
%        center of the minimum radius enclosing circle
%
%  radius - scalar - denotes the radius of the minimum
%        enclosing circle
%
%
% Example usage:
%   x = randn(50000,1);
%   y = randn(50000,1);
%   tic,[c,r] = minboundcircle(x,y);toc
%
%   Elapsed time is 0.171178 seconds.
%
%   c: [-0.2223 0.070526]
%   r: 4.6358
%
%
% See also: minboundrect
%
%
% Author: John D'Errico
% E-mail: woodchips@rochester.rr.com
% Release: 1.0
% Release date: 1/10/07

% default for hullflag
if (nargin<3) || isempty(hullflag)
  hullflag = true;
elseif ~islogical(hullflag) && ~ismember(hullflag,[0 1])
  error 'hullflag must be true or false if provided'
end

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
% never needed.
if hullflag && (n>3)
  edges = convhulln([x,y],{'QJ' 'Pp'});

  % list of the unique points on the convex hull itself
  % convhulln returns them as edges
  edges = unique(edges(:));

  % exclude those points inside the hull as not relevant
  x = x(edges);
  y = y(edges);
    
end

% now we must find the enclosing circle of those that
% remain.
n = length(x);

% special case small numbers of points. If we trip any
% of these cases, then we are done, so return.
switch n
  case 0
    % empty begets empty
    center = [];
    radius = [];
    return
  case 1
    % with one point, the center has radius zero
    center = [x,y];
    radius = 0;
    return
  case 2
    % only two points. center is at the midpoint
    center = [mean(x),mean(y)];
    radius = norm([x(1),y(1)] - center);
    return
  case 3
    % exactly 3 points
    [center,radius] = enc3(x,y);
    return
end

% more than 3 points.

% Use an active set strategy.
aset = 1:3; % arbitrary, but quite adequate
iset = 4:n;

% pick a tolerance
tol = 10*eps*(max(abs(mean(x) - x)) + max(abs(mean(y) - y)));

flag = true;
while flag
  % get the enclosing circle for the current set
  [center,radius] = enc3(x(aset),y(aset));
  
  % are all the inactive set points inside the circle?
  r = sqrt((x(iset) - center(1)).^2 + (y(iset) - center(2)).^2);
  [rmax,k] = max(r);
  if (rmax - radius) <= tol
    % the active set enclosing circle also enclosed
    % all of the inactive points.
    flag = false;
  else
    % it must be true that we can replace one member of aset
    % with iset(k). Which one?
    s1 = [aset([2 3]),iset(k)];
    [c1,r1] = enc3(x(s1),y(s1));
    if (norm(c1 - [x(aset(1)),y(aset(1))]) <= r1)
      center = c1;
      radius = r1;
      
      % update the active/inactive sets
      swap = aset(1);
      aset = [iset(k),aset([2 3])];
      iset(k) = swap;
      
      % bounce out to the while loop
      continue
    end
    s1 = [aset([1 3]),iset(k)];
    [c1,r1] = enc3(x(s1),y(s1));
    if (norm(c1 - [x(aset(2)),y(aset(2))]) <= r1)
      center = c1;
      radius = r1;
      
      % update the active/inactive sets
      swap = aset(2);
      aset = [iset(k),aset([1 3])];
      iset(k) = swap;
      
      % bounce out to the while loop
      continue
    end
    s1 = [aset([1 2]),iset(k)];
    [c1,r1] = enc3(x(s1),y(s1));
    if (norm(c1 - [x(aset(3)),y(aset(3))]) <= r1)
      center = c1;
      radius = r1;
      
      % update the active/inactive sets
      swap = aset(3);
      aset = [iset(k),aset([1 2])];
      iset(k) = swap;
      
      % bounce out to the while loop
      continue
    end
    
    % if we get through to this point, then something went wrong.
    % Active set problem. Increase tol, then try again.
    tol = 2*tol;
    
  end
  
end

% =======================================
%  begin subfunction
% =======================================
function [center,radius] = enc3(X,Y)
% minimum radius enclosing circle for exactly 3 points
%
% x, y are 3x1 vectors

% convert to complex
xy = X + sqrt(-1)*Y;

% just in case the points are collinear or nearly so, get
% the interpoint distances, and test the farthest pair
% to see if they work.
Dij = @(XY,i,j) abs(XY(i) - XY(j));
D12 = Dij(xy,1,2);
D13 = Dij(xy,1,3);
D23 = Dij(xy,2,3);

% Find the most distant pair. Test if their circumcircle
% also encloses the third point.
if (D12>=D13) && (D12>=D23)
  center = (xy(1) + xy(2))/2;
  radius = D12/2;
  if abs(center - xy(3)) <= radius
    center = [real(center),imag(center)];
    return
  end
elseif (D13>=D12) && (D13>=D23)
  center = (xy(1) + xy(3))/2;
  radius = D13/2;
  if abs(center - xy(2)) <= radius
    center = [real(center),imag(center)];
    return
  end
elseif (D23>=D12) && (D23>=D13)
  center = (xy(2) + xy(3))/2;
  radius = D23/2;
  if abs(center - xy(1)) <= radius
    center = [real(center),imag(center)];
    return
  end
end

% if we drop down to here, then the points cannot
% be collinear, so the resulting 2x2 linear system
% of equations will not be singular.
A = 2*[X(2)-X(1), Y(2)-Y(1); X(3)-X(1), Y(3)-Y(1)];
rhs = [X(2)^2 - X(1)^2 + Y(2)^2 - Y(1)^2; ...
       X(3)^2 - X(1)^2 + Y(3)^2 - Y(1)^2];
     
center = (A\rhs)';
radius = norm(center - [X(1),Y(1)]);


