function makefigure(y, ThreeDee, PlotOrClose)
% Copyright (c) 2009, The MathWorks, Inc.
%
% Creates / updates /closes a MATLAB figure
persistent figureHandle;

if ishandle(figureHandle)
    % If figure exists, use it
    figure(figureHandle);
    if (nargin > 2)&&(PlotOrClose < -eps)
        % close the figure if needed
        close(figureHandle);
        return;
    end;
else
    % If figure doesn't exist and plotting is required, create it.
    if (nargin > 2)&&(PlotOrClose > eps)
        figureHandle = figure;
    else
        return;
    end;
end;

% Clear the figure and plot in 2D or 3D
clf;
if ThreeDee
    surf(y);
else
    plot(y);
end;
