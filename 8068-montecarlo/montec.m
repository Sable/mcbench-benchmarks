function I=montec(f,a,b,n)

%I=montec('f',a,b,k);
%Calculates integral using montecarlo method
for k=1:n
    s=2.^k;
    t=rand(1,s);
    x=a+t.*(b-a);

    for i=1:s
        y(i)=feval(f,x(i));
    end

    I(k)=((b-a)./s)*sum(y);
end
plot(I);


   