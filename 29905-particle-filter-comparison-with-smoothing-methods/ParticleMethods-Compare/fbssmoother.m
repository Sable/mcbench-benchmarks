function [wstilda wstilda2,wstilda3]=fbssmoother(a,b,xf,wftilda)
[n,T]=size(xf);
%Initialize weights
wstilda(:,T)=wftilda(:,T);
for i=1:n
ws3(i,T)=wftilda(i,T)*weight(xf(i,T),xf(:,T),wstilda(i,T),wftilda(:,T),i,a,b);
end
wstilda3(:,T)=ws3(:,T)/sum(ws3(:,T));

for t=T-1:-1:1
%Compute smoother weights p(x(t))|Y)
for i=1:n
ws(i,t)=wftilda(i,t)*weight(xf(:,t+1),xf(:,t),wstilda(:,t+1),wftilda(:,t),i,a,b);
end
wstilda(:,t)=ws(:,t)/sum(ws(:,t));
%Compute joint smoother weight p(x(t),x(t+1)|Y) and p(x(t),x(t)|Y)
for i=1:n
ws2(i,t)=wftilda(i,t)*weight(xf(i,t+1),xf(:,t),wstilda(i,t+1),wftilda(:,t),i,a,b);
ws3(i,t)=wftilda(i,t)*weight(xf(i,t),xf(:,t),wstilda(i,t),wftilda(:,t),i,a,b);
end
wstilda2(:,t)=ws2(:,t)/sum(ws2(:,t));
wstilda3(:,t)=ws3(:,t)/sum(ws3(:,t));
end