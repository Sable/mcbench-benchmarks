function out = nearestInterp(imgw, map, maxhw )
% Description:
% Fill holes using nearest neighbor (median filter of neighbors) interpolation
%
% Inputs:
% imgw - input image
% map - Map of the canvas with 0 indicating holes and 1 indicating pixel
% maxhw - Max radius for nearest neighbor interpolation
%
% Output:
% out - interpolated image
%
% Author: Fitzgerald J Archibald
% Date: 23-Apr-09

outH  = size(imgw,1);
outW  = size(imgw,2);
out = imgw;

[yi_arr, xi_arr] = find(map==0); % Find locations needing fill
if isempty(yi_arr) == false
    color = size(imgw,3);
    for ix = 1:length(yi_arr),

        xi = xi_arr(ix);
        yi = yi_arr(ix);

        % Find min window which has non-hole neighbors
        nz = false;
        for h = 1:maxhw,
            yixL=max(yi-h,1);
            yixU=min(yi+h,outH);
            xixL=max(xi-h,1);
            xixU=min(xi+h,outW);

            if isempty(find(map(yixL:yixU,xixL:xixU), 1)) == false
                nz = true;
                break;
            end
        end

        % use the median of non-hole neighbors in the window for filling
        if nz == true,
            for colIx = 1:color,
                win=imgw(yixL:yixU, xixL:xixU, colIx);
                out(yi,xi,colIx) = median(win(find(map(yixL:yixU, xixL:xixU)~=0)));
            end
        end

    end
end

return;

