clear all
close all
T=200; %Number of Time Steps
n=1000; %Number of Particles
m=100;
%Parameters
a=.6; b=.2; c=2; d=.2; g=.5; h=1; lambda=.15;
p0=[a,b,c,d,g,h,lambda];

%Simulate the dynamical system x and y, initializing x(1)=x0
x0=rand;
[x,y,l]=simulatej(p0(1),p0(2),p0(3),p0(4),p0(5),p0(6),p0(7),x0,T);

%p(1,:)=[a,b,c,d,g,h,lambda];
%p(1,:)=[.5,.1,.2,.2,1,.5,.1]; %works
p(1,:)=[.5,.5,.5,.5,.5,.5,.5];
for i=1:m 
%X01=random('uniform',0,1.5,(4*n/5),1);
%X02=random('uniform',1.5,2.5,(n/5),1);
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
p(i+1,:)=constraints(p(i+1,:));
end


theta=[a,b,c,d,g,h,lambda];
for i=1:100
nm(i)=norm(p(i,:)-theta,'fro')/norm(theta,'fro');
end
subplot(1,3,1)
plot(y,'k','LineWidth',2)
hold on
plot(my(p(end,3),f),'-b*')
xlabel('time')
ylabel('Price Level')
subplot(1,3,2)
plot(nm)
xlabel('iteration')
ylabel('RMSE')
subplot(1,3,3)
plot(ll)
xlabel('iteration')
ylabel('Likelihood')

norm(y-my(p(end,3),f),'fro')/norm(y,'fro');