function [spath,mpath,stdpath,fwd,stdfwd,xpath,epath,r1,r2]=schwartzsmithsim(start,param,ftemp,T,rmatrix,sim)
kappa=param(1);
mue=param(2);
sigmax=param(3);
sigmae=param(4);
lambdae=param(5);
lambdax=param(6);
pxe=param(7);
x0=param(8);
e0=param(9);
 
 
iter=start;
for k=1:length(T)
    loc=mod(iter,12);
    
    if loc==0
        f(k)=ftemp(12);
    else
        f(k)=ftemp(loc);
    end
    iter=iter+1;
end
 
for i=1:length(T)
    explns(i,1)=exp(-kappa*T(i))*x0+e0-((1-exp(-kappa*T(i)))*lambdax/kappa)+(mue-lambdae)*T(i);
    varlns(i,1)=((1-exp(-2*kappa*T(i)))*sigmax^2/(2*kappa))+sigmae^2*T(i)+2*(1-exp(-kappa*T(i)))*pxe*sigmax*sigmae/kappa;
    fwd(i,1)=f(i)*exp(explns(i,1)+.5*varlns(i,1));
    varlnfwd(i,1)= T(i)*(sigmae)^2 + (1-exp(-2*kappa*T(i)))*(sigmax^2)/(2*kappa) + 2*(1-exp(-kappa*T(i)))*pxe*sigmax*sigmae/kappa;
    stdfwd(i,1)=f(i)*sqrt((exp(varlnfwd(i,1))-1)*exp(2*explns(i,1)+varlnfwd(i,1)));
    stdspot(i,1)=f(i)*sqrt((exp(varlnfwd(i,1))-1)*exp(2*explns(i,1)+varlnfwd(i,1)));
    ve(i,1)=sigmae^2*T(i);
    vx(i,1)=(1-exp(-2*kappa*T(i)))*(.5*sigmax^2)/kappa;
end


m=length(T);

r1(:,:)=rmatrix;
r2(:,:)=pxe.*r1(:,:)+sqrt(1-pxe^2).*randn(sim,m); 
 
for i=1:sim
 
x(1)=x0-lambdax*T(1)-kappa*x0*T(1)+sigmax*sqrt(T(1))*r1(i,1);
e(1)=e0+(mue-lambdae)*T(1)+sigmae*sqrt(T(1))*r2(i,1);
s(1)=f(1)*exp(e(1)+x(1));

for t=1:m-1
    x(t+1)=x(t)-lambdax*(T(t+1)-T(t))-kappa*x(t)*(T(t+1)-T(t))+sigmax*sqrt((T(t+1)-T(t)))*r1(i,t+1);
    e(t+1)=e(t)+(mue-lambdae)*(T(t+1)-T(t))+sigmae*sqrt((T(t+1)-T(t)))*r2(i,t+1);
    s(t+1)=f(t+1)*exp(e(t+1)+x(t+1));
end
epath(i,:)=e(1:end);
xpath(i,:)=x(1:end);
spath(i,:)=s(1:end);
lspath(i,:)=log(s(1:end));
c(i)=corr(r1(i,:)',r2(i,:)');
c2(i)=corr(xpath(i,:)',epath(i,:)');
end
evar = var(epath)';
xvar = var(xpath)';
 
%E(S(T))=E(F(T,T))
mpath=mean(spath)'; 
%V(ln(S(T)))=V[ln(F(T,T)]
varlnpath=var(lspath)';
%E(ln(S(T)))=E[ln(F(T,T)]
mlnpath=mean(lspath)';
stdpath=sqrt((exp(varlnpath)-1).*exp(2*mlnpath+varlnpath));

