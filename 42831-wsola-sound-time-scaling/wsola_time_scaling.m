function sig_out = wsola_time_scaling(sig_in, fs, scale_factor, simil_method)
% sig_in - input signal
% fs - sampling frequency
% scale_factor - by what ratio to strech/compress the audio. 
% simil_method - optional parameter either 'xcorr' or 'amdf' (default)
%
% from the paper by Werner VERHELST and Marc ROELANDS
% found here: 
% http://www.etro.vub.ac.be/research/dssp/PUB_FILES/int_conf/ICASSP-1993.pdf

if nargin<4
	simil_method = 'amdf';
end

sf_split_margin = 3;
orig_len = length(sig_in);
% recursively treat scale factors too big or too small
if (scale_factor > sf_split_margin) || (scale_factor < 1/sf_split_margin)
    num_recur = ceil(abs((log(scale_factor)./log(sf_split_margin))));
    
    scale_factor_recur = scale_factor.^((num_recur-1)/num_recur);
    
    sig_in = wsola_time_scaling(sig_in, fs, scale_factor_recur, simil_method);
    
    scale_factor = scale_factor./(length(sig_in)./orig_len);
end


% consts
win_time = 0.020; %sec
overlap_ratio = 0.5;
max_err = min(0.005, win_time*overlap_ratio./scale_factor/2); 

% lengths
win_len = ceil(win_time.*fs);
max_err_len = ceil(max_err.*fs);
step_len = floor(overlap_ratio.*win_len);

% vectors
win = hann(win_len);
% orig_scale = 1:length(sig_in);
new_scale = (1:round((length(sig_in).*scale_factor*2)))';
sig_out = zeros(size(new_scale));
win_out = zeros(size(new_scale));

cursor_in = 1;
cursor_out = 1;

while cursor_in<(length(sig_in)-win_len-max(step_len, step_len./scale_factor) - 2*max_err_len)...
                                    && cursor_out<(length(sig_out)-win_len)
    % input segments
    new_seg = sig_in(cursor_in:(cursor_in+win_len-1)).*win;
    new_seg_neihbour = sig_in((cursor_in+step_len):(cursor_in+step_len+win_len-1)).*win;
    % overlap add
    sig_out(cursor_out:(cursor_out+win_len-1)) = ...
            sig_out(cursor_out:(cursor_out+win_len-1))+...
            new_seg;
    % overlap add window normalization vec
    win_out(cursor_out:(cursor_out+win_len-1)) = ...
            win_out(cursor_out:(cursor_out+win_len-1))+...
            win;
    % move cursors
    cursor_out = cursor_out + step_len;
    cursor_in = cursor_in + round(step_len./scale_factor);
    % new candidate
    new_seg_cand = sig_in((cursor_in):(cursor_in+win_len-1)).*win;
    % similarity calc. Note: matlab apears to be using FFT for xcorr, and
    % so computes the whole thing (instead of just the center). 
    % Writing own version of xcorr would probably make it faster.
    if strcmp(simil_method, 'xcorr')
        shift = max_xcorr_similarity(new_seg_neihbour, new_seg_cand, max_err_len);
    elseif strcmp(simil_method, 'amdf')
        shift = min_amdf_similarity(new_seg_neihbour, new_seg_cand, max_err_len);
    else
        return
    end 
    % adjust cursor place
    cursor_in = cursor_in - shift;
end

% remove slack
sig_out(cursor_out:end) = [];
win_out(cursor_out:end) = [];

sig_out = sig_out./(win_out+eps); %normalize to remove possible modulations

end

    % cross correlation based similarity calculation
    function shift = max_xcorr_similarity(seg1, seg2, max_lag)
        [~, max_i] = max(xcorr(seg1, seg2, max_lag, 'unbiased'));
        shift = max_i - max_lag;
    end

    % amdf based similarity calculation
    function shift = min_amdf_similarity(seg1, seg2, max_lag)
        n = length(seg1);
        amdf = ones(1,2*max_lag-1);
        for lag=-max_lag:max_lag
            amdf(lag+max_lag+1) = sum(abs(seg2(max(1,(-lag+1)):min(n,(n-lag)))-...
                           seg1(max(1,(lag+1)):min(n,(n+lag))) ))/n;
        end
        [~, min_i] = min(amdf);
        shift = min_i - max_lag;
    end