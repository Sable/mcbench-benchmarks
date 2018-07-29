function [ CR ] = ConsistencyAHP( CompMat )
%CONSISTENCYAHP AHP Consistency Analysis
%   Calculates the quality level of a decision
%   using Consistency Ratio
% AUTHOR:
%           F. Ozgur CATAK
% CREATED:
%           October, 2011


%%
% Random Consistency Index
RI = [0 0 0.58 0.9 1.12 1.24 1.32 1.41 1.45 1.49];
%%
[W lambda] = eig(CompMat);
[m n] = size(CompMat);

lambdaMax = max(max(lambda));

% Consistency index calculation
CI = (lambdaMax - n)/(n-1);

% Consistency Ratio
CR = CI/RI(1,n);
if CR > 0.10
    str = 'CR is %% %1.2f. Subjective evaluation is NOT consistent!!!';
    str=sprintf(str,CR);
    disp(str);
end

end