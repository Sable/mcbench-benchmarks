%  Figure 10.54      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
%
% fig10_54.m is a script to generate Fig. 10.54, the step response
% for the fuel/air ratio with a nonlinear sensor.  A (3,3)
% Pade approximant is used to approximate the delay.
clf;
% construct the F/A dynamics with the sensor time-constant too
f =[-50     0     0;
     0    -1     0;
    10    10   -10];

g =[25.0000;
    0.5000;
         0];
h =[0     0     1];
j=0;
[f3,g3,h3,j3 ]=pade(.2,3); %  the delay Pade model
% put the plant and the delay in series
[fp,gp,hp,jp]=series(f,g,h,j,f3,g3,h3,j3); 
% construct the controller
nc=.1*[1 .3];
dc=[1 0]; % the PI controller in polynomial form
[fc,gc,hc,jc]= tf2ss(nc, dc); % put the controller in state space form
[fol,gol,hol,jol] = series(fc,gc,hc,jc,fp,gp,hp,jp);
% get a discrete model for Ts = .01
[phi,gam] = c2d(fol,gol,.01);
% 
% form the closed-loop difference equation
x=[0 0 0 0 0 0 0]';
yout=[];

for t=0:.01:20;
 y=hol*x ;
 e=.4*sat(150*(.068-y));
 x=phi*x+gam*e;
 yout=[yout [e;y]];
end

t=0:.01:20;
subplot(211); 
plot(t,yout(1,:));
axis( [0 20 -.6 .6]);
xlabel('Time (sec)');
ylabel('e');
title('Fig. 10.54 (b) Error plot for nonlinear control of F/A')
grid on;

subplot(212);
plot(t,yout(2,:));
axis([0 20 0 .09]);
xlabel('Time (sec)');
ylabel('F/A');
title('Fig. 10. 54 (c) Output F/A ratio for nonlinear control')
hold off;
%grid
nicegrid

