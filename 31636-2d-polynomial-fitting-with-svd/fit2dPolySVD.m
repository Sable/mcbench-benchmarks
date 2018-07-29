function coeffs = fit2dPolySVD( x, y, z, order )
% Fit a polynomial f(x,y) so that it provides a best fit
% to the data z.
% Uses SVD which is robust even if the data is degenerate.  Will always
% produce a least-squares best fit to the data even if the data is
% overspecified or underspecified.
% x, y, z are column vectors specifying the points to be fitted.
% The three vectors must be the same length.
% Order is the order of the polynomial to fit.
% Coeffs returns the coefficients of the polynomial.  These are in
% increasing power of y for each increasing power of x, e.g. for order 2:
% zbar = coeffs(1) + coeffs(2).*y + coeffs(3).*y^2 + coeffs(4).*x +
% coeffs(5).*x.*y + coeffs(6).*x^2
% Use eval2dPoly to evaluate the polynomial.

[sizexR, sizexC] = size(x);
[sizeyR, sizeyC] = size(y);
[sizezR, sizezC] = size(z);

if (sizexC ~= 1) || (sizeyC ~= 1) || (sizezC ~= 1)
    fprintf( 'Inputs of fit2dPolySVD must be column vectors' );
    return;
end

if (sizeyR ~= sizexR) || (sizezR ~= sizexR)
    fprintf( 'Inputs vectors of fit2dPolySVD must be the same length' );
    return;
end


numVals = sizexR;

% scale to prevent precision problems
scalex = 1.0/max(abs(x));
scaley = 1.0/max(abs(y));
scalez = 1.0/max(abs(z));
xs = x .* scalex;
ys = y .* scaley;
zs = z .* scalez;


% number of combinations of coefficients in resulting polynomial
numCoeffs = (order+2)*(order+1)/2;

% Form array to process with SVD
A = zeros(numVals, numCoeffs);

column = 1;
for xpower = 0:order
    for ypower = 0:(order-xpower)
        A(:,column) = xs.^xpower .* ys.^ypower;
        column = column + 1;
    end
end

% Perform SVD
[u, s, v] = svd(A);

% pseudo-inverse of diagonal matrix s
sigma = eps^(1/order); % minimum value considered non-zero
qqs = diag(s);
qqs(abs(qqs)>=sigma) = 1./qqs(abs(qqs)>=sigma);
qqs(abs(qqs)<sigma)=0;
qqs = diag(qqs);
if numVals > numCoeffs
    qqs(numVals,1)=0; % add empty rows
end

% calculate solution
coeffs = v*qqs'*u'*zs; 


% scale the coefficients so they are correct for the unscaled data
column = 1;
for xpower = 0:order
    for ypower = 0:(order-xpower)
        coeffs(column) = coeffs(column) * scalex^xpower * scaley^ypower / scalez;
        column = column + 1;
    end
end



