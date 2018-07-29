function [res,fval,it] = muller (f,Z0,itmax,ztol,ftol,option)
% MULLER find a zero of a real or complex function Y = F(Z)
% 
% Syntax:
%
% RES = MULLER (F,Z0) find the zero of a complex or real function 
% 'F' (either an anonymous function or .m function) using three initial 
% guesses contained in the vector Z0. Muller takes the function F and
% evaluetes it at each initial point using feval. F doesn't need to be
% vectorized.
% The initial guesses can be real or complex numbers close to the zero, 
% bracketing the zero is not necessary. Parameters ITMAX, ZTOL and
% FTOL are set by default to 1000, 1e-5 and 1e-5, respectively.
%
% RES = MULLER (F,Z0,ITMAX) the maximum number of iterations is set
% equal to ITMAX. ZTOL and FTOL are set by default with the values mentioned
% above.
%
% RES = MULLER (F,Z0,ITMAX,ZTOL) ZTOL is used as a stopping
% criterion. If the absolute difference between the values of Z found in
% the two latest iterations is less than ZTOL, the program is stopped. FTOL
% is set by default with the value mentioned above.
%
% RES = MULLER (F,Z0,ITMAX,ZTOL,FTOL) FTOL is used as a stopping
% criterion. If the value of the function F at the Z found in the last
% iteration is less than FTOL, the program is stopped.
%
% RES = MULLER (F,Z0,ITMAX,ZTOL,FTOL,'both') indicate that both
% criteria ZTOL and FTOL must be satisfied simultaneously. By default, 
% MULLER stops if one of the two criteria is fulfilled.
%
% [RES,FVAL] = MULLER (F,Z0,...) return the value of the function 
% F at the Z found in the last iteration.
%
% [RES,FVAL,IT] = MULLER (F,Z0,...) return the number of iterations
% used to find the zero.
%
% Example 1:
% myf = @(x) (x-1)^3; 
% 
% muller(myf,[0 0.1 0.2],[],[],[],'both')
% ans = 
%    1.0000 + 0.0000i
%
% Example 2:
% 
% [res,fval,it] = muller2('cosh',[0 0.1 0.2],[],[],[],'both')
% 
% res = 
%   0.0000 + 1.5708i
%
% fval = 
%   5.5845e-012 + 3.0132e-012i
% 
% it =
%   5
%
% Method taken from:
% Numerical Recipes: The art of scientific computing
% W.H. Press; B.P. Flannery; S.A. Teukolsky; W.T. Vetterling
% 1986
%
% Thanks to John D'Errico for his helpfull review.
%
% Written by Daniel H. Cortes
% MAE Department, West Virginia University
% March, 2008.
%


%=================================================
% Checking proper values of the input parameters
%=================================================


if nargin > 6
    error ('Too many arguments.')
elseif nargin < 2
    error('Too few arguments.')
end

if nargin < 6
    opt = 1;
elseif ischar(option) == 1
    if size(option,2) == 4
        if sum(option == 'both') == 4
            opt = 2;
        else
            error ('Option parameter must be *both*.')
        end
    else
        error ('Option parameter must be *both*.')
    end
else
    error ('Option parameter must be a character array (string).')
end


if nargin < 5
    ftol = 1e-5;
elseif isnumeric(ftol) ~= 1
    error ('FTOL must be a numeric argument.')
elseif isempty(ftol) == 1
    ftol = 1e-5;
elseif  size(ftol,1) ~= 1 || size(ftol,2) ~= 1
    error ('FTOL cannot be an array')
end


if nargin < 4
    ztol = 1e-5;
elseif isnumeric(ztol) ~= 1
    error ('ZTOL must be a numeric argument.')
elseif isempty(ztol) == 1
    ztol = 1e-5;
elseif  size(ztol,1) ~= 1 || size(ztol,2) ~= 1
    error ('ZTOL cannot be an array.')
end


if nargin < 3
    itmax = 1000;
elseif isnumeric(itmax) ~= 1
    error ('ITMAX must be a numeric argument.')
elseif isempty(itmax) == 1
    itmax = 1000;
elseif  size(itmax,1) ~= 1 || size(itmax,2) ~= 1
    error ('ITMAX cannot be an array.')
end


if isnumeric(Z0) ~= 1
    error ('Z0 must be a vector of three numeric arguments.')
elseif isempty(Z0) == 1 || length(Z0) ~= 3 || min(size(Z0)) ~= 1
    error ('Z0 must be a vector of length 3 of either complex or real arguments.')
end

if Z0(1)==Z0(2) || Z0(1)==Z0(3) || Z0(2)==Z0(3)
    error('The initial guesses must be different')
end

%=============================
% Begining of Muller's method
%=============================

z0 = Z0(1);
z1 = Z0(2);
z2 = Z0(3);

y0 = feval ( f, z0);
y1 = feval ( f, z1);
y2 = feval ( f, z2);

for it = 1:itmax
    q = (z2 - z1)/(z1 - z0);
    A = q*y2 - q*(1+q)*y1 + q^2*y0;
    B = (2*q + 1)*y2 - (1 + q)^2*y1 + q^2*y0;
    C = (1 + q)*y2;

    if ( A ~= 0 )

        disc = B^2 - 4*A*C;

        den1 = ( B + sqrt ( disc ) );
        den2 = ( B - sqrt ( disc ) );

        if ( abs ( den1 ) < abs ( den2 ) )
            z3 = z2 - (z2 - z1)*(2*C/den2);
        else
            z3 = z2 - (z2 - z1)*(2*C/den1);
        end

    elseif ( B ~= 0 )
        z3 = z2 - (z2 - z1)*(2*C/B);
    else
        warning('Muller Method failed to find a root. Last iteration result used as an output. Result may not be accurate')
        res = z2;
        fval = y2;
        return
    end

    y3 = feval ( f, z3);
    
    if opt == 1
        if ( abs (z3 - z2) < ztol || abs ( y3 ) < ftol )
            res = z3;
            fval = y3;
            return
        end
    else
        if ( abs (z3 - z2) < ztol && abs ( y3 ) < ftol )
            res = z3;
            fval = y3;
            return
        end
    end
    
    z0 = z1;
    z1 = z2;
    z2 = z3;

    y0 = y1;
    y1 = y2;
    y2 = y3;

end

res = z2;
fval = y2;
warning('Maximum number of iterations reached. Result may not be accurate')



