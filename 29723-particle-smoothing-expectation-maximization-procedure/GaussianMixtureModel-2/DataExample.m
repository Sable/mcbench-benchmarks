clear all
close all
load edata.txt

y=edata';
y=y(1:600);
x=log(y/50);
T=length(y);
n=50; %Number of Particles
m=100; %Number of updates
p(1,:)=[.5,.5,.5,.5,.5,.5,.5];
for i=1:m 
X0=random('uniform',min(x),max(x),n,1);
%X0=[X01;X02];
tic
[xf,wftilda,wftilda2,wftilda3]=pfilterj(p(i,1),p(i,2),p(i,3),p(i,4),p(i,5),p(i,6),p(i,7),X0,y);
toc
%Estimation of filter and fbs smoother posterior means at time t
f(T)=xf(:,T)'*wftilda(:,T);
for t=1:T-1
f(t)=xf(:,t)'*wftilda(:,t);
e21(t)=(xf(:,t+1).*xf(:,t))'*wftilda2(:,t);
end
f2(i,:)=f;
ll(i)=likelihoodj(y,f,p(i,1),p(i,2),p(i,3),p(i,4),p(i,5),p(i,6),p(i,7))
p(i+1,:)=parametersfbs(xf,f,y,wftilda,wftilda2,wftilda3,p(i,:))
%p(i+1,:)=constraints(p(i+1,:));
end


for i=1:40
nm(i)=norm(my(p(i,3),f2(i,:))-y,'fro')/norm(y,'fro');
end

subplot(3,1,1)
hold on
plot(y,'k')
plot(my(p(end,3),f),':r')
xlabel('time')
ylabel('Price Level')
h = legend('Observed Price','Estimated Price');
subplot(3,1,2)
plot(nm)
xlabel('iteration')
ylabel('RMSE')
subplot(3,1,3)
plot(ll)
xlabel('iteration')
ylabel('Likelihood')