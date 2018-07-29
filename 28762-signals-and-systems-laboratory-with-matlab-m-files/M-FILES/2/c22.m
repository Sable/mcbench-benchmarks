% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni



% sinusoidal signal 
  A=3;
 omega=3*pi;
 thita=pi/3;
 T= 2*pi/omega;
 t=0:0.01:4*T; 
 x=A*cos(omega*t+thita);
 plot(t,x)

 figure
 t=0:0.1:2*pi;
 x1=cos(t);
 x2=sin(t+pi/2);
 plot(t,x1,t,x2,'o')
 xlim([0 2*pi])

 
 % exponential signal 
 figure
 t=-2:.1:5;
 x=3*exp(0.4*t);
 y=2*exp(-0.9*t);
 plot(t,x,t,y,':');
 legend('x(t)','y(t)')

 
  % complex exponential signals 
 figure
  t=0:.1:2;
 y_re=real(2*exp(j*pi*t+pi/3));
 y_im=imag(2*exp(j*pi*t+pi/3));
 plot(t,y_re,t,y_im,'-.');

 figure
 t=0:0.1:5;
 x=(2*exp(j*pi*t)).*(3*exp(j*2*pi*t));
 y=6*exp(j*3*pi*t);
 plot(t,real(x),t,real(y),'ko')
 
 
