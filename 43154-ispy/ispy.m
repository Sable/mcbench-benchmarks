function ispy(A,sizeMultiplier)
%ISPY Visualize sparsity pattern and the size of the elements of a matrix.
%
%   ISPY(S) plots the sparsity pattern of the matrix S and visualizes the
%   size and sign of its elements. Positive elements are plotted in
%   red and negative elements in blue. Zero elements are not plotted.
%   The size of an element is scaled logarithmically.
%
%   The imaginary part of any number is discarded.
%   NaNs are plotted as red stars on a yellow background.
%   Infs are plotted as blue stars on a green background.
%
%   If the matrix is very big, try zooming in to get a more accurate view.
%
%   If the visualisation should rely on coloring instead of sizes, or if the
%   matrix is really big, then you should consider using imagesc instead.
%
%   sizeMultiplier allows for manual tuning of the visualized sizes.
%
%   Examples:
%      ispy(gallery('wathen',15,15))
%      ispy(gallery('orthog',50,5))
%
%   See also SPY and IMAGESC.

%   -- v1.0 / 2013-08-20 / Samu Alanko, Patrick N. Raanes

% Input checks
if nargin<2
    sizeMultiplier = 1;
end
if nnz(A) == 0
    fprintf('Matrix is empty! Exiting. \n');
    return;
end

% Sizes
[M,N] = size(A);

% We neglect the complex parts of the elements
A = real(sparse(A));

% All nonzero elements
[Xnz,Ynz,Snz] = find(A);
% Finite elems
inds = isfinite(Snz);
X = Xnz(inds); Y = Ynz(inds); S = Snz(inds);
% Infinite elems
inds = isinf(Snz);
Xinf = Xnz(inds); Yinf = Ynz(inds);
% NaN elems
inds = isnan(Snz);
Xnan = Xnz(inds); Ynan = Ynz(inds);

% Get indices of positive and negative elements
posind = S>0;
negind = S<0;

% Set up figure
fh = gcf; % fig handle
ah = gca; % axes handle
xlim([0 N+1]); ylim([0 M+1]);

% Main routine
drawelems();

% Beautify
title(inputname(1));
box on; 
set(ah, 'YDir', 'reverse')




% Draws the elements that are inside the current view (makes zoom fast)
function drawelems()

    % Get axes size and multiply the sizeMultiplier by the
    % ratio (axes area)/(standard axes area)
    [axW,axH] = getAxesSize(ah);
    sm = sizeMultiplier * axW*axH/1.2e5;

    % Elements included in current zoom
    xlims = get(ah,'YLim');
    ylims = get(ah,'XLim');
    width = abs(xlims(2)-xlims(1));

    % Select the elements that are inside the current view
    ninds = negind & X>=xlims(1) & X<=xlims(2) & Y>=ylims(1) & Y<=ylims(2);
    pinds = posind & X>=xlims(1) & X<=xlims(2) & Y>=ylims(1) & Y<=ylims(2);

    nn = sum(ninds); % num of neg elems
    np = sum(pinds); % num of pos elems

    Xp = [X(ninds); X(pinds)];
    Yp = [Y(ninds); Y(pinds)];
    Sp = [S(ninds); S(pinds)];

    % Markersizes - constants
    minmarkersize = 4;              % Minimum marker size
    maxmarkersize = 40*sm;          % Maximum marker size
    markersize    = 12*40*sm/width; % Average size

    % Markersize of elements
    meanval = mean(abs(Sp));
    Sp = markersize.*(log(abs(Sp)./meanval+1)/log(2));
    Sp = min(max(Sp,minmarkersize*ones(size(Sp))),maxmarkersize*ones(size(Sp)));
    Sp = markersize*Sp/mean(abs(Sp));

    % Plot
    cla; hold on;
    scatter(Yp(1:nn),    Xp(1:nn),    Sp(1:nn),    'b','filled'); % neg elems
    scatter(Yp(nn+1:end),Xp(nn+1:end),Sp(nn+1:end),'r','filled'); % pos elems

    % NaN and Inf
    if ~isempty(Xnan)
        scatter(Ynan,Xnan,1000*sm,'y.');
        scatter(Ynan,Xnan,80*sm,'r*');
    end
    if ~isempty(Xinf)
        scatter(Yinf,Xinf,1000*sm,'g.');
        scatter(Yinf,Xinf,80*sm,'b*');
    end

    hold off;

    % Attach callback functions. Also make them detachable if the figure
    % is reused. But if it's reused in resizing/zooming, then we must attach
    % the callbacks again. That's why the callbacks are inside drawelems().
    zh = zoom(fh);
    ph = pan(fh);
    set(zh,'ActionPostCallback',@zoomcallback);
    set(ph,'ActionPostCallback',@pancallback);
    set(fh,'ResizeFcn',@resizecallback);
    set(fh,'NextPlot','Replace');

end

% Callback functions
function zoomcallback(~,~)
    drawelems();
end

function pancallback(~,~)
    drawelems();
end

function resizecallback(~,~)
    drawelems();
end


end




% Get axes size in "points" units
function [w,h] = getAxesSize(ah)
oldUnits = get(ah,'Units');
set(ah, 'Units', 'points');
axPos = get(ah,'Position');
set(ah,'Units',oldUnits);
w = axPos(3);
h = axPos(4);
end

