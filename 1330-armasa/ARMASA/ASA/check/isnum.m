function state = isnum(var)

if isequal(class(var),'double') & ...
      ~isempty(var) & ...
      ~any(any(isnan(var))) & ...
      ~any(any(isinf(var)));
   state = 1;
else
   state = 0;
end
