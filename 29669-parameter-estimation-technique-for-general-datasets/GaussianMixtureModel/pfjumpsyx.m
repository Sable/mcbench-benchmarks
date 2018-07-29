%Author: Moeti Ncube

%The programs simulates a 'spikey' data process given model specification of PDF files and parameters theta (to replicate spot power
%price movements). It then reestimates the simulated data using the
%proposed time indexed expectation maximization procedure.
clear
T=1000; %Number of Time Steps

%Mean and standard deviation of state equation
a=.6; b=.2;
%Mean and standard deviation of state equation
c=2; d=.2;
%jump and lambda
g=2; h=30; lambda=0.05;
theta=[a,b,c,d,g,h,lambda];

% Use these parameters to generate different types of datasets
%theta=[1,.02,0,0,0,0,]; %RW
%theta=[.5,.2,0,0,0,0,0];  %AR(1)
%theta=[.6,.2,0,0,(1-.6)*4,1,1]; %MR m=500 
%theta=[.6,.2,0,0,0,100,.5]; %SV
%theta=[.01,.2,0,0,5,20,.1]; %Spikes
%theta=[.99,.2,0,0,0,200,.1]; %Jumps

%Simulate the dynamical system x and y, initializing x(1)=x0
x0=rand;
[x,y,l]=simulatej(theta(1),theta(2),theta(3),theta(4),theta(5),theta(6),theta(7),x0,T);

%Initialize theta for estimation
theta=[.5,.5,.5,.5,.5,.5,.5];
%theta=rand(1,7)
for i=1:100

p(i,:)=theta

for t=2:T
p1(t)=theta(7)*normpdf(x(t),theta(1)*x(t-1)+theta(5),sqrt((1+theta(6)))*theta(2))/(theta(7)*normpdf(x(t),theta(1)*x(t-1)+theta(5),sqrt((1+theta(6)))*theta(2))+(1-theta(7))*normpdf(x(t),theta(1)*x(t-1),theta(2)));
p2(t)=1-p1(t);
end

sumx2x2p1=sum(x(2:end).*x(2:end).*p1(2:end));
sumx2x1p1=sum(x(2:end).*x(1:end-1).*p1(2:end));
sumx1x1p1=sum(x(1:end-1).^2.*p1(2:end));
sumx1p1=sum(x(1:end-1).*p1(2:end));
sumx2p1=sum(x(2:end).*p1(2:end));
sump1=sum(p1(2:end));

sumx2x2p2=sum(x(2:end).*x(2:end).*p2(2:end));
sumx2x1p2=sum(x(2:end).*x(1:end-1).*p2(2:end));
sumx1x1p2=sum(x(1:end-1).^2.*p2(2:end));
sumx1p2=sum(x(1:end-1).*p2(2:end));
sumx2p2=sum(x(2:end).*p2(2:end));
sump2=sum(p2(2:end));

%a
top=(1/((theta(6)+1)*theta(2)^2))*(sumx2x1p1-theta(5)*sumx1p1)+(1/theta(2)^2)*sumx2x1p2;
bot=(1/((theta(6)+1)*theta(2)^2))*sumx1x1p1+(1/theta(2)^2)*sumx1x1p2;
theta(1)=top/bot;
 
%b
first=sumx2x2p1-2*theta(5)*sumx2p1+sum(theta(5)^2*p1(2:end))-2*theta(1)*sumx2x1p1+2*theta(1)*theta(5)*sumx1p1+theta(1)^2*sumx1x1p1;
second=sumx2x2p2-2*theta(1)*sumx2x1p2+theta(1)^2*sumx1x1p2;
theta(2)=(((1/(theta(6)+1))*first+second)/(T-1))^.5;

%c
sumyy=sum(y(2:end).*y(2:end));
sumyfx=sum(y(2:end).*exp(x(2:end)));
sumfxfx=sum(exp(x(2:end)).^2);
theta(3)=sumyfx/sumfxfx;

%d
theta(4)=sqrt((sumyy-2*theta(3)*sumyfx+theta(3)^2*sumfxfx)/T);

%g
theta(5)=(sumx2p1-theta(1)*sumx1p1)/sum(p1(2:end));

%h
theta(6)=first/(theta(2)^2*sump1)-1;

%lambda
theta(7)=sump1/T;

ll(i)=likelihoodj(y,x,theta(1),theta(2),theta(3),theta(4),theta(5),theta(6),theta(7));

end

theta=[a,b,c,d,g,h,lambda];
for i=1:100
nm(i)=norm(p(i,:)-theta,'fro')/norm(theta,'fro');
end

subplot(1,3,1)
plot(y)
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


