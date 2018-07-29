  function ObjVal = griewank(x,mydata)
   [A, B] = size(x);
   nummer = repmat(1:B, [A 1]);
   ObjVal = sum(((x.^2) / 4000)')' - prod(cos(x ./ sqrt(nummer))')' + 1; 

  return
  