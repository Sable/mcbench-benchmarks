function gauss_elimnation
a = [6 2 8;3 5 2;0 8 2];
b = [26;8;-7];
a(:,length(a)+1)=b
[rows cols]=size(a);
answer=zeros(rows,1);
 for i=1:cols
for j=i+1:rows
tmp=a(i,:).*(-a(j,i)/a(i,i));
a(j,:)=tmp+(a(j,:));
end
 end
 for i=length(1:rows)-(1:rows)+1 
if(i<cols-1)
a(i,cols)=a(i,cols)-(sum(a(i,i+1:cols-1)));
end
answer(i)=a(i,cols)/(a(i,i));
 a(1:i-1,i)=a(1:i-1,i).*answer(i);
 end
disp('Solution = ');
disp(answer)
end