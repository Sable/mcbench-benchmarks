function [cmap,cax] = mcColorMap(values,cmap)
%MCCOLORMAP returns the color mappin for values given cmap.
%   MCCOLORMAP uses the color map (CMAP) to define the color mapping for
%   the range in VALUES.
%

% find range of data in values and normalize to [0 1]
maxVal = max(values);
minVal = min(values);
normVal = (values - minVal)./ (maxVal - minVal);

% map to color
noColors = length(cmap);
indx = interp1(0:1/(noColors-1):1,1:noColors,normVal,'nearest');
cmap = cmap(indx,:);
cax = [minVal maxVal];





