% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% 	Discrete Time Transfer Function 


%from impulse response
syms n z
h=2^n;
H=ztrans(h,z);
H=simplify(H)



%from difference equation 
syms n z X Y
Y1=(z^-1)*Y;
X1=(z^-1)*X;
G=Y-Y1-X-X1;
Y=solve(G,Y);
H=Y/X




% definition with tf
num = [2 1];
den = [1 3 2];
Ts=0.4;
H=tf(num,den,Ts)
