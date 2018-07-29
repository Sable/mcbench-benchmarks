function Fn = fibrecur(N)
% Computes the Fibonacci number, F(N), using recursion (a poor choice)
if N <= 2
  Fn = 1;
else
  Fn = fibrecur(N-1) + fibrecur(N-2);
end