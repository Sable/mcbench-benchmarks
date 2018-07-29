function epitrochoid(r1,r2,len)
%animation of EPITROCHOID
%epitrochoid(r1,r2,len);
%r1=radius of fixed circle on which smaller circle rolls
%r2=radius of rolling circle  
%len=line connected to centre of rolling circle
%example: epitrochoid(1,0.25,0.5);
%         epitrochoid(1,0.25,1);
%this code also trace epicycloid
%when r2=len then it becomes epicycloid
%example for epicycloid: epitrochoid(1,0.25,0.25); 
%always keep r1>r2
if nargin==0
    r1=1;          %radius of fixed circle on which smaller circle rolls
    r2=0.25;        %radius of rolling circle  
    len=0.5;       %line connected to centre of rolling circle    
end
n=0;            
dtheta=pi/20;  %increase in angle per iteration 
roughx=[];     %variable to trace trochoid 
roughy=[];     %variable to trace trochoid 
upto=2*pi*r1/r2+dtheta; %rotate upto
t=linspace(0,2*pi,75);

[x,y]=pol2cart(t,r2);
h1=patch(x,y,'r');%draw rolling circle


[phil,rl]=cart2pol([-len 0],[0 0]);
h2=line(0,0);%draw line connected to centre of rolling circle

[x_fix,y_fix]=pol2cart(t,r1);
line(x_fix,y_fix);%draw fixed circle,only once because it is fixed

axis equal
axis(r1*[-2 2 -2 2]) %fix axis

while n<upto && ishandle(h1)
     [xl,yl]=pol2cart(phil-n,rl); %rotate line
     [x2,y2]=transform2d(xl,yl,0,-(r1+r2),-n*r2/r1,0,r1+r2);
     set(h2,'xdata',x2,'ydata',y2);%draw line

     [x,y]=pol2cart(t,r2); %rotate circle
     [x3,y3]=transform2d(x,y,0,-(r1+r2),-n*r2/r1,0,r1+r2);
     set(h1,'xdata',x3,'ydata',y3);%draw rolling circle

     line([roughx x2(1)],[roughy y2(1)]);%trace trochoid
     roughx=x2(1);
     roughy=y2(1);

     pause(0.025)
     n=n+dtheta;
end
 %function end