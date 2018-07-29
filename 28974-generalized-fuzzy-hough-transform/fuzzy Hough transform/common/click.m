function hdl = click(I, varargin)
%
% click help

text = '';
if nargin == 2
    text = varargin{1};
end

hdl = figure;

h1 = subplot('position',[0.1 0.2 0.88 0.67]);
if (isfloat(I))
    if (max(I(:)) <= 1)
        I = 255*I;
    end
    I = uint8(imnorm(I, [0 255]));
end
imagesc(I);
axis off;
axis image;
% ylabel('image', 'FontSize',8);
title(text, 'FontSize',14);

h2 = subplot('position',[0.1 0.1 0.88 0.08]);
set(h2, 'FontSize',7);
[counts, x] = imhist(I);
bar(x, counts);
axis(h2, [0 255 min(counts) max(counts)]);
% set(h2, 'XTickLabel','');
% colorbar('Location','SouthOutside');
xlabel('gray level', 'FontSize',8);
ylabel('histogram', 'FontSize',8);
colormap gray;
axes(h1);
