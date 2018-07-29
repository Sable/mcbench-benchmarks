function A = transformation_matrix(N,opt_meth)

%--------------------------------------------------------------------------
%
%       A = transformation_matrix(N,opt_meth)
%
% Computation of the transformation_matrix (square matrix N by N) between the harmonic
% contributions gn(t) and the Hammerstein kernels hn(t) following two
% different approaches.
%
% Inputs:
%   N : desired size of the square matrix
%   opt_meth: Method to use for the computation 'Reb' for [1] or 'Nov' for [2].
%
% Output:
%   A : square matrix N by N
%
% References:
%
% [1] M. Rébillat, R. Hennequin, E. Corteel, B.F.G. Katz, "Identification
% of cascade of Hammerstein models for the description of non-linearities 
% in vibrating devices", Journal of Sound and Vibration, Volume 330, Issue 
% 5, Pages 1018-1038, February 2011. 
%
% [2] A. Novak, L. Simon, F. Kadlec, P. Lotton, "Nonlinear system 
% identification using exponential swept-sine signal", IEEE Transactions on
% Instrumentation and Measurement, Volume 59, Issue 8, Pages 2220-2229,
% August 2010.
%
% Marc Rébillat & Romain Hennequin - 02/2011
% marc.rebillat@limsi.fr / romain.hennequin@telecom-paristech.fr
%
%--------------------------------------------------------------------------

if strcmp(opt_meth,'Reb')
    
    [T, TT] =  chebyshevAux(N);
    T = T(2:end,2:end);
    A = T' ;
    
elseif strcmp(opt_meth,'Nov')
    
    for n = 1:N
        for m = 1:N
            if ( (n>=m) && (mod(n+m,2)==0) )
                A(n,m) = (((-1)^(2*n+(1-m)/2))/(2^(n-1)))*nchoosek(n,(n-m)/2) ;
            end
        end
    end

    A = inv(A') ;
    
end

function [T0 T1] = chebyshevAux(n)

switch lower(n)
    case 0
        T0 = 1;
        T1 = 0;
    case 1
        T0 = [1,0;0,1];
        T1 = 1;
    otherwise
        T0 = zeros(n+1);
        [T1 T2] = chebyshevAux(n-1);
        T0(1:n,1:n) = T1;
        T0(n+1,:) = 2*[0 T1(n,:)] - [T2(n-1,:) 0 0];
end
