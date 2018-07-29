%  Figure 10.36      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%
%  Fig. 10.36  Script for computation of the yaw damper Bode plot 
%  for feedback through a washout circuit.


% the equations of the aircraft:

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
% the washout circuit
nw=[1 0];dw=[1 1/3];
[fw,gw,hw,jw]=tf2ss(nw,dw);
%  Open-loop equations with washout
sysw=ss(fw,gw,hw,jw);
sysp=ss(fp,gp,hp,jp);
syspw=series(sysp,sysw)
[fpw,gpw,hpw,jpw]=ssdata(syspw);
 % the washout compensated root locus
 hold off; clf
w=logspace(-1,1);
syspw1=ss(fpw,gpw,-hpw,-jpw);
[mag, ph]=bode(syspw1,w);
subplot(211); loglog(w,mag(:,:)); grid; hold on;
xlabel('\omega (rad/sec)');
ylabel('Magnitude');
loglog(w,ones(size(mag(:,:))),'g');
title('Fig. 10.36 Bode plot for rate-feedback with washout')
ph1 = [ph(:,:); -180*ones(size(ph(:,:)))];
subplot(212); semilogx(w,ph1); grid;
xlabel('\omega (rad/sec)');
ylabel('Phase (deg)');

