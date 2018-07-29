%MARCH 26, 2009
%Program for Orthogonal Least Square Algorithm used in Radial Basis
%Functions (RBF) Neural Networks for Function Approximation.
%Max tolerance input is taken from user and Activation function for 
%Hidden Neurons is Gaussian (kernel function).

%Refer to S.Chen, C.F.N Cowan, and P.M. Grant 
%IEEE trans. on Neural-Networks vol. 2 (1991) pp 302-309 
%for more info on OLS Algorithm

%Contact me: anshuman0387[at]yahoo[dot]com


%Ms significant regressors are choosen out of the total regressors M

clc,clear all,close all;
sig=1.1;                                                               %Sigma for gaussian function is fixed to 1.1
tol=input('Enter max expected error (Emax) ');      %Enter max unexplained variance
a=linspace(-1,1,10);
b=1+exp(-a);                                                       %Function to be approximated is b

d=b';                                                                    %Target ouput is d   
[ar,ac]=size(a);
for i=1:ac
    for j=1:ar
        C(i,j)=a(j,i);                                                 % All test data centres are initial regressors
    end
end

dis=dist(C,a);                                  
for i=1:ac
    for j=1:ac
        P(i,j)=kernel(dis(i,j),sig);                              %Output of each nneuron in the hidden layer
    end
end

[M,N]=size(P);                                                    %M-no of nodes in hidden layer. N- No. of training data vectors    
P=P';
P
k=1;
e=tol+1;                                                              %Initial e is greater than tolerance  

for i=1:M
    p=P(:,i);
    w1=p;
    g(1)=(w1'*d)/(w1'*w1);            
    err(i)=(g(1)^2)*(w1'*w1)/(d'*d);                          
end
[maxerr(k),maxi(k)]=max(err);
W(:,k)=P(:,maxi(k));


while e>=tol
    e=0;
    k=k+1;
    for i=1:M
         if i~=maxi
             p=P(:,i);
             sum=0;
             for j=1:k-1
                 wj=W(:,j);
                  alph(j,k)=(wj'*p)/(wj'*wj);
                  sum=sum+alph(j,k)*wj;
             end
             wk=p-sum;
             w(:,i)=wk;
             g(k)=(wk'*d)/(wk'*wk);
             err(i)=(g(k)^2)*(wk'*wk)/(d'*d);             
         else
             err(i)=0;
             continue
         end         
    end
    [maxerr(k),maxi(k)]=max(err);
    W(:,k)=w(:,maxi(k));
    for j=1:k
        e=e+maxerr(j);
    end
    e=1-e;
end

g=g';

Error=d-W*g                                                      %Error for each training vector???


%This algorithm is not giving good results. Error for training data set is not as expected.
%Am I doing something wrong???

%Contact me:anshuman0387[at]yahoo[dot]com. 
%Any suggestions would be of great help!