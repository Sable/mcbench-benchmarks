function v = visort(v,N)  %#eml
temp = v;

for i=1:N-1
    m = v(i);
    k = 1;
    
    for j = i+1:N
        if v(j) < m
            m = v(j);
            k = j-i+1;
        end
    end

    for j = 1:k-1
        v(i+j) = temp(i+j-1);
    end

    v(i) = m;

    for j=1:N
        temp(j) = v(j);
    end
end