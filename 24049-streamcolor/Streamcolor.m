function hout=streamcolor(varargin)
%STREAMCOLOR:  COLOR Streamlines from 2D or 3D vector data.
%   H = STREAMCOLOR(X,Y,Z,U,V,W,STARTX,STARTY,STARTZ,VMAG) creates streamlines
%   from 3D vector data U,V,W. The arrays X,Y,Z define the coordinates for
%   U,V,W and must be monotonic and 3D plaid (as if produced by MESHGRID). 
%   STARTX, STARTY, and STARTZ define the starting positions of the stream
%   lines. A vector of line handles is returned.
%   
%   H = STREAMCOLOR(U,V,W,STARTX,STARTY,STARTZ,VMAG) assumes 
%         [X Y Z] = meshgrid(1:N, 1:M, 1:P) where [M,N,P]=SIZE(U). 
%   
%   H = STREAMCOLOR(X,Y,U,V,STARTX,STARTY,VMAG) creates streamlines from 2D
%   vector data U,V. The arrays X,Y define the coordinates for U,V and
%   must be monotonic and 2D plaid (as if produced by MESHGRID). STARTX
%   and STARTY define the starting positions of the streamlines. A vector
%   of line handles is returned.
%   
%   H = STREAMCOLOR(U,V,STARTX,STARTY,VMAG) assumes 
%         [X Y] = meshgrid(1:N, 1:M) where [M,N]=SIZE(U). 
%  
%   3D Example:
%   load wind
%   [sx,sy,sz] = meshgrid(80,10:5:60,1:2:15);
%   X=x; Y=y; Z=z; U=u; V=v; W=1*w; 
%   Vmag=sqrt(U.^2+V.^2+W.^2);  
%   streamcolor(X,Y,Z,U,V,W,sx,sy,sz,Vmag)

%   2D Example:
%   load wind
%   [sx,sy] = meshgrid(80,10:60);
%   X=x(:,:,5); Y=y(:,:,5); U=u(:,:,5); V=v(:,:,5); 
%   Vmag=sqrt(U.^2+V.^2); 
%   streamcolor(X,Y,U,V,sx,sy,Vmag);
%   grid on; axis image

%   See also STREAM3, STREAM2, CONEPLOT, ISOSURFACE, SMOOTH3, SUBVOLUME,
%            REDUCEVOLUME.

% Bertrand Dano 05-05-2009
%   Copyright 1984-2009 The MathWorks, Inc. 


lw=2; % width of the streamlines
cmap=colormap;

[verts x y z u v w sx sy sz Vmag] = parseargs(nargin,varargin);
Vmax=max(Vmag(:));

if isempty(verts)
  if isempty(w)       % 2D
    if isempty(x)
      verts = stream2(u,v,sx,sy);
    else
      verts = stream2(x,y,u,v,sx,sy);
    end
  else                % 3D
    if isempty(x)
      verts = stream3(u,v,w,sx,sy,sz);
    else
      verts = stream3(x,y,z,u,v,w,sx,sy,sz);
    end
  end
end

h = [];
for k = 1:length(verts);
  vv = verts{k};
  if ~isempty(vv)
    if size(vv,2)==3
      %h = [h ; line(vv(:,1), vv(:,2), vv(:,3))];
        X=vv(:,1); Y=vv(:,2); Z=vv(:,3);
        Vcol=uint8(floor(interp3(x,y,z,Vmag,X,Y,Z)/Vmax*64));
        Vcol(Vcol==0)=1;
    for j=2:length(X)
        line([X(j-1) X(j)],[Y(j-1) Y(j)],[Z(j-1) Z(j)],'color',[cmap(Vcol(j),1) cmap(Vcol(j),2) cmap(Vcol(j),3) ],'linewidth',lw)
    end
      
      
    else
      %h = [h ; line(vv(:,1), vv(:,2))];
        X=vv(:,1); Y=vv(:,2);
        Vcol=uint8(floor(interp2(x,y,Vmag,X,Y)/Vmax*64));
        Vcol(Vcol==0)=1;
    for j=2:length(X)
        line([X(j-1) X(j)],[Y(j-1) Y(j)],'color',[cmap(Vcol(j),1) cmap(Vcol(j),2) cmap(Vcol(j),3) ],'linewidth',lw)
    end
    
    end
  end
end

if nargout>0
  hout=h;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [verts, x, y, z, u, v, w, sx, sy, sz, Vmag] = parseargs(nin, vargin)

verts = [];
x = [];
y = [];
z = [];
u = [];
v = [];
w = [];
sx = [];
sy = [];
sz = [];
Vmag = [];

if nin==1  % streamline(xyz) or  streamline(xy) 
  verts = vargin{1};
  if ~iscell(verts)
    error('Stream vertices must be passed in as a cell array')
  end
elseif nin==4 | nin==5           % streamline(u,v,sx,sy)
  u = vargin{1};
  v = vargin{2};
  sx = vargin{3};
  sy = vargin{4};
  if nin==5, Vmag = vargin{5}; end
elseif nin==6 | nin==7        % streamline(u,v,w,sx,sy,sz) or streamline(x,y,u,v,sx,sy)
  u = vargin{1};
  v = vargin{2};
  if ndims(u)==3
    w = vargin{3};
    sx = vargin{4};
    sy = vargin{5};
    sz = vargin{6};
  else
    x = u;
    y = v;
    u = vargin{3};
    v = vargin{4};
    sx = vargin{5};
    sy = vargin{6};
  end
  if nin==7, Vmag = vargin{7}; end
elseif nin==9 | nin==10     % streamline(x,y,z,u,v,w,sx,sy,sz)
  x = vargin{1};
  y = vargin{2};
  z = vargin{3};
  u = vargin{4};
  v = vargin{5};
  w = vargin{6};
  sx = vargin{7};
  sy = vargin{8};
  sz = vargin{9};
  if nin==10, Vmag = vargin{10}; end
else
  error('Wrong number of input arguments.'); 
end

sx = sx(:); 
sy = sy(:); 
sz = sz(:); 


