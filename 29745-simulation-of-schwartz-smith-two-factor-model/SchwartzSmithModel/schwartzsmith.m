
function LogL= schwartzsmith(k,sigmax,lambdax,mu,sigmae,rnmu,pxe,s,y)

%nf=# of maturities, n=# of iterations
[nf,n]=size(y); 
matur=[1/12,5/12,9/12,13/12,17/12]; %maturity times of futures contracts
dt=1/360; % time step interval

%Unobserved state variable equation: x(t)=c+G*x(t-1)+w(t) Equation (14)
c=[0;mu*dt]; %Value of c
G=[exp(-k*dt),0;0,1]; % Value of G

%Listing components of W=var[w(t)]
xx=(1-exp(-2*k*dt))*(sigmax)^2/(2*k);
xy=(1-exp(-k*dt))*pxe*sigmax*sigmae/k;
yx=(1-exp(-k*dt))*pxe*sigmax*sigmae/k;
yy=(sigmae)^2*dt;
W=[xx,xy;yx,yy]; %Value of W=var[w(t)]


%Observed state variable equation: y(t)=d(t)+F(t)'x(t)+v(t) Equation (15)
for z=1:nf
%p1, p2, and p3 are components of A(T) Equation 9
p1=(1-exp(-2*k*matur(z)))*(sigmax)^2/(2*k);
p2=(sigmae)^2*matur(z);
p3=2*(1-exp(-k*matur(z)))*pxe*sigmax*sigmae/k;
d(z,1)=rnmu*matur(z)-(1-exp(-k*matur(z)))*lambdax/k+.5*(p1+p2+p3); %Value of d(t)
F(z,1)=exp(-k*matur(z)); % Value of F column 1
F(z,2)=1;  % Value of F column 2
end
V=diag([s;s;s;s;s]); % Measurment errors. Cov[v(t)]=V

%The Kalman Filter
m(:,1)=[.119;2.857]; %Initial state vector m(t)=E[xt;et]
Ct=[.1,.1;.1,.1]; %Inital covariance matrix C(t)=cov[xt,et]

sum1=0;
sum2=0;
for t=2:n+1
    
%next two lines are mean and covariance of [xt,et]
a(:,t)=c+G*m(:,t-1); 


R=G*Ct*G'+W;
    
%next two lines are mean and covariance of t-futures prices given t-1
f(:,t)=d+F*a(:,t); %f(t)=dt+F(t)'*at [unlike paper, I defined F=F']
Q=F*R*F'+V; %Qt=Ft'Rt*Ft+V This is Ft is likelihood equation

% Correction to predicted state
A=R*F'*(Q)^-1; %At=Rt*Ft*Qt^-1

%E[xt,xt] and Cov[xt,et]condition on all information available at time t
m(:,t)=a(:,t)+A*(y(:,t-1)-f(:,t)); %Equation (16a)


Ct=R-A*Q*A'; % Equations (16b)

m(:,t-1)=m(:,t);
sum1=sum1+log(det(Q));
sum2=sum2+(y(:,t-1)-f(:,t))'*(Q)^-1*(y(:,t-1)-f(:,t));
end

LogL=-(nf*n)/2*log(2*pi)-.5*sum1-.5*sum2; %LogLikelihood function
