function I=montec2var(g,a,b,c,d,n)

%I=montec2var('g',a,b,c,d,n)
%Calculates doble integral using Montecarlo method (fixed boundaries)
for k=1:n
    s=2.^k;
    t=rand(2,s);
    x=a+t(1,:).*(b-a);			%extremos a,b fijos
    y=c+t(2,:).*(d-c);			%extremos c,d fijos

    for i=1:s
        z(i)=feval(g,x(i),y(i));
    end

    I(k)=(((b-a).*(d-c))./s).*sum(z);
end

plot(I);

