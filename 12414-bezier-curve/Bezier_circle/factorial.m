% factorial function
% Copyright by Nguyen Quoc Duan - EMMC11

% Purpose : to compute the factorial of a natural number 

function f=factorial(n)
if n==0|n==1
   f=1;
else
   f=n*factorial(n-1);
end