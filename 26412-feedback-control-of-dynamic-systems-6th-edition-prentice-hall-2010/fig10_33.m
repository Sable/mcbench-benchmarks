%  Figure 10.33      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
% Fig. 10.33 Script for computation of the  frequency response of yaw 
% control. Aircraft Bode plot. 
clf;
f =[-0.0558   -0.9968    0.0802    0.0415;
    0.5980   -0.1150   -0.0318         0 ;
   -3.0500    0.3880   -0.4650         0 ;
         0    0.0805    1.0000         0] ;
g =[0.0073;
   -0.4750;
    0.1530;
         0];
h = [0     1     0     0];
j =[0];
% the equations of the actuator:

na=[0 10];
da=[1 10];
[fa,ga,ha,ja]=tf2ss(na,da);

% the equations of the aircraft with actuator:

[fp,gp,hp,jp]=series(fa,ga,ha,ja,f,g,h,j);

% the uncompensated frequency response;

w= logspace(-1, 1);

[magp ,php]=bode(fp,-gp,hp,jp,1,w);
magp1=[magp, ones(size(magp))];
subplot(211); 
loglog(w,magp1); 
grid;
xlabel('\omega (rad/sec)');
ylabel('Magnitude, |G(s)|');
title('Fig. 10.33 Frequency response of the yaw damper with direct feedback');
php1=[php,  -180*ones(size(php))];
subplot(212); 
semilogx(w, php1);
grid;
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)');
%Bode grid
bodegrid
