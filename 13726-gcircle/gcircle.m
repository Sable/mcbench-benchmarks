function h = gcircle(fig)
% GCIRCLE Interactively draw a circle similar to gline
%   GCIRCLE(FIG) draws a circle by clicking the mouse at the center and at
%   some distance away in the figure FIG.
% 
%   H = GCIRCLE(FIG) Returns the handle to the line.
% 
%   GCIRCLE with no input arguments draws in the current figure.


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

switch s
   case 'start'
   oldtag = get(draw_fig,'Tag');
   figure(draw_fig);
   if any(get(ax,'view')~=[0 90]), 
     set(draw_fig, 'Tag', oldtag);
     error('stats:gcircle:NotTwoDimensional','GCIRCLE works only for 2-D plots.');
   end
   
   % Create an invisible line to preallocate the xor line color.
   xlimits = get(ax,'Xlim');
   x = (xlimits + flipud(xlimits))./2;
   ylimits = get(ax,'Ylim');
   y = (ylimits + flipud(ylimits))./2;
   hline = line(x,y,'Parent',ax,'Visible','off','eraseMode','normal');
   hcirc = line(x,y,'Parent',ax,'Visible','off','eraseMode','normal');

   bdown = get(draw_fig,'WindowButtonDownFcn');
   bup = get(draw_fig,'WindowButtonUpFcn');
   bmotion = get(draw_fig,'WindowButtonMotionFcn');
   oldud = get(draw_fig,'UserData');
   set(draw_fig,'WindowButtonDownFcn','gcircle(''down'')')
   set(draw_fig,'WindowButtonMotionFcn','gcircle(''motion'')')
   set(draw_fig,'WindowButtonupFcn','')
 
   ud.hline = hline;
   ud.hcirc = hcirc;
   ud.pts = [];
   ud.buttonfcn = {bdown; bup; bmotion};
   ud.oldud = oldud;
   ud.oldtag = oldtag;
   ud.xlimits = xlimits;
   ud.ylimits = ylimits;
   set(draw_fig,'UserData',ud);
   if nargout == 1
      h = hcirc;
   end

case 'motion'
   set(draw_fig,'Pointer','crosshair');

   if isempty(ud.pts);
      return;
   end

   set(ud.hline,'Xdata',ud.pts(:,1),'Ydata',ud.pts(:,2),'eraseMode','normal', ...
        'linestyle','-.', 'linewidth', 1, 'Color',1-gcacolor,'Visible','on');
   
   [x,y,r] = circle(ud.pts(:,1),ud.pts(:,2));
   udcirc.xc = ud.pts(1,1); 
   udcirc.yc = ud.pts(1,2);
   udcirc.r = r;
   set(ud.hcirc,'Xdata',x,'Ydata',y,'eraseMode','normal', ...
        'linestyle','-', 'linewidth', 1.5, 'Color',1-gcacolor,'Visible','on',...
        'UserData',udcirc);
   
   Pt2 = get(ax,'CurrentPoint'); 
   Pt2 = Pt2(1,1:2);    
   ud.pts(2,:) = Pt2;

   set(draw_fig,'UserData',ud);

case 'down'   
   Pt1 = get(ax,'CurrentPoint'); 
   ud.pts = [Pt1(1,1:2); Pt1(1,1:2)];
   set(ud.hline,'Xdata',ud.pts(:,1),'Ydata',ud.pts(:,2),'eraseMode','normal', ...
        'linestyle','--', 'linewidth', 1, 'Color',1-gcacolor,'Visible','on');
    
   set(ud.hcirc,'Xdata',ud.pts(:,1),'Ydata',ud.pts(:,2),'eraseMode','normal', ...
        'linestyle','-', 'linewidth', 1.5, 'Color',1-gcacolor,'Visible','on');

   set(draw_fig,'WindowButtonDownFcn','gcircle(''down2'')','UserData',ud)
   
case 'down2'
   delete(ud.hline);
   bfcns = ud.buttonfcn;
   set(draw_fig,'windowbuttondownfcn',bfcns{1},'windowbuttonupfcn',bfcns{2}, ...
         'windowbuttonmotionfcn',bfcns{3},'Pointer','arrow', ...
		 'Tag',ud.oldtag,'UserData',ud.oldud)

otherwise
   error('stats:gcircle:BadCallBack','Invalid call-back.');
end


% Make sure the axis limits don't change
set(ax,'xlim',ud.xlimits,'ylim',ud.ylimits);


function [xout,yout,r] = circle(x,y)
xc = x(1);
yc = y(1);

r = sqrt(diff(x)^2 + diff(y)^2);
npts = 1000;
res = 2*pi/(npts-1);
theta = 0:res:2*pi;

xout = r*cos(theta) + xc;
yout = r*sin(theta) + yc;
