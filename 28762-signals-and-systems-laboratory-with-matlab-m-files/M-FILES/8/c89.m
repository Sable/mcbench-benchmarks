% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
%    Frequency Response of a 3-point Moving average filter  


syms X w 
X1=X*exp(-j*w);
X2=X*exp(-j*2*w);
Y=(1/3)*(X+X1+X2);
H=Y/X;

H=simplify(H)
ezplot(abs(H), [0 2*pi]);
legend(' |H(\omega)|'); 

figure
w1=0:.1:2*pi;
HH=subs(H,w,w1);
plot(w1,angle(HH));
xlim([0 2*pi]);
legend('\angle H(\omega)')

figure
w=0:.1:2*pi;
Htheor=sin(3*w/2).*exp(-j*w)./(3*sin(w/2));
plot(w,abs(Htheor));
xlim([0 2*pi]);
ylim([-.2 1.2]) 
legend( '|H(\omega)|- theory ');

figure
plot(w,angle(Htheor));
xlim([0 2*pi]);
ylim([-2.3 2.3]);
legend('\angle H(\omega)-theory')
