%Figure 4.30       Feedback Control of Dynamic Systems, 5e
%                      Franklin, Powell, Emami

%script to compute sensitivity
%given n11,d11,n12,d12,n22,d22,n21,d21,kp
clf;
kp=9; tau=.01;
n11=0; d11=1;
n12=1; d12=1;
n22=1; d22= [tau 1];
n21=1; d21=[tau 1];
sys11=tf(n11,d11);
sys12=tf(n12,d12);
sys22=tf(n22,d22);
sys21=tf(n21,d21);
syskp=tf(kp,1);
sysfb=feedback(syskp,sys22);
syssr1=series(sys12,sysfb);
syssr2=series(syssr1,sys21);
syssr3=series((1/kp)*sysfb,sys21);
sysy=sys11+syssr2;
sysdy=series(syssr1,syssr3);
[y,t]=step(sysy);
[yd,t]=step(sysdy);
plot(t,[y yd y+.1*yd]);
grid on;
xlabel('Time (sec)');
ylabel('Output and sensitivity');
title('Figure 4.30');
text(.002,.75,'y');
text(.001,.75,'y+dy');
text(.002,.35,'k_{cl}dy/dk_{cl}');


 