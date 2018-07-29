function bounds=FTC_Histogram_Segmentation(h)

%============================================================
% function bounds=FTC_Histogram_Segmentation(h)
%
% This function performed the Fine To Coarse histogram
% segmentation algorithm described in the paper from Julie 
% Delon  et al., "A non parametric approach for histogram
% segmentation", IEEE Transactions on Image Processing 
% 16(1), 253-261 (2007).
% This Matlab code is simply a "mexified" version of Julie's
% code (and I thank Julie to provided me this code!). It also 
% includes some fraction code from the Megawave library.
%
% Input: h: the 1D histogram you want to segment
% Output: bounds: vector containing the list of boundaries 
%                 corresponding to each detected segment
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%============================================================

if (size(h,1)<2) && (size(h,2)>1)
    h=h';
end

if size(h,2)>1
    disp('the input argument is not a 1D histogram');
    bounds=0;
    return
end

bounds=ftc_seg(h);