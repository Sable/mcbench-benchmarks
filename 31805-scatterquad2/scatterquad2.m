function v=scatterquad2(x,y,z)
% SCATTERQUAD2 - calculates the volume under a surface defined by scattered points
%
% Usage:
%   v = scatterquad2(x,y,z)
%
% Inputs:
%   X,Y,Z are vectors of equal size specifying the coordinates of the points
%   defining the surface.  Z can also be a scalar or a function handle accepting
%   two inputs.
%
% Outputs:
%   V is the volume under the surface defined by linear interpolation of Z on
%   the Delaunay triangulation of the points (X(i),Y(i)), assuming that z=0
%   outside the convex hull of the points (X(i),Y(i)).
%
% Method:
%   The linear interpolation is a linear combination of basis functions of the
%   form z=t if (x,y) is in triangle T such that 
%     (x,y)=r*(u1,v1)+s*(u2,v2)+t*(u3,v3)  where r+s+t=1 (all non-negative) and
%   (u,v) are the vertices of T, or z=0 otherwise.  The integral of z is
%   (1/3)*Area(T) where the area of T is determined by the cross product of two
%   edge vectors.
%
% Examples:
%   load seamount
%   scatterquad2(x,y,z-min(z)) % returns 190.7996
%   inR = (x>=211.1 & x<=211.4 & y>=-48.35 & y<=-48);
%   scatterquad2(x,y,(z-min(z)).*inR) % returns 142.3083
%   scatterquad2(x,y,1) % returns 0.2696
%
% For functions that can be evaluated at arbitrary points, use DBLQUAD or
% QUAD2D.  For regular grids, use TRAPZ twice.

if nargin<3
  error('scatterquad2:nargin','Expect 3 input arguments');
elseif ~isnumeric(x) || ~isnumeric(y)
  error('scatterquad2:xytype','Inputs X and Y must be numeric');
elseif ~isequal(numel(x),numel(y))
  error('scatterquad2:xysize','Inputs X and Y must have same number of elements');
elseif numel(x)<3
  error('scatterquad2:xsize','Inputs X and Y must have at least 3 elements');
elseif ~isnumeric(z)
  if isa(z,'function_handle')
    try
      z=z(x,y);
      if ~isnumeric(z)
        error('scatterquad2:zftype','Input Z failed to return a numeric array');
      end;
    catch ME
      error('scatterquad2:zfeval','Input Z failed to evaluate at (X,Y)');
    end;
  else
    error('scatterquad2:ztype','Input Z must be numeric or a function handle');
  end;
end;

if ~isequal(numel(z),numel(x))
  if numel(z)==1
    z=repmat(z,numel(x),1);
  else
    error('scatterquad2:zsize','Input Z must be scalar or the same size as X and Y');
  end;
end;

DT=DelaunayTri(x,y);
i=DT(:,1);
j=DT(:,2);
k=DT(:,3);
A=abs((x(j)-x(i)).*(y(k)-y(i))-(y(j)-y(i)).*(x(k)-x(i)))/2; % area of triangles
v=sum((z(i)+z(j)+z(k)).*A)/3;

end % main function scatterquad2(...)
