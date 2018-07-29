function state = isintscalar(var)

if isreal(var) & ...
   isequal(var,fix(var)) & ...
   isequal(size(var),[1 1])
   state = 1;
else
   state = 0;
end
