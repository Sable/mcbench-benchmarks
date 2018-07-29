% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% Problem 5- System response to sinusoidal input

w0=2*pi;
Hw0=(3*(j*w0)^2+4*j*w0+2)/((j*w0)^2+2*j*w0+1);
mag=abs(Hw0);
phas=angle(Hw0);
t=0:.1:5;
y=3*mag*cos(w0*t+pi/2+phas);
plot(t,y)
legend('Output signal y(t)')
 

