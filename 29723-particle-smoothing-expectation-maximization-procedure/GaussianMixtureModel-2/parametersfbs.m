function [p,ll]=parametersfbs(xf,xs,y,wstilda,wstilda2,wstilda3,p)
T=length(xf(1,:));

for t=2:T
ep1(t)=p(7)*normpdf(xs(t),p(1)*xs(t-1)+p(5),sqrt((1+p(6)))*p(2))/(p(7)*normpdf(xs(t),p(1)*xs(t-1)+p(5),sqrt((1+p(6)))*p(2))+(1-p(7))*normpdf(xs(t),p(1)*xs(t-1),p(2)));
ep2(t)=1-ep1(t);
end

e11(T)=(xf(:,T).*xf(:,T))'*wstilda3(:,T);
for t=1:T-1
e21(t)=(xf(:,t+1).*xf(:,t))'*wstilda2(:,t);
e11(t)=(xf(:,t).*xf(:,t))'*wstilda3(:,t);
eyf(t+1)=exp(xf(:,t+1))'*wstilda(:,t+1);
eff(t+1)=exp(2*xf(:,t+1))'*wstilda(:,t+1);
end

esumx2x2p1=sum(e11(2:end).*ep1(2:end));
esumx2x1p1=sum(e21.*ep1(2:end));
esumx1x1p1=sum(e11(1:end-1).*ep1(2:end));
esumx1p1=sum(xs(1:end-1).*ep1(2:end));
esumx2p1=sum(xs(2:end).*ep1(2:end));
esump1=sum(ep1(2:end));

esumx2x2p2=sum(e11(2:end).*ep2(2:end));
esumx2x1p2=sum(e21.*ep2(2:end));
esumx1x1p2=sum(e11(1:end-1).*ep2(2:end));


top=(1/((p(6)+1)*p(2)^2))*(esumx2x1p1-p(5)*esumx1p1)+(1/p(2)^2)*esumx2x1p2;
bot=(1/((p(6)+1)*p(2)^2))*esumx1x1p1+(1/p(2)^2)*esumx1x1p2;
p(1)=top/bot;

first=esumx2x2p1-2*p(5)*esumx2p1+sum(p(5)^2*ep1(2:end))-2*p(1)*esumx2x1p1+2*p(1)*p(5)*esumx1p1+p(1)^2*esumx1x1p1;
second=esumx2x2p2-2*p(1)*esumx2x1p2+p(1)^2*esumx1x1p2;
p(2)=abs(((1/(p(6)+1))*first+second)/(T-1))^.5;

sumyy=sum(y.*y);
sumyfx=sum(y.*eyf);
sumfxfx=sum(eff(2:end));
p(3)=sumyfx/sumfxfx;

p(4)=sqrt(abs(sumyy-2*p(3)*sumyfx+p(3)^2*sumfxfx)/T);

p(5)=abs((esumx2p1-p(1)*esumx1p1)/sum(ep1(2:end)));

p(6)=abs(first/(p(2)^2*esump1)-1);
p(7)=esump1/T;

ll=likelihoodj(y,xs,p(1),p(2),p(3),p(4),p(5),p(6),p(7));
