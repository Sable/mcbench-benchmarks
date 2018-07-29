

clear 

dt=input('Time step  '); % When f(t) is asuumed to be constant in [k*dt (k+1)*dt] dt must be small   
n=4; % The number of DDOF

% Measured acceleration responses
load response.mat
[ll,nn]=size(accn);

% mass matrix:  m1=6kg, m2=5kg, m3=4kg 
%m=[60 50 40 30];
mass=diag([60 50 40 30]); 

l=3; % The number of accelerometers
%dd=eye(n); % Location of Sensors
dd=zeros(l,n); dd(1,2)=1.0; dd(2,3)=1.0; dd(3,4)=1.0; % Meaurements of acceleration responses at the 1st and 3th floor
y=dd*accn'; % Measured acceleration responses

%Y是观测得到的加速度


B=eye(n);
% B_un    - excitation influence matrix associated with the r-unknown excitation
Bl=[B(:,n)];     % Unkown excitation on the top floor  
B_un=inv(mass)*Bl;
G_un=dd*B_un;1

% Initial values
X(1:2*n,1)=zeros(2*n,1);  % Initial values of displacements and velocities
X(2*n+1:3*n,1)=1.0*10^2*ones(n,1); % Initial values of stiffness 
X(3*n+1:4*n,1)=ones(n,1); % Initial values of damping 

pk=zeros(4*n);
pk(1:2*n,1:2*n)=eye(2*n);  % Initial values for error covariance of matrix 
pk(2*n+1:3*n,2*n+1:3*n)=10^6*eye(n);  % Initial values of stiffness error covariance matrix
pk(3*n+1:4*n,3*n+1:4*n)=10^2*eye(n);  % Initial values of damping error covariance matrix 

Q=10^-10;
R=10^-1*eye(l); % measurement noise 
% Recursive Solution

%load force.mat

%f_un=force(:,2);
f_un(1)=0;
[stiff,damp,xkp,xcp]=kcm(n,X(:,1));
A=zeros(4*n);  % State transition matrix
A(1:n,n+1:2*n)=eye(n);
for k=1:ll-1;
% 状态方城  dX/dt=A*X+B_un*force; 
% 观测方城  Y=E*X+G_un*force
%求整体系数A、B_un、E、G_un
  

  
  A(n+1:2*n,1:4*n)=-inv(mass)*[stiff,damp,xkp, xcp];
  Fi=eye(4*n)+A*dt;
   
  %[Ad,Bd_un]=c2d(A,B_un,dt);
  
  hk=dd*inv(mass)*(-stiff*X(1:n,1)-damp*X(n+1:2*n,1));
  E=dd*A(n+1:2*n,1:4*n);
  
% The predicted extended state vector by numerical integration

  OPTIONS = [];
  pre=ode45(@predict,[dt*k dt*(k+1)],X(:,1),OPTIONS,n,f_un(1),B_un,mass); % Assume f_un is constant in [k*dt (k+1)*dt],dt must be small
  Xbk_1=pre.y(:,end);

  [X(:,2),pk_1]=klm(Xbk_1,pk,y(:,k),hk,f_un(1),Fi,E,G_un,R,Q);
%  [X(:,k+1),pk_1]=klm(Xbk_1,pk,y(:,k),hk,force(k,2),Fi,E,G_un,R,Q,k);
   pk=pk_1;
   
%     Ked=dlqe(Ad,Bd_un,E,Q,R);
%     X(:,k+1)=Xbk_1+Ked*(y(:,k)-(hk+G_un*f_un(k)));
   k
 [ X(2*n+1:4*n,1) X(2*n+1:4*n,2)];

% Estiamte the unkonw input by recusrive least squear estimation

  [stiff,damp,xkp,xcp]=kcm(n,X(:,2));
  
  hk_1=dd*inv(mass)*(-stiff*X(1:n,2)-damp*X(n+1:2*n,2));
  [f_un(2)]=rlse(y(:,k+1),hk_1,G_un,R);
%  f_un=detrend(f_un);
  f_un(1)=f_un(2);
  X(:,1)=X(:,2);
  
end

