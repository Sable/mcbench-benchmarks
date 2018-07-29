function zbar = eval2dPoly( x, y, coeffs )
% Given the coefficients of a polynomial as returned by fit2dPolySVD,
% calculates the values z for input values (x,y).
% x, y are column vectors specifying the points to be calculated.
% The vectors must be the same length.
% Coeffs is the coefficients array returned by fit2dPolySVD.


[sizexR, sizexC] = size(x);
[sizeyR, sizeyC] = size(y);

if (sizexC ~= 1) || (sizeyC ~= 1)
    fprintf( 'Inputs of eval2dPoly must be column vectors' );
    return;
end

if (sizeyR ~= sizexR)
    fprintf( 'Inputs vectors of eval2dPoly must be the same length' );
    return;
end


numVals = sizexR;

order = 0.5 * (sqrt(8*length(coeffs)+1) - 3);

zbar = zeros(numVals,1);
column = 1;
for xpower = 0:order
    for ypower = 0:(order-xpower)
        zbar = zbar + (coeffs(column) .* x.^xpower .* y.^ypower);
        column = column + 1;
    end
end


