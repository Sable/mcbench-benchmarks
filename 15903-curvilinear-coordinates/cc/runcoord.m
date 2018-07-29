function runcoord
% This program plots coordinate surfaces for various
% familiar curvilinear coordinate systems.

%       by Howard Wilson, July, 2007

while 1
  clc, close, opt=listcases;  
  switch opt
  case 1
    disp('The following figure illustrates coordinate lines')
    disp('coordinate surfaces, and tangent vectors')
    disp(' ')
    disp('Press return to see the figure'), pause
    coordfig, disp('Press return to continue')
    pause, close

  case 2
    titl='SPHERICAL COORDINATES';
    n=21; t1=expspace(0,1,n)'; t2=expspace(0,pi/2,n)';
    t3=expspace(0,pi/2,n)'; t0=[.85,pi/4,pi/4];
    t={t1,t2,t3,t0}; close
    type sphr0.m, disp(' ')
    disp('Press return to see the figure'), pause
    surfcases(@sphr0,t,titl)
    %rotate3d on
    shg, disp(' '), disp('Press return to continue')
    shg, pause, close

  case 3
    titl='CYLINDRICAL COORDINATES';
    n=21; t1=expspace(0,1,n)'; t2=expspace(0,pi/2,n)';
    t3=expspace(0,1,n)'; t0=[.8,pi/4,.75];
    t={t1,t2,t3,t0}; 
    type cylin0.m, disp(' ')
    disp('Press return to see the figure'), pause
    surfcases(@cylin0,t,titl)
    %rotate3d on
    shg, disp(' '), disp('Press return to continue')
    shg, pause, close
    
  case 4
    titl='NONORTHOGONAL CONE COORDINATES';
    n=21; t1=expspace(0,1,n)'; t2=expspace(0,pi/4,n)';
    t3=expspace(0,pi/2,n)'; t0=[.8,.8*pi/4,pi/4];
    t={t1,t2,t3,t0}; 
    type cone0.m, disp(' ')
    disp('Press return to see the figure'), pause
    surfcases(@cone0,t,titl)
    %rotate3d on
    view(62,12), disp(' '), disp('Press return to continue')
    shg, pause, close
    
  case 5
    titl='TOROIDAL COORDINATES';
    u=[.7,.8,10]; v=[0,.1*pi,pi]; w=[0,pi/4,pi/2];    
    n1=21; t1=expspace(u(1),u(3),n1,20)';
    n2=21; t2=expspace(v(1),v(3),n2,10)';
    n3=21; t3=expspace(w(1),w(3),n3)'; 
    t0=[u(2),v(2),w(2)]; t={t1,t2,t3,t0}; 
    type toroid0.m, disp(' ')
    disp('Press return to see the figure'), pause
    surfcases(@toroid0,t,titl)
    view(24,30)
    %rotate3d on
    disp(' '), disp('Press return to continue')
    shg, pause, close
    
    
  case 6
    titl='OBLATE SPHEROIDAL COORDINATES';
    u=[0 .4 .5]; v=[0,pi/4 pi/2]; w=[0,pi/4,pi/2];
    n1=21; t1=expspace(u(1),u(3),n1)';
    n2=21; t2=expspace(v(1),v(3),n2)';
    n3=21; t3=expspace(w(1),w(3),n3)'; 
    t0=[u(2),v(2),w(2)]; t={t1,t2,t3,t0}; 
    type oblate0.m, disp(' ')
    disp('Press return to see the figure'), pause
    surfcases(@oblate0,t,titl)    
    view(12,25)
    %rotate3d on
    disp(' '), disp('Press return to continue')
    shg, pause, close 
    
  case 7
    titl='ELLIPSOIDAL COORDINATES';
    b=1; c=2*b; 
    u=b*[0 .9 1]; v=[b,.9*c,c]; w=c*[1 4.5 5];
    n1=21; t1=expspace(u(1),u(3),n1,1)';
    n2=21; t2=expspace(v(1),v(3),n2,.5)';
    n3=21; t3=expspace(w(1),w(3),n3,.5)'; 
    t0=[u(2),v(2),w(2)]; t={t1,t2,t3,t0};     
    type elipsod0.m, disp(' ')
    disp('Press return to see the figure'), pause
    surfcases(@elipsod0,t,titl)
    view(48,28)
    %rotate3d on
    disp(' '), disp('Press return to continue')
    shg, pause, close
    
  case 8
    titl='ELLIPTIC CYLINDER COORDINATES';
    u=[0 .8 1]/2; v=[0 .5 1]*pi/8; w=[0 .12 .15];
    n1=21; t1=expspace(u(1),u(3),n1,1)';
    n2=21; t2=expspace(v(1),v(3),n2,.5)';
    n3=21; t3=expspace(w(1),w(3),n3,1)'; 
    t0=[u(2),v(2),w(2)]; t={t1,t2,t3,t0}; 
    type elipcyl0.m, disp(' ')
    disp('Press return to see the figure'), pause
    surfcases(@elipcyl0,t,titl)
    view(64,23)
    %rotate3d on
    disp(' '), disp('Press return to continue')
    shg, pause, close  
          
  case 9  
    titl='PARABOLIC COORDINATES';
    u=[0 .85 1]*3; v=[0 .85 1]*2; w=[0 .3  1]*pi/2;
    n1=21; t1=expspace(u(1),u(3),n1,1)';
    n2=21; t2=expspace(v(1),v(3),n2,.5)';
    n3=21; t3=expspace(w(1),w(3),n3,1)'; 
    t0=[u(2),v(2),w(2)]; t={t1,t2,t3,t0}; 
    type parab0.m, disp(' ')
    disp('Press return to see the figure'), pause
    surfcases(@parab0,t,titl)
    view(64,23)
    %rotate3d on
    disp(' '), disp('Press return to continue')
    shg, pause, close    
  case 0
    disp('All Done'), disp(' '), return
  otherwise
    disp('Invalid option'), pause(2), close      
  end %while
end

%================================================

function option=listcases
head=sprintf(... 
['\n             EXAMPLES ILLUSTRATING SURFACES                   ',...
'\n        DEFINED BY CURVILINEAR COORDINATE SYSTEMS              \n',...
'\nSelect an option:                                              \n',...
 ' 1: Sketch of Coordinate Lines and Coordinates Surfaces         \n',...
 ' 2: Spherical Coordinates            3: Cylindrical Coordinates \n',...
 ' 4: Non-Orthogonal Cone Coordinates  5: Toroidal Coordinates    \n',...
 ' 6: Oblate Spheroidal Coordinates    7: Ellipsoidal Coordinates \n',...
 ' 8: Elliptic Cylinder Coordinates    9: Parabolic Coordinates   \n',...
 ' 0: Stop \n']);
 disp(head), option=input(' > ? '); disp(' ')

%================================================

function surfcases(func,t,titl)
% surfcases(func,t,titl)
t1=t{1}; t2=t{2}; t3=t{3}; t0=t{4};
[x1,y1,z1]=pcsurf(func,t0(1),t2,t3);
[x2,y2,z2]=pcsurf(func,t1,t0(2),t3);
[x3,y3,z3]=pcsurf(func,t1,t2,t0(3));
%surf(x1,y1,z1,'facecolor',[1,0,0]); hold on  % red
surf(x1,y1,z1,'facecolor',[1,0.5,0]); hold on % orange
surf(x2,y2,z2,'facecolor',[127/255 1 212/255]);
surf(x3,y3,z3,'facecolor',[1 1 0]);
xlabel('x axis'), ylabel('y axis')
zlabel('z axis'), title(titl)
grid on, axis equal
view(47,43), shg, hold off

%================================================

function [x,y,z]=pcsurf(func,t1,t2,t3)
% [x,y,z]=pcsurf(func,t1,t2,t3)
% This function computes points on a coordinate
% system surface when one coordinate is held
% constant and the other two vary.
[n,k]=sort([length(t1),length(t2),length(t3)]);
if k(1)==1
  [t2,t3]=meshgrid(t2,t3); t1=t1*ones(size(t2)); 
elseif k(1)==2
  [t1,t3]=meshgrid(t1,t3); t2=t2.*ones(size(t1));
else % k(1)==3
  [t1,t2]=meshgrid(t1,t2); t3=t3.*ones(size(t1));
end
[x,y,z]=feval(func,t1,t2,t3);

%================================================

function x=expspace(xi,xf,n,ratio)
% x=expspace(xi,xf,n,ratio)
% This function determines a set of points
% between xi and xf so that the point
% spacing varies from one end to the
% other. The points vary exponentially
% in the form x(j)=c2+c1*h^j
% xi, xf - initial and final points
% n      - number of points computed
% ratio  - (x(n)-x(n-1))/(x(2)-x(1))
if nargin<4, ratio=1; end
if ratio==1 
  x=linspace(xi,xf,n);
else
  h=ratio^(1/(n-2)); c1=(xf-xi)/(h^n-h);
  c2=xi-c1*h; x=c2+c1*h.^(1:n);
end

%================================================

function coordfig
% function coordfig plots a generic curvilinear
% coordinate system and labels the coordinate
% lines, the coordinate surfaces, and the
% covariant base vectors.

% data defining the coordinate lines
[clab,g,glab,m,p,pataro,patlab,xy]=corpltdat;

% Coordinate line data
x1=xy(:,1); y1=xy(:,4); x2=xy(:,2); y2=xy(:,5);
x3=xy(:,3); y3=xy(:,6);

% Base vector labels
gl1='g_1'; gl2='g_2'; gl3='g_3';

% Coordinate line labels
cl1='\theta_1 line'; cl2='\theta_2 line';
cl3='\theta_3 line';

% Coordinate surface labels
al1='\theta_1 surf'; al2='\theta_2 surf';
al3='\theta_3 surf';  close

% Plot the coordinate lines
plot(x1,y1,'k',x2,y2,'k',x3,y3,'k',...
     [x1(m),x2(m),x3(m),x1(m)],...
     [y1(m),y2(m),y3(m),y1(m)],'k')
hold on

% Arrows pointing to surface area patches
pa=pataro; pa1=pa(:,1); pa2=pa(:,2); pa3=pa(:,3);

% Base vector arrows
g1=g(:,1); g2=g(:,2); g3=g(:,3);

% Coordinate area patches
p1=p(:,1); p2=p(:,2); p3=p(:,3);
plot(p1,'k'), plot(p2,'k'), plot(p3,'k')
plot(g1,'k'), plot(g2,'k'), plot(g3,'k')
plot(pa1,'k'), plot(pa2,'k'), plot(pa3,'k') 

d=.1+.2*i; dx=real(d); dy=imag(d);

% Label base vectors
u=real(g1(end)+d); v=imag(g1(end)+d); text(u,v,gl1),
u=real(g2(end)+d); v=imag(g2(end)+d); text(u,v,gl2),
u=real(g3(end)+d); v=imag(g3(end)+d); text(u,v,gl3),
 
% Label coordinate lines
u=x1(end)+dx; v=y1(end)+d; text(u,v,cl1)
u=x2(end)+dx; v=y2(end)+d; text(u,v,cl2)
u=x3(end)+dx; v=y3(end)+d; text(u,v,cl3)  

% Label patch areas
u=real(pa1(1))+dx; v=imag(pa1(1))+dy; text(u,v,al1),
u=real(pa2(1))+dx; v=imag(pa2(1))-dy; text(u,v,al2),
u=real(pa3(1))+dx; v=imag(pa3(1))+dy; text(u,v,al3),

title('CURVILINEAR COORDINATE SYSTEM')
axis([-1 11 1 10]), axis off
set(gcf,'color','white'),
shg

%================================================

function [x1,y1,x2,y2,x3,y3,m]=pltcrvcor
% [x1,y1,x2,y2,x3,y3,m]=pltcrvcor
xy =[...
 0.2456   0.2456   0.2456   2.3600   2.3600   2.3600
 3.0526   2.4678   1.2982   3.5877   4.5819   4.6404
 5.3626   4.5439   2.6725   4.2310   5.8977   6.5409
 7.5848   7.0877   4.6608   4.6696   7.0673   8.1784
 9.1637   8.9298   6.2398   4.7865   7.4766   8.8801];
xd1=xy(:,1); yd1=xy(:,4); xd2=xy(:,2); yd2=xy(:,5);
xd3=xy(:,3); yd3=xy(:,6); n=20;
% close, hold on
[x1,y1]=carc(xd1([1,3,5]),yd1([1,3,5]),n);
[x2,y2]=carc(xd2([1,3,5]),yd2([1,3,5]),n);
[x3,y3]=carc(xd3([1,3,5]),yd3([1,3,5]),n);
d=ishold; hold on, m=18;
plot(x1,y1,'k',x2,y2,'k',x3,y3,'k')
plot([x1(m),x2(m),x3(m),x1(m)],...
    [y1(m),y2(m),y3(m),y1(m)],'k')
axis([-1,10,1,10])
axis equal
shg 
if d==1, return, end
hold off

%================================================

function [x,y,x0,y0,r]=carc(xd,yd,n)
% [x,y,x0,y0,r]=carc(xd,yd,n)
% This function determines a series of points
% on a circular arc through three given points
% xd,yd   - vectors giving coordinates of the
%           three points which define the arc
% n       - number of output points required.
%           If n is input as negative, then 
%           the arc is also plotted.
% x,y     - vectors of coordinates on the arc
% x0,y0,r - center coordinates and radius of
%           the circular arc
xd=xd(:); yd=yd(:); if nargin<3, n=20; end
u=-[xd,yd,ones(3,1)]\(xd.^2+yd.^2);
x0=-u(1)/2; y0=-u(2)/2; z0=x0+i*y0;
r=sqrt(-u(3)+(u(1)^2+u(2)^2)/4); 
v=xd+i*yd-z0; t=angle(v);
if t(1)>0 & t(3)<0, t(3)=t(3)+2*pi;
elseif t(1)<0 & t(3)>0, t(3)=t(3)-2*pi; end 
ang=linspace(t(1),t(3),abs(n))';
z=z0+r*exp(i*ang); x=real(z); y=imag(z);
if n>0, return, end
hold on
plot(x,y,'k'), axis equal
shg, hold off

%================================================

 function [clab,g,glab,m,p,pataro,patlab,xy]=corpltdat
 % [clab,g,glab,m,p,pataro,patlab,xy]=corpltdat
clab={'\theta_1 line', '\theta_2 line', '\theta_3 line'};
g=[0.2704 + 2.3553i   0.2704 + 2.3553i   0.2704 + 2.3553i
   2.7704 + 3.6711i   1.9283 + 4.3553i   0.9020 + 4.8289i
   2.2046 + 3.5329i   1.4968 + 4.0382i   0.6520 + 4.3658i
   2.3954 + 3.4737i   1.6796 + 4.0553i   0.8073 + 4.4579i
   2.3362 + 3.2829i   1.6968 + 3.8724i   0.8994 + 4.3026i
   2.7704 + 3.6711i   1.9283 + 4.3553i   0.9020 + 4.8289i];
glab={'g_1', 'g_2', 'g_3'}; m=18;
p=[7.1125 + 7.4079i   7.2441 + 5.5921i   7.8494 + 5.8816i
   6.6652 + 7.6447i   6.9283 + 6.0132i   7.7178 + 6.4868i
   6.5073 + 7.5395i   6.7441 + 5.8816i   7.4810 + 6.3816i
   6.9546 + 7.3026i   7.0599 + 5.4605i   7.6125 + 5.7763i
   7.1125 + 7.4079i   7.2441 + 5.5921i   7.8494 + 5.8816i];
pataro=[...
   7.1389 + 8.3026i   6.6915 + 4.1711i   8.4283 + 6.5658i
   6.9020 + 7.5658i   6.9020 + 5.6184i   7.7968 + 6.1447i
   6.9862 + 7.7013i   6.7875 + 5.3395i   7.9441 + 6.1974i
   6.9375 + 7.6763i   6.8704 + 5.4013i   7.8915 + 6.2079i
   6.9125 + 7.7250i   6.9323 + 5.3184i   7.9020 + 6.2605i
   6.9020 + 7.5658i   6.9020 + 5.6184i   7.7968 + 6.1447i];
patlab={'theta_1 surf', 'theta_2 surf', '\theta_3 surf'};
xy=[0.2456    0.2456    0.2456    2.3600    2.3600    2.3600
    0.6845    0.5996    0.3900    2.5776    2.7691    2.8212
    1.1280    0.9682    0.5567    2.7856    3.1652    3.2748
    1.5759    1.3508    0.7455    2.9841    3.5477    3.7197
    2.0279    1.7470    0.9557    3.1728    3.9161    4.1549
    2.4840    2.1562    1.1869    3.3516    4.2700    4.5793
    2.9438    2.5780    1.4387    3.5206    4.6089    4.9918
    3.4071    3.0117    1.7102    3.6796    4.9323    5.3916
    3.8738    3.4568    2.0010    3.8285    5.2398    5.7776
    4.3436    3.9127    2.3103    3.9673    5.5311    6.1490
    4.8163    4.3788    2.6374    4.0959    5.8058    6.5048
    5.2916    4.8545    2.9815    4.2143    6.0634    6.8441
    5.7694    5.3393    3.3418    4.3223    6.3037    7.1663
    6.2495    5.8324    3.7173    4.4200    6.5263    7.4704
    6.7315    6.3332    4.1073    4.5073    6.7310    7.7559
    7.2153    6.8410    4.5108    4.5842    6.9174    8.0219
    7.7006    7.3553    4.9268    4.6505    7.0854    8.2679
    8.1873    7.8753    5.3543    4.7064    7.2347    8.4933
    8.6751    8.4004    5.7923    4.7517    7.3652    8.6975
    9.1637    8.9298    6.2398    4.7865    7.4766    8.8801];