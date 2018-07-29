%cycloid
len=0.75; %length of line connected to centre of rolling circle
r=0.5;    %radius of rolling circle
          %if len=r then it becomes cycloid
n=0;
roughx=[];
roughy=[];
dtheta=pi/20;
t=linspace(0,2*pi,50);

[x,y]=pol2cart(t,r);
h1=patch(x,y,'r');%draw the circle

xl=[-len 0];yl=[0 0];%coordinates of line
h2=line(0,0);%draw line connected to centre of rolling circle

axis equal
axis([0 5*pi -1 1.5+(r+len)]);
set(gca,'position',[0.01 0.01 0.98 0.98])
set(gcf,'position',[10 40 1200 500])

line([-2 17],[0 0])%base line

upto=2*5*pi+dtheta;
while n<upto && ishandle(h2)
     set(h1,'xdata',x+n*r,'ydata',y-min(y));%move circle forward by
     
     [x3,y3]=transform2d(xl,yl,n*r,r,-n,0,0);%rotate and translate line
     set(h2,'xdata',x3,'ydata',y3);
     line([roughx x3(1)],[roughy y3(1)])
     roughx=x3(1);
     roughy=y3(1);
     pause(0.025)
     n=n+dtheta;
end