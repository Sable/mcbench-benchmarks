%spring2mass 
%double spring and mass system
%equations taken from http://www.myphysicslab.com/dbl_spring1.html
%equations are solver using Eulers method
%constants
m1=0.5; %mass of 1st block
m2=1;   %mass of 2nd block
w1=1;   %width of 1st block
w2=1;   %width of 2nd block
k1=2.0; %spring constant of 2nd spring
k2=5.5; %spring constant of 1st spring
r1=3;   %length of 1st spring in rest
r2=2;   %length of 2nd spring in rest
%variables
t=0;
dt=0.05; %time step
v1=0;    
v2=0;
x1=2;   %initial position of 1st block
x2=4;   %initial position of 2nd block

posx=[0.5 -0.5 -0.5 0.5];
posy=[0.5 0.5 -0.5 -0.5];
h1=line(0,0);

line([-5 10],[-0.5 -0.5],'color','k');%base line
line([0 0],[-0.5 5],'linestyle',':'); %a wall on left 
block1=patch(posx,posy,'y');
block2=patch(posx,posy,'r');

axis equal
axis([-1 10 -3 3]);
while t<=50 && ishandle(h1)
   x1=x1+dt*v1; 
   x2=x2+dt*v2;  
   v1 =v1+dt*( -(k1/m1)* (x1 - r1) + (k2/m1)*(x2 - x1 - w1 - r2));
   v2 =v2+dt*( -(k2/m2)* (x2 - x1 - w1 - r2) ); 
   
   set(h1,'xdata',[0 x1 x2],'ydata',[0 0 0]);
   set(block1,'xdata',posx+x1,'ydata',posy);
   set(block2,'xdata',posx+x2,'ydata',posy);
   t=t+dt;
   pause(0.025);
end