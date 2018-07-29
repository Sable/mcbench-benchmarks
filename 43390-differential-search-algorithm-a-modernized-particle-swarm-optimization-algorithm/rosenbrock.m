function fval = rosenbrock(X,mydata)
Dim=size(X,2);
[~,B] = size(X);
u1 = X(:,1:B-1);
u2 = X(:,2:B);
     
if Dim == 2
   fval = 100*(u2-u1.^2).^2+(1-u1).^2;
else
   fval = sum((100*(u2-u1.^2).^2+(1-u1).^2)')';
end   

return