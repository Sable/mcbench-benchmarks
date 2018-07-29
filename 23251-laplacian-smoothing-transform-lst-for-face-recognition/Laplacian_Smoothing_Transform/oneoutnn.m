function [z,e]=oneoutnn(x,iil)

[m,n]=size(x);
d=zeros(m,m);
v=double(x)*double(x');
for i=1:m;
    for j=1:m;
        d(i,j)=sqrt(v(i,i)+v(j,j)-2*v(i,j));
    end;
    d(i,i)=10000000000000;
end;
[a,b]=min(d);
e=iil(b');
c=iil-e;
e(:,2)=iil;
z=0;
for i=1:m;
    if c(i)~=0;
        z=z+1;
    end;
end;