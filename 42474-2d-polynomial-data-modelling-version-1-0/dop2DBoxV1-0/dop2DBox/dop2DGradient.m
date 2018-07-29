function [gX, gY, gT] = poly2DGradient( D, lsX, nbX, lsY, nbY, dx, dy )
%
% Purpose : This function computes the local gradient of a 2D data set
% using local polynomial methods. The gradient can be computed with a
% specified degree of reqularization
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
%   [gX, gY, gT] = poly2DGradient( D ); compute a gradient with no
%   regularization.
%   [gX, gY, gT] = poly2DGradient( D, lsX, nbX, lsY, nbY); computes the
%   gradient with the assumption that dx = dy = 1.
%   [gX, gY, gT] = poly2DGradient( D, lsX, nbX, lsY, nbY, dx, dy );
%
% Input Parameters :
%   D: The 2D data lying on a grid, the function can be applied to any
%   form of data, e.g. surface data or images.
%   lsX: support length in the x direction.
%   nbX: the number of basis functions in the x direction. nbX = lsX implies
%   no regularization.
%   lsX: support length in the y direction.
%   nbY: the number of basis functions in the x direction. nbY = lsY implies
%   no regularization.
%   dx = step size in the x direction.
%   dy = step size in the y direction.
%
% Return Parameters :
%   gX = gradient in the x direction.
%   gY = gradient in the y direction.
%   gT (optional) the total gradient.
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
if nargin == 5
    xs = (1:nx)';
    ys = (1:ny)';
else
    xs = dx*(1:nx)';
    ys = dy*(1:ny)';
end;
%
% generate the rquired differentiating matrices
%
Dx = dopDiffLocal( xs, lsX, nbX, 'sparse' );
Dy = dopDiffLocal( ys, lsY, nbY, 'sparse' );
%
% Compuet the gradients
%
gX = D * Dx';
gY = Dy * D ;
%
if nargout == 3
    gT = abs( gX + 1i * gY);
end;
