function marginhist(x,y,nbins)
%MARGINHIST Plot bivariate data as a scatterplot with histograms along the margins.
%   MARGINHIST(X,Y) creates a 2D scatterplot of the data in the vectors X
%   and Y, and puts a univariate histogram at the horizontal and vertical
%   axes of the plot.  X and Y must be the same length.
%
%   Example:
%
%      x = randn(100,1);
%      y = exp(.5*randn(100,1));
%      marginhist(x,y,[10,10])

%   Copyright 2009 The MathWorks, Inc.
%   Revision: 1.0  Date: 2003/12/08
%
%   Requires MATLAB® R13.

if nargin < 3
    nbins = [10 10];
end

[nx,cx] = hist(x,nbins(1));
[ny,cy] = hist(y,nbins(2));
dx = diff(cx(1:2));
xlim = [cx(1)-dx cx(end)+dx];
dy = diff(cy(1:2));
ylim = [cy(1)-dy cy(end)+dy];

yoff = 0;
if prod(ylim)<0, yoff = min(y)*2; end

subplot(2,2,2); plot(x,y,'o'); h1 = gca; axis([xlim ylim]);
xlabel('x'); ylabel('y');
subplot(2,2,4); bar(cx,-nx,1); h2 = gca; axis([xlim -max(nx)*1.01 0]); axis('off');
subplot(2,2,1); barh(cy-yoff,-ny,1); h3 = gca; axis([-max(ny)*1.01 0 ylim-yoff]); axis('off');
line([0 0],ylim-yoff,'Color','k')

set(h1,'Position',[0.35 0.35 0.55 0.55]);
set(h2,'Position',[.35 .1 .55 .15]);
set(h3,'Position',[.1 .35 .15 .55]);

colormap([.8 .8 1]);
