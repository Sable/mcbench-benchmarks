function [Z, S] = poly2DApprox( D, nrBfsX, nrBfsY )
%
% Purpose : This function approximates data which lie on a 2D grid using a 
% 2D tensor polynomial. The function returns both the approximated data and
% the 2D polynomial spectrum.
%
% This function uses the discrete orthogonal polynomial toolbox DOPbox. The
% toolbox is available at MATLAB file exchange:
%
%   http://www.mathworks.com/matlabcentral/fileexchange/41250
%
% The use of the DOPbox enable the computation with polynomials of very
% high degree. There is no problem to compute a polynomial of degree d =
% 1000, the only disadvantage is the corresponding loss in speed.
%
% Some of the theory associated with this function can be found in the
% publication, Discrete Polynomial Moments and Savitzky-Golay Smoothing,
% available at:
%
% www.waset.org/journals/waset/v48/v48-85.pdf
%
% Use (syntax):
%   Z = polySurf( D, nrBfsX, nrBfsY );
%   [Z, S] = polySurf( D, nrBfsX, nrBfsY );
%
% Input Parameters :
%   D: The 2D data lying on a grid, the function can be applied to any 
%   form of data, e.g. surface data or images.
%   nrBfsX: the number of basis functions used in the x direction.
%   nrBfsY: the number of basis functions used in the y direction.
%
% Return Parameters :
%   Z: The 2D polynomial approximation to the data.
%   S: The 2D polynomial spectrum
%
% Description and algorithms:
%   This function uses tensor products of Gram polynomials.
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
[ny, nx] = size( D );
%
% generate the rquired polynomial bases
%
Bx = dop( nx, nrBfsX );
By = dop( ny, nrBfsY );
%
% Compuet teh 2D polynomial spectrum
%
S = By' * D * Bx;
%
% Generate the 2D approximation
%
Z = By * S * Bx';