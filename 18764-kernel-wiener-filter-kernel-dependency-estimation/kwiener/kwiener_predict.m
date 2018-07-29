function pimage = kwiener_predict(ninput,X,Y,kcoeff,param)
% FUNCTION pimage = kwiener_predict(ninput,X,Y,kcoeff,param)
%   AUTHOR:    Makoto Yamada
%              (myamada@ism.ac.jp)
%   DATE:       12/25/07
%   Rev1:       02/16/08 : Modified the pre-image computation
% 
%  DESCRIPTION:
% 
%   This function compute the preimage by using kernel Wiener filter (kernel Dependency
%   Estimation) with Canonical Correlation Analysis (CCA) framework.
%
%  INPUTS:
%       ninput:     "ninput" is an unknown m times 1 dimensional vector.
%
%            X:     "X" is a (n times N) dimensional input matrix,
%                   where "n" is the vector dimension and N is the number
%                    of samples.
%
%            Y:     "Y" is a (m times N) dimensional output matrix.
%                    where "m" is the vector dimension and N is the number
%                    of samples.
%
%       kcoeff:      "kcoeff" is a structure variable which contains 
%                    the coefficient of kernel Wiener filter.
%
%        param:      1. "param.s" is a parameter for Gaussian kernel, 
%                       exp(-norm(x - y)^2/s).
%                    2. "param.rnk" is a rank of kernel Wiener Filter.
%                    3. "param.nnear" is the Number of nearest nighbor
%                       vectors to estimate a pre-image.
%
%  OUTPUTS:
% 
%    pimage   :     Preimage estimation.
% 
% 
%  Example: 
%              
%              param.nnear = 20;      %Number of nearest nighbor vectors to estimate a pre-image.
%              param.s     = 256*0.7; %Gaussian Kernel Parameter.
%              param.rnk   = 100;     %Rank of kernel Wiener filter.
%              ninput      = Ytest(:,1);
%              pimage      = kwiener_predict(ninput,X,Y,kcoeff,param);%Predicting the preimage of "ninput".
%            
%
%  Reference:  1. J. Weston et.al. ``Kernel Dependency Estimation,'' NIPS
%                 2003
%
%              2. M. Yamada and M. R. Azimi-Sadjadi, ``Kernel Wiener Filter
%                 using Canonical Correlation Analysis Framework,''
%                 IEEE SSP'05, Bordeaux, France, July 17-20, 2005. 
%
%              3. C. Cortes et.al. ``A General Regression Technique for
%                 Learning Transductions,'' ICML, Bonn, Germany, Aug 7-11.
%
%              4. M. Yamada and M. R. Azimi-Sadjadi, ``Kernel Wiener Filter
%                 with Distance Constraint,'' ICASSP,  Toulouse, France,
%                 May 14-19, 2006
%
%              5. Zhe Chen et.al, ``Correlative Learning: A Basis for Brain and Adaptive
%                 Systems,'' Wiley, Oct. 2007 (Section 4.6)

%Parameter for Kernel Wiener Filter
nnear = param.nnear;
s     = param.s; 

%If the rank parameter exceeds the 
if param.rnk < kcoeff.rnk
    rnk   = param.rnk;
else
    rnk   = kcoeff.rnk;
end
    
%Centering Matrix for Pre-image Computation.
J    = eye(nnear) - 1/nnear*ones(nnear, nnear);

%Pre-image Computation
Kxt = kcoeff.Kxt(1:rnk,:);
ky = kernelg(Y, ninput, s); 
kyt = kcoeff.Dg(:,1:rnk)'*ky;

%Modified on 1/7/2008
%d_h gives the probability density of p(x_i | ninput)
d_h = Kxt'*kyt/(kyt'*kyt);
indm = find(d_h < 0);
d_h(indm) = 0;
d = -s*log(min(1,d_h) + eps);

%p_h gives the probability density of p(x_i | ninput)
p_h = d_h/sum(d_h);

%Pre-image computation
[val index_d] = sort(d);
Xr = X(:, index_d(1:nnear));
C = Xr*J;

%Mean estimation
mx = mean(Xr,2);

dd = d(index_d(1:nnear));

rc = rank(C);
[U D V] = svd(C);
d0 = abs(diag(C'*C));

pimage = -1/2*U(:,1:rc)*inv(D(1:rc,1:rc))*V(:,1:rc)'*(dd - d0);
pimage = pimage + mx;