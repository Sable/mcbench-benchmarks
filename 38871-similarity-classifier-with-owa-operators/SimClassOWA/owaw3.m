function w=weight3(n,m) % n-length of weighting vector, m - is alpha
% exponential linguistic quantifier: Q(r)=exp(-alpha*r)
re=[];
for h=1:n
    re=[re (exp(-m*(h/n))-exp(-m*((h-1)/n)))];  
end
reT=sum(re);
w=re/reT;
end