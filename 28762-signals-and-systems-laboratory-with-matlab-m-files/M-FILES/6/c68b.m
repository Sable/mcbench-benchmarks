% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni

%Autocorrelation and crosscorrelation 


%autocorrelation of exp(-t)u(t-1)
step=0.01;
t1=0:step:1-step;
x1=zeros(size(t1));
t2=1:step:10;
x2=exp(-t2);
x=[x1 x2];
R=xcorr(x)*step;
plot(-10:step:10,R)
legend('R_x(\tau) with xcorr')


% crosscorrelation of r(t) and r(t-2)
figure
t1=0:0.1:5;
x1=t1;
t2=5.1:0.1:7;
x2=zeros(size(t2));
x=[x1 x2];
t1=0:0.1:1.9;
y1= zeros(size(t1));
t2=2:0.1:7;
y2=t2-2;
y=[y1 y2];
R=xcorr(x,y)*0.1;
plot(-7:0.1:7,R)
legend('R_x_y(\tau) ')
grid
