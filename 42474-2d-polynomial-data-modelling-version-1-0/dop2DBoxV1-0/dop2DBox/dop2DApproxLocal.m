function Z = poly2DApproxLocal( D,  lsX, nrBfsX, lsY, nrBfsY )
%
% Purpose : This function performs local polynomial approximation for
% data which lie on a 2D grid. 
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
%   Z =  poly2DApproxLocal( D,  lsX, nrBfsX, lsY, nrBfsY )
%
% Input Parameters :
%   D: The 2D data lying on a grid, the function can be applied to any 
%   form of data, e.g. surface data or images.
%   nrBfsX: the number of basis functions used in the x direction.
%   lsX: the support length in the x direction.
%   nrBfsY: the number of basis functions used in the y direction.
%   lsY: the support length in the y direction.
%
% Return Parameters :
%   Z: The 2D local polynomial approximation to the data.
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
[ny, nx] = size( D );
%
% generate the rquired polynomial bases
%
xs = (1:nx)';
ys = (1:ny)';
%
Sx = dopApproxLocal( xs, lsX, nrBfsX, 'sparse' );
Sy = dopApproxLocal( ys, lsY, nrBfsY, 'sparse' );
%
%
% Generate the 2D local approximation
%
Z = Sy * D * Sx';