% n is the no. representing the which harmonics: 1 -> 1st harmonic
% Nb is the no. of Blades
%(Ref: page no. 106 Watkinson)

function [] = Rotor_Harmonics( Nb,n )

% Nb=4;
% n=3;
% figure(1)

save DataFile Nb n
clear all
clc
load DataFile
delete DataFile.mat

load NACA4412.txt;
xb=NACA4412(:,1);		% Nx1
yb=NACA4412(:,2);		% Nx1

rR=25;
R=100;
Spar_Loc=[2*3.5;0;2*0.3];

xb=xb/5.5-Spar_Loc(1);
yb=yb/5.5-Spar_Loc(3);
xb=[xb;xb(1)];
yb=[yb;yb(1)];

psi=[0:1:360]*pi/180;
npsi=length(psi);
bihn=0.25*sin(n*psi);

x=R*cos(psi);
y=R*sin(psi);

rn=3;   % no. of nodes in the radial direction
r=linspace(0,R,rn);

[rr ssi]=meshgrid(r,psi);
bbb=repmat(bihn',1,rn);
xx=rr.*cos(bbb).*cos(ssi);
yy=rr.*cos(bbb).*sin(ssi);
zz=rr.*sin(bbb);

Zmin=min(min(zz));
Zmax=max(max(zz));

h=Zmax+abs(Zmin);

x=R*cos(psi);
y=R*sin(psi);

hold on
BladeSurface=surface(xx,yy,zz,'FaceColor','b','EdgeAlpha',0.5);
set(BladeSurface,'visible','off')
rotoredge(1)=plot3(xx(:,end),yy(:,end),zz(:,end),'b','LineWidth',1.2);

div=[0:360/n:360-360/n]*pi/180;
xdiv=[R*cos(div); R*cos(div)];
ydiv=[R*sin(div); R*sin(div)];
zdiv=[repmat(Zmin,1,n); repmat(Zmax,1,n)];
Div=plot3(xdiv,ydiv,zdiv,'b','LineStyle',':');


cyl(1)=Cylinder( [0,0,Zmin],R,h,'z',50,'open');
set(cyl(1),'FaceColor','b','EdgeAlpha',0,'FaceAlpha',0.2)
cyl(2)=plot3(x,y,repmat(Zmin,size(x)),'b');
cyl(3)=plot3(x,y,repmat(Zmax,size(x)),'b');

HP=fill3(x,y,repmat(0,size(x)),'y','FaceAlpha',0.4,'EdgeAlpha',0.8);

CROSSLINE(1)=plot([-(R+30) (R+30)],[0 0],'Color',[0.5020    0.5020         0]);
CROSSLINE(2)=plot([0 0],[-(R+30) (R+30)],'Color',[ 0.5020    0.5020         0]);

ANGLES(1)=text((R+30)*cos(0),(R+30)*sin(0),0,'0^o','Color','k','FontSize',12);
ANGLES(2)=text((R+30)*cos(90*pi/180),(R+30)*sin(90*pi/180),0,'90^o','Color','k','FontSize',12);
ANGLES(3)=text((R+30)*cos(180*pi/180),(R+30)*sin(180*pi/180),0,'180^o','Color','k','FontSize',12);
ANGLES(4)=text((R+30)*cos(270*pi/180),(R+30)*sin(270*pi/180),0,'270^o','Color','k','FontSize',12);

dPSI=360/Nb;

Azimuths=0:dPSI:(360-360/Nb);
indx=Azimuths+1;
FlapAxes=-[-sin(Azimuths'*pi/180) cos(Azimuths'*pi/180) zeros(Nb,1)];

for i=1:Nb
    BladeSet(i,:)=Make_Blade(xb,yb,rR,R,Azimuths(i),0,0,0);
end

Head(1,:)=Cylinder( [0 0 -3.5],9,8,'z',25,'closed' );
Head(2,:)=Cylinder( [0 0 -20.5],4,17,'z',25,'closed' );
set(Head,'FaceColor',[0.5020    0.5020    0.5020])
set(BladeSet(:,1),'FaceColor',[0.5020         0    0.2510])

for i=1:npsi
    ShadedBeta(i)=fill3([0 x(i) xx(i,3)],[0 y(i) yy(i,3)],[0 0 zz(i,3)],[1 0 1]);
end
set(ShadedBeta,'Visible','off')

% % % This is for making the Shaded beta with two different colors in positive
% % % and negative beta regions
% negZindx=find(zz(:,3)<0);
% set(ShadedBeta,'FaceColor','m')
% set(ShadedBeta(negZindx),'FaceColor','g')

for i=1:Nb
    set(ShadedBeta(indx(i)),'Visible','on')
end

axis equal
axis off
camlookat(cyl)
daspect([1 1 1])
daspect('manual')
camzoom(1.7)
view(3)

beta=bihn(indx)*180/pi;
for j=1:Nb
    rotate(BladeSet(j,:),FlapAxes(j,:),bihn(indx(j))*180/pi,[0 0 0])
end
iprev =1;
betaprev=beta;

save DataFile BladeSet BladeSurface cyl HP iprev betaprev Azimuths ... 
    bihn Div indx CROSSLINE ANGLES ShadedBeta Head rotoredge