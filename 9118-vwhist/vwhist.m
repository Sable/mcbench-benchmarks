function handle = vwhist(x,y,dx,dy,direction,FaceColor,EdgeColor)
%VWHIST   Variable width histogram
%   Draws a variable width histogram.
%   Does not calculate data, it is just a drawing utility.
%   Draws histogram with defined x, so data length(data)=length(x)-1,
%   or, if lengths are equal, bars are centred at x.
%
%   Syntax:
%      HANDLES = VWHIST(X,Y,DX,DY,DIREC,FaceColor,EdgeColor)
%
%   Inputs:
%      X           X locations
%      Y           Data
%      DX, DY      Offset added to bars [ 0 ]
%      DIREC       Direction, horizontal or vertical [ {0} | 1 ]
%      FaceColor   Bars FaceColor [ 'y' ]
%      EdgeColor   Bars EdgeColor [ 'r' ]
%
%   Output:
%      HANDLES   Handles to fill objects (bars)
%
%   Example:
%      x= [1.5 3 4 6 7 7.5];
%      y =[  3  7  2  0 3  ];
%      figure,
%
%      subplot(2,2,1)
%      handle = vwhist(x,y);
%      axis([0 10 0 10]);
%
%      subplot(2,2,2)
%      handle = vwhist(x,y,0,2,1); set(handle,'facecolor','g');
%      axis([0 10 0 10]);
%
%      y = [4 y];
%      subplot(2,2,3)
%      handle = vwhist(x,y,0,2); set(handle,'facecolor','w')
%      axis([0 10 0 10]);
%
%
%   MMA 8-10-2004, martinho@fis.ua.pt

%   Department of physics
%   University of Aveiro, Portugal

handle=[];

if nargin < 7
  EdgeColor = 'r';
end
if nargin < 6
  FaceColor = 'y';
end
if nargin < 5
  direction = 0;
end
if nargin < 4
  dy = 0;
end
if nargin < 3
  dx = 0;
end
if nargin < 2
  y = x;
  x=1:length(y);
end
if nargin < 1
  disp('# nothing to do...');
end

% check lengths:
nx = length(x);
ny = length(y);

if nx == ny
  x_ = (x(2:end)+x(1:end-1))/2;
  dx1 = x_(1) - x(1);
  dxe = x(end) - x_(end);
  x = [x(1)-dx1 x_ x(end)+dxe];
elseif nx ~= ny+1
  disp('# wrong lengths of x and y, nx=ny or nx=ny+1, only')
end

for i=1:length(x)-1
  xx = [x(i) x(i+1) x(i+1) x(i) x(i) ] + dx;
  yy = [0    0      y(i)   y(i) 0    ] + dy;

  if ~direction
    handle(i) = fill(xx,yy,FaceColor);
  else
    handle(i) = fill(yy,xx,FaceColor);
  end
  set(handle(i),'EdgeColor',EdgeColor);
  if i==1
    h = ishold;
    hold on
  end
end

if ~h
  hold off
end
