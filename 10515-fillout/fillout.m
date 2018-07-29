function h=fillout(x,y,lims,varargin)
%FILLOUT   Fill outside a 2-D polygon
%   While Matlab FILL, fills inside a polygon, FILLOUT fills outside
%   a boundary. The boundary can be a continuous line, defined by the
%   vectors X,Y  or a region defined by the 2-D arrays X,Y.
%
%   Syntax:
%      H = FILLOUT(X,Y,LIM,VARARGIN)
%
%   Inputs:
%      X, Y   Boundary vectors (continuous) or 2-D arrays.
%      LIM    Outer limite box, like AXIS, ie, [minX maxX minY maxY],
%             by default the limits of the data is used
%      VARARGIN:
%         Any options of the FILL command. By default the fill color
%         (FaceColor) is green and the EdgeColor is none
%      
%
%   Output:
%      H   Handle of the filled surface 
%
%   Examples:
%      % 1. Using 2-D arrays:
%      x=1:10;
%      y=[1:5]'*x.^2;
%      x=repmat(x,5,1); nans = repmat(nan,size(x));
%      figure
%      subplot(2,1,1)
%      fillout(x,y,[-1 11 -100 600],'b'); hold on, pcolor(x,y,nans)
% 
%      % 2. Using vectors:
%      load <some_boundary> % with the variable x and y
%      subplot(2,1,2)
%      fillout(x,y); hold on, plot(x,y)
%
%   MMA 23-3-2006, mma@odyle.net


h=[];

if nargin <2
  disp(['## ',mfilename,' : more input arguments required']);
  return
end
 
if prod(size(x)) > length(x)
  x=var_border(x);
end
if prod(size(y)) > length(y)
  y=var_border(y);
end

if length(x) ~= length(y)
  disp(['## ',mfilename,' : x and y must have the same size']);
  return  
end

if nargin<4
  varargin={'g'};  
end
if nargin<3
  lims=[min(x) max(x) min(y) max(y)];
else
  if lims(1) > min(x), lims(1)=min(x); end
  if lims(2) < max(x), lims(2)=max(x); end
  if lims(3) > min(y), lims(3)=min(y); end
  if lims(4) < max(y), lims(4)=max(y); end 
end

xi=lims(1); xe=lims(2);
yi=lims(3); ye=lims(4);

i=find(x==min(x)); i=i(1);

x=x(:);
y=y(:);
x=[x(i:end)' x(1:i-1)' x(i)];
y=[y(i:end)' y(1:i-1)' y(i)];

x=[xi   xi xe xe xi xi   x(1) x];
y=[y(1) ye ye yi yi y(1) y(1) y];

h=fill(x,y,varargin{:});
set(h,'edgecolor','none');

function [x,xc] = var_border(M)
%VAR_BORDER   Get border of 2D array
%
%   Syntax:
%      [X,XC] = VAR_BORDER(M)
%
%   Input:
%      M   2D array
%
%   Output:
%      X    Border
%      XC   Values at the 4 corners
%
%   Example:
%      x = 1:10;
%      y = 1:10;
%      [x,y] = meshgrid(x,y);
%      [xx,xxc] = var_border(x);
%      [yy,yyc] = var_border(y);
%      M = rand(10,10);
%      [m,mc] = var_border(M);
%      figure
%      plot(xx,yy); hold on
%      plot3(xx,yy,m,'r')
%      view([-30 60])
%      plot3(xxc,yyc,mc,'bo')
%      axis([-1 11 -1 11 -1 2])
%
%   MMA 18-8-2004, martinho@fis.ua.pt
%
%   See also PLOT_BORDER3D, ROMS_BORDER

%   Department of Physics
%   University of Aveiro, Portugal

x  = [];
xc = [];

if nargin == 0
  disp('» no variable')
  return
end


xl = M(:,1);
xt = M(end,:);  xt = xt';
xr = M(:,end);  xr = flipud(xr);
xb = M(1,:);    xb = flipud(xb');

x =  [xl; xt; xr; xb];

% corners:
xc =  [xl(1) xl(end) xr(1) xr(end)];
