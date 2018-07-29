function [Fn,Fnm1] = fibrecurmemo(N)
% Computes the Fibonacci number, F(N), using a memoized recursion
if N <= 2
  Fn = 1;
  Fnm1 = 1;
else
  [Fnm1,Fnm2] = fibrecurmemo(N-1);
  Fn = Fnm1 + Fnm2;
end