function speedbump_sim(v,t,ym)
%Animation function for the motion of a 1 DOF auto suspension as it travels
%over a sinusoidal speed bump
%Written by T. Nordenholz, Fall 05
%To use, type speedbump_sim(v,t,x) where v is the horizontal speed (m/s) of the car,
%t is the time(sec)array, and x is the vertical (upwards) displacement (m)
%Geometrical and plotting parameters can be set within this program

%set geometric parameters
tsd=10; %slow down factor(ie animation will be tsd x slower than real time) 
w=.8;%width of speedbump
h=.1;%height of speed bump
massw=.5;%length of mass
massh=.1;%height of mass
L0=.6-massh/2;%unstretched length of spring
Wsd=.1;
x=v*t;%horizontal distance travelled by car
%generate the base profile yb 
for n=1:length(x)
    if x(n)<=0|x(n)>=w
        yb(n)=0;
    else
        yb(n)=h*sin(pi/w*x(n));
    end
end
massx=massw*[-.5,-.5,.5,.5,-.5];%data for drawing mass
massy=massh*[-.5,.5,.5,-.5,-.5];
y=ym+L0+massh/2; %vertical position of mass center

%set up figure and initialze plot/animation 
Hf=figure('Position',[1,100,1000,500]);
%ground
Hp_ground=area(x,yb);axis([x(1)-massw,x(end)+massw,0,2*L0]),grid on,xlabel('s(m)'),ylabel('y (m)')
hold on
set(Hp_ground,'FaceColor','r');
%plot of x vs t
Hl_mass=line(x(1),y(1));
set(Hl_mass,'LineWidth',2)
%mass
Hp_mass=fill(x(1)+massx,y(1)+massy,'b');
%center of mass marker
Hl_cm=line(x(1),y(1),'Marker','O','MarkerSize',6,'MarkerFaceColor','k');
titlestr=['v = ',num2str(v),' m/s'];
title(titlestr)

% spring/damper 
Hgt_springdamp=hgtransform;
Hl_Bend=line([0,0],[0,.1],'Color','k','Parent',Hgt_springdamp);
Hl_Tend=line([0,0],[.9,1],'Color','k','Parent',Hgt_springdamp);
Hl_Bbar=line(Wsd*[-1,1],[.1,.1],'Color','k','Parent',Hgt_springdamp);
Hl_Tbar=line(Wsd*[-1,1],[.9,.9],'Color','k','Parent',Hgt_springdamp);
Hl_spring=line(Wsd*[1,2,1,0,1,2,1,0,1],linspace(.1,.9,9),'Color','k','Parent',Hgt_springdamp);
Hl_dampB=line(Wsd*[-1,-1],[.1,.4],'Color','k','Parent',Hgt_springdamp);
Hl_dampBpist=line(Wsd*[-1.3,-.7],[.4,.4],'Color','k','Parent',Hgt_springdamp);
Hl_dampT=line(Wsd*[-1,-1],[.6,.9],'Color','k','Parent',Hgt_springdamp);
Hl_dampTcyl=line(Wsd*[-.5,-.5,-1.5,-1.5],[.55,.6,.6,.55],'Color','k','Parent',Hgt_springdamp);
set(Hgt_springdamp,'Matrix',[1,0,0,x(1);0,L0,0,yb(1);0,0,1,0;0,0,0,1]);

%draw all above objects and hold for 1 second
drawnow
tic,while toc<1,end
tic

% run animation
for n=1:length(t)
    L=L0+ym(n)-yb(n); %set spring length
    set(Hl_mass,'XData',x(1:n),'YData',y(1:n));
    set(Hp_mass,'XData',x(n)+massx,'YData',y(n)+massy);
    set(Hl_cm,'XData',x(n),'YData',y(n));
    set(Hgt_springdamp,'Matrix',[1,0,0,x(n);0,L,0,yb(n);0,0,1,0;0,0,0,1]);
    % time delay(run tsd x slower than real time)
    while toc<tsd*(t(n)-t(1)),end
    time(n)=toc;
    drawnow;
end



