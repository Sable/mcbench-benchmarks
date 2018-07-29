function [y, yn, Ys] = odeLSE( L, g, C, d )
%
% Purpose : This function implmenets a least squares approximation with
% linear constraints. The interpretation provided is specifically aimed at
% solving differential equations.
%
%  min_y || L y  - g ||_2^2 given C y = d
%
% Use (syntax):
%   y = odeLSE( L, g, C, d );
%   y = odeLSE( L, [], C, d );
%   y = odeLSE( L, g, C, [] ),
%
%   [y, yn, Ys] = odeLSE( L, g, C, d )
%
% Input Parameters :
%   L: the linear differential operator in matrix form
%   g: a vector of values corresponding to the fording function. g may be
%   replaced by [] indicating zero forcing function.
%   C: a matrix whos columns implement the constraints
%   d: the column vector of constraint calues
%       c_i^T  y = d_i
%
% Return Parameters :
%   y: the solution to the differential equation
%   yn: the homogeneous solution (optional)
%   Ys: the columns are the unitary constrained functions
%
% Description and algorithms:
%
% References : 
%
% Author :  Matther Harker and Paul O'Leary
% Date :    29. Jan 2013
% Version : 1.0
%
% (c) 2013 Matther Harker and Paul O'Leary
% url: www.harkeroleary.org
% email: office@harkeroleary.org
%
% History:
%   Date:           Comment:
%
%--------------------------------------------------------------------
% Test the input paramaters
%
[ln,lm] = size( L );
[cn,cm] = size( C );
%
if (lm ~= cn)
    error('The dimensions of L and C are not consistent');
end;
%
noG = isempty(g);
if ~noG
    [gn,gm] = size( g );
    if (gm ~= 1)
        error('g must be a column vector.');
    end;
    %
    if (lm ~= gn)
        error('The dimensions of L and g are not consistent');
    end;
else
    g = zeros(lm,1);
end;
%
noD = isempty(d);
if ~noD
    [dn,dm] = size( d );
    if (dm ~= 1)
        error('d must be a column vector.');
    end;
    %
    if (cm ~= dn)
        error('The dimensions of C and d are not consistent');
    end;
else
    d = zeros(cm,1);
end;
%
if noD && noG
    warning('Both the diff. eqn. and constraints are homogeneous');
    disp('You may wish to reformulate the problem as an eigenvector problem.');
end;
%----------------------------------------------------------------------
% Do the coputation
%
p = size( C, 2 ) ; % Number of independent constraints
%
[Q,R] = qr( C ) ;
%
Rs = R(1:p,1:p) ;
%
Qs = Q(:,1:p) ;
Qn = Q(:,p+1:end) ;
%
Ls = L * Qs ;
Ln = L * Qn ;
%
Rsit = inv(Rs');
%
[pinvLn, rankLn] = odePinv( Ln );
%
% test for the uniqueness of the solution
%
[~, mLn] = size( Ln );
if mLn ~= rankLn
     warning('There is no unique solution to this set of equations.');
end;
%
gh = g - Ls * Rsit * d;
tol = 1e-5;
rankLsg = odeRank([Ls, gh], tol);
ranlLs = odeRank(Ls, tol);
%
if rankLsg ~= ranlLs
    warning('You should investigate the numerical conditioning of the problem');
    disp('The forcing function may be inconsistent with the differential ');
    disp('equation or the differentiating matrix may have an additional null space.');
     disp('The solution is now an LS approximation.');
end;
%
% Compute the final solution
%
Yn = Qn * pinvLn ;
Ys = (Qs - Yn * Ls )* Rsit;
%
ys = Ys * d;
yn = Yn * g ;
%
y = yn + ys;
%
%========
% END
%========