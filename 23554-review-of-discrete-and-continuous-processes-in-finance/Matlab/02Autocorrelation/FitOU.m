function [m,theta,s,b]=FitOU(Y,tau)

T=length(Y);

X=Y(2:end,:);
F=[ones(T-1,1) Y(1:end-1,:)];
E_XF=X'*F/T;
E_FF=F'*F/T;
B=E_XF*inv(E_FF);

U=F*B'-X;
v_tau = cov(U);

theta=-log(B(2))/tau;
m=B(1)/(1-B(2));
s=sqrt(v_tau*2*theta/(1-exp(-2*theta*tau)));
b=B(2);



