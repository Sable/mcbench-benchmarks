function f=mpcsetup(A,B,C,D,p,m,Q,R,x0,u0)
% MPCSETUP  Set-up State Space MPC controller
%
%   SSMPC=MPCSETUP(A,B,C,D,P,M,Q,R,X0,U0) returns a function handle for a
%   state space model predictive control for the state space model
%   x(k+1) = Ax(k) + Bu(k)
%   y(k)   = Cx(k) + Du(k)
%   with predictive horizon, P and moving horizon M, performance weights of
%   output, Q and of input, R, initial state, X0 and initial control, U0.
%
%   SSMPC is the online controller, which can be called as follows 
%
%   U = SSMPC(Y,REF) returns the control input, U (nu by 1) according to
%   current measured output, Y (1 by ny) and future reference, REF (nr by
%   ny, nr>=1). 
%
%   The MPC minimize the following performance criterion:
%
%   J = min Y'QY + U'RU
%
%   The online controller is implemented as a nested function so that the
%   state of the internal model can be kept inside of the function. This
%   simplifies the input and output interface of the online controller.
%
% See also: mpc, dmc

% Version 1.0 by Yi Cao at Cranfield University on 20 April 2008

% Example: 2-CSTR model
%{
% Six-state model
A=[ 0.1555  -13.7665   -0.0604         0         0         0
    0.0010    1.0008    0.0068         0         0         0
         0    0.0374    0.9232         0         0         0
    0.0015   -0.1024   -0.0003    0.1587  -13.6705   -0.0506
         0    0.0061         0    0.0006    0.9929    0.0057
         0    0.0001         0         0    0.0366    0.9398];
Bu=[0.0001       0
         0       0
   -0.0036       0
         0  0.0001
         0       0
         0 -0.0028];
Bd=[      0         0
          0         0
     0.0013         0
          0         0
          0         0
          0    0.0008];
C=[0 362.995 0 0 0 0
   0 0 0 0 362.995 0];
D=zeros(2,2);
% Prediction horizon and moving horizon
p=10;
m=3;
% Performance wights
Q=1.5*eye(2*p);
R=eye(2*m);
% MPC set-up
ssmpc=mpcsetup(A,Bu,C,D,p,m,Q,R);
% Simulation length and variables for results
N=1500;
x0=zeros(6,1);
Y=zeros(N,2);
U=zeros(N,2);
% Predefined reference
T=zeros(N,2);
T(10:N,:)=1;
T(351:N,:)=3;
T(600:N,:)=5;
T(1100:N,:)=3;
% Simulation
for k=1:N
    % Process disturbances
    w=Bd*(rand(2,1)-0.5)*2;
    % Measurements noise
    v=0.01*randn(2,1);
    % actual measurement
    y=C*x0+v;
    % online controller
    u=ssmpc(y,T(k:end,:));
    % plant update
    x0=A*x0+Bu*u+w;
    % save results
    Y(k,:)=y';
    U(k,:)=u';
end
t=(0:N-1)*0.1;
subplot(211)
plot(t,Y,t,T,'r--','linewidth',2)
title('output and setpoint')
ylabel('temp, C^\circ')
legend('T_1','T_2','Ref','location','southeast')
subplot(212)
stairs(t,U,'linewidth',2)
legend('u_1','u_2','location','southeast')
title('input')
ylabel('flow rate, m^3/s')
xlabel('time, s')
%}

% Input and output check
error(nargchk(8,10,nargin));
error(nargoutchk(1,1,nargout));

% dimension of the system
nx=size(A,1);
[ny,nu]=size(D);

% precalculate the gain matrices of the online controller
[K,Pr] = predmat(A,B,C,D,p,m,Q,R);
% only the first instance is required
K1 = K(1:nu,:);
Pr = Pr(1:nu,:);

% default initial conditions
if nargin<9
    x0=zeros(nx,1);
end
if nargin<10
    u0=zeros(nu,1);
end

% the online controller
f = @ssmpc;
    function u=ssmpc(y,r)
        % update state
        x0 = A*x0 + B*u0;
        % get the reference
        nr=size(r,2);
        if nr>=p
            ref=r(:,1:p);
        else
            ref=[r r(:,end+zeros(p-nr,1))];
        end
        % model-plant mismatch
        offset = (y(:) - C*x0);
        % update optimal control
%         u0 = -K1*x0 + Pr*reshape(bsxfun(@minus,ref,offset),[],1);
        u0 = -K1*x0 + Pr*reshape(ref-offset(:,ones(p,1)),[],1);
        % controller output
        u = u0;
    end
end


function [K,Pr] = predmat(A,B,C,D,hP,hM,Q,R)
 
%%%% Initialise
[nx,nu]=size(B);
ny = size(C,1);

Gss = inv([A-eye(nx) B;C D]);
M1 = Gss(nx+1:end,nx+1:end);

Px=zeros(hP*ny,nx);  Pu=zeros(hP*ny,hP*nu);  P=C;
% L=eye(ny*hP);

%%%% Use recursion to find predictions
for i=1:hP;
   Puterm = P*B;
   for j=i:hP;
         vrow=(j-1)*ny+1:j*ny;
         vcol=(j-i)*nu+1:(j-i+1)*nu;
         Pu(vrow,vcol)=Puterm;
   end
   P=P*A;
   vrow=(i-1)*ny+1:i*ny;
   Px(vrow,1:nx) = P;
end
P=Px;
M=zeros(nu*hM,ny*hP);
for i=1:hM,
    I=(i-1)*nu+1:i*nu;
    J=(i-1)*ny+1:i*ny;
    M(I,J)=M1;
end

%%% Sum last columns of H
v=(hM-1)*nu;
HH=zeros(hP*ny,nu);
for k=1:nu;
    HH(:,k) = sum(Pu(:,v+k:nu:end),2);
end
H = [Pu(:,1:(hM-1)*nu),HH];

S = H'*Q*H+R;
S = (S+S')/2;
X1 = H'*Q*P;
X2 = -H'*Q-R*M;

%%%% Unconstrained control law
Mi=inv(S);
K = Mi*X1;
Pr = -Mi*X2;
end