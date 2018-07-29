% Based on LLR get mutual information. Just a wrapper so you can try
% different methods to get MI.
% Copyright (C) 2011 Colin O'Flynn
%
%     This file is not part of the Iterative Solutions Coded Modulation
%     Library, and is instead part of an extension by Colin O'Flynn at
%     newae.com. It is distributed under the same terms as ISCML and can be
%     included in the official ISCML project if the authors wish
%
%     See license file with this distribution.

function mi = measure_mutual_information(LLR, data)
    %Uncomment which ever method you want

    %Averaging Method
    mi = measureMI_llrOnly(LLR);
    
    %Histogram Method
    %NB: Histogram method function expects LLRs with opposite sign, so we
    %flip sign before sending in
    %mi = measure_mutual_information_histogram(-LLR, data);
end