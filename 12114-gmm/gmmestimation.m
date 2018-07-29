function [paraest,t_sta,V,it,Chi_sta,Pvalue]=gmmestimation(moment,para0,Y,X,Z,number,K)
%This program is for  GMM estimation
%input:
%moment: moment conditions function defined by users
%para0:initial value for estimated parameters
%Y,X:data used to estimate parameters
%Z: data for instrument variables
%number: maximum convergence number when choosing optimal weighting matrix
%K:number of moment conditions
%output:   
%paraest:parameters estimated
%t_sta: T statistics for each estimated parameter
%V:covariance matrix for estimated parameters
%it: number of iteration
%Chi_sta and Pvalue: overidentifying test, null hypothesis is moment
%conditions are feasible
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Edited by Cao Zhiguang
%E-mail:caozhiguang@21cn.com
%Date:2006/05/01
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%example
%to estimate the following model:Y=alpha+beta*X+eta
%moment conditions:[E(eta);E(X*eta)]=0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clear
%kk=1000;
%x=randn(kk,1);y=1+2*x+randn(kk,1)/3;z=[ones(kk,1),x];number=100;
%para0=[0;1];
%[paraest,t_sta,V]=gmmestimation('linearmodel01',para0,Y,X,Z,number,2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%moment conditions
%function f=linearmodel01(para,num,Y,X,Z,W)
%[T,q]=size(Y);
%alpha=para(1);beta=para(2);
%eta=[Y-(alpha+beta*X)];
%for i=1:T
   % m_t(i,:)=kron(eta(i,:),Z(i,:));
    %end
%m=mean(m_t)';
%obj=m'*W*m;
%if num==1
    %f=obj;
    %elseif num==2
    %f=m_t;
    %elseif num==3
    %f=m;
    %end
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%main code for GMM
nlag=round(size(Y,1)^(1/3));
W(:,:,1)=eye(K);
[para(:,1),fv(:,1)]=fminsearch(moment,para0,[],1,Y,X,Z,W(:,:,1));
for i=2:number
mom=feval(moment,para(:,i-1),2,Y,X,Z,W(:,:,i-1));
W(:,:,i)=gmmweightmatrix(mom,nlag);
[para(:,i),fv(:,i)]=fminsearch(moment,para(:,i-1),[],1,Y,X,Z,W(:,:,i));
if abs(fv(:,i)-fv(:,i-1))/abs(fv(:,i-1))<1e-4|fv(i)<=1e-15
  break
end
end 
it=i;
if it==number
    error('number of iteration exceeds defined maximium number')
else 
    paraest=para(:,it);
    f0=feval(moment,paraest,3,Y,X,Z,W(:,:,it));
    for j=1:length(para0)
        a=zeros(length(para0),1);
        eps=max(paraest(j)*1e-4,1e-5);
        a(j)=eps;
        M(:,j)=(feval(moment,paraest+a,3,Y,X,Z,W(:,:,it))-f0)/eps;
    end
end
V=pinv(M'*W(:,:,it)*M)/size(Y,1);
stderror=sqrt(diag(V));
t_sta=paraest./(stderror);
Chi_sta=size(Y,1)*fv(it);
Pvalue=1-chi2cdf(Chi_sta,K-length(para0));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%find the weight matrix using Newey and West method
function W=gmmweightmatrix(mom,nlag)
q=size(mom,2);T=size(mom,1);
a2=zeros(q,q);a3=zeros(q,q);
for j=1:nlag
    a1=zeros(q,q);
    for i=1:(T-j)
       a1=mom(i+j,:)'*mom(i,:)+a1;
    end
    S(:,:,j)=T/(T-q)*1/T*a1;
    a2=(1-j/(nlag+1))*S(:,:,j)+a2;
    a3=(1-j/(nlag+1))*S(:,:,j)'+a3;
end
b1=zeros(q,q);
for i=1:T
    b1=mom(i,:)'*mom(i,:)+b1;
end
if nlag==0
    newS=b1*T/(T-q)*1/T;
else 
    newS=a2+a3+b1*T/(T-q)*1/T;
end
W=pinv(newS);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%