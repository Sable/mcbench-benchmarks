function [S, Bxo, Byo] = dgt2( D, Bx, By )
%
% Purpose : This function computes a 2D Gram polynomial transformation, 
% e.g. of an Image. 
%
% Use (syntax):
%   S = dgt2( D )
%   [S, Bx, By] = dgt2( D )
%
% Input Parameters :
%   D: The 2D data lying on a grid, the function can be applied to any
%   form of data, e.g. surface data or images.
%
%   Bx, By:= (optional) the bases functions for the x and y directions. 
%   Passing of these paramaters is forseen since synthesizing the basis
%   functions is the numerically most intensive portion of this
%   computation. If multiple transforms are being computed it will save
%   considererable time by avoiding resynthesising the bases
%
% Return Parameters :
%   S: The two dimensional Gram Polynomial Spectrum for the image.
%   Bx, By: (optional) The matrices containing basis functions used in th
%   ex and y directions respectivly.
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
switch nargin
    case {1}
        %
        % Generate the bases
        %
        By = dop( ny );
        %
        if ny == nx
            %
            % Avoide generating the second basis if the matrix D is square
            %
            Bx = By;
        else
            Bx = dop(nx);
        end;
        %
    case {2}
        error('This function must be called with either one or three paramaters');
    case {3}
        [nbx, mbx] = size( Bx );
        if nbx ~= mbx
            error('The matrix Bx must be complete, i.e. it must be square');
        end;
        %
        [nby, mby] = size( By );
        if nby ~= mby
            error('The matrix By must be complete, i.e. it must be square');
        end;
        %
        if nby ~= ny
            error('The dimension of matrix By is not compatable with D');
        end;
        %
        if nbx ~= nx
            error('The dimension of matrix Bx is not compatable with D');
        end;
end;
%
% Compute the Polynomial Spectrum
%
S = By' * D * Bx;
% 
if nargout == 3
    Bxo = Bx;
    Byo = By;
end;