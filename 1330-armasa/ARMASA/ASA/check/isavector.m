function state = isavector(var)

state = ndims(var) == 2 & ~(size(var,1)>1 & size(var,2)>1);

