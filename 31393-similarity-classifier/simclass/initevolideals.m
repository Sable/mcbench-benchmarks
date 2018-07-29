function pop = initevolideals(ideaalit,Y,p,m);

w = Y{3};
nc = Y{4};

dim_v = length(w);
y=Y{1};
k=0;

for i = 1 : length(p)
    for j = 1 : length(m)
        k = k+1;
        ideal = idealvectors(ideaalit, [p(i), m(j), y(3)]);
        pop(k,:) = reshape(ideal',1,dim_v*nc);    
    end
end
