function tGammaCCDF

for (a = 0.2:1:4.2)
  for (x = -0.5:1:10)
    GCDF = Gamma1aCCDF(x, a);
    Ginc = 1 - gammainc(x, a);
    fprintf ('x, a: %g, %g; GCDF, Ginc: %g, %g\n', x, a, GCDF, Ginc);
  end
end

return
