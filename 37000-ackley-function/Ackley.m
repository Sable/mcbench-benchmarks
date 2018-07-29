function y = Ackley(x)
  n = 2;
  sum1 = 0;
  sum2 = 0;
  
  for i=1:n
   sum1 = s1+x(i)^2;
   sum2 = s2+cos((2*pi)*x(i));
  end
  
  y = 20 + exp(1)-20*exp(-0.2*sqrt(1/n*sum1))-exp(1/n*sum2);
  
end