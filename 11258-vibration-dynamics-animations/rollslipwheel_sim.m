function rollslipwheel_sim(t,x,theta)
%Animation function for a wheel rolling/slipping
%down an incline
%written by T Nordenholz, January 2006
%To use, type rollslipwheel(t,x,theta), where t is the time array (sec), x
%is the distance (m) array traveled by the center of mass down the incline, 
%and theta is the counterclockwise angular position (rad) array of the wheel 
%Geometrical and plotting parameters can be set within this program


%set geometric parameters
R=.1; %radius (m)
d=2*pi*R; %length (m) traveled by the wheel cm during simulation
beta=30*pi/180; %incline angle (rad)
Q=linspace(0,2*pi,100);%angle parameter for generating the wheel

%set aspect ratio for equal vertical & horizontal scaling
SS=get(0,'ScreenSize');
AR=SS(4)/SS(3);%screen aspect ratio W/L

%create figure and initialize animation
Hf=figure('Units','normalized','Position',[.1,.1,.8,.8]);
%incline
Hp_ground=area([-d*cos(beta)-2*R,2*R],[-d*sin(beta)-R*cos(beta)-(2*R+R*sin(beta))*tan(beta),-R*cos(beta)+(2*R-R*sin(beta))*tan(beta)],AR*(-d*cos(beta)-2*R));
axis([-d*cos(beta)-2*R,2*R,AR*(-d*cos(beta)-2*R),AR*2*R]),grid on
set(Hp_ground,'FaceColor','r');
hold on

%wheel and spoke
Hgt_wheel=hgtransform;
Hp_wheel=patch(R*cos(Q),R*sin(Q),'b','Parent',Hgt_wheel);
Hl_spoke=line([0,R*cos(beta)],[0,R*sin(beta)],'Color','k','Linewidth',2,'EraseMode','xor','Parent',Hgt_wheel);

%labels
Hl_label=line([-d*cos(beta)+2*R*sin(beta),2*R*sin(beta)],[-d*sin(beta)-2*R*cos(beta),-2*R*cos(beta)],'Color','k','Linewidth',2)
text(-d/2*cos(beta)+2.5*R*sin(beta),-d/2*sin(beta)-2.5*R*cos(beta),'2\piR','Rotation',beta*180/pi,'FontWeight','bold','Fontsize',12);

%plot and hold for 1 sec
drawnow
tic;while toc<1,end;
tic

%run animation
for n=1:length(t)
    set(Hgt_wheel,'Matrix',[cos(theta(n)),-sin(theta(n)),0,-x(n)*cos(beta);sin(theta(n)),cos(theta(n)),0,-x(n)*sin(beta);0,0,1,0;0,0,0,1]);
    while toc<2*t(n);end
    drawnow
end
    
    
       

