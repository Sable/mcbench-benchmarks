function level = thresh(I)
%THRESH Global image threshold using Otsu's method.
%   level = thresh(I) computes a global threshold (level) that can be
%   used to convert an intensity image to a binary image with IM2BW. Level
%   is a normalized intensity value that lies in the range [0, 1].
%   THRESH uses Otsu's method, which chooses the threshold to minimize
%   the intraclass variance of the thresholded black and white pixels.
%
%   The implementation of this function is based on MATLAB's GRAYTHRESH
%   function. THRESH is simplified and was changes in order to be used
%   with distances that are the results of the MTM_PWC function.

%  Written by: Elad Bullkich, Idan Ilan, Yair Moshe
%  Signal and Image Processing Laboratory (SIPL)
%  Department of Electrical Engineering
%  Technion - Israel Institute of Technology
%
%  $Revision 1.0        $Date: 5/30/2012

% Reference:
% N. Otsu, "A Threshold Selection Method from Gray-Level Histograms,"
% IEEE Transactions on Systems, Man, and Cybernetics, vol. 9, no. 1,
% pp. 62-66, 1979.

I =(I(:));
num_bins = 65536;
counts = imhist(I,num_bins);

% Variables names are chosen to be similar to the formulas in
% the Otsu paper.
p = counts / sum(counts);
omega = cumsum(p);
mu = cumsum(p .* (1:num_bins)');
mu_t = mu(end);

sigma_b_squared = (mu_t * omega - mu).^2 ./ (omega .* (1 - omega));

% Find the location of the maximum value of sigma_b_squared.
% The maximum may extend over several bins, so average together the
% locations.  If maxval is NaN, meaning that sigma_b_squared is all NaN,
% then return 0.
maxval = max(sigma_b_squared);
isfinite_maxval = isfinite(maxval);
if isfinite_maxval
    idx = mean(find(sigma_b_squared == maxval));
    % Normalize the threshold to the range [0, 1].
    level = (idx - 1) / (num_bins - 1);
else
    level = 0.0;
end

end