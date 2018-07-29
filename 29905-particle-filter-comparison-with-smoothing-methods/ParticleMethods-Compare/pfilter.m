function [xf,wftilda]=pfilter(a,b,c,d,X0,y)
T=length(y);
n=length(X0);
xf(:,1)=X0;
wftilda(:,1)=1/n*ones(n,1);
for t=2:T
xf(:,t)=random('normal',mx(a,xf(:,t-1)),b);
%Compute and normalize filter weights
wf(:,t)=normpdf(y(t),my(c,xf(:,t)),d);
%Ensures a nonzero summation in denominator
[n1,val]=zerotest(y(t),my(c,xf(:,t)),wf(:,t));
wf(n1,t)=val;
wftilda(:,t)=wf(:,t)/sum(wf(:,t));
end