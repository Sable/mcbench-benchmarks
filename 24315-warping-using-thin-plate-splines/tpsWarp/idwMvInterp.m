function out = idwMvInterp(imgw, map, maxhw, p )
% Description:
% Fill holes using Inverse Distance Weighting interpolation
%
% Inputs:
% imgw - input image
% map - Map of the canvas with 0 indicating holes and 1 indicating pixel
% maxhw - Radius of inverse weighted interpolation
% p - power for inverse weighted interpolation
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
        yixL=max(yi-maxhw,1);
        yixU=min(yi+maxhw,outH);
        xixL=max(xi-maxhw,1);
        xixU=min(xi+maxhw,outW);

        % use inverse distance weighting filter for filling
        mapw = map(yixL:yixU,xixL:xixU);
        if isempty(find(mapw, 1)) == false,
            wk = compWk(mapw, xi-xixL+1, yi-yixL+1, p); % compute weights for interpolation
            for colIx = 1:color,
                out(yi,xi,colIx) = idw(imgw(yixL:yixU, xixL:xixU, colIx), mapw, wk); % interpolation
            end
        end
    end
end

return;

% compute wk
function wk = compWk(map, cx, cy, p)

[h,w] = size(map);
[x,y] = meshgrid(1:h,1:w);
y=(y-cx).^2;
x=(x-cy).^2;
d2=x+y; % square of distance
wk = 1./(d2'.^(p/2));

return;

% Inverse distance weighting
function out = idw(in, map, wk)

num=sum(double(in(find(map))).*wk(find(map))); % weight the available pixel values among the neighbors
den=sum(wk(find(map))); % sum of contributing weights within radius r

out = num / den;

return