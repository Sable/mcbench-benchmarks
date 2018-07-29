function Distance = Compare(VectorA, VectorB,n,field);

VectorC = gfadd(VectorA, VectorB, field);

%Calculate the Stats
Distance = 0;
for i = 1:n
    if VectorC(i) ~= -Inf
        Distance = Distance + 1;
    end
end