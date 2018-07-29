function out=weierstrass(X,str)
out=[];
for I=1:size(X,1);
val=0;
x=X(I,:);
n=size(x,2);
for i=1:n
    for k=0:20
        val=val+0.5^k*cos(2*pi*3^k*(x(i)+0.5));
    end
end
temp=0;
for k=0:20
    temp=temp+0.5^k*cos(2*pi*3^k*0.5);
end
out(I)=val-n*temp;
out=out';
end