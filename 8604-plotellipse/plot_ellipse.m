function handle=plot_ellipse(major,minor,inc,phase,pos,options,type)
%PLOT_ELLIPSE   Draw ellipse using major, minor, inc and phase
%
%   Syntax:
%      HANDLE=PLOT_ELLIPSE(MAJOR,MINOR,INC,PHASE,POS,OPTYONS,TYPE)
%
%   Inputs:
%      MAJOR     Semi-major axis
%      MINOR     Semi-minor axis
%      INC       Inclination
%      PHASE     Phase
%      POS       Center of ellipse [ <x y> <x y z> {<0 0>} ]
%      OPTIONS   Plot line options [ 'b' ]
%      TYPE      Way phase is shown [ {1} 2 3 ]
%
%   Output:
%      HANDLES   handle for plotted line (also for a point if type is 3)
%
%   Comment:
%      If position has three elements (x, y and z), ellipse will be
%      plotted in the plane zz=z.
%
%   Example:
%      figure
%      plot_ellipse(2,1,45,20,[1 -1],'r'), axis equal
%
%   MMA 2-2003, martinho@fis.ua.pt

%   Department of physics
%   University of Aveiro

if nargin < 7
  type=1;
end
if nargin < 6
  options='b';
end
if nargin < 5
  pos=[0 0];
end

if major < minor
  warning('major axis cant be less than minor...')
end

% ellipse:
t=linspace(0,2*pi,100);
x=major*cos(t-phase*pi/180);
y=minor*sin(t-phase*pi/180);
[th,r]=cart2pol(x,y);
[x,y]=pol2cart(th+inc*pi/180,r);

% arrow:
if type == 1 | type == 2
  a=major/10;
end
if type == 3
  a=major/20; % length
end
Fi=30;      % angle.
teta=atan2(y(end)-y(end-1),x(end)-x(end-1))*180/pi;
fi=(180-Fi+teta)*pi/180;
fii=(180+Fi+teta)*pi/180;

if type == 3
  aux=3; % extra arrow point
  teta_aux=atan2(y(aux)-y(aux-1),x(aux)-x(aux-1))*180/pi;
  fi_aux=(180-Fi+teta_aux)*pi/180;
  fii_aux=(180+Fi+teta_aux)*pi/180;

  aux2=6; % extra arrow point
  teta_aux2=atan2(y(aux2)-y(aux2-1),x(aux2)-x(aux2-1))*180/pi;
  fi_aux2=(180-Fi+teta_aux2)*pi/180;
  fii_aux2=(180+Fi+teta_aux2)*pi/180;
end

Fi=Fi*pi/180;

P1=[x(1) y(1)];
P2=[P1(1)+a*cos(fi)/cos(Fi)  P1(2)+a*sin(fi)/cos(Fi)  P1(end)];
P3=[P1(1)+a*cos(fii)/cos(Fi) P1(2)+a*sin(fii)/cos(Fi) P1(end)];

if type == 3
  P1_aux=[x(aux) y(aux)];
  P2_aux=[P1_aux(1)+a*cos(fi_aux)/cos(Fi)  P1_aux(2)+a*sin(fi_aux)/cos(Fi)  P1(end)];
  P3_aux=[P1_aux(1)+a*cos(fii_aux)/cos(Fi) P1_aux(2)+a*sin(fii_aux)/cos(Fi) P1(end)];

  P1_aux2=[x(aux2) y(aux2)];
  P2_aux2=[P1_aux2(1)+a*cos(fi_aux2)/cos(Fi)  P1_aux2(2)+a*sin(fi_aux2)/cos(Fi)  P1(end)];
  P3_aux2=[P1_aux2(1)+a*cos(fii_aux2)/cos(Fi) P1_aux2(2)+a*sin(fii_aux2)/cos(Fi) P1(end)];
end


if type == 1
  x=pos(1)+[0 x NaN P2(1) P1(1) P3(1)];
  y=pos(2)+[0 y NaN P2(2) P1(2) P3(2)];
elseif type == 2
   x=pos(1)+[x NaN P2(1) P1(1) P3(1)];
   y=pos(2)+[y NaN P2(2) P1(2) P3(2)];
elseif type == 3
  x=pos(1)+x;
  y=pos(2)+y;

  x1=x(1);
  y1=y(1);

  x_aux=pos(1)+[P2_aux(1) P1_aux(1) P3_aux(1)];
  y_aux=pos(2)+[P2_aux(2) P1_aux(2) P3_aux(2)];

  x_aux2=pos(1)+[P2_aux2(1) P1_aux2(1) P3_aux2(1)];
  y_aux2=pos(2)+[P2_aux2(2) P1_aux2(2) P3_aux2(2)];

  x=[x NaN x_aux nan x_aux2];
  y=[y NaN y_aux nan y_aux2];
end

h=ishold;
if length(pos) == 2
  if type == 3
    handle.line=plot(x,y,options);
    hold on
    handle.poin1=plot(x1,y1,'k.')
  else
    handle=plot(x,y,options);
  end
elseif length(pos) == 3
  if type == 3
    handle.line=plot3(x,y,pos(3)*ones(size(x)),options)
    hold on
    handle.poin1=plot3(x1,y1,pos(3),'k.')
  else
    handle=plot3(x,y,pos(3)*ones(size(x)),options)
  end
else
  warning('wrong pos dimensions...')
end

if h~=1
   hold off
end
