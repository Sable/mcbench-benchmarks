function f_hist = weighted_hist(fdata,weights,nlabels)

%WEIGHTED_HIST Computes weighted histograms
%
%   f_hist = weighted_hist(fdata,weights,nlabels);
%
%   fdata is a 2-D matrix MxN where M is the number of votes and N the 
%   number of samples.
%
%   weights is a Mx1 weight vector
%
%   nlabels is the number of labels


v_subs = fdata + nlabels*repmat(0:(size(fdata,2)-1),size(fdata,1),1);
weights_val = repmat(weights,1,size(v_subs,2));
f_hist = accumarray(v_subs(:),weights_val(:));
f_hist(numel(f_hist)+1:nlabels*size(fdata,2))=0;
f_hist = reshape(f_hist,nlabels,size(fdata,2));
