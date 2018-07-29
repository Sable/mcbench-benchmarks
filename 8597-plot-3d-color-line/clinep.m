% This function plots a 3D line (x,y,z) encoded with scalar color data (c).
% This function is an improvement over the CLINE function previously made
% available on TMW File Exchange.  Rather than using the LINE function a
% PATCH surface is generated.  This provides a way to change the
% colormapping because the surface patches use indexed colors rather than
% true colors.  Hence changing the COLORMAP or CAXIS of the figure will
% change the colormapping of the patch object.
%
% DEMO:  clinep;
%
% SYNTAX: h=clinep(x,y,z[,c,W]);
%
% INPUTS:
%   x - mx1 vector of x-position data
%   y - mx1 vector of y-position data
%   z - mx1 vector of z-position data
%
% -OPTIONAL INPUTS-
%
%   c - mx1 vector of index color-data (uses current colormap or DEFAULT)
%   W - 1x1 specifies the line thickness (DEFAULT is 3)
%
% OUTPUT:
%  
%   h - Graphics handle to the patch object.
%
% DBE 2005/09/29
%
% P.S.  The code is modified from code that generates a 3D tube, rather
% than a line, but that needs more work still.

function p=clinep(x,y,z,c,W);

if nargin==0  % Generate sample data...
  figure; axis off; axis equal;
    cameratoolbar('Show');
    cameratoolbar('SetMode','orbit','SetCoordSys','none');
  
  x=linspace(-1,1,100);
  y=sin(4*pi*x);
  z=cos(4*pi*x);
  c=sin(x);
  W=3;
  l=light; view(110,60); zoom(2);
elseif nargin<3
  error('Insufficient input arguments\n');
elseif nargin<4
  c=ones(size(x));
  W=3;
elseif nargin<5
  W=3;
end

% scl=100;
N=3;

% Create a unit disc...points lie in X-Y plane therefore have a Z-normal
[xc,yc,zc]=cylinder(0.00001,N); % The original function allowed you to specify N(=3) to generate a tube, and the radius(=0.01) was =1.
xc=xc(1,1:end-1);        % Only use first layer and remove replicated end point
yc=yc(1,1:end-1);
zc=zc(1,1:end-1);
Nz=[0 0 1];                  % Disc normal

xyz=[];
faces=[];
for k=1:length(x)
  % Determine the rotation between the unit disc normal and the local curves tangent
  if k==length(x)
    dl=[x(k)-x(k-1) y(k)-y(k-1) z(k)-z(k-1)];                       % Local curves tangent (at end point)
  else
    dl=[x(k+1)-x(k) y(k+1)-y(k) z(k+1)-z(k)];                       % Local curves tangent
  end
    dl=dl/norm(dl,2);                                               % Unit tangent vector
    alpha=acos(dot(Nz,dl));                                         % Angle between local curve tangent and disc normal
    R=RotMat(cross(Nz,dl),alpha);                                       % Rotation between them
    xyz=[xyz R*[xc(:)'; yc(:)'; zc(:)']+repmat([x(k) y(k) z(k)]',[1 N])]; % Rotate and translate the data
  
    if k<=length(x)-1
      faces=[faces; [(1:N)' ([2:N,1])' ([2:N,1])'+N (1:N)'+N]+N*(k-1)];
    end
end

vertices=xyz';

if isequal([1 3],size(c))
  fc=repmat(c ,[size(faces,1) 1]);
elseif isequal([3 1],size(c))
  fc=repmat(c',[size(faces,1) 1]);
else  
  fc=repmat(c(1:end),[N 1]); fc=fc(:);
end

p=patch('Vertices',vertices,'Faces',faces,'FaceVertexCData',fc,'FaceColor','Flat');
  set(p,'EdgeColor','Flat','LineWidth',W);

return

% This function generates a rotation matrix, R, for rotation about 
% the axis, ax, through an angle, alpha (radians).  
%
% SYNTAX: R=RotMat(ax,alpha)
%
% ax    - 1x3 Column vector
% alpha - 1xN or Nx1 vector of rotation angles
%
% DBE 08/28/01
function R=RotMat(ax,alpha)

sz=size(ax);
if sz(1)<sz(2)
  ax=ax';
end
ax=ax./norm(ax,2);   % Make sure it is a unit vector (normalize)

Wa=zeros(3,3); Wa(1,2)=-ax(3); Wa(1,3)=ax(2); Wa(2,1)=ax(3); Wa(2,3)=-ax(1); Wa(3,1)=-ax(2); Wa(3,2)=ax(1);

ident(1,1)=1; ident(2,2)=1; ident(3,3)=1;

ax_ax=ax*ax';
for i=1:length(alpha)
  cos_a=cos(alpha(i));
  sin_a=sin(alpha(i));
  R(:,:,i)=cos_a*ident+(1-cos_a)*ax_ax+sin_a*Wa;
end

return
