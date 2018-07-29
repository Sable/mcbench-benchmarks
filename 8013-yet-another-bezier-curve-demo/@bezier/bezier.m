function b=bezier(varargin)
% construction of a Bezier curve
% Usage:
% 	b=bezier('coeffs',[ax,bx,cx,x0,ay,by,cy,y0]);
% 	b=bezier('points',[x0,y0,x1,y1,x2,y2,x3,y3]);
% 	b=bezier('xpoints',[x0,y0,x1,y1,x2,y2,x3,y3]);
% 	b=bezier(b1);

b = struct('ax',0,'bx',0,'cx',0,'ay',0,'by',0,'cy',0,...
  	   'x0',0,'y0',0,'x1',0,'y1',0,'x2',0,'y2',0,'x3',0,'y3',0);
b = class(b,'bezier');

f={'ax','bx','cx','ay','by','cy','x0','y0','x1','y1','x2','y2','x3','y3'};

if (nargin~=2 & nargin~=0 & nargin~=1)
	error('Can take only zero, one or two parameters');
end

if nargin==0
 return;
end

if nargin==1
  a=varargin{1};
  if isa(a,'bezier')
   b.x0=a.x0;
   b.x1=a.x1;
   b.x2=a.x2;
   b.x3=a.x3;
   b.y0=a.y0;
   b.y1=a.y1;
   b.y2=a.y2;
   b.y3=a.y3;
   b.ax=a.ax;
   b.bx=a.bx;
   b.cx=a.cx;
   b.ay=a.ay;
   b.by=a.by;
   b.cy=a.cy;
   return;
  else
    error('Possible usage is b=bezier(b1)');
  end
end


if nargin==2
  t=varargin{1};
  v=varargin{2};
  if strcmpi(t,'xpoints')
    if length(v)~=8
     error('The second parameter should consist of 8 elements');
    end
    % convert  physical points to coeffs
    v=num2cell(v(:)');
    [x0,y0,x1,y1,x2,y2,x3,y3]=deal(v{:});
    
    cx = 9*x1-11/2*x0+x3-9/2*x2;
    bx = -45/2*x1+9*x0-9/2*x3+18*x2;
    ax = 9/2*x3+27/2*x1-9/2*x0-27/2*x2;
    
    cy = 9*y1-11/2*y0+y3-9/2*y2;
    by = -45/2*y1+9*y0-9/2*y3+18*y2;
    ay = 9/2*y3+27/2*y1-9/2*y0-27/2*y2;

    [b.x0,b.ax,b.bx,b.cx,b.y0,b.ay,b.by,b.cy]=deal(x0,ax,bx,cx,y0,ay,by,cy);
    b=recalculate_points(b);
    return;
  end

  if strcmpi(t,'coeffs')
   if length(v)~=8
    error('The second parameter should consist of 8 elements');
   end
   b.ax=v(1);
   b.bx=v(2);
   b.cx=v(3);
   b.x0=v(4);
   b.ay=v(5);
   b.by=v(6);
   b.cy=v(7);
   b.y0=v(8);
   % recalculate points
   b=recalculate_points(b);
  return;
  end
  if strcmpi(t,'points')
   if length(v)~=8
    error('The second parameter should consist of 8 elements');
   end
   b.x0=v(1);
   b.x1=v(2);
   b.x2=v(3);
   b.x3=v(4);
   b.y0=v(5);
   b.y1=v(6);
   b.y2=v(7);
   b.y3=v(8);
  % recalculate coeffs
   b=recalculate_coeffs(b);
   return;
  end
  error('The first argument should be either ''coeffs'' or ''points''.');
end
