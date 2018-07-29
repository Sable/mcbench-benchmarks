% polyvalm2 - Evaluate polynomial with matrix argument.
%*************************************************************************************
% 
%  MATLAB (R) is a trademark of The Mathworks (R) Corporation
% 
%  Function:    polyvalm2
%  Filename:    polyvalm2.m
%  Programmer:  James Tursa
%  Version:     1.1
%  Date:        November 11, 2009
%  Copyright:   (c) 2009 by James Tursa, All Rights Reserved
%
%  This code uses the BSD License:
%
%  Redistribution and use in source and binary forms, with or without 
%  modification, are permitted provided that the following conditions are 
%  met:
%
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%      
%  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%  POSSIBILITY OF SUCH DAMAGE.
% 
%  polyvalm2 evaluates a polynomial with a square matrix argument faster
%  than the MATLAB built-in functions polyvalm or mpower.
%
%   Y = polyvalm2(P,X), when P is a vector of length N+1 whose
%   elements are the coefficients of a polynomial, is the value
%   of the polynomial evaluated with matrix argument X.  X must
%   be a square matrix. 
%
%       Y = P(1)*X^N + P(2)*X^(N-1) + ... + P(N)*X + P(N+1)*I
%
%   Class support for inputs P, X:
%      float: double, single
%
%  The polyvalm2 speed improvements come from the following:
%
%  1) The MATLAB built-in function polyvalm uses Horner's method.
%     polyvalm2 uses a binary decomposition of the matrix powers
%     to do the calculation more efficiently, reducing the total
%     number of matrix multiplies used to calculate the answer.
%
%  2) polyvalm calculates the product of a scalar times a matrix
%     as the product of diag(scalar*ones(etc))*matrix ... i.e. it
%     does a matrix multiply. polyvalm2 will calculate this more
%     efficiently as the simple product scalar*matrix.
%
%  3) polyvalm does all of the calculations shown above, even if
%     the coefficient P(i) is zero. polyvalm2 does not do
%     calculations for P(i) coefficients that are zero.
%
%  4) polyvalm converts sparse matrix inputs into full matrices to
%     do the calculations, whereas polyvalm2 keeps the intermediate
%     calculations and the answer sparse.
%
%  An extreme case of speed difference can be found with a sparse
%  matrix example:
%
%  >> A = sprand(2500,2500,.01);
%  >> p = [1 2 3 4];
%  >> tic;polyvalm(p,A);toc
%     Elapsed time is 43.669362 seconds.
%  >> tic;polyvalm2(p,A);toc
%     Elapsed time is 4.240375 seconds.
%
%  The trade-off is that polyvalm2 uses more memory for intermediate
%  variables than polyvalm, so for very large matrices polyvalm2 can
%  run out of memory. In these cases polyvalm2 will abandon the
%  efficient calculation method and just call the built-in polyvalm.
%  For sparse matrix inputs, however, polyvalm2 will typically be more
%  memory efficient than the MATLAB polyvalm function.
%
%  Caution: Since polyvalm2 uses different calculations to form the matrix
%  powers, the end result may not match polyvalm exactly. Also, for the
%  case where only the leading coefficient is non-zero, polyvalm2 may not
%  match mpower exactly. But the answer will be just as accurate. And if
%  there are inf's or NaN's involved, then the end result will not, in
%  general, match polyvalm or mpower results. This should not be a great
%  drawback to using polyvalm2, however, since even the MATLAB built-in
%  functions polyvalm and mpower will not match each other in these cases.
%  (By reordering the calculations, the NaN's propagate differently)
% 
%  Change Log:
%  Nov 11, 2009: Updated for sparse matrix input --> sparse result
%
%**************************************************************************

function Y = polyvalm2(p,X)
%\
% Check the arguments
%/
if( nargin ~= 2 )
    error('MATLAB:polyvalm2:InvalidNumberOfArgs','Need two input arguments.');
end
if( nargout > 1 )
    error('MATLAB:polyvalm2:TooManyOutputArgs','Too many output arguments.');
end
classname = superiorfloat(p,X);
if( ~(isvector(p) || isempty(p)) )
    error('MATLAB:polyvalm2:InvalidP','P must be a vector.');
end
z = size(X);
if( length(z) > 2 || z(1) ~= z(2) )
    error('MATLAB:polyvalm2:NonSquareMatrix','Matrix must be square.');
end
if( isempty(X) )
    if( issparse(X) )
        Y = sparse(z(1),z(2));
    else
        Y = zeros(z,classname);
    end
    return
end
%\
% Clear out any leading zeros and reverse the coefficients
%/
try
    f = find(p,1,'first');
    if( isempty(f) )
        if( issparse(X) )
            Y = sparse(z(1),z(2));
        else
            Y = zeros(z,classname);
        end
        return
    end
    p2 = p(end:-1:f);
%\
% Initialize return value with the constant term, and then set the
% constant term coefficient to 0 so we don't process it anymore.
%/
    if( issparse(X) )
        Y = diag(p2(1) * sparse(ones(z(1),1)));
    else
        Y = diag(p2(1) * ones(z(1),1,classname));
    end
    p2(1) = 0;
%\
% Special small cases use custom code for quick return
%/
    np = length(p2);
    if( np == 1 )
        return
    elseif( np == 2 )
        if( p2(2) == 1 )
            Y = Y + X;
        else
            Y = Y + p2(2) * X;
        end
        return
    end
%\
% Initialize the cell array that will hold the X powers
%/
    cp{np} = [];
%\
% Get the binary decomposition of the powers as rows of binary characters,
% each row representing a different power, and arranged from 0 at the top
% to the highest power at the bottom.
%/
    bp = dec2bin(0:(np-1));
%\
% Loop through the bit positions from least significant to most significant
%/
    P = X;
    zz = size(bp,2);
    for n=zz:-1:1
%\
% Only process those rows with non-zero coefficients. If the bit position
% for this row is 1, then we need to apply the current power of X to the
% cell for this row. Each cell is building up the appropriate power of X.
% cp{1} is for X^0 (not used or needed actually because we have that piece
% already calculated from above), cp{2} is for X^1, cp{3} is for X^2, etc.
% P is the current power of X, i.e. P = X^(2^(zz-n))
%/
        check = (p2 ~= 0);
        for m=1:np
            if( check(m) && bp(m,n) == '1' )
                if( isempty(cp{m}) )
                    cp{m} = P;
                else
                    cp{m} = cp{m} * P;
                end
%\
% Look at all the downstream bit patterns. If any match the current one for
% the bits processed so far, then just copy the current cell into the
% downstream cells (no need to repeat the calculation downstream because we
% already know the answer). Then reset the check flag for that downstream
% row so we don't process it for this particular loop index.
%/
                for k=m+1:np
                    if( check(k) && isequal(bp(m,n:zz),bp(k,n:zz)) )
                        cp{k} = cp{m};
                        check(k) = 0;
                    end
                end
%\
% If the remaining leftmost bits of the current row are 0, then we are done
% with this power of X. Apply the coefficient and add it to the result,
% then free up the memory for this cell position. Also, reset the
% coefficient for this row to 0 so we know not to process this row anymore.
%/
                if( all(bp(m,1:(n-1))=='0') )
                    Y = Y + p2(m) * cp{m};
                    p2(m) = 0;
                    cp{m} = [];
                end
            end
        end
%\
% Square the current power of X, but not if it is the last index in the
% loop because in that case it won't be used or needed. For some reason,
% P * P is a lot faster than P^2.
%/
        if( n ~= 1 )
            P = P * P;
        end
    end
%\
% The binary decomposition scheme used too much memory, so clear all of the
% local large variables and just call the built in polyvalm function
% instead. This is slower and computationally less efficient, but it is
% more memory efficient so it might work.
%/
catch
    warning('MATLAB:polyvalm2:OutOfMemory','Out Of Memory ... Resorting to built-in polyvalm');
    clear cp P bp p2 check;
    Y = polyvalm(p,X);
end
return
end
