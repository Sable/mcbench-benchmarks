function w=weight2(n,m) % n-length of weighting vector, m - is alpha
% quadratic linguistic quantifier: Q(r)=(1/(1-alpha*(r)^0.5))
re=[];
for h=1:n
    re=[re ((1-m*(h/n)^0.5)^-1 - (1-m*((h-1)/n)^0.5)^-1)];  
end
reT=sum(re);
w=re/reT;
end