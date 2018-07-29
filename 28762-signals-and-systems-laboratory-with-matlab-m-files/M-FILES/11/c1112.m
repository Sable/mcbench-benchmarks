% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
%
% Transfer Function to Frequency Response 



%continious time
Hs=tf(1,[1 3])

w=-10:.1:10;
Hw=freqresp(Hs,w);

plot(w,abs(Hw(:,:)));
legend(' |H(\Omega) |');
figure
plot(w,angle(Hw(:,:)))
legend('\angle H(\Omega)');

w=-2:2
Hw=freqresp(Hs,w)



% discrete time 

%finite duration impulse response
n=0:3;
h=[3 5 2 1];

syms z w
Htf=sum(h.*z.^-n);

H=subs(Htf,z,exp(j*w));
H=simplify(H)

%confirmation
Hw=sum(h.*exp(-j*w*n))



%infinite duration impulse response
syms n z w
h=(2/3)^n*heaviside(n);

Hz=ztrans(h,z);

H=subs(Hz,z,exp(j*w));
H=simplify(H)

%confirmation
h=(2/3)^n;
Hw=symsum(h*exp(-j*w*n),n,0,inf)




%from difference equation 
syms z n w Yz X

Y1z=z*(-1)*Yz;

G=Yz-0.9*Y1z-X;
Yz=solve(G,Yz);

Hz=Yz/X

Hw=subs(Hz,z,exp(j*w))




%moving average filter
syms z w Xz
X1=z^(-1)*Xz;
X2=z^(-2)*Xz;

Yz=(1/3)*(Xz+X1+X2);

Hz=Yz/Xz
Hz=simplify(Hz)

Hw=subs(Hz,z,exp(j*w))
Hw=simplify(Hw)

hn=iztrans(Hz)





