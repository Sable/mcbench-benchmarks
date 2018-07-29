function [theta,P,e]=nnukf(theta,P,x,y,Q,R)
% NNUKF     A function using the UKF to training a MLP NN
% [theta,P,z]=nnukf(theta,P,x,y,Q,R) searches the optimal parameters, theta 
% of  a MLP NN based on a set of training data with input x and output y.
% Input:
%   theta: initial guess of MLP NN parameter. The network structure is
%   determined by the number of parameters, ns, the number of inputs (size of
%   x),nx and the number of output (size of y), ny. The euqation of the NN
%   is: y = W2 * tanh( W1 * x + b1) + b2, and theta = [W1(:);b1;W2(:);b2].
%   Therefore, ns = nx * nh + nh + nh * ny + ny, which gives the number of
%   hidden nodes is nh = (ns - ny) / (nx + ny + 1);
%   P: the covariance of the initial theta. Needs to be tuned to get good
%   training performance.
%   x and y: input and output data for training. For batch training, x and
%   y should be arranged in such a way that each observation corresponds to 
%   a column.
%   Q: the virtual process covariance for theta, normally set to very small
%   values.
%   R: the measurement covariance, dependen on the noise level of data, tunable. 
%
% Example: a NN model to approximate the sin function
%{
rand('state',0)
randn('state',0)
N=20;
Ns=100;
x=1.2*randn(N,Ns);
y=sin(x)+0.1*randn(N,Ns);
z=y;
nh=4;
ns=nh*2+nh+1;
theta=randn(ns,1);
P=diag([100*ones(1,nh*2) 1000*ones(1,nh+1)]);
Q=0.0001*eye(ns);
R=100*eye(Ns);
% alpha=0.8;
T1=1:N/2;
for k=T1
    [theta,P,z(k,:)]=nnukf(theta,P,x(k,:),y(k,:),Q,R);
end
W1=reshape(theta(1:nh*2),nh,[]);
W2=reshape(theta(nh*2+1:end),1,[]);
T2=N/2+1:N;
for k=T2
    z(k,:)=W2(:,1:nh)*tanh(W1(:,1)*x(k,:)+W1(:,2+zeros(1,Ns)))+W2(:,nh+ones(1,Ns));
end
subplot(211)
plot(x(T1,:),y(T1,:),'ob',x(T1,:),z(T1,:),'.r')
title('training results')
subplot(212)
plot(x(T2,:),y(T2,:),'ob',x(T2,:),z(T2,:),'.r')
title('testing results')
%}
%
% By Yi Cao at Cranfield University on 10 January 2008
%

f=@(u)u;
h=@(u)nn(u,x,size(y,1));
[theta,P]=ukf(f,theta,P,h,y(:),Q,R);
e=h(theta);


function y=nn(theta,x,ny)
[nx,N]=size(x);
ns=numel(theta);
nh=(ns-ny)/(nx+ny+1);
W1=reshape(theta(1:nh*(nx+1)),nh,[]);
W2=reshape(theta(nh*(nx+1)+1:end),ny,[]);
y=W2(:,1:nh)*tanh(W1(:,1:nx)*x+W1(:,nx+ones(1,N)))+W2(:,nh+ones(1,N));
y=y(:);

