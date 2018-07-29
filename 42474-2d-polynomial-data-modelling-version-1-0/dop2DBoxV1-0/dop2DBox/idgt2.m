function D = idgt2( S, Bx, By )
%
% Purpose : This function computes the inverse 2D Gram polynomial
% transformation, e.g. of an Image.
%
% Use (syntax):
%   D = idgt2( S )
%   D = idgt2( S, Bx, By )
%
% Input Parameters :
%   S:= is the 2D Gram polynomial spectrum
%
%   Bx, By:= (optional) the bases functions for the x and y directions. Ths
%   passing of these paramaters is forseen since synthesizing the basis
%   functions is the numerically most intensive portion of this
%   computation. If the basis are provided from the function gt.m they can
%   be used here. This avoids resynthesizing the bases.
%
% Return Parameters :
%   D := The data synthesized form the spectrum
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

%
[ny, nx] = size( S );
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
            Bx = dop(ny);
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
% Compute the Polynomial Spectrum
%
D = By * S * Bx';
