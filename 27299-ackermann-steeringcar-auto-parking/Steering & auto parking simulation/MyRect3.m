% Author : Mohammed Khaled
% Email : Mohamad.khalid86@gmail.com
% for more info visit My Blog :http://algorithmgeek.blogspot.com/
% ___________________________________________________
% Auto parking 1

% clc,clear;
% seta= 1.1800;
% %seta=(seta/180)*pi;
% x=0;
% y=0;
% a=40;
% b=80;
% axis([-100 140 -100 140]);
function  [xa1 xb1 xb2 xa2 ya1 yb1 yb2 ya2]=MyRect3(x,y,a,b,seta)
global wl;
global ww;
global D;
global L;
global WSeta; 


xa1=x;
ya1=y;


xa2=xa1-a*cos(seta);
ya2=ya1+a*sin(seta);

xb1=x+b*sin(seta);
yb1=y+b*cos(seta);

xb2=xb1-a*cos(seta);
yb2=yb1+a*sin(seta);

patch([xa1 xb1 xb2 xa2],[ya1 yb1 yb2 ya2],[0 1 0]);

% the Right back wheel
xref=x+(D-wl/2)*sin(seta);
yref=y+(D-wl/2)*cos(seta);

xa11=xref+(ww/2)*cos(seta);
ya11=yref-(ww/2)*sin(seta);


xa21=xa11-(ww)*cos(seta);
ya21=ya11+(ww)*sin(seta);

xb11=xa11+wl*sin(seta);
yb11=ya11+wl*cos(seta);

xb21=xb11-ww*cos(seta);
yb21=yb11+ww*sin(seta);

patch([xa11 xb11 xb21 xa21],[ya11 yb11 yb21 ya21],[0 0 0]);




% the left back wheel
xref=xref-(a)*cos(seta);
yref=yref+(a)*sin(seta);

xa11=xref+(ww/2)*cos(seta);
ya11=yref-(ww/2)*sin(seta);


xa21=xa11-(ww)*cos(seta);
ya21=ya11+(ww)*sin(seta);

xb11=xa11+wl*sin(seta);
yb11=ya11+wl*cos(seta);

xb21=xb11-ww*cos(seta);
yb21=yb11+ww*sin(seta);

patch([xa11 xb11 xb21 xa21],[ya11 yb11 yb21 ya21],[0 0 0]);

% The Right front wheel

xref=x+(D+L)*sin(seta);
yref=y+(D+L)*cos(seta);

KWheel=sqrt((wl/2)^2+(ww/2)^2);


xa11=xref-KWheel*sin(seta+WSeta+atan(ww/wl));
ya11=yref-KWheel*cos(seta+WSeta+atan(ww/wl));

xa21=xa11+(ww)*cos(seta+WSeta);
ya21=ya11-(ww)*sin(seta+WSeta);

xb11=xa11+wl*sin(seta+WSeta);
yb11=ya11+wl*cos(seta+WSeta);

xb21=xb11+ww*cos(seta+WSeta);
yb21=yb11-ww*sin(seta+WSeta);

patch([xa11 xa21 xb21 xb11],[ya11 ya21 yb21 yb11],[0 0 0]);



% The left front wheel

xref=xref-(a)*cos(seta);
yref=yref+(a)*sin(seta);

KWheel=sqrt((wl/2)^2+(ww/2)^2);


xa11=xref-KWheel*sin(seta+WSeta+atan(ww/wl));
ya11=yref-KWheel*cos(seta+WSeta+atan(ww/wl));

xa21=xa11+(ww)*cos(seta+WSeta);
ya21=ya11-(ww)*sin(seta+WSeta);

xb11=xa11+wl*sin(seta+WSeta);
yb11=ya11+wl*cos(seta+WSeta);

xb21=xb11+ww*cos(seta+WSeta);
yb21=yb11-ww*sin(seta+WSeta);

patch([xa11 xa21 xb21 xb11],[ya11 ya21 yb21 yb11],[0 0 0]);



