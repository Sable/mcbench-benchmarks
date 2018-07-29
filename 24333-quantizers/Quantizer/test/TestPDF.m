function TestPDF

% Use two different methods to calculate each of the following

% Compare standard PDF's against general gamma function computation
xtest = [-Inf, -2:0.5:5, Inf];
TestPDFInt2('Gauss vs GammaGen', xtest, PDFFn('Gauss'), ...
                                        {@GareaX, @GmeanX, @GvarX});
TestPDFInt2('Laplace vs GammaGen', xtest, PDFFn('Laplace'), ...
                                          PDFFn('General_Gamma', 1));
TestPDFInt2('Gamma vs GammaGen', xtest, PDFFn('Gamma'), ...
                                        PDFFn('General_Gamma', 0.5));

% Uniform against tabulated uniform
xtest = [-Inf, -2:0.5:2, Inf];
x = [-sqrt(3), -1.5 -0.5 0 1 sqrt(3)];
p = ones(size(x));
TestPDFInt2('Uniform vs Tabulated', xtest, PDFFn('Uniform'), ...
                                           PDFFn('Tabulated', x, p));

% Gaussian against tablulated Gaussian
xtest = [-Inf, -2:0.5:5, Inf];
x = -8:0.001:8;
p = 1/sqrt(2*pi) * exp(-x.^2/2);
TestPDFInt2('Gauss vs Tabulated', xtest, PDFFn('Gauss'), ...
                                         PDFFn('Tabulated', x, p), 1e-6);

% Sinusoid against tabulated sine (poor agreement)
xtest = [-Inf, -2:0.5:2, Inf];
x = linspace(-sqrt(2)+0.0001,sqrt(2)-0.0001,1001);
p = (1/pi) ./ sqrt(2-x.^2);
TestPDFInt2('Sine vs Tabulated', xtest, PDFFn('Sine'), ...
                                        PDFFn('Tabulated', x, p), Inf);

cd(SaveDir);

return

% ----- -----
function TestPDFInt2 (Title, xtest, FPDF, FPDFA, Tol)

if (nargin <= 4)
  Tol = 1e-8;
end

fprintf('\n----- %s ----- \n', Title);
fprintf('    Limits            Area         Mean          Var\n');
Farea = FPDF{1};
Fmean = FPDF{2};
Fvar = FPDF{3};
FareaA = FPDFA{1};
FmeanA = FPDFA{2};
FvarA = FPDFA{3};
  
for (x = xtest)

% Moment integrals
  F0 = feval(Farea, x, Inf);;
  F1 = feval(Fmean, x, Inf);
  F2 = feval(Fvar, x, Inf);
  fprintf('[%5g,%4g], %12g %12g %12g \n', x, Inf, F0, F1, F2);
  
% Alternate moment integrals
  F0A = feval(FareaA, x, Inf);
  F1A = feval(FmeanA, x, Inf);
  F2A = feval(FvarA, x, Inf);
  fprintf('              %12g %12g %12g \n', F0A, F1A, F2A);

% Test results
  if (abs(F0-F0A) > Tol || abs(F1-F1A) > Tol || abs(F2-F2A) > Tol)
    error('Results disagree');
  end

end

return

% -----
function v = GareaX (xa, xb)

a = 0.5;
b = sqrt(a*(a+1));
v = Gamma2aCCDF(sign(xa)*xa^2/(2*b), a) ...
    - Gamma2aCCDF(sign(xb)*xb^2/(2*b), a);

return

% -----
function v = GmeanX (xa, xb)

a = 1;
b = sqrt(a*(a+1));
v = sqrt(2/pi) * (Gamma2aCCDF(xa^2/(2*b), a) - Gamma2aCCDF(xb^2/(2*b), a));

return

% -----
function v = GvarX (xa, xb)

a = 1.5;
b = sqrt(a*(a+1));
v = Gamma2aCCDF(sign(xa)*xa^2/(2*b), a) ...
    - Gamma2aCCDF(sign(xb)*xb^2/(2*b), a);

return
