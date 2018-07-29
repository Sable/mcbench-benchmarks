function [psi,delta,xmap,wstilda4,wstilda5]=mapsmoother(a,b,c,d,X20,xf,wftilda,y)
[n,T]=size(xf);
%Initialization
delta(:,1)=X20;
%Recursion
for t=2:T
    for j=1:n
        delta(j,t)=log(normpdf(y(t),my(c,xf(j,t)),d))+max(delta(:,t-1)+log(normpdf(xf(j,t),mx(a,xf(:,t-1)),b)));
        [h,psi(j,t)]=max(delta(:,t-1)+log(normpdf(xf(j,t),mx(a,xf(:,t-1)),b)));
    end
end
%Termination
[m,iter(T)]=max(delta(:,T));
xmap(T)=xf(iter(T),T);

for i=1:n
ws5(i,T)=wftilda(i,T)*weight(xmap(T),xf(:,T),1,wftilda(:,T),i,a,b);
end
wstilda5(:,T)=ws5(:,T)/sum(ws5(:,T));
%Backtracking
for t=T-1:-1:1
   iter(t)=psi(iter(t+1),t+1);
   xmap(t)=xf(iter(t),t);
   
for i=1:n
ws4(i,t)=wftilda(i,t)*weight(xmap(t+1),xf(:,t),1,wftilda(:,t),i,a,b);
ws5(i,t)=wftilda(i,t)*weight(xmap(t),xf(:,t),1,wftilda(:,t),i,a,b);
end
wstilda4(:,t)=ws4(:,t)/sum(ws4(:,t));
wstilda5(:,t)=ws5(:,t)/sum(ws5(:,t));
end

