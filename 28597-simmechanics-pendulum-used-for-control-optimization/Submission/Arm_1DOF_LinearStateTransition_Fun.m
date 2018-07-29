function [Results,u_star2,t]=Arm_1DOF_LinearStateTransition_Fun(StartAngle,Stable,I,l_c)
% this suggests an initial solution for the pendulium problem
%Stable 1 hanging pendulium, -1 inverted
%StartAngle given in degrees

%system parameters
m=1; %mass of plumb, kg
g=9.806; %gravity, m/sec^2
% I and l_c are now set by input

% simumation parameters
X_0=[StartAngle(1),0].'*pi/180; %intial value
X_F=[0,0].'*pi/180; %final value
t0=0;
tf=1;
T=linspace(t0,tf,1000);
T_2=[T, T(end)+(0.0001:0.01:0.1)];

% I*theta_ddot = -m*g*l_c*sin(theta)+u 
% regular pendulium
% linearizing about theta=0 for now
A = [0 1; -Stable*m*g*l_c/I, 0]; 
B=[0; 1/I];

% W_c_fun=@(t) expm(A*t(n))*B*(B.')*expm(A.'*t(n));
% Written as subroutine below
temp11= quad(@(timein) W_c_fun(timein,A,B,1,1),t0,tf);
temp21= quad(@(timein) W_c_fun(timein,A,B,2,1),t0,tf);
temp12= quad(@(timein) W_c_fun(timein,A,B,1,2),t0,tf);
temp22= quad(@(timein) W_c_fun(timein,A,B,2,2),t0,tf);
W_c= [temp11, temp12; temp21, temp22];

u_pre=-B.';
u_post=(W_c\(expm(tf*A)*X_0-X_F));
u_star=zeros(size(T_2));
for alice=1:length(T)
u_star(alice)=u_pre*expm(A.'*(tf-T(alice)))*u_post;
end

Dynamics=@(t,x) [x(2); -Stable*(m*g*l_c/I)*sin(x(1))+...
    (sign(interp1(T_2,u_star,t,'pchip'))*min([abs(interp1(T_2,u_star,t,'pchip')),7]))/I];
[t,Results]=ode45(Dynamics,T_2,X_0);
% Apply saturation
u_star2=sign(interp1(T_2,u_star,t,'pchip')).*...
    min(abs(interp1(T_2,u_star,t,'pchip')),7);
end

function temp = W_c_fun(t,A,B,WhichRow,WhichCol)
temp=zeros([1,length(t)]); 
for n=1:length(t)
    temp1=expm(A*t(n))*B*(B.')*expm(A.'*t(n));
    temp(n)=temp1(WhichRow,WhichCol);
end
end

