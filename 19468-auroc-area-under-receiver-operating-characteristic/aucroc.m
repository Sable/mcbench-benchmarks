function auc = aucroc(p_predicted, p_target, freq)

        % Count observations by class
        nTarget     = sum(freq .* p_target);
        nBackground = sum(freq .* (1-p_target));

        % Rank data
        R = tiedrank(p_predicted);  % 'tiedrank' from Statistics Toolbox
        [R_uniq, I, J] = unique(R);
        [R_mean,R_num] = grpstats(freq,R,{'mean','numel'});
        R_freq = R_mean .* R_num;

        % adjust for counts
        rank_start_freq = cumsum(R_freq);
        rank_start_freq = [0; rank_start_freq(1:(end-1))] + 1;
        rank_mean_freq = (2*rank_start_freq+R_freq-1)/2;
        
        rank_orig = rank_mean_freq(J);

        % Calculate AUC
        %Error = (sum(R(Actual == 1)) - (nTarget^2 + nTarget)/2) / (nTarget * nBackground);
        auc = (sum(rank_orig .* p_target .* freq) - (nTarget^2 + nTarget)/2) / (nTarget * nBackground);
                

