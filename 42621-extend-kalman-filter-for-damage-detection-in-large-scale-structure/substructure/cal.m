clear all;

dt=input('Time step  ');

% Input forces
%S=input('Force intensity of white noise   ');
S=75000.0;

%Duration=input('Time duration  ');
Duration=1;

for nipinghe=1:3
SeedNum=input('Input the seed number  ');
%Filter index
Findx=1;
%Filter index =1 -  use a filter to handle the direct pass-through problem. 

% ***** Generate white noise
randn('state',SeedNum);
t=[dt:dt:Duration]';
Nt=length(t);

if Findx==1
   filter_order = 6;
   filter_cutoff = 20; %Hz
   [filt_num,filt_den] = butter(filter_order,filter_cutoff*2*dt);
   Nt2=Nt+2*filter_order;
else
   Nt2=Nt;
end;

ff=S*randn(Nt2,1)./dt^0.5;

if Findx==1
   ff= filter(filt_num,filt_den,ff);
   ff= ff(Nt2-Nt+1:end,:);
end;

force(1,:)=0;
force(2:Nt+1,1)=t;
force(2:Nt+1,nipinghe+1)=ff;


end


save force.mat force

%Noise level
nl=input('noise level  ');

%The 10-DOF Linear System

% cleaer all;
%dt=input('Time step  ');  

n=20;

%求整体结构的质量和刚度矩阵
% M=2*10^6*eye(n);
% k=3.23*10^8*ones(n,1);

% Yang Wang's model
m=10^6*[1.1 1.1 1.1 1.1 1.1 1.1 1.1 1.1 1.1 1.1 1.1 1.1 1.1 1.1 1.1 1.1 1.1 1.1 1.1 1.1];
mass=diag(m);
k=10^6*[862.07*ones(1,5) 554.17*ones(1,6) 453.51*ones(1,3) 291.23*ones(1,3) 256.46*ones(1,2) 171.70];;


stiff=zeros(20);
stiff(20,20)=k(20);stiff(20,19)=-k(20);stiff(1,1)=k(1)+k(2);stiff(1,2)=-k(2);
for i=2:19
    stiff(i,i)=k(i)+k(i+1);
    stiff(i,i+1)=-k(i+1);
    stiff(i,i-1)=-k(i);
end

damprate=0.05;
w=sqrt(eig(stiff,mass));
a0=2*damprate/(w(1)+w(2))*w(1)*w(2)
a1=2*damprate/(w(1)+w(2))
damp=a0*mass+a1*stiff;
   
% State transition matrix
A=zeros(2*n);
A(1:n,n+1:2*n)=eye(n);
A(n+1:2*n,1:n)=-inv(mass)*stiff;
A(n+1:2*n,n+1:2*n)=-inv(mass)*damp;
   
Bl=zeros(n,3);
Bl(1,1)=1.0;  % Input Force at the top floor
Bl(5,2)=1.0;
Bl(18,3)=1.0;
B=[zeros(n,3); inv(mass)*Bl];

% initial condition
X0=zeros(2*n,1);   % initial conditions
[Y,X]=lsim(A,B,A,B,force(:,2:end),force(:,1));

% Acceleration response
acc=Y(:,n+1:2*n);

% Add measurement noise
% calculate the rms of all measurements
ll=length(acc(:,1));
for i=1:n
   noise=randn(ll,1);
   accn(:,i)=acc(:,i)+nl/100*std(acc(:,i))*noise;
end;

save response.mat accn  
save xstate.mat X 
  