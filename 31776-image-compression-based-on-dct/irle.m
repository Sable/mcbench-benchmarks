function XZv=irle(x)
L=length(x);
s=1;
k=1;
i=1;
while i<=L
    while s<=x(i+1)
        XZv(k)=x(i);
        s=s+1;
        k=k+1;
    end;
    i=i+2;
    s=1;
end;