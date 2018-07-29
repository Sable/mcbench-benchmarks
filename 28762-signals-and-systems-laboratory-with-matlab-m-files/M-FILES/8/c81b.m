% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
% The system response to exp(-3t)u(t) to is  t*exp(-3t)u(t)


clear all; 

syms t w
x=exp(-3*t) *heaviside(t);
y=t*exp(-3*t) *heaviside(t);
X=fourier(x,w) ; 
Y=fourier(y,w);

%Frequency Response 
H=Y/X

% Impulse response
h=ifourier(H,t)


%verification
syms t
y=t*exp(-3*t) *heaviside(t);
ezplot(y, [0 10] );
legend ('y(t)')
ylim([0 0.15])

figure
t=0:.01:5;
x=exp(-3*t);
h=x;
y=conv(x,h)*.01;
plot(0:.01:10,y);
legend ('x(t)*h(t)')
ylim([0 0.15])

