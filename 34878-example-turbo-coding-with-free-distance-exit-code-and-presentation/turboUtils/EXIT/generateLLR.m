function llrs = generateLLR(input, Ia_value)
% Given an input sequence & desired IA value, generate the Log-likilood
% Ratios to feed into the decoder for EXIT chart plotting.
%
% (C) Colin O'Flynn 2011
%
%     This file is not part of the Iterative Solutions Coded Modulation
%     Library, and is instead part of an extension by Colin O'Flynn at
%     newae.com. It is distributed under the same terms as ISCML and can be
%     included in the official ISCML project if the authors wish
%
%     See license file with this distribution.
%

    % Check we aren't being screwed around with
    if Ia_value < 0
        error('IA must be >= 0');
    elseif Ia_value > 1;
        error('IA must be <= 1');        
    elseif Ia_value == 0
        %IA = 0, sigma = 0, so output = zeros
        llrs = zeros(1, length(input));
        return
    elseif Ia_value == 1;
        %IA = 1, sigma = +inf, but we limit to avoid problems
        llrs = 2*(input-0.5)*100000;
        return
    end

    % Generate Base LLR: gaussian zero-mean variable, stddev = 1
    basellrs = randn(1, length(input));
       
    % We will iteratively bring this low/high limit into the desired IA_value
    low = 0.0;
    high = 1.0;
    
    while 1
    
        Ia_mean = (low + high)/2;
%        Ia_mean = Ia_value;
        
        % Based on the mean value of Im, we need to set the stddev to something.
        % This is given in "Convergance Analysis and Optimal Scheduling for
        % Multiple Concatenated Codes" by F Brannstrom & L K Rasmussen & A J Grant.
        % The approximate value is given as:
        %
        h1 = 0.3073;
        h2 = 0.8935;
        h3 = 1.1064;
        sigma = ( (-1.0 / h1) * log2(1.0 - (Ia_mean ^ (1.0 / h3) ) ) ) ^ (1.0 / (2.0 * h2));       
        
        % We need initial LLR, and we apply this formula (see Turbo
        % Coding, Turbo Equalization and Space-Time Coding 2nd ed page 498)
        % Since input is 0 or 1, 2*(input - 0.5) makes it set of -1 or +1
        % Then apply formula 16.7 from that book, where basellrs are the
        % noise term. We want this noise term to have stddev of sigma, so
        % we multiply them by sigma.
        llrs = (2*(input-0.5))*(sigma^2/2) + basellrs * sigma;
        
         % Measure the resulting MI
         IaOfLLR = measureMI_llrOnly(llrs);
         
         if abs(IaOfLLR-Ia_value) < 0.0001
             %Close enough
             return
         elseif IaOfLLR > Ia_value
             %Resulting Ia is too high - shift it down by lowering upper
             %limit
             high = Ia_mean;
         else
             %Resulting Ia is too low - shift it up by increasing lower
             %limit
             low = Ia_mean;
         end        
     end           