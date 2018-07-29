%
% Written by M. Harper Langston - 5/10/00
% mhl219@cims.nyu.edu or harper_langston@hotmail.com
%
% Form right-hand side of the Poisson problem in a box.
% the gt,gb,gl and gr are the boundary conditions (see Form_Boundary.m)
% and m is the size of each block and number of such blocks in the matrix,
% h = 1/m+1 from poisson.m, f is the vector f(x,y) and N is the scheme we
% are using (5-point, 9-point or modified 9-point).
% Gamma is passed for the modified 9 point scheme since don't want to recompute
% Gamma.  Helps if multiplying f by new modified matrix scheme.
function [v] = Form_Right(m,h,f,gb,gt,gl,gr,N);
%length of f
g = f(2:m+1,2:m+1);
len = length(g(:));
% gnew is the correction vector we will subtract from fnew.
% This is one of the trickier steps, following the method used by Prof. Chen
% in the lecture from 2/24/00, forming the vector with components from the bndry
if N==5
	gnew = gl(2:length(gl)-1);
	gnew(len-m+1:len) = gr(2:length(gr)-1);
	for k = 1:m
  		gnew((k-1)*m + 1) = gnew((k-1)*m + 1) + gb(k+1);
     	gnew(m*k) = gnew(m*k) + gt(k+1);
   end
   gnew = gnew'; 
elseif N==9 | N == 10
   gnew = zeros(len,1);
   for k = 1:m
      gnew(k) = (1/6)*gl(k)+(2/3)*gl(k+1)+(1/6)*gl(k+2);
      gnew(len-m+k) = (1/6)*gr(k)+(2/3)*gr(k+1)+(1/6)*gr(k+2);
   end
	for k = 1:m
  		gnew((k-1)*m + 1) = gnew((k-1)*m + 1) + (1/6)*gb(k)+(2/3)*gb(k+1)+(1/6)*gb(k+2);
     	gnew(m*k) = gnew(m*k) + (1/6)*gt(k)+(2/3)*gt(k+1)+(1/6)*gt(k+2);
   end
   gnew(1) = gnew(1) - (1/6)*gl(1);
   gnew(m) = gnew(m) - (1/6)*gl(m+2);
   gnew(len-m+1) = gnew(len-m+1) - (1/6)*gr(1);
   gnew(end) = gnew(end) - (1/6)*gr(end);
end
% Call to Modified_Right forms the vector, f, which is just f if N=9 or 5,
% but f is altered as in the modified nine-point scheme if N = 10 (page 127 of Iserles)
[f] = Modified_Right(f,m,N);
v = (h^2).*f-gnew;
%
% Written by M. Harper Langston - 5/10/00
% mhl219@cims.nyu.edu or harper_langston@hotmail.com
%