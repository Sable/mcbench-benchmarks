% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni



%problem 1 - Fourier Transform of cos(t)

syms t w
x=cos(t);
X=fourier(x,w);
w1=[-4:.05:4];
X=subs(X,w,w1);
for i=1:length(X)
if X(i)==inf
X(i)=1;
end
end
plot(w1,X)
legend('F[cos(t)]')
