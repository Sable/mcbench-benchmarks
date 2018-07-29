function nc=normcor(a,b)
m=size(a);
n=size(b);
a=im2double(a);
b=im2double(b);
a1=mean2(a);
b1=mean2(b);
c1=0;c2=0;
for i=1:m
    for j=1:n
      c1=c1+(a(i,j)-a1);
      c2=c2+(b(i,j)-b1);
      num=c1*c2;
      c3=(c1^2)*(c2^2);
      dem=sqrt(c3);
    end
end
nc=num/dem;

