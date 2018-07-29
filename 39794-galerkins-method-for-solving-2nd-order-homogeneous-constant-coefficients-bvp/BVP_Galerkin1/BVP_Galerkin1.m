%The purpose of this program is to implement Galerkin method over 
% the entire domain for solving the following general 2nd order, 
% homogeneous, Boundary Value problem (BVP) with constant coefficients, and
% then comparing the answer with the exact solution.
%==========================================================================
%               ax"(t)+bx'(t)+cx(t)=0 for t1<=t<=t2
%                   BC: x(t1)=x1 and x(t2)=x2
% >> BVP_Galerkin1(a,b,c,t1,t2,x1,x2,n)
% where "n" is the number of trial functions
% The output of this program is 
% 1- The approximated solution of x(t) vs. exact solution of x(t)
% 2- The approximated x'(t) vs. exact x'(t)
% 3- The approximated x"(t) vs. exact x"(t)
% ======Example============================================================
% Equation                  x"(t)+ x'(t)+ x(t)=0
% Boundary values           x(1)=2,     x(10)=0;
% Solution: We have:
%                           a=1;    b=1;   c=1;
%                           t1=1;       t2=10;          
%                           x1=2;       x2=0;
% Using n=8 tiral functions,
% >>BVP_Galerkin(1,2,3,1,10,2,0,8)
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%                   October.26, 2010, Ramin Shamshiri  
%                       ramin.sh@ufl.edu
%            Doctoral student at the University of Florida
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function BVP_Galerkin1(a,b,c,t1,t2,x1,x2,n) % Declare function
dt=0.001; % increment
%% Begin Approximate solution via Galerkin method over the entire domain


for i=1:n
    for j=1:n
    K1(i,j)=(i*j)*(t2^(j+i-1)-t1^(j+i-1))/(i+j-1);          % K1 matrix corresponding to the x"(t)
    K2(i,j)=j*((t2^(i+j))-(t1^(i+j)))/(i+j);                % K2 matrix corresponding to the x'(t)
    K3(i,j)=(t2^(i+j+1)-(t1^(i+j+1)))/(i+j+1);              % K3 matrix corresponding to the x(t)
    end
end
% Overall Matrix
K=-a*K1+b*K2+c*K3;

%Applying boundary conditions and Solving nxn system of equations 
for i=1:n-1
     for j=1:n
         A(i,j)=K(i,j)+((j*a*t2^(j+i-1))-(j*a*t1^(j+i-1)));
       
     end
end

%Applying boundary conditions
for j=1:n
    A(n-1,j)=(t1^j);
    A(n,j)=(t2^j);
end

for i=1:n-1
    B(i,1)=0;
end
B(n-1,1)=x1;
B(n,1)=x2;

C=inv(A)*B; % Ci: Coefficients of terms 

t=t1:dt:t2;
t=t'; 
% Creating vertical axis values, x(t)
x=  zeros((t2-t1)/dt+1,1);
for i=1:(t2-t1)/dt+1
    for j=1:n
        x(i,1)=x(i,1)+ C(j,1)*(t(i,1)^j);
    end
end

% calculating x'(t)
dx=zeros((t2-t1)/dt+1,1);
for i=2:(t2-t1)/dt+1
    dx(i,1)=(x(i)-x(i-1))/dt;
end
% calculating x"(t)
d2x=zeros((t2-t1)/dt+1,1);
for i=3:(t2-t1)/dt+1
    d2x(i,1)=(dx(i)-dx(i-1))/dt;
end

 figure1 = figure('Color',[1 1 1]); 
% Plotting approximate solution via Galerkin method over the entire domain
subplot(3,1,1,'Parent',figure1);
% Plotting the Approximate solution in green (Galerkin method over the entire domain)
plot(t,x,'-.', 'Color','r', 'LineWidth',2), grid on; hold on; 
% Plotting the approximate dx
subplot(3,1,2,'Parent',figure1);
plot(t,dx, '-.', 'Color','r', 'LineWidth',2), grid on; hold on; 
% Plotting the approximate d2u
subplot(3,1,3,'Parent',figure1);
plot(t,d2x, '-.', 'Color','r', 'LineWidth',2), grid on; hold on; 
%% End of approximate solution via Galerkin method over the entire domain




%% ==============Begin Calculating Exact Soution========================== 
r=roots([a b c]);   % Roots of auxiliary equation
r1=r(1);  r2=r(2);

% Bulding t-axis values
t=t1:dt:t2; t=t'; 
s=size(t);

% Bulding x(t) axis values
x=zeros(s(1),1);
if r1==r2   % For critically damped case
    
    C=inv([exp(r1*t1)  t1*exp(r2*t1);exp(r1*t2)  t2*exp(r2*t2)])*([x1;x2]);
    C1=C(1);
    C2=C(2);
    
    for i=1:s(1)
        x(i)=C1*exp(r1*t(i))+C2*t(i)*exp(r2*t(i));
    end
    
else        % For Under-damped or Over-damped case
    
    C=inv([exp(r1*t1) exp(r2*t1);exp(r1*t2) exp(r2*t2)])*([x1;x2]);
    C1=C(1);
    C2=C(2);
        
    for i=1:s(1)
        x(i)=C1*exp(r1*t(i))+C2*exp(r2*t(i));
    end
end

% calculating x'(t)
dx=zeros(s(1),1);
for i=2:s(1)
    dx(i,1)=(x(i)-x(i-1))/dt;
end

% calculating x"(t)
d2x=zeros(s(1),1);
for i=3:s(1)
    d2x(i,1)=(dx(i)-dx(i-1))/dt;
end

% Plotting Exact solution 
subplot(3,1,1,'Parent',figure1);
% Plotting the exact solution x(t) in blue
plot(t,x, 'Color','b', 'LineWidth',2); 
xlabel('Time (sec)','FontSize',12);
ylabel('x(t) (m)','FontSize',12);
legend1 = legend(subplot(3,1,1),'show');
legend('Approximate x(t)','Exact x(t)')

% Plotting the exact solution x'(t) in blue
subplot(3,1,2,'Parent',figure1);
plot(t,dx, 'Color','b', 'LineWidth',2); 
xlabel('Time (sec)','FontSize',12);
ylabel('dx/dt (m/s)','FontSize',12);
legend1 = legend(subplot(3,1,2),'show');
legend('Approximate dx(t)','Exact dx(t)')

% Plotting the exact solution x"(t) in blue
subplot(3,1,3,'Parent',figure1);
plot(t,d2x, 'Color','b', 'LineWidth',2);
xlabel('Time (sec)','FontSize',12);
ylabel('d^2x/dt^2 m/s^2','FontSize',12);
legend1 = legend(subplot(3,1,3),'show');
legend('Approximate d2x(t)','Exact dx(t)')
clc
%% =====================End of exact solution============================== 



