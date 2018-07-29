function Ex1_TheSolarSystem

clear all;clc;close all;delete('*.asv');

%% Units uses
% *Units: Mass(kg), redios(AU : 1 AU = 1.5e-11 m), time(yr)*

k=1e3;ks=.04;


r_sun=k*(6.9551e8/1.5e11);

%% Planets
%
% *1- Mercury (Me)*
M_Me=2.4e23; rs_Me=0.38710; ec_Me=0.206;
r_Me=k*((2439.7e3)/1.5e11);%AU*e3: radius of plant
Pp(1,1)=M_Me; Pp(1,2)=rs_Me; Pp(1,3)=ec_Me; Pp(1,4)=r_Me;
%%
% *2- Venus (Ve)*
M_Ve=4.9e24; rs_Ve=0.72333; ec_Ve=0.007;
r_Ve=k*((6051.8e3)/1.5e11);%AU*e3: radius of plant
Pp(2,1)=M_Ve; Pp(2,2)=rs_Ve; Pp(2,3)=ec_Ve; Pp(2,4)=r_Ve;
%%
% *3- Earth (Ea)*
M_Ea=6e24; rs_Ea=1; ec_Ea=0.017;
r_Ea=k*((6378.14e3)/1.5e11);%AU*e3: radius of plant
Pp(3,1)=M_Ea; Pp(3,2)=rs_Ea; Pp(3,3)=ec_Ea; Pp(3,4)=r_Ea;
%%
% *4- Mars (Ma)*
M_Ma=6.6e23; rs_Ma=1.52366; ec_Ma=0.093;
r_Ma=k*((3396.2e3)/1.5e11);%AU*e3: radius of plant
Pp(4,1)=M_Ma; Pp(4,2)=rs_Ma; Pp(4,3)=ec_Ma; Pp(4,4)=r_Ma;
%%
% *5- Jupiter (Ju)*
M_Ju=1.9e27; rs_Ju=5.20336; ec_Ju=0.048;
r_Ju=k*((71492e3)/1.5e11);%AU*e3: radius of plant
Pp(5,1)=M_Ju; Pp(5,2)=rs_Ju; Pp(5,3)=ec_Ju; Pp(5,4)=r_Ju;
%%
% *6- Saturn (Sa)*
M_Sa=5.7e26; rs_Sa=9.53707; ec_Sa=0.056;
r_Sa=k*((60268e3)/1.5e11);%AU*e3: radius of plant
Pp(6,1)=M_Sa; Pp(6,2)=rs_Sa; Pp(6,3)=ec_Sa; Pp(6,4)=r_Sa;
%%
% *7- Uranus (Ur)*
M_Ur=8.8e25; rs_Ur=19.19126; ec_Ur=0.046;
r_Ur=k*((25559e3)/1.5e11);%AU*e3: radius of plant
Pp(7,1)=M_Ur; Pp(7,2)=rs_Ur; Pp(7,3)=ec_Ur; Pp(7,4)=r_Ur;
%%
% *8- Nepton (Ne)*
M_Ne=1.03e26; rs_Ne=30.06896; ec_Ne=0.01;
r_Ne=k*((24764e3)/1.5e11);%AU*e3: radius of plant
Pp(8,1)=M_Ne; Pp(8,2)=rs_Ne; Pp(8,3)=ec_Ne; Pp(8,4)=r_Ne;
%%
% *9- Pluto (Pl)*
M_Pl=6e24; rs_Pl=39.48168; ec_Pl=0.248;
r_Pl=k*((1195e3)/1.5e11);%AU*e3: radius of plant
Pp(9,1)=M_Pl; Pp(9,2)=rs_Pl; Pp(9,3)=ec_Pl; Pp(9,4)=r_Pl;

%%
% *-------------------------------------------------------------------*
%
% *********************************************************************
%
% *-------------------------------------------------------------------*

%% Equations of Motion
% _ Form 3rd Newton's low : Fg=G*(Ms*Mp)/r^2 we get the defrence equations _
%
% _ for the system's motion as following _
%
% $$v_x(i+1)=v_x(i)-(((4*pi^2*x(i))/r^3)*dt)$$
%
% $$x(i+1)=x(i)+(v_x(i+1)*dt)$$
%
% $$v_y(i+1)=v_y(i)-(((4*pi^2*y(i))/r^3)*dt)$$
%
% $$y(i+1)=y(i)+(v_y(i+1)*dt)$$

%% Initial Condations
%
% _The motion is on the plan so w'll make z equal to zero_
%
% _also, w'll start with y=0_

r=Pp(:,2);
x(:,1)=r;y=zeros(length(r),1);
vx(:,1)=zeros(length(r),1);
vy(:,1)=2*pi*ones(length(r),1); dt=.002;

i=0; t=0;

while t<=11.862615
    i=i+1;
    for n=1:length(r)
        vx(n,i+1)=vx(n,i)-(((4*pi^2*x(n,i))/(r(n))^3)*dt);
        x(n,i+1)=x(n,i)+(vx(n,i+1)*dt);
        vy(n,i+1)=vy(n,i)-(((4*pi^2*y(n,i))/(r(n))^3)*dt);
        y(n,i+1)=y(n,i)+(vy(n,i+1)*dt);
    end
    t=t+dt;
end


%%
% *-------------------------------------------------------------------*
%
% *********************************************************************
%
% *-------------------------------------------------------------------*

%% Visualizing System on VR
% *1- Calling the varsual world*
world = vrworld('solarsystem.wrl');

open(world);

view(world, '-internal');
vrdrawnow;

Sun_VR= vrnode(world, 'Sun');
Me_VR = vrnode(world, 'Mercury');
Ve_VR = vrnode(world, 'Venus');
Ea_VR = vrnode(world, 'Earth');
Ma_VR = vrnode(world, 'Mars');
Ju_VR = vrnode(world, 'Jupiter');
Sa_VR = vrnode(world, 'Saturn');
Ur_VR = vrnode(world, 'Uranus');
Ne_VR = vrnode(world, 'Nepton');
Pl_VR = vrnode(world, 'Pluto');
%%
% *2- adjust the plantes's (VR Objects) radiuses*

Sun_VR.scale = ks*[r_sun r_sun r_sun];
Me_VR.scale = [Pp(1,4) Pp(1,4) Pp(1,4)];
Ve_VR.scale = [Pp(2,4) Pp(2,4) Pp(2,4)];
Ea_VR.scale = [Pp(3,4) Pp(3,4) Pp(3,4)];
Ma_VR.scale = [Pp(4,4) Pp(4,4) Pp(4,4)];
Ju_VR.scale = [Pp(5,4) Pp(5,4) Pp(5,4)];
Sa_VR.scale = [Pp(6,4) Pp(6,4) Pp(6,4)];
Ur_VR.scale = [Pp(7,4) Pp(7,4) Pp(7,4)];
Ne_VR.scale = [Pp(8,4) Pp(8,4) Pp(8,4)];
Pl_VR.scale = [Pp(9,4) Pp(9,4) Pp(9,4)];

z=zeros(1,length(x));

for i=1:length(x)

    Me_VR.translation = [x(1,i) y(1,i) z(i)];
    Ve_VR.translation = [x(2,i) y(2,i) z(i)];    
    Ea_VR.translation = [x(3,i) y(3,i) z(i)];    
    Ma_VR.translation = [x(4,i) y(4,i) z(i)];    
    Ju_VR.translation = [x(5,i) y(5,i) z(i)];    
    Sa_VR.translation = [x(6,i) y(6,i) z(i)];    
    Ur_VR.translation = [x(7,i) y(7,i) z(i)];    
    Ne_VR.translation = [x(8,i) y(8,i) z(i)];    
    Pl_VR.translation = [x(9,i) y(9,i) z(i)];    
    vrdrawnow;
    pause(0.001);
end

pause(1);
reload(world);
close(world);delete(world);

for n=1:9
plot(x(n,:),y(n,:))
hold on;
end
hold off
text(0,0,'Sun')
text(x(1,1),0,'Mercury')
text(x(2,1),0,'Venus')
text(x(3,1),0,'Earth')
text(x(4,1),0,'Mars')
text(x(5,1),0,'Jupiter')
text(x(6,1),0,'Saturn')
text(x(7,1),0,'Uranus')
text(x(8,1),0,'Nepton')
text(x(9,1),0,'Pluto')
end