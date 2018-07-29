function [cost,f]=ants_cost(m,n,d,at,el);
for i=1:m
    s=0;
    for j=1:n
        s=s+d(at(i,j),at(i,j+1));
    end
    f(i)=s;
end
cost=f;
f=f-el*min(f);%elimination of common cost.
