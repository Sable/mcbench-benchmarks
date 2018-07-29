function semicircle = minboundsemicircle(x,y)
% minboundsemicircle: minimum radius bounding semi-circle
% usage: semicircle = minboundsemicircle(x,y)
%
% Finds that semi-circle with minimal radius
% that fully contains the data
%
% Arguments:
%  x,y - vectors listing the (x(i),y(i)) pairs
%        to be bounded.
%
% Arguments: (output)
%  semicircle - a structure that contains five fields.
%
%     semicircle.center = 1x2 vector, defining the
%       center coordinates of the minimal
%       semi-circle.
%
%     semicircle.radius = scalar, defines the radius
% 
%     semicircle.normal = 1x2 vector, defines the
%       normal vector to the diameter.
%
%     semicircle.D1 = one end point of the diameter
%       of the bounding semi-circle
%
%     semicircle.D2 = The opposite end point of the
%       diameter of the bounding semi-circle
%
%
% Example usage:
%  n = 100000;
%  x = abs(randn(n,1));
%  y = randn(n,1);
%
%  tic,semicirc = minboundsemicircle(x,y);toc
%
% Elapsed time is 0.727236 seconds.
% 
%  semicirc
% semicirc = 
%    radius: 4.7941
%    center: [3.8906e-05 -0.15372]
%    normal: [1 9.2189e-06]
%        D1: [-5.2901e-06 4.6404]
%        D2: [8.3103e-05 -4.9478]
%
%
% See also: minboundrect, minboundcircle
%
%
% Author: John D'Errico
% E-mail: woodchips@rochester.rr.com
% Release: 1.0
% Release date: 4/1/09

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
% never needed.
switch n
  case 0
    error('no points supplied')
  case 1
    % a single point. result is trivial
    semicircle.center = [x,y];
    semicircle.radius = 0;
    semicircle.normal = [1 0];
    semicircle.D1 = semicircle.center;
    semicircle.D2 = semicircle.center;
  case 2
    % two points. result is still trivial
    semicircle.center = [mean(x),mean(y)];
    d = norm([diff(x),diff(y)]);
    
    semicircle.radius = d/2;
    semicircle.normal = [1 0];
    semicircle.D1 = [x(1),y(1)];
    semicircle.D2 = [x(2),y(2)];
  otherwise
    % three or more points
    xy = [x,y];
    edges = convhulln(xy,{'QJ' 'Pp'});
    
    % find the list of perimeter points
    perimlist = unique(edges(:));
    
    % exclude those points inside the hull as
    % not relevant in the optimization
    xyp = xy(perimlist,:);
    
    % now find the enclosing semi-circle of those that
    % remain.
    np = length(perimlist);
    
    % how many edges are there in the hull
    ne = size(edges,1);
    
    % define the objective function for fminbnd
    fun = @(c,uv) max(uv(:,1).^2 + (uv(:,2) - c).^2);
    
    % loop over each edge of the hull
    semicircle.radius = inf;
    for i = 1:ne
      % translate so that one end point of
      % the current edge is the origin
      origin = xy(edges(i,1),:);
      E2 = xy(edges(i,2),:) - origin;
      
      % the normal to the current edge
      nrml = E2*[0 -1;1 0];
      nrml = nrml/norm(nrml);
      
      % set the sign of the normal so that
      % it points towards the data
      uv = xyp - repmat(origin,np,1);
      if mean(uv*nrml') < 0
        nrml = -nrml;
      end
      
      % rotate the points for simplicity
      % R is a rotation matrix.
      R = [nrml;E2/norm(E2)]';
      uv = uv*R;
      
      % set limits on the center location
      % for the semi-circle
      c1 = min(uv(:,2));
      c2 = max(uv(:,2));
      
      % solve for the minimal radius semi-circle
      % using fminbnd. This will be efficient.
      [c,R2] = fminbnd(@(c) fun(c,uv),c1,c2);
      radius = sqrt(R2);
      
      if radius < semicircle.radius
        % this semi-circle is better than the
        % previous best semi-circle that we found.
        semicircle.center = origin + [0,c]*R';
        semicircle.radius = radius;
        semicircle.normal = nrml;
        semicircle.D1 = semicircle.center - R(:,2)'*radius;
        semicircle.D2 = semicircle.center + R(:,2)'*radius;
        
        % plot
        % plot(x,y,'o')
        % hold on
        % plot([semicircle.D1(1),semicircle.D2(1)],[semicircle.D1(2),semicircle.D2(2)],'b-')
        % plot(semicircle.center(1),semicircle.center(2),'b*')
        % t = linspace(0,2*pi,200);
        % plot(semicircle.center(1) + semicircle.radius*cos(t),semicircle.center(2) + semicircle.radius*sin(t),'g-')
        % hold off
        % axis equal
        % pause
        
      end
    end % for i = 1:ne
end % switch n





