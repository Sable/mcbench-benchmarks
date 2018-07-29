function [aw,ae,ap,su]=abc

global dx n2 ta tb
warning off
b=n2*(dx^2);

i=1;        
aw(i)=0;
ae(i)=1;
su(i)=b*ta+2*tb;
sp(i)=-b-2;
ap(i)=aw(i)+ae(i)-sp(i);


i=2;
aw(i)=1;
ae(i)=1;
su(i)=b*ta;
sp(i)=-b;
ap(i)=aw(i)+ae(i)-sp(i);

i=3;
aw(i)=1;
ae(i)=0;
su(i)=b*ta;
sp(i)=-b;
ap(i)=aw(i)+ae(i)-sp(i);