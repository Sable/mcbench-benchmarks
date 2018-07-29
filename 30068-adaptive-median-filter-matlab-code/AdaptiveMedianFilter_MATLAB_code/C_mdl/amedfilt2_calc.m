function J = amedfilt2_calc(I) %#codegen
% 2-D Adaptive Median Filter
% This filter ignores edge effects and boundary conditions, as such, the
% output is a cropped version of the original image, where the amount
% cropped is equal to the maximum window size vertically and horizontally.

% Define smax as a constant
smax = 9;

% Initialize Output Image (J)
J = I;

% Calculate valid region limits for filter
[nrows ncols] = size(I);
ll = ceil(smax/2);
ul = floor(smax/2);

% Loop over the entire image ignoring edge effects
for rows = ll:nrows-ul
    for cols = ll:ncols-ul
        
        window_ind = -ul:ul;        
        region = I(rows+window_ind,cols+window_ind);
        centerpixel = region(ll,ll);

        for s = 3:2:smax
            
            % We can collapse the ROI calculations into a single function
            [rmin,rmax,rmed] = roi_stats(region,smax,s);

            % adapt region size
            if rmed > rmin && rmed < rmax
                if centerpixel <= rmin || centerpixel >= rmax
                    J(rows,cols) = rmed;
                end

                % stop adapting
                break;
            end
        end
    end
end



function [rmin,rmax,rmed] = roi_stats(region,smax,s)
% Limits for ROI
ll = ceil(smax/2)-floor(s/2);
ul = ceil(smax/2)+floor(s/2);

v = ones(smax*smax,1);
count = 1;

for i = ll:ul
    for j = ll:ul
        v(count) = region(i,j);
        count = count+1;
    end
end

v = visort(v,s*s);
rmed = v(ceil(s*s/2));
rmin = v(1);
rmax = v(s*s);