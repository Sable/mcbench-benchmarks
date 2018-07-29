%% getFisherMatrix: calculate the Observed Fisher Information Matrix
%
% Usage:
%   Jf = getFisherMatrix(P, delta, logf)
%
% Inputs:
%    P                vector of parameters as input of logf
%    delta            vector with the deltas of all the parameters for the
%                      derivative approximation
%    logf             logarithm of the likelihood function  
%
% Output:
%    Jf               Fisher Information Matrix
%
% ------------------------------------------------------------------------
% See also
%
% Author : Flavio Cannavo'
% e-mail: flavio(dot)cannavo(at)gmail(dot)com
% Release: 1.0
% Date   : 22-03-2011
%
% History:
% 1.0  22-03-2011  First release.
%%

function Jf = getFisherMatrix(P, delta, logf)

numparams = length(P);

Jf = nan(numparams);

for i=1:numparams
    for j=1:numparams
        P11 = P; P_11 = P; P1_1 = P; P_1_1 = P; 
        P11(i) = P(i) + delta(i);
        P11(j) = P(j) + delta(j);
  
        P1_1(i) = P1_1(i) + delta(i);
        P1_1(j) = P1_1(j) - delta(j);
        
        P_11(i) = P_11(i) - delta(i);
        P_11(j) = P_11(j) + delta(j);
        
        P_1_1(i) = P(i) - delta(i);
        P_1_1(j) = P(j) - delta(j);
                
        Jf(i,j) = - ( logf(P11) - logf(P_11) - logf(P1_1) + logf(P_1_1) ) / ((3*(i~=j)+1)*delta(i)*delta(j));
    end
end

Jf = (Jf + Jf')/2;