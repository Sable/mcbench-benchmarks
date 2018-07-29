function a=recor2(bsol,para)
time=bsol(5)+bsol(6);
kk=trajt(para,bsol);
tt=torque(kk);
ft=ftorque(tt);
ffq=kk(1:2,:);
fq=sum(sum(abs(diff(ffq'))));
pos=forkin(kk(1:2,:));
xx=pos(1,:);yy=pos(2,:);
x=diff(xx);
y=diff(yy);    
fdis=sum(sqrt(x.^2+y.^2));
a=[time,fq,fdis,ft];
