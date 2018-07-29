function fi = tinterp(p,t,f,xi,yi,method)

% Interpolation of scattered data.
%
%   fi = tinterp(p,t,f,xi,yi,method);
%
% INPUTS:
%
%   p = [x1,y1; x2,y2; etc]             - an Nx2 matrix defining the [x,y] 
%                                         coordinates of the scattered vertices 
%
%   t = [n11,n12,n13; n21,n22,n23; etc] - an Mx3 matrix defining the
%                                         triangulation of the points in p, as 
%                                         returned by delaunayn(p)
%
%   f = [f1; f2; etc]                   - an Nx1 vector defining the value
%                                         of the function at the scattered 
%                                         vertices
%
%   xi,yi                               - Vectors or matrices of identical
%                                         size, defining the [x,y] coordinates
%                                         where the function is to be
%                                         interpolated
%
%   method = 'linear','quadratic'       - Type of interpolant, method is
%                                         optional and if not passed the 
%                                         'linear' method is used
%
% OUTPUT:
%
%   fi                                  - The interpolation evaluated at
%                                         all points in xi,yi. 
%
% The 'linear' method should return identical results to griddata. The
% 'quadratic' method is NEW! (I think) and should return more accurate results 
% when compared with the 'cubic' method in gridata (See tester.m).  
%
% Example:
%
%   p = rand(100,2);
%   t = delaunayn(p);
%   f = exp(-20*sum((p-0.5).^2,2));
%
%   figure, trimesh(t,p(:,1),p(:,2),f), title('Exact solution on scattered data')
%
%   x     = linspace(0,1,50);
%   [x,y] = meshgrid(x);
%   fL    = tinterp(p,t,f,x,y);
%   fQ    = tinterp(p,t,f,x,y,'quadratic');
%
%   figure, mesh(x,y,fL), title('Linear interpolation')
%   figure, mesh(x,y,fQ), title('Quadratic interpolation')
%
% See also TESTER, DELAUNAYN, GRIDDATA

% Any comments? Let me know:
%
%   d_engwirda@hotmail.com
%
% Darren Engwirda - 2006


% Check I/O
if nargin<6
    method = 'linear';
elseif nargin>6
    error('Too many inputs');
end
if nargout~=1
    error('Wrong number of outputs');
end

% Force lowercase
method = lower(method);

% Error checking
if size(p,2)~=2
    error('p must be an Nx2 vector as passed to delaunayn');
end
if size(t,2)~=3
    error('t must be an Mx3 matrix containing the triangulation of p as per delaunayn');
end
if (max(t(:))>size(p,1))||(min(t(:))<=0)
    error('t is not a valid triangulation for p');
end
if (size(f,2)~=1)||(size(f,1)~=size(p,1))
    error('f must be an Nx1 vector defining the function f(p) at the vertices')
end
if ~strcmp(method,'linear')&&~strcmp(method,'quadratic')
    error('method must be either ''linear'' or ''quadratic'' ');
end
sizx = size(xi); sizy = size(yi);
if any(sizx-sizy)
    error('xi & yi must be the same size');
end
pi = [xi(:),yi(:)];

% Allocate output
fi = zeros(size(pi,1),1);

% Find enclosing triangle of points in pi
i = tsearch(p(:,1),p(:,2),t,pi(:,1),pi(:,2));

% Deal with points oustide convex hull
in = ~isnan(i); 

% Keep internal points
pin = pi(in,:); 
tin = t(i(in),:);

% Corner nodes
t1 = tin(:,1); t2 = tin(:,2); t3 = tin(:,3);

% Linear shape functions
dp1 = pin-p(t1,:);
dp2 = pin-p(t2,:);
dp3 = pin-p(t3,:);
A3  = abs(dp1(:,1).*dp2(:,2)-dp1(:,2).*dp2(:,1));
A2  = abs(dp1(:,1).*dp3(:,2)-dp1(:,2).*dp3(:,1));
A1  = abs(dp3(:,1).*dp2(:,2)-dp3(:,2).*dp2(:,1));

% Interpolant
if strcmp(method,'linear')      % Linear interpolation
    
    % Take weighted average of constant extrapolations
    fi(in) = (A1.*f(t1)+A2.*f(t2)+A3.*f(t3)) ./ (A1+A2+A3);
    
else                            % Quadratic interpolation
    
    % Form gradients
    [fx,fy] = tgrad(p,t,f);
    
    % Take weighted average of linear extrapolations
    fi(in) = ( A1.*(f(t1) + dp1(:,1).*fx(t1) + dp1(:,2).*fy(t1)) + ...
               A2.*(f(t2) + dp2(:,1).*fx(t2) + dp2(:,2).*fy(t2)) + ...
               A3.*(f(t3) + dp3(:,1).*fx(t3) + dp3(:,2).*fy(t3)) ) ./ (A1+A2+A3);
           
end

% Deal with outside points
if any(~in)
    fi(~in) = NaN;
end

% Reshape output
fi = reshape(fi,sizx);

return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fnx,fny] = tgrad(p,t,f)

% Approximate [df/dx,df/dy] at the vertices.

% Nodes
t1 = t(:,1); t2 = t(:,2); t3 = t(:,3);

% Evaluate centroidal gradients (piecewise-linear interpolants)
x23 = p(t2,1)-p(t3,1);  y23 = p(t2,2)-p(t3,2);
x21 = p(t2,1)-p(t1,1);  y21 = p(t2,2)-p(t1,2);

% Centroidal values - [df/dx,df/dy]
den =  (x23.*y21-x21.*y23);
fcx =  (y23.*f(t1)+(y21-y23).*f(t2)-y21.*f(t3)) ./ den;
fcy = -(x23.*f(t1)+(x21-x23).*f(t2)-x21.*f(t3)) ./ den;

% Calculate simplex quality
q = quality(p,t);

% Form nodal gradients.
% Take the quality weighted average of the neighbouring centroidal values.
% Low quality simplices ("thin" triangles) can contribute inaccurate
% gradient information - quality weighting seems to limit this effect.
fnx = 0*f; 
fny = fnx; 
den = fnx;
for k = 1:size(t,1)
    % Nodes
    n1 = t1(k); n2 = t2(k); n3 = t3(k);
    % Current values
    qk = q(k); qfx = qk*fcx(k); qfy = qk*fcy(k); 
    % Average to n1
    fnx(n1) = fnx(n1)+qfx;
    fny(n1) = fny(n1)+qfy;
    den(n1) = den(n1)+qk;
    % Average to n2
    fnx(n2) = fnx(n2)+qfx;
    fny(n2) = fny(n2)+qfy;
    den(n2) = den(n2)+qk;
    % Average to n3
    fnx(n3) = fnx(n3)+qfx;
    fny(n3) = fny(n3)+qfy;
    den(n3) = den(n3)+qk;
end
fnx = fnx./den;
fny = fny./den;

return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function q = quality(p,t)

% Approximate simplex quality

% Nodes
p1 = p(t(:,1),:); p2 = p(t(:,2),:); p3 = p(t(:,3),:);

% Approximate quality
d12 = p2-p1;
d13 = p3-p1;
q   = 3.4641*abs(d12(:,1).*d13(:,2)-d12(:,2).*d13(:,1))...
                            ./(sum(d12.^2,2)+sum(d13.^2,2)+sum((p3-p2).^2,2));

return