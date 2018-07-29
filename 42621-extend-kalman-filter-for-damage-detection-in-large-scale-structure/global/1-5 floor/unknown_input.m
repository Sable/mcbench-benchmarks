
% Sequential Klaman estimator and rescurive least-square estimation of unknown inputs
% (Feb. 2009, by Y. Lei)
%此程序为benchmark case3 X方向的四层刚度的识别，其质量为[3452.4 2652.4 2652.4
%1809.9]其Y方向的刚度为[106.6*10e7  106.6*10e7 106.6*10e7 106.6*10e7]
%正问题的四层响应为accy.mat
clear all

% dt=input('Time step  '); % When f(t) is asuumed to be constant in [k*dt (k+1)*dt] dt must be small   
dt=0.001
n=5; % The number of DDOF

% Measured acceleration responses
load response.mat
accn=accn(:,1:5);
%accn=accx;
[ll,nn]=size(accn);

% mass matrix:  m1=8.3kg, m2=8kg, m3=8kg 
m=10^6*[1.1 1.1 1.1 1.1 1.1];
mass=diag(m); 

l=5; % The number of accelerometers
dd=eye(n); % Location of Sensors
 %dd=zeros(l,n); dd(1,2)=1.0; dd(2,3)=1.0;dd(3,4)=1.0; % Meaurements of acceleration responses at the 1st and 3th floor
y=dd*accn'; % Measured acceleration responses

%B=eye(n);
% B_un    - excitation influence matrix associated with the r-unknown excitation
Bl=zeros(5,2);Bl(1,1)=1;
Bl(5,2)=1;     % Unkown excitation on the top floor  
B_un=inv(mass)*Bl;
G_un=dd*B_un;

% Initial values
X(1:2*n,1)=zeros(2*n,1);  % Initial values of displacements and velocities
X(2*n+1:3*n,1)=10^6*862.07*0.85*ones(1,5); % Initial values of stiffness 
X(3*n+1,1)=0.1292*0.8;  ; % Initial values of damping 
X(3*n+2,1)=0.0155*0.8;


pk=zeros(3*n+2);
pk(1:2*n,1:2*n)=0.1*eye(2*n);  % Initial values for error covariance of matrix 
pk(2*n+1:3*n,2*n+1:3*n)=10^15*eye(n);  % Initial values of stiffness error covariance matrix
%pk(2*n+1,2*n+1)=10^8;
pk(3*n+1,3*n+1)=10^-3; % Initial values of damping error covariance matrix 
pk(3*n+2,3*n+2)=0.000001;

Q=10^-8;
R=10^-1*eye(l); % measurement noise 
% Recursive Solution

% load force.mat
% f_un=force(:,2);
f_un(1:2,1)=0;

for k=1:ll-1;
% 状态方城  dX/dt=A*X+B_un*force; 
% 观测方城  Y=E*X+G_un*force
%求整体系数A、B_un、E、G_un
  
  A=zeros(3*n+2);  % State transition matrix
  A(1:n,n+1:2*n)=eye(n);
  [stiff,damp,fkp,fap,fbp]=kcm(n,X(:,k));
  A(n+1:2*n,:)=-inv(mass)*[stiff,damp,fkp, fap,fbp];
  Fi=eye(3*n+2)+A*dt;
   
  %[Ad,Bd_un]=c2d(A,B_un,dt);
  
  hk=dd*inv(mass)*(-stiff*X(1:n,k)-damp*X(n+1:2*n,k));
  E=dd*A(n+1:2*n,:);
  
% The predicted extended state vector by numerical integration

  OPTIONS = [];
  pre=ode45(@predict,[dt*k dt*(k+1)],X(:,k),OPTIONS,n,f_un(:,k),B_un,mass); % Assume f_un is constant in [k*dt (k+1)*dt],dt must be small
  Xbk_1=pre.y(:,end);

  [X(:,k+1),pk_1]=klm(Xbk_1,pk,y(:,k),hk,f_un(:,k),Fi,E,G_un,R,Q);
%  [X(:,k+1),pk_1]=klm(Xbk_1,pk,y(:,k),hk,force(k,2),Fi,E,G_un,R,Q,k);
   pk=pk_1;
   
%     Ked=dlqe(Ad,Bd_un,E,Q,R);
%     X(:,k+1)=Xbk_1+Ked*(y(:,k)-(hk+G_un*f_un(k)));
   k
 [ X(2*n+1:3*n+2,k) X(2*n+1:3*n+2,k+1)]

% Estiamte the unkonw input by recusrive least squear estimation
% 
  [stiff,damp,fkp,fap,fbp]=kcm(n,X(:,k+1));
  
  hk_1=dd*inv(mass)*(-stiff*X(1:n,k+1)-damp*X(n+1:2*n,k+1));
  [f_un(:,k+1)]=rlse(y(:,k+1),hk_1,G_un,R);
%  f_un=detrend(f_un);
  
end
save X.mat X
save f_un.mat f_un