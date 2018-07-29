% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
%  	System response to sinusoidal inputs 



% which element of vector a has the closest value to z  
a=-4:4
z=2.3;
a-z
abs(a-z)
[m,i]=min(abs(a-z))
a(i)

%  	System response
num=[3 4 2];
den=[1 1 3];
[H,w]=freqs(num,den);
w0=1;
[m,i]=min(abs(w-w0));
w(i)
Hw0=H(i)
mag=abs(Hw0)
phas=angle(Hw0)
t=0:.1:30;
y1=3*mag*cos(w(i)*t+pi/4+phas)
plot(t,y1)
legend('Output  y(t)')
ylim([-6 8]);
