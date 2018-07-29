function w=weight4(n,m) % n-length of weighting vector, m - is alpha
% trigonometric linguistic quantifier: Q(r)=asin(r*alpha)
re=[];
for h=1:n
    re=[re (asin(m*(h/n))-asin(m*((h-1)/n)))];    
end
reT=sum(re);
w=re/reT;
end