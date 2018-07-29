function [xf,wftilda,wftilda2,wftilda3]=pfilterj(a,b,c,d,g,h,lambda,X0,y)
T=length(y);
n=length(X0);
xf(:,1)=X0;
wftilda(:,1)=1/n*ones(n,1);
for t=2:T
xf(:,t)=gaussmix(mx(a,xf(:,t-1)),b,mx([a,g],xf(:,t-1)),sqrt(1+h)*b,lambda);
%Compute and normalize filter weights
wf(:,t)=normpdf(y(t),my(c,xf(:,t)),d);
%Ensures a nonzero summation in denominator
[n1,val]=zerotest(y(t),my(c,xf(:,t)),wf(:,t));
wf(n1,t)=val;
wftilda(:,t)=wf(:,t)/sum(wf(:,t));
end

for i=1:n
wf3(i,T)=wftilda(i,T)*weight(xf(i,T),xf(:,T),wftilda(i,T),wftilda(:,T),i,a,b,g,h,lambda);
end
wftilda3(:,T)=wf3(:,T)/sum(wf3(:,T));

for t=T-1:-1:1
%Compute joint smoother weight p(x(t),x(t+1)|Y) and p(x(t),x(t)|Y)
for i=1:n
wf2(i,t)=wftilda(i,t)*weight(xf(i,t+1),xf(:,t),wftilda(i,t+1),wftilda(:,t),i,a,b,g,h,lambda);
wf3(i,t)=wftilda(i,t)*weight(xf(i,t),xf(:,t),wftilda(i,t),wftilda(:,t),i,a,b,g,h,lambda);
end

%Ensures a nonzero summation in denominator
if sum(wf2(:,t))==0;
wftilda2(:,t)=1/n*ones(n,1);
else
wftilda2(:,t)=wf2(:,t)/sum(wf2(:,t));
end

if sum(wf3(:,t))==0;
wftilda3(:,t)=1/n*ones(n,1);
else
wftilda3(:,t)=wf3(:,t)/sum(wf3(:,t));
end

end