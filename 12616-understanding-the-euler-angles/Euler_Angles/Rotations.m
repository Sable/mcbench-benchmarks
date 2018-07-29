cla
clear all
delete Trans.mat Maxes.mat
clc

psi=20;
theta=35;
phi=40;

R=60;
% figure(1)

hold on


[CoAxes0(1) CoAxes0(2) CoAxes0(3)]=arrow3d( [0 0 0]',1.2,R-5,5,'x');
[CoAxes0(4) CoAxes0(5) CoAxes0(6)]=arrow3d( [0 0 0]',1.2,R-5,5,'y');
[CoAxes0(7) CoAxes0(8) CoAxes0(9)]=arrow3d( [0 0 0]',1.2,R-5,5,'z');


[CoAxes1(1) CoAxes1(2) CoAxes1(3)]=arrow3d( [0 0 0]',1.2,R-5,5,'x');
[CoAxes1(4) CoAxes1(5) CoAxes1(6)]=arrow3d( [0 0 0]',1.2,R-5,5,'y');
[CoAxes1(7) CoAxes1(8) CoAxes1(9)]=arrow3d( [0 0 0]',1.2,R-5,5,'z');
set(CoAxes1,'Visible','off')

[CoAxes2(1) CoAxes2(2) CoAxes2(3)]=arrow3d( [0 0 0]',1.2,R-5,5,'x');
[CoAxes2(4) CoAxes2(5) CoAxes2(6)]=arrow3d( [0 0 0]',1.2,R-5,5,'y');
[CoAxes2(7) CoAxes2(8) CoAxes2(9)]=arrow3d( [0 0 0]',1.2,R-5,5,'z');
set(CoAxes2,'Visible','off')

[CoAxes3(1) CoAxes3(2) CoAxes3(3)]=arrow3d( [0 0 0]',1.2,R-5,5,'x');
[CoAxes3(4) CoAxes3(5) CoAxes3(6)]=arrow3d( [0 0 0]',1.2,R-5,5,'y');
[CoAxes3(7) CoAxes3(8) CoAxes3(9)]=arrow3d( [0 0 0]',1.2,R-5,5,'z');
set(CoAxes3,'Visible','off')
% 
set([CoAxes0(1) CoAxes0(4) CoAxes0(7)],'EdgeAlpha',0)
set([CoAxes1(1) CoAxes1(4) CoAxes1(7)],'EdgeAlpha',0)
set([CoAxes2(1) CoAxes2(4) CoAxes2(7)],'EdgeAlpha',0)
set([CoAxes3(1) CoAxes3(4) CoAxes3(7)],'EdgeAlpha',0)

set([CoAxes0(3) CoAxes0(6) CoAxes0(9)],'EdgeAlpha',0.2)
set([CoAxes1(3) CoAxes1(6) CoAxes1(9)],'EdgeAlpha',0.2)
set([CoAxes2(3) CoAxes2(6) CoAxes2(9)],'EdgeAlpha',0.2)
set([CoAxes3(3) CoAxes3(6) CoAxes3(9)],'EdgeAlpha',0.2)

set(CoAxes0,'FaceColor','w')
set(CoAxes1,'FaceColor','c')
set(CoAxes2,'FaceColor','m')
set(CoAxes3,'FaceColor','k')

set([CoAxes0([1 3]) CoAxes1([1 3]) CoAxes2([1 3]) CoAxes3([1 3])],'FaceColor','r')
set([CoAxes0([4 6]) CoAxes1([4 6]) CoAxes2([4 6]) CoAxes3([4 6])],'FaceColor','g')
set([CoAxes0([7 9]) CoAxes1([7 9]) CoAxes2([7 9]) CoAxes3([7 9])],'FaceColor','b')

   
azi=linspace(0,2*pi,50);
x=R*cos(azi);
y=R*sin(azi);
z=repmat(0,size(x));

BaseSphere(3)=plot3(x,y,z);
BaseSphere(2)=plot3(y,z,x);
BaseSphere(1)=plot3(z,x,y);
set(BaseSphere,'Visible','off')

RotPlane(3)=fill3(x,y,z,'b','FaceAlpha',0.05,'EdgeColor','b');
RotPlane(2)=fill3(y,z,x,'g','FaceAlpha',0.05,'EdgeColor','g');
RotPlane(1)=fill3(z,x,y,'r','FaceAlpha',0.05,'EdgeColor','r');
set(RotPlane,'Visible','off')

% ---------------------------------------------------  Rotation path
x=[0 R*cos([-0.5 0 0.5]*pi/180)];
y=[0 R*sin([-0.5 0 0.5]*pi/180)];
z=zeros(size(x));

arc3(1)=fill3(x,y,z,'y');
arc3(2)=copyobj(arc3(1),gca);
rotate(arc3(2),[0 0 1],90,[0 0 0])

arc2(1)=fill3(y,z,x,'y');
arc2(2)=copyobj(arc2(1),gca);
rotate(arc2(2),[0 1 0],90,[0 0 0])

arc1(1)=fill3(z,x,y,'y');
arc1(2)=copyobj(arc1(1),gca);
rotate(arc1(2),[1 0 0],90,[0 0 0])

set([arc1 arc2 arc3],'EdgeAlpha',0)
set([arc1 arc2 arc3],'FaceAlpha',0.3)
set([arc1 arc2 arc3] ,'Visible','off')
% ---------------------------------------------------  Rotation path

box off
axis off

view([1 1 1])
daspect([1 1 1])
daspect('manual')
camlookat(BaseSphere)
camzoom(1.5)
% zoom reset


count=0;

Vx=[1;0;0];
Vy=[0;1;0];
Vz=[0;0;1];

set(gcf,'Color',[   0.7529    0.7529 0.8])

A1=0;
A2=0;
A3=0;
Aprev=0;
ROT=[0 0 0];
ARC1=0;
ARC2=0;
ARC3=0;

save Maxes CoAxes0 CoAxes1 CoAxes2 CoAxes3 BaseSphere RotPlane arc1 arc2 arc3
save Trans A1 A2 A3 Aprev Vx Vy Vz count ROT R ARC1 ARC2 ARC3