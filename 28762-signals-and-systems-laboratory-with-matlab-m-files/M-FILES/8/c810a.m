% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
%   Problem 1-  Frequency Response of a
%   continuous time system with impulse response pT(t)



% a)
syms t w
h=heaviside(t+1)-heaviside(t-1)
H=fourier(h,w)
ezplot(abs(H), [-20 20]);
legend('| H(\Omega) |')

figure
w1=-20:.1:20;
HH=subs(H,w,w1);
plot(w1,angle(HH));
ylim([-.2 3.8]);
legend('\angle H(\Omega)')


% b)
figure
h2=heaviside(t+5)-heaviside(t-5);
H2=fourier(h2,w)
ezplot(abs(H2), [-20 20]);
ylim([-.1 11.2]);
legend('| H(\Omega) | ')

figure
w1=-20:.1:20;
HH=subs(H2,w,w1);
plot(w1,angle(HH));
legend('\angle H(\Omega)')
