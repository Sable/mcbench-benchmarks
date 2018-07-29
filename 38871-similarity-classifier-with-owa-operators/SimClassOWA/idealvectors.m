function ideals = idealvectors(data, y)
% INPUT:
%
%   data    =    datamatrix
%   y(1)    =    p-value in similarity measure
%   y(2)    =    m-value in similarity measure 
%   y(3)    =    used similarity measure
% OUTPUT:
%
%   ideals  =    Ideal vectors for classes

d_dim = size(data,1); 
v_dim = size(data,2)-1;
data=sortrows(data, v_dim+1); 

nc = data(d_dim, v_dim+1); 
cs = []; 
cs(1) = 1;

for j = 1 : nc 
    lc(j) = length(find(data(:, v_dim+1) == j)); 
    cs(j+1) = cs(j) + lc(j);
end

for j = 1 : nc 
    ideals(j,:) = pmean(data( cs(j) : cs(j+1)-1 , 1:v_dim ), y(2));
end
