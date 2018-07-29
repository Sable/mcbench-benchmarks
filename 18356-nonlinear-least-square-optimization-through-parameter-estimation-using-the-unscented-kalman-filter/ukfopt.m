function [x,e]=ukfopt(h,x,tol,P,Q,R)
%UKFOPT     Unconstrained optimization using the unscented Kalman filter
%
%       [x,e]=ukfopt(f,x,tol,P,Q,R) minimizes e=norm(f(x)) until e<tol. P, Q
%       and R are tuning parmeters relating to the Kalman filter
%       performance. P and Q should be n x n, where n is the number of 
%       decision variables, while R should be m x m, where m is the 
%       dimension of f. Normally, Q and R should be set to d*I e*I where 
%       both d and e are vary small positive scalars. P could be initially 
%       set to a*I where a is the estimated distence between the initial 
%       guess and the optimal valuve. This function can also be used to solve 
%       a set of nonlinear equation, f(x)=0.
%
% This is an example of what a nonlinear Kalman filter can do. It is
% strightforward to replace the unscented Kalman filter with the extended 
% Kalman filter to achieve this same functionality. The advantage of using 
% the unscented Kalman filter is that it is derivative-free. Therefore, it 
% is also suitable for non-analytical functions where no derivatives can 
% be obtained.
%
% Example 1: The Rosenbrock's function is solved within 100 iterations
%{
f=@(x)100*(x(2)-x(1)^2)^2+(1-x(1))^2;
x=ukfopt(f,[2;-1],1e-9,0.45*eye(2))
%}
% Example 2: Solver a set of nonlinear equations represented by MLP NN
%{
rand('state',0);
n=3;
nh=4;
W1=rand(nh,n);
b1=rand(nh,1);
W2=rand(n,nh);
b2=rand(n,1);
x0=zeros(n,1);
f=@(x)W2*tanh(W1*x+b1)+b2;
tol=1e-6;
P=1000*eye(n);
Q=1e-7*eye(n);
R=1e-6*eye(n);
x=ukfopt(f,x0,tol,P,Q,R);
%}
% Example 3: Training a MLP NN. You may have to try several time to get
% results. The best way is to use nnukf.
%{
rand('state',0)
randn('state',0)
N=100;        %training data length
x=randn(1,N); %training data x
y=sin(x);     %training data y=f(x)
nh=4;         %MLP NN hiden nodes
ns=2*nh+nh+1;
f=@(z)y-(z(2*nh+(1:nh))'*tanh(z(1:nh)*x+z(nh+1:2*nh,ones(1,N)))+z(end,ones(1,N)));
theta0=rand(ns,1);
theta=ukfopt(f,theta0,1e-3,0.5*eye(ns),1e-7*eye(ns),1e-6*eye(N));
W1=theta(1:nh);
b1=theta(nh+1:2*nh);
W2=theta(2*nh+(1:nh))';
b2=theta(ns);
M=200;         %Test data length
x1=randn(1,M);
y1=sin(x1);
z1=W2*tanh(W1*x1+b1(:,ones(1,M)))+b2(:,ones(1,M));
plot(x1,y1,'ob',x1,z1,'.r')
legend('Actual','NN model')
%}
%
% By Yi Cao at Cranfield University, 08 January 2008
%

n=numel(x);     %numer of decision variables
f=@(x)x;        %virtual state euqation to update the decision parameter
e=h(x);         %initial residual
m=numel(e);     %number of equations to be solved
if nargin<3,    %default values
    tol=1e-9;
end
if nargin<4
    P=eye(n);
end
if nargin<5
    Q=1e-6*eye(n);
end
if nargin<6
    R=1e-6*eye(m);
end
k=1;            %number of iterations
z=zeros(m,1);   %target vector
ne=norm(e);
while ne>tol
    [x,P]=ukf(f,x,P,h,z,Q,R);               %the unscented Kalman filter
    e=h(x);
    ne=norm(e);                                 %residual
    if mod(k,100)==1
        fprintf('k=%d e=%g\n',k,ne)    %display iterative information
    end
    k=k+1;                                  %iteration count
end
fprintf('k=%d e=%g\n',k,ne)            %final result
