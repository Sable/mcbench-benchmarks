function tLogGamma

for (x = 0:0.5:10)
  LG = LogGamma(x);
  ML = gammaln(x);
  fprintf ('x: %g, LogGamma, Matlab: %g, %g\n', x, LG, ML);
end

return
