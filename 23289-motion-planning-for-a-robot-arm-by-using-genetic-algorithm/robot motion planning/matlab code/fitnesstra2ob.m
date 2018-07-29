function aa = fitnesstra2(pop,para)
 global angles   
[pops,numvar]=size(pop);
for i=1:pops
    time=pop(i,5)+pop(i,6);
    kk=trajt(para,pop(i,:));
    angles= kk(1:2,[5,7,10,13,15,17,20,23,25,27,30,33,35]);
    tt=torque(kk);
    ft=ftorque(tt);
    poo=kk(1:2,:);
    fq=sum(sum(abs(diff(poo'))));
    pos=forkin(poo);xx=pos(1,:);yy=pos(2,:);
    x=diff(xx);
    y=diff(yy);
    dis=sqrt(x.^2+y.^2);
    fdis=sum(dis);
    a1=2.3;
    a2=1.8;
    a3=2;
    a4=1;
    f=a1*ft+a2*fq+a3*fdis+a4*time;
    fob=fobstacle2(xx,yy);
    aa(i)=fob/f;
end
 
    