function b=rowswap(a,i,j)
%i and j are row number%
a([i,j],:)=a([j,i],:);
b=a;

