function show_match(Ig1, Ig2, loc1, loc2);
n = size(loc1,1);
im3 = appendimages(Ig1,Ig2);
figure('Position', [100 100 size(im3,2) size(im3,1)]);
colormap('gray');
imagesc(im3);
hold on;
cols1 = size(Ig1,2);
for i = 1: n
  %if (match(i) > 0)
    line([loc1(i,2) loc2(i,2)+cols1], ...
         [loc1(i,1) loc2(i,1)], 'Color', 'c', 'LineWidth', 2);
  %end
end
hold off;