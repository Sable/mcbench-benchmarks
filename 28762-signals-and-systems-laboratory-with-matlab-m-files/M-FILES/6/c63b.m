% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


%Fourier Transfrom pair pT(t)<->Tsin(wT/2)/(wT/2)

syms t w T
x=heaviside(t+T/2)-heaviside(t-T/2);
xx=subs(x,T,4);
ezplot(xx,[ -4 4])
legend('x(t)')
X1=fourier(x,w)

figure
X2=T*(sin(w*T/2))/(w*T/2);
ww=[-30:.1:-.1 .1:.1:30];
X=subs(X1,w,ww)
X=subs(X,T,4);
plot(ww,X)
xlabel('\Omega  rad/s')
legend('X(\Omega)')
