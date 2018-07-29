function state = isascalar(var)

if isequal(size(var),[1 1])
   state = 1;
else
   state = 0;
end
