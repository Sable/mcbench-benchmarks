function [x_soln,nrow,A_aug]= timo_gausselimination_fun(A,B);
%Note that this program does not directly change the rows of the augmented
%matix. Instead it uses the nrow vector to keep track of the row changes.


%create the augmented matrix A|B
Aug=[A B];
n=rank(A);

%initialize the nrow vector
for i=1:n
    nrow(i)=i;
end
nrow=nrow';


for k=1:n-1;
max=0;
index=0;

%find the maximum value in the column under the current checked element and
%return its row position
for j=k:n
    if abs(Aug(nrow(j),k))>max
        max=abs(Aug(nrow(j),k));
        index=j;
    end
end
%perform row exchange in the nrow vector
if nrow(k)~=nrow(index)
    ncopy=nrow(k);
    nrow(k)=nrow(index);
    nrow(index)=ncopy;
    disp(sprintf ('row changed '))
else 
    disp(sprintf ('no change '))
end

%Gaussian elimination
for i=(k+1):n
    m(nrow(i),k)=Aug(nrow(i),k)/Aug(nrow(k),k);
   
    for j=k:n+1
        Aug(nrow(i),j)=Aug(nrow(i),j)-m(nrow(i),k)*Aug(nrow(k),j);
    end
        
end
end

%backward subsitution
x(n)=0;
x=x';

x(n)=Aug(nrow(n),n+1)/Aug(nrow(n),n);
i=n-1;
while i>0
    x(i)=(Aug(nrow(i),n+1)-Aug(nrow(i),i+1:n)*x(i+1:n))/(Aug(nrow(i),i));
   i=i-1;
end
x_soln=x;
A_aug=Aug;
