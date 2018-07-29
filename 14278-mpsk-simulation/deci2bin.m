function z=deci2bin(x,l)

[A,B]=size(x);

for j=1:B,
    y = zeros(1,l);	
    i = 1;
    while x(j)>=0 & i<=l
        y(i)=rem(x(j),2);
        x(j)=(x(j)-y(i))/2;
        i=i+1;
    end
    y=y(l:-1:1);
    z(j,:)=y;
end
