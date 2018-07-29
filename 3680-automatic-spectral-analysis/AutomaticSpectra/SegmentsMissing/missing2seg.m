function [sig, n_obs] = missing2seg(tg,xg)

%MISSING2SEG Extracts segments from missing data.
%   [sig n_obs] = missing2seg(tg,xg) extracts segments of 
%   uninterrupted observations from (time,observation) pairs (tg,xg).
%   Single disjunct observations are discarted.
%
%   Segments of equal length are grouped together. This speeds
%   up the subsequent analysis of the segments using BURG_SU.
%   This means that the order of occurrence of the segments
%   is not conserved. This does not change the result of BURG_SU.
%
%   See also BURG_SU, IRR2GRID.

tg = tg(:);
xg = xg(:);

adj_st = (diff(tg)==1);            % Status: adjacent or not
i_ch = find(diff([0; adj_st; 0])); % index of tg where index changes
n_seg = length(i_ch)/2;
i_s = i_ch(1:2:end);
i_e = i_ch(2:2:end);
npseg = tg(i_e)-tg(i_s)+1;

sig = cell(1,max(npseg));
for seg = 1:n_seg
    i_s = i_ch(2*seg-1);
    i_e = i_ch(2*seg);
    npseg = tg(i_e)-tg(i_s)+1;
    sig{npseg} = [sig{npseg} xg(i_s:i_e)];
end

%Remove empty cells
n_obs = [];
sig_ne = {};
counter = 1;
for lus = 1:length(sig)
    if ~isempty(sig{lus})
        sig_ne{counter} = sig{lus};
        s = size(sig{lus});
        n_obs = [n_obs s(1)*ones(1,s(2))]
        counter = counter+1;    
    end
end
sig = sig_ne;