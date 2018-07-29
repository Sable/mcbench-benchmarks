function coeff = create_Fit(x,counts)
% this function is used for gaussian curve fitting;
x = x(:);
counts = counts(:);
fo = fitoptions('method','NonlinearLeastSquares','Lower',[-Inf -Inf    0 -Inf -Inf    0]);
ok = isfinite(x) & isfinite(counts);
ft = fittype('gauss1');
cf = fit(x(ok),counts(ok),ft,fo);
coeff = coeffvalues(cf);

