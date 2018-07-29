%double pendulum animation
%the equations are taken form http://www.myphysicslab.com/dbl_pendulum.html
%the differential equations are solved using Euler's method
%
m1=3; %mass of 1st bob     %red 
m2=1; %mass of 2nd bob     %yellow
l1=1; %length of 1st string
l2=2; %length of 2nd string which is connected with 1st bob
g=9.8;%acceleration due to gravity
dt=0.025;%time step
theta1=pi/1.5;%initial angle made by 1st bob
theta2=pi;    %initial angle made by 2nd bob
omega1=0.2; 
omega2=0.2;
omega1n=0.0;
omega2n=0.0;
t=0;

line([-0.5 0.5],[0 0],'linestyle',':','color','k');
h=line(0,0);
b1=line(0,0,'linestyle','none','marker','.','markersize',30,'color','r');%1st bob
b2=line(0,0,'linestyle','none','marker','.','markersize',30,'color','y');%2nd bob

al=l1+l2+2; %axis limit
axis([-al al -al al]);
axis square

while t<=50 && ishandle(h)
    
    theta1=theta1+dt*omega1; 
    theta2=theta2+dt*omega2;
    
    omega1n=omega1+dt*(-g*(2*m1 + m2)*sin(theta1)-m2*g*sin(theta1-2*theta2)-2*sin(theta1-theta2)*m2*(omega2^2*l2+omega1^2*l1*cos(theta1-theta2)))...
           /(l1*(2* m1 + m2 - m2*cos(2*theta1 - 2*theta2)));
    omega2n=omega2+dt*(2*sin(theta1-theta2)*(omega1^2*l1*(m1 + m2)+g*(m1 + m2)*cos(theta1) + omega2^2*l2*m2*cos(theta1 - theta2)))...
           /(l2*(2*m1 + m2 - m2*cos(2*theta1 - 2*theta2)));
    
    x1=l1*sin(theta1);
    y1=-l1*cos(theta1);
    x2=l1*sin(theta1)+l2*sin(theta2);
    y2=-l1*cos(theta1)-l2*cos(theta2);
    
    omega1=omega1n;
    omega2=omega2n;
    set(h,'xdata',[0 x1 x2],'ydata',[0 y1 y2]);
    set(b1,'xdata',x1,'ydata',y1);%update position of 1st bob
    set(b2,'xdata',x2,'ydata',y2);%update position of 2nd bob
    t=t+dt;
    pause(0.02)
end

