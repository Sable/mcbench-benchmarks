function [Results,u_star2,t,Q,K,tset]=...
    Arm_1DOF_LinearQuadRegulator_Fun(StartAngle,Stable,I,l_c)
% this suggests an initial solution for the inverted pendulium problem
%Stable 1 hanging pendulium, -1 inverted
%StartAngle given in degrees

%system parameters
m=1; %mass of plumb, kg
g=9.806; %gravity, m/sec^2
% I and l_c are now set by input
u_max=7;
SettlingPercent=2e-3;

% simumation parameters
X_0=[StartAngle(1),0].'*pi/180; %intial value
t0=0;
tf=1;
T=linspace(t0,tf,1000);

% I*theta_ddot = -m*g*l_c*sin(theta)+u 
% regular pendulium
% linearizing about 0 for now
A = [0 1; -Stable*m*g*l_c/I, 0]; 
B=[0; 1/I];

% the trick is to find the size Q needs to be to get the desired settling
% time
QFind=@(Q) SettleTime(Q,A,B,tf,Stable,m,g,l_c,I,u_max,X_0,SettlingPercent);
kimmy=logspace(-3,10,30);
kimmyTime=zeros(size(kimmy));
for liz=1:length(kimmy)
    kimmyTime(liz)=QFind(kimmy(liz));
end

Q1=find(kimmyTime<tf,1,'first');
if isempty(Q1)
options = optimset('Display','off','LargeScale','off');
[dummy,Q2]=min(kimmyTime);
Q = fminunc(@(Q) QFind(Q),Q2,options);
elseif Q1==1 
    % for the inverted pendulium, the gain required to stabilize the system
    % may be sufficient to surpass the settling requirement
    Q=1e-3;
else    
options = optimset();
Q = fzero(@(Q) QFind(Q)-tf,[kimmy(Q1-1),kimmy(Q1)],options);
end
K=lqr(A,B,diag([Q,0]),1,0);
tset=QFind(Q);

Dynamics=@(t,x) [x(2); -Stable*(m*g*l_c/I)*sin(x(1))+-sign(K*x(:))*min([abs(K*x(:)),u_max])/I];
[t,Results]=ode45(Dynamics,T,X_0);
u_star2=-(K*(Results.')).';
u_star2(abs(u_star2)>u_max)=sign(u_star2(abs(u_star2)>u_max))*u_max;
end

function ts=SettleTime(Q,A,B,tf,Stable,m,g,l_c,I,u_max,X_0,SettlingPercent)
K=lqr(A,B,diag([Q,0]),1,0);

Dynamics=@(t,x) [x(2); -Stable*(m*g*l_c/I)*sin(x(1))+-sign(K*x(:))*min([abs(K*x(:)),u_max])/I];
[t,Results]=ode45(Dynamics,linspace(0,tf*2,1000),X_0);
Energy=(g/l_c)*(1-cos(Results(:,1)))+1/2*Results(:,2).^2;
% not energy for inverted pendulum (since energy is stored), but should
% give a resonable measure of how it's settled, It will be unnecessarily
% large for inverted.
temp=find(abs(Energy)>=SettlingPercent*Energy(1),1,'last');
ts=t(temp);
end