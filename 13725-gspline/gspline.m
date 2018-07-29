function h = gspline(fig)
% GSPLINE - Interactively draw interpolating spline similar to gline
%   GSPLINE(FIG) draws a spline by left - clicking the mouse at the control
%   points of the spline in the figure FIG. Right clicking will end the
%   spline.

%   H = GSPLINE(FIG) Returns the handle to the line.
%
%   GSPLINE with no input arguments draws in the current figure.


if nargin<1, 
  draw_fig = gcf;
  fig = draw_fig;
  s = 'start'; 
end

if isstr(fig), 
   s = fig;
   draw_fig = gcbf;
   ud = get(draw_fig,'UserData');
else
   s = 'start';
   draw_fig = fig; 
end

ax = get(draw_fig,'CurrentAxes');
if isempty(ax)
   ax = axes('Parent',draw_fig);
end

gcacolor = get(ax,'Color');

% Check to see if we're clicking to exit
mouse = get(draw_fig,'selectiontype');
% Normal:    Click left mouse button.
% Extend:    Shift - click left mouse button or click both left and right 
%            mouse buttons,  or click middle mouse button. 
% Alternate: Control - click left mouse button or click right mouse button.
% Open:      Double-click any mouse button.
if ~strcmp('start',s)
    switch lower(mouse(1:3))
        case 'nor'
        case 'ext'
            s = 'last';
        case 'alt'
            s = 'last';
        case 'ope'
            s = 'last';
    end
end

switch s
   case 'start'
   oldtag = get(draw_fig,'Tag');
   figure(draw_fig);
   if any(get(ax,'view')~=[0 90]), 
     set(draw_fig, 'Tag', oldtag);
     error('stats:gspline:NotTwoDimensional','gspline works only for 2-D plots.');
   end
   
   
   % Initialize spline
   xlimits = get(ax,'Xlim');
   x = (xlimits + flipud(xlimits))./2;
   ylimits = get(ax,'Ylim');
   y = (ylimits + flipud(ylimits))./2;
   hline = line(x,y,'Parent',ax,'Visible','off','eraseMode','normal');

   % Save current window functions and data
   bdown = get(draw_fig,'WindowButtonDownFcn');
   bup = get(draw_fig,'WindowButtonUpFcn');
   bmotion = get(draw_fig,'WindowButtonMotionFcn');
   oldud = get(draw_fig,'UserData');
   
   % Create new window functions
   set(draw_fig,'WindowButtonDownFcn','gspline(''first'')')
   set(draw_fig,'WindowButtonMotionFcn','gspline(''motion'')')
   set(draw_fig,'WindowButtonupFcn','')
   
   set(draw_fig,'doublebuffer','on')
 
   % Save drawing data as in 'UserData'
   ud.hline = hline;
   ud.pts = [];
   ud.buttonfcn = {bdown; bup; bmotion};
   ud.oldud = oldud;
   ud.oldtag = oldtag;
   ud.npts = 1;
   ud.xlimits = xlimits;
   ud.ylimits = ylimits;
   set(draw_fig,'UserData',ud);
   
   if nargout == 1
      h = hline;
   end

case 'motion'
   set(draw_fig,'Pointer','crosshair');

   if isempty(ud.pts);
      return;
   end

   [xspline,yspline] = splineInterp(ud.pts(:,1),ud.pts(:,2));
   
   set(ud.hline,'Xdata',xspline,'Ydata',yspline, ...
        'linestyle','-', 'linewidth', 1.5, 'Color',1-gcacolor,'Visible','on');
   Pt2 = get(ax,'CurrentPoint'); 
   Pt2 = Pt2(1,1:2);    
   ud.pts(ud.npts+1,:) = Pt2;

   set(draw_fig,'UserData',ud);

case 'first'   
   Pt1 = get(ax,'CurrentPoint'); 
   ud.pts = [Pt1(1,1:2); Pt1(1,1:2)];

   set(draw_fig,'WindowButtonDownFcn','gspline(''down'')','UserData',ud)
   
case 'down'         
   Pt1 = get(ax,'CurrentPoint'); 
   ud.pts = [ud.pts; Pt1(1,1:2)]; 
   ud.npts = ud.npts + 1;   
   [xspline,yspline] = splineInterp(ud.pts(:,1),ud.pts(:,2));
%    
%    set(ud.hline,'Xdata',xspline,'Ydata',yspline,'eraseMode','normal', ...
%         'linestyle','-', 'linewidth', 1.5, 'Color',1-gcacolor,'Visible','on');

   set(draw_fig,'WindowButtonDownFcn','gspline(''down'')','UserData',ud)
      
case 'last'
   bfcns = ud.buttonfcn;
   set(draw_fig,'windowbuttondownfcn',bfcns{1},'windowbuttonupfcn',bfcns{2}, ...
         'windowbuttonmotionfcn',bfcns{3},'Pointer','arrow', ...
		 'Tag',ud.oldtag,'UserData',ud.oldud)
   set(ud.hline,'UserData',ud.pts)

otherwise
   error('stats:gspline:BadCallBack','Invalid call-back.');
end

% Make sure the axis limits don't change
set(ax,'xlim',ud.xlimits,'ylim',ud.ylimits);



function [xout,yout] = splineInterp(x,y,BC)
% SPLINE_INTERP - Interpolate data with cardinal spline
%   SPLINE_INTERP(P,BC), where P is nx3 matrix of coordinates and BC is a
%   2x3 array containing the tangencies at the beginning and end of the
%   curve

z = zeros(size(x(:)));

P = [x(:) y(:) z(:)];

% Determine number of points
n = size(P,1);

if n <= 2
    xout = x;
    yout = y;
    return
end

% Determine number of tangencies to account for
m = n - 2;

% Our known vector Reduces to -3*(Pn - Pn+2)
Pa = P(1:m,:);
Pb = P(3:n,:);
PP = -3*(Pa - Pb); %;-[0.5*(1-t)*(1+b)*(1-c)*(Pa-Pb)];

% Create Try diagonal matrix (1,4,1)
TM = (diag(4*ones(n,1)) + diag(ones(n-1,1),1) + diag(ones(n-1,1),-1));

% Check for boundary conditions
if nargin == 2,
    % If no BC specified, impose zero curvature at endpoints
    PP = [6*(P(2,:) - P(1,:)); PP; 6*(P(n,:) - P(n-1,:))];
    TM(1,1:3) = [4 2 0];
    TM(n,n-2:n) = [0 2 4];
else
    % Use BC as tangencies at endpoints
%     BC = varargin{1};
    PP = [BC(1,:); PP; BC(2,:)];
    TM(1,1:2) = [1 0];
    TM(n,n-1:n) = [0 1];
end

% Solve for uknown tangencies 
P_dot = TM\PP; %inv(TM)*PP;     

% Set up matricies for solving
CMx = [P(1:n-1,1) P(2:n,1) P_dot(1:n-1,1) P_dot(2:n,1)];
CMy = [P(1:n-1,2) P(2:n,2) P_dot(1:n-1,2) P_dot(2:n,2)];
CMz = [P(1:n-1,3) P(2:n,3) P_dot(1:n-1,3) P_dot(2:n,3)];

% Calculate interpolated points
num_pts = 79;
res = .1;%(n-1)/(num_pts-1);                % Point frequency
j = 1;

% Sort our data points so that it makes sense for plotting
for u=0:res:1,
    for q = 1:n-1,
        M = [CMx*H(u) CMy*H(u) CMz*H(u)];
        MM(j,:,q) = M(q,:);        
    end
    j = j+1;
end
out = [];
for i=1:n-1,
    out = [out; MM(:,:,i)];
end

% Remove repeated points
out(find(diff(sqrt(sum(out.^2,2)))==0),:) = [];

xout = out(:,1);
yout = out(:,2);



% Calculate the Hermite Basis Functions
function h = H(u),
h = [(1-3*u^2) + 2*u^3; 3*u^2 - 2*u^3; u - 2*u^2 + u^3; u^3 - u^2;];
