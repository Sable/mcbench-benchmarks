function ObjVal = rosenbrock(x,mydata)

   dim=size(x,2);  
   [null_,Nvar] = size(x);
   mat0 = x(:,1:Nvar-1);
   mat1 = x(:,2:Nvar);
     
      if dim == 2
         ObjVal = 100*(mat1-mat0.^2).^2+(1-mat0).^2;
      else
         ObjVal = sum((100*(mat1-mat0.^2).^2+(1-mat0).^2)')';
      end   

  return