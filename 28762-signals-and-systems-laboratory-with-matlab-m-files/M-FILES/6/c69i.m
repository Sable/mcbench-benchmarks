% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni



%problem 9- autocorrelation of exp(-3t)u(t)

syms t r
x=exp(-3*t)*heaviside(t);
x1=x;
x_2=subs(x1,t,t-r);
x2=conj(x_2);
R=int(x1*x2,t,-inf,inf);
ezplot(R, [-8 8]);
legend('R_x(\tau)');
ylim([0  0.17]);
