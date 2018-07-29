

function [InfoLoss] = CalcInfoLoss(D, N, Crossval_OR_Resubstit)

% The Estimation of Information Loss can be found in the PAMI paper
% Copyright: Dimitrios Ververidis 
% Version 0.0  Date: 09 Jan 09

% INPUT
% D: Dimensionality      2<D<N-1
% N : samples per class    D<N-1
% Crossval_OR_Resubstit: STRING ('Crossvalidation', 
%                                'Resubstitution').
% OUTPUT
% InfoLoss: The amount of information loss lying in [0,1]

cd('LowLevelFunctions')
if strcmp(Crossval_OR_Resubstit,'Resubstitution') 
    %------------  Re-substitution Info Loss  -----------------
    if D ==1
        hX2Beta = 0;
    elseif D<N-1
        if D < N-3
            LogLArgem = log(1/N/(3+D-N)) + (2*N-6)/(N-D-3) * log(N-1) + ...
                D/(3+D-N) *log( 2*N) + ...
                8*log(FactorGamma(N-1, N-D-1,1/(3+D-N)/4)) - (N-1)^2/N/(N-D-3);

            LArgem = real(exp(LogLArgem));
            rSolBeta1 =  (N-D-3) * lambertw2(-1, LArgem) + (N-1)^2 / N;
            rSolBeta1 = real(rSolBeta1);
            rSolBeta2 =  (N-D-3) * lambertw2(0, LArgem) + (N-1)^2 / N;
            rSolBeta2 = real(rSolBeta2);
        elseif D == N-2
            LogLArgem = log(1/N) - (2*N-6)* log(N-1) + ...
                (N-2)*log( 2*N) + 16*log(FactorGamma(N-1, 1,1/8)) + (N-1)^2/N;
            LArgem = real(exp(LogLArgem));

            rSolBeta1 =  - lambertw2(0, LArgem) + (N-1)^2 / N;
            rSolBeta1 = real(rSolBeta1);
            rSolBeta2 = (N-1)^2 / N;
        elseif D == N-3
            rSolBeta1  = -2*((N-3)/2*log(2*N) - (N-3)*log(N-1) + 8*log(FactorGamma(N-1, 2,1/8)));
            rSolBeta2  = (N-1)^2 / N;
        end

        if  abs(N/(N-1)^2 *  rSolBeta2 - 1) < 1e-10
            rSolBeta2 = (N/(N-1)^2)^(-1);
        end

        hX2Beta =  betainc(N/(N-1)^2*rSolBeta2, D/2, (N-D-1)/2) - ...
            chi2cdf(rSolBeta2,D) - ...
            betainc(N/(N-1)^2*rSolBeta1, D/2, (N-D-1)/2) + ...
            chi2cdf(rSolBeta1,D);
    elseif D>=N-1
        hX2Beta = 1;
    end
    InfoLoss = hX2Beta; 
    %------------End Re-substitution -----------------
else
    % -----   Cross-validation Info Loss -----------------
    if D ==1
        hX2Fisher = 0;
    elseif D<N-2
         rSolFisher = -N*lambertw2(-1,...
            - FactorGamma(N, N-D, 2/N) * 2^(D/N) * N^(D/N-2) * ...
                         (N^2-1)^(1-D/N) * exp(1/N^2 - 1)) - N+1/N;
         rSolFisher = real(rSolFisher);  
         hX2Fisher = chi2cdf(rSolFisher, D) - ...
            betainc(1./(  1 + (N^2-1)./(N*rSolFisher)), D/2, (N-D)/2);
    elseif D>=N-2
        hX2Fisher = 1;
    end
    InfoLoss = hX2Fisher;
    %------------End Cross-validation -----------------
end
cd('..');

return

function w = lambertw2(b,z)
%LAMBERTW  Lambert W-Function.
%   W = LAMBERTW(Z) computes the principal value of the Lambert 
%   W-Function, the solution of Z = W*exp(W).  Z may be a 
%   complex scalar or array.  For real Z, the result is real on
%   the principal branch for Z >= -1/e.
%
%   W = LAMBERTW(B,Z) specifies which branch of the Lambert 
%   W-Function to compute.  If Z is an array, B may be either an
%   integer array of the same size as Z or an integer scalar.
%   If Z is a scalar, B may be an array of any size.
%
%   The algorithm uses series approximations as initializations
%   and Halley's method as developed in Corless, Gonnet, Hare,
%   Jeffrey, Knuth, "On the Lambert W Function", Advances in
%   Computational Mathematics, volume 5, 1996, pp. 329-359.

% Pascal Getreuer 2005-2006
% Modified by Didier Clamond, 2005

if nargin == 1
   z = b;
   b = 0;
end

% Use asymptotic expansion w = log(z) - log(log(z)) for most z
tmp = log(z + (z == 0)) + i*b*6.28318530717958648;
w = tmp - log(tmp + (tmp == 0));

% For b = 0, use a series expansion when close to the branch point
k = find(b == 0 & abs(z + 0.3678794411714423216) <= 1.5);
tmp = sqrt(5.43656365691809047*z + 2) - 1 + i*b*6.28318530717958648;
w(k) = tmp(k);

for k = 1:36
   % Converge with Halley's iterations, about 5 iterations satisfies
   % the tolerance for most z
   c1 = exp(w);
   c2 = w.*c1 - z;
   w1 = w + (w ~= -1);
   dw = c2./(c1.*w1 - ((w + 2).*c2./(2*w1)));
   w = w - dw;

   if all(abs(dw) < 0.7e-16*(2+abs(w)))
      break;
   end
end

% Specially handle z = 0
w(b ~= 0 & z == 0) = -inf;


