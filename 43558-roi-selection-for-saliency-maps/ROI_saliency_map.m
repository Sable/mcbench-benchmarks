%----------------------------------------------------------
% Bharath, Ramesh, et al. "Scalable scene understanding using
% saliency-guided object localization." Control and Automation (ICCA), 2013
% 10th IEEE International Conference on. IEEE, 2013.
% http://ieeexplore.ieee.org/xpls/abs_all.jsp?arnumber=6565074
%----------------------------------------------------------

function fgm = ROI_saliency_map(I)

    % Opening by reconstruction
    se = strel('disk',5,0);
    Ie = imerode(I, se);
    Iobr = imreconstruct(Ie, I);
    
    if mean2(Iobr)==0 %rare case when sal. map is completely eroded
        fgm = I > 0;
        return;
    end

    % Regional maxima selects flat peaks
    fgm = imregionalmax(Iobr,8);
    
    % Discard regions with very low saliency values; Extra step not
    % included in the paper. 
    discard_thresh = 0.2;
    
    labelimg = bwlabel(fgm);
    s = regionprops(labelimg, I, 'MeanIntensity');
    avg_sal = [s.MeanIntensity];
    avg_sal = rescale(avg_sal,0,1);
    
    idx = find(avg_sal > discard_thresh);
    
    if ~isempty(idx)
    fgm = ismember(labelimg,idx);
    end
    
    
end