%Replicates results of original schwartz-smith papter
clear
load crudeoil.txt 
y=crudeoil';
load spotcrudeoil.txt
x=spotcrudeoil;

k=1.49;
sigmax=.286;
lambdax=.157;
mu=.03;
sigmae=.145;
rnmu=.0115;
pxe=.3;
s=[.042;.006;.003;.0000;.004];

%nf=# of maturities, n=# of iterations
[nf,n]=size(y); 
matur=[1/12,5/12,9/12,13/12,17/12]; %maturity times of futures contracts
dt=7/360; % time step interval

%Unobserved state variable equation: x(t)=c+G*x(t-1)+w(t) Equation (14)
C=[0;mu*dt]; %Value of c
A=[exp(-k*dt),0;0,1]; % Value of G

%Listing components of W=var[w(t)]
xx=(1-exp(-2*k*dt))*(sigmax)^2/(2*k);
xy=(1-exp(-k*dt))*pxe*sigmax*sigmae/k;
yx=(1-exp(-k*dt))*pxe*sigmax*sigmae/k;
yy=(sigmae)^2*dt;
W=[xx,xy;yx,yy]; %Value of W=var[w(t)]
R=eye(size(W,1));


%Observed state variable equation: y(t)=d(t)+F(t)'x(t)+v(t) Equation (15)
for z=1:nf
%p1, p2, and p3 are components of A(T) Equation 9
p1=(1-exp(-2*k*matur(z)))*(sigmax)^2/(2*k);
p2=(sigmae)^2*matur(z);
p3=2*(1-exp(-k*matur(z)))*pxe*sigmax*sigmae/k;
d(z,1)=rnmu*matur(z)-(1-exp(-k*matur(z)))*lambdax/k+.5*(p1+p2+p3); %Value of d(t)
H(z,1)=exp(-k*matur(z)); % Value of F column 1
H(z,2)=1;  % Value of F column 2
end
Q=diag(s); % Measurment errors. Cov[v(t)]=V

%The Kalman Filter
a0=[.119;2.857]; %Initial state vector m(t)=E[xt;et]
P0=[.1,.1;.1,.1]; %Inital covariance matrix C(t)=cov[xt,et]

[y_cond,v,a,a_cond,P,P_cond,F,logl]=kalman_filter(y',H,d,A,C,R,a0,P0,Q,W,0);



hold on
plot(exp(a(:,1)+a(:,2)),':r','linewidth',3); 
plot(exp(a(:,2)),':b','linewidth',3);
plot(x,'k','linewidth',2);
h = legend('Estimated Price','Equilibrium Price','Observed Price');
title('Schwartz-Smith Optimization Results')
