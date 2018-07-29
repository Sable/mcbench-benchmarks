function b=rowechon(a)
%row echelon matrix,and it has a small bug with a=[0 1 2;0 2 4;0 3 6]
[m,n]=size(a);
b=a;
i=1;
while i<=m-1
  if b(i,i)==0
      temp=b([i:1:m],:);
      if temp(:,i)==zeros(m-i+1,1)
      b=b;
      else
      for j=i+1:m
      b=rowswap(b,i,j);
      if b(i,i)~=0
       for j=i+1:m
       b=rowadd(b,j,i,-b(j,i)/b(i,i));
       end   
      break
      end
      end
      end
      
else
  for j=i+1:m
 b=rowadd(b,j,i,-b(j,i)/b(i,i));
  end
end
i=i+1;
end
