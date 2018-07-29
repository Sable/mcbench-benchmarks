function RND = mnbinrnd(W, K, M, N)
%MNBINRND       Maszle's negative binomial random numbers
%
%   RND = MNBINRND(W, K, M, N) 
%
%   returns an M x N matrix of random numbers chosen from a negative
%   binomial distribution with mean W and aggregation K.
%
%   This is an alternate form of the negative binomial commonly
%   employed in biology to describe aggregated count data. 
%   W and K are related to the traditional parametrization by the
%   relationships: 
%
%       P = K/(K + W),  and K = R,
%
%   with the distinction that K is any positive real number, not just
%   positive integers.  K < 1 yields a highly skewed distribution.
%
%   The size of RND is the common size of W and K if both are matrices.
%   If either parameter is a scalar, the size of RND is the size of
%   the other parameter. 
%
%   Alternatively, RND = NBINRND(W, K, M, N) returns an M x N matrix. 
%
%   Requires stats toolbox.
%
%   See also MNBINPDF


%----------------------------------------------------------------------
% Copyright (c) 1999.  Don R. Maszle.  All rights reserved.
%
%   -- Revisions -----
%        Date:  4 March 1999
%      Author:  Don R. Maszle
%      E-mail:  maze@sparky.berkeley.edu
%   -- SCCS  ---------
%----------------------------------------------------------------------


%-- Perform standard argument checks for random generators


if (nargin < 2)
    error('Requires at least two parameters.'); 
end


if (nargin == 2)
    [iError nRows nCols] = rndcheck(2,2,K,W);
    if (max(size(K)) == 1)
      K = K(ones(nRows,1),ones(nCols,1));
    end
    if (max(size(W)) == 1)
      W = W(ones(nRows,1),ones(nCols,1));
    end
end


if (nargin == 3)
    [iError nRows nCols] = rndcheck(3,2,K,W,M);
    K = K(ones(M(1),1),ones(M(2),1));
    W = W(ones(M(1),1),ones(M(2),1));


end


if (nargin == 4)
    [iError nRows nCols] = rndcheck(4,2,K,W,M,N);
    K = K(ones(M,1), ones(N,1));
    W = W(ones(M,1), ones(N,1));
end


if (iError > 0)
    error('Size information is inconsistent.');
end



% From "Non-uniform random variate generation", Luc Devroye, New York,
% Springer-Verlag, 1986.  (Thanks to Charles N. Haas, Drexel U. for
% pointing me to this source.)
%
% As Devroye derives, the negative binomial can be expressed as a
% Poisson of a Gamma with parameters K and (1-P)/P, where P = K/(K + W).


RND = poissrnd(gamrnd(K, W./K, M, N));

