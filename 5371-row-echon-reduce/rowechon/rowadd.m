function b=rowadd(a,i,j,k)
%b=rowadd(a,i,j,k),i-th row is changed

a(i,:)=a(i,:)+k*a(j,:);
b=sym(a);
