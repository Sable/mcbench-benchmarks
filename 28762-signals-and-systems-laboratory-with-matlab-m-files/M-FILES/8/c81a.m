% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%
% Frequency Response of a system described by the impulse response
% h(t)=exp(-t)u(t)

syms t w
h=exp(-t) *heaviside(t)
H=fourier(h,w)

w1=0:.1:10;
HH=subs(H,w,w1);
plot(w1,abs(HH));
title ('Frequency response magnitude')

figure
plot(w1,angle(HH))
title ('phase H(\Omega)  in radians')

%Frequency Response in polar form
figure
dif=HH-abs(HH).* exp(j*angle(HH));
subplot(211)
plot(w1,real( dif));
ylim([-1e-7 1e-7])
legend('real part')
subplot(212)
plot(w1,imag(dif));
ylim([-1e-7 1e-7])
legend('imaginary part')

