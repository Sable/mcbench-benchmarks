function []=Rotor(be,th,ze)% be=[0 10 2];
% th=[0 12 8];
% ze=[0 0 0];



load NACA632_615.txt;
xy=NACA632_615;

x=xy(:,1);
y=xy(:,2);

rR=10;
R=100;
Spar_Loc=[2*3.5;0;2*0.3];

x=x/5-Spar_Loc(1);
y=y/5-Spar_Loc(3);
x=[x;x(1)];
y=[y;y(1)];

deg=pi/180;
b=be*deg;
t=th*deg;
z=ze*deg;

beta=inline('b1+b2*cos(psi)+b3*sin(psi)','b1','b2','b3','psi');
zeta=inline('z1+z2*cos(psi)+z3*sin(psi)','z1','z2','z3','psi');
theta=inline('t1+t2*cos(psi)+t3*sin(psi)','t1','t2','t3','psi');

psi=linspace(0,2*pi,50);
n=10;
r=linspace(0,100,n);

[rr ssi]=meshgrid(r,psi);

bbb=beta(b(1),b(2),b(3),ssi);
zzz=zeta(z(1),z(2),z(3),ssi);

xx=rr.*cos(bbb).*cos(ssi-zzz);
yy=rr.*cos(bbb).*sin(ssi-zzz);
zz=rr.*sin(bbb);


zmin=-15;
zmax=max(max(zz));

Rotor_Cone=surf(xx,yy,zz,repmat(7,size(zz)),'FaceAlpha',0);   % handle !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
set(Rotor_Cone,'Visible','off')
hold on
HP=fill( 100*cos(psi),100*sin(psi),'w' );                       % handle !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
set(HP,'FaceAlpha',0)
set(HP,'Visible','off')

TPP=fill3(xx(:,n),yy(:,n),zz(:,n),'g','FaceAlpha',0.5);         % handle !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
set(TPP,'Visible','off')

NFP=fill3( 100*cos(psi),100*sin(psi),zeros(size(psi)),'m' ,'FaceAlpha',0.5); 
rotate(NFP,[1 0 0],th(2),[0 0 0])
rotate(NFP,[0 1 0],th(3),[0 0 0])
set(NFP,'Visible','off')


HP_Cross(1)=plot3([-100 100],[0 0],[0 0]);
HP_Cross(2)=plot3([0 0],[-100 100],[0 0]);
set(HP_Cross,'Color','y','Linewidth',2)
set(HP_Cross,'Visible','off')

% ############################################## Plot limits ####################################################################
xlim([-100 100])
ylim([-100 100])
zlim([zmin zmax])


[Rotor_Shaft(1) Rotor_Shaft(2) Rotor_Shaft(3)]=Cylinder( [0 0 0],2.5,zmin,'z',15,'closed' );
set(Rotor_Shaft,'FaceColor','w')
set(Rotor_Shaft,'Visible','off')


[XAXIS(1) XAXIS(2) XAXIS(3)]=arrow3d( [0 0 0.5]',0.5,90,8,'x');
[YAXIS(1) YAXIS(2) YAXIS(3)]=arrow3d( [0 0 0.5]',0.5,90,8,'y');
[ZAXIS(1) ZAXIS(2) ZAXIS(3)]=arrow3d( [0 0 0.5]',0.5,40,4,'z');

XAXIS(4)=text(110,0,0,'X','Color','r','FontSize',12);
YAXIS(4)=text(0,110,0,'Y','Color','r','FontSize',12);
ZAXIS(4)=text(0,0,zmax+10,'Z','Color','r','FontSize',12);



set(XAXIS(1),'FaceColor','k','EdgeAlpha',0)
set(XAXIS(2),'FaceColor','r')
set(XAXIS(3),'FaceColor','k')

set(YAXIS(1),'FaceColor','k','EdgeAlpha',0)
set(YAXIS(2),'FaceColor','r')
set(YAXIS(3),'FaceColor','k')

set(ZAXIS(1),'FaceColor','k','EdgeAlpha',0)
set(ZAXIS(2),'FaceColor','r')
set(ZAXIS(3),'FaceColor','k')

set(XAXIS,'Visible','off')
set(YAXIS,'Visible','off')
set(ZAXIS,'Visible','off')


PSI=0:10:360;

Targetx=100*cos(PSI*pi/180);
Targety=100*sin(PSI*pi/180);
looktarget=plot3(Targetx',zeros(size(Targetx')),Targety',Targetx',Targety',zeros(size(Targetx')),zeros(size(Targetx')),Targetx',Targety');
set(looktarget,'Visible','off')

BETA(1,:)=beta(b(1),b(2),b(3),PSI*deg);
THETA(1,:)=theta(t(1),t(2),t(3),PSI*deg);
ZETA(1,:)=zeta(z(1),z(2),z(3),PSI*deg);

tr=[t(1) t(2)-b(3) b(2)+t(3)];
br=[b(1) 0 0];
zr=z;
            
BETA(2,:)=beta(br(1),br(2),br(3),PSI*deg);
THETA(2,:)=theta(tr(1),tr(2),tr(3),PSI*deg);
ZETA(2,:)=zeta(zr(1),zr(2),zr(3),PSI*deg);

br=[b(1) b(2)+t(3) b(3)-t(2)];
tr=[t(1) 0 0];
zr=z;

BETA(3,:)=beta(br(1),br(2),br(3),PSI*deg);
THETA(3,:)=theta(tr(1),tr(2),tr(3),PSI*deg);
ZETA(3,:)=zeta(zr(1),zr(2),zr(3),PSI*deg);

for i=1:37;
    Blade_Disk(i,:)=Make_Blade(x,y,rR,R,PSI(i),THETA(1,i)/deg,BETA(1,i)/deg,ZETA(1,i)/deg);
    set(Blade_Disk(i,:),'Visible','off')
    
    
    a_HP(i,1)=text(90*cos(PSI(i)*deg),90*sin(PSI(i)*deg),0,['HP: \psi = ' num2str(PSI(i)) ],'Color','k','FontSize',12);
    a_HP(i,2)=text(90*cos(PSI(i)*deg),90*sin(PSI(i)*deg),0-10,['HP: \beta = ' num2str(BETA(1,i)/deg) ],'Color','r','FontSize',12);
    a_HP(i,3)=text(90*cos(PSI(i)*deg),90*sin(PSI(i)*deg),0+10,['HP: \theta = ' num2str(THETA(1,i)/deg) ],'Color','m','FontSize',12);
    a_HP(i,4)=text(90*cos(PSI(i)*deg),90*sin(PSI(i)*deg),0+20,['HP: \zeta = ' num2str(ZETA(1,i)/deg) ],'Color','b','FontSize',12);
    set(a_HP(i,:),'Visible','off')

    
    a_TPP(i,1)=text(90*cos(PSI(i)*deg),90*sin(PSI(i)*deg),0,['TPP: \psi = ' num2str(PSI(i))],'Color','k','FontSize',12);
    a_TPP(i,2)=text(90*cos(PSI(i)*deg),90*sin(PSI(i)*deg),0-10,['TPP: \beta = ' num2str(BETA(2,i)/deg) ],'Color','r','FontSize',12);
    a_TPP(i,3)=text(90*cos(PSI(i)*deg),90*sin(PSI(i)*deg),0+10,['TPP: \theta = ' num2str(THETA(2,i)/deg) ],'Color','m','FontSize',12);
    a_TPP(i,4)=text(90*cos(PSI(i)*deg),90*sin(PSI(i)*deg),0+20,['TPP: \zeta = ' num2str(ZETA(2,i)/deg) ],'Color','b','FontSize',12); 
    set(a_TPP(i,:),'Visible','off')
    
    a_NFP(i,1)=text(90*cos(PSI(i)*deg),90*sin(PSI(i)*deg),0,['NFPP: \psi = ' num2str(PSI(i)) ],'Color','k','FontSize',12);
    a_NFP(i,2)=text(90*cos(PSI(i)*deg),90*sin(PSI(i)*deg),0-10,['NFPP: \beta = ' num2str(BETA(3,i)/deg) ],'Color','r','FontSize',12);
    a_NFP(i,3)=text(90*cos(PSI(i)*deg),90*sin(PSI(i)*deg),0+10,['NFPP: \theta = ' num2str(THETA(3,i)/deg) ],'Color','m','FontSize',12);
    a_NFP(i,4)=text(90*cos(PSI(i)*deg),90*sin(PSI(i)*deg),0+20,['NFPP: \zeta = ' num2str(ZETA(3,i)/deg) ],'Color','b','FontSize',12); 
    set(a_NFP(i,:),'Visible','off')
end
    

axis equal
axis off

daspect([1 1 1])
daspect('manual')
camlookat(looktarget)
camzoom(1.5)

save para Rotor_Shaft HP TPP Rotor_Cone  HP_Cross XAXIS YAXIS ZAXIS Blade_Disk NFP a_HP a_TPP a_NFP

save looktargetfile looktarget