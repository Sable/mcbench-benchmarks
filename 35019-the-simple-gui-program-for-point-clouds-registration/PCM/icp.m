%output: data2- register data set 
%err-root mean square error
%k-number of iteration 
function [R, t,corr,data2,TX,RX,M,S,err,NN,NNC,K,VV] = icp(data1, data2, tol)
% [R, t, corr, data2] = icp(data1, data2, tol)
%
% This is an implementation of the Iterative Closest Point (ICP) algorithm.
% The function takes two data sets and registers data2 with data1. It is
% assumed that data1 and data2 are in approximation registration. The code
% iterates till no more correspondences can be found.
%
% Arguments: data1 - 3 x n matrix of the x, y and z coordinates of data set 1
%            data2 - 3 x m matrix of the x, y and z coordinates of data set 2
%            tol   - the tolerance distance for establishing closest point
%                     correspondences
%
% Returns: R - 3 x 3 accumulative rotation matrix used to register data2
%          t - 3 x 1 accumulative translation vector used to register data2
%          corr - p x 2 matrix of the index no.s of the corresponding points of
%                 data1 and data2
%          data2 - 3 x m matrix of the registered data2 
%
% Copyright : This code is written by Ajmal Saeed Mian {ajmal@csse.uwa.edu.au}
%              Computer Science, The University of Western Australia. The code
%              may be used, modified and distributed for research purposes with
%              acknowledgement of the author and inclusion this copyright information.

c1 = 0;
c2 = 1;
R = eye(3);
t = zeros(3,1);
tri = delaunayn(data1');
K=0;
TX=[];
RX=[];
err=[];
NN=[];
NNC=[];
while c2 > c1   
%while c2 < c1
%disp(c1)
%disp(c2)
    c1 = c2;
    K=K+1;
    NNC(K)=c2;
    fprintf('%.d Iteration\n',K)
    [corr, D] = dsearchn(data1', tri, data2');
    corr(:,2) = [1 : length(corr)]';
   ii = find(D > tol);
   corr(ii,:) = [];
    [R1, t1,M,S,N] = reg(data1, data2, corr);
  
    data2 = R1*data2;
    data2 = [data2(1,:)+t1(1); data2(2,:)+t1(2); data2(3,:)+t1(3)];
    R = R1*R;
    t = R1*t + t1;   
    TX(K)=R(1,1);
    RX(K)=t(1,1);
    c2 = length(corr);  
    NN(K)=N;
    
 V=rms(M,S);
 VV(K)=rms(M,S);
 err(K)=sqrt(V);
 %c2=V;
 
end

%-----------------------------------------------------------------
function [R1, t1,M,S,n] = reg(data1, data2, corr)
n = length(corr); 
M = data1(:,corr(:,1)); 
mm = mean(M,2);
S = data2(:,corr(:,2));
ms = mean(S,2); 
Sshifted = [S(1,:)-ms(1); S(2,:)-ms(2); S(3,:)-ms(3)];
Mshifted = [M(1,:)-mm(1); M(2,:)-mm(2); M(3,:)-mm(3)];
K = Sshifted*Mshifted';
K = K/n;
[U A V] = svd(K);
R1 = V*U';
if det(R1)<0
    B = eye(3);
    B(3,3) = det(V*U');
    R1 = V*B*U';
end
t1 = mm - R1*ms;
%function 
function V=rms(M,S)

M=M';
S=S';

dp=ones(length(M),1);
for i=1 : length(M)
    dp(i,1)=distance(M(i,1),M(i,2),M(i,3),S(i,1),S(i,2),S(i,3));
end
JK=ones(length(M),1);
for i=1 : length(M)
JK(i,1)=dp(i,1)^2;
end
V=sum(JK)/length(M);
function dist=distance(X1,Y1,Z1,X2,Y2,Z2)
X=(X2-X1)^2;
Y=(Y2-Y1)^2;
Z=(Z2-Z1)^2;
dist=sqrt(X+Y+Z);
