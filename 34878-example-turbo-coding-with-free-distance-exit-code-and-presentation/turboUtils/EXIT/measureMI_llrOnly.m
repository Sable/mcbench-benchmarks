% Based on LLR get mutual information. Currently this function uses the
% averaging method, which does't actually require the data input
% Copyright (C) 2011 Colin O'Flynn
%
%     This file is not part of the Iterative Solutions Coded Modulation
%     Library, and is instead part of an extension by Colin O'Flynn at
%     newae.com. It is distributed under the same terms as ISCML and can be
%     included in the official ISCML project if the authors wish
%
%     See license file with this distribution.
%
% This function is based on a version Copyright (C) 2010  Robert G. Maunder
% from http://users.ecs.soton.ac.uk/rm/resources/matlabturbo .

function mi = measureMI_llrOnly(LLR)
    %Equation to use is from the paper "THE EXIT CHART – INTRODUCTION TO
    %EXTRINSIC INFORMATION TRANSFER IN ITERATIVE PROCESSING" Section 2.3. 

    halfllrs = abs(LLR) ./ 2;    
    P = exp(halfllrs) ./ (exp(halfllrs) + exp(-halfllrs));
    
    %Apply Hb (Binary Entropy Function)   
    entropies = -P .* log2(P) - (1-P) .* log2(1-P);

    %Test for NAN result as well
    mi = 1 - sum(entropies(~isnan(entropies)))/length(entropies);
end