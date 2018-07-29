function a=recor(bsol,para)
time=bsol(8)+bsol(9);
[c,conff]=invkin3(para(4),para(5),bsol(4));
cond=[para(1:3),conff];
chrom=[bsol(1:3),bsol(5:end)];
kk=trajt3(cond,chrom);
tt=torque3(kk);
ft=ftorque3(tt);
ffq=kk(1:3,:);
fq=sum(sum(abs(diff(ffq'))));
pos=forkin3(kk(1,:),kk(2,:),kk(3,:));
xx=pos(1,:);yy=pos(2,:);
x=diff(xx);
y=diff(yy);    
fdis=sum(sqrt(x.^2+y.^2));
a=[time,fq,fdis,ft];