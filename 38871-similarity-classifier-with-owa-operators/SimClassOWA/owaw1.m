% the basic RIM quantifier: Q(r)=r^alpha
function re=weight1(n,m) % n-length of weighting vector, m - is alpha
re=[];
for h=1:n
    re=[re ((h/n).^m-((h-1)/n).^m)];
end
end