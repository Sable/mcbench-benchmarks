function [aa,z] = fitnesstra3ob(pop,para)
global cond xx yy angles
[pops,numvar]=size(pop);
for i=1:pops
    [phi,conff]=invkin3(para(4),para(5),pop(i,4)) ;%final conficuration
    z(i)=phi;
    cond=[para(1:3),conff];
    chrom=[pop(i,1:3),pop(i,5:end)];
    kk=trajt3(cond,chrom);
    angles=kk(1:3,[5,7,10,13,15,17,20,23,25,27,30,33,35]);
    tt=torque3(kk);
    ft=ftorque3(tt);
    poo=kk(1:3,:);fq=sum(sum(abs(diff(poo'))));
    pos=forkin3(kk(1,:),kk(2,:),kk(3,:));xx=pos(1,:);yy=pos(2,:);
    x=diff(xx);
    y=diff(yy);    
    fdis=sum(sqrt(x.^2+y.^2));
    time=pop(i,8)+pop(i,9);
    a1=1.7;
    a2=2;
    a3=2;
    a4=1;
    fit=a1*ft+a2*fq+a3*fdis+a4*time;
    fob=fobstacle;
    aa(i)=fob/fit;
end
 
    