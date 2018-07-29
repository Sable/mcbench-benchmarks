function slicefr(x,y,z,v,xs,ys,zs)
% This script is a routine built around Matlab's SLICE function.
% It does the same as SLICE, just, it plots a black 'frame' along the edges
% of each slice and a dotted line where two slices intersect.
% This works only of slices parallel to the co-ordinate axes.
%
% U. Theune, Geophysics, U of A
%

slice(x,y,z,v,xs,ys,zs)

hold on
axis tight
xl=get(gca,'xlim');
yl=get(gca,'ylim');
zl=get(gca,'zlim');

% Plot the frames
for i=1:length(xs)
    plot3([1 1 1 1 1]*xs(i),[yl(1) yl(1) yl(2) yl(2) yl(1)],[zl(1) zl(2) zl(2) zl(1) zl(1)],'k','linewidth',0.5)
end
for i=1:length(ys)
    plot3([xl(1) xl(1) xl(2) xl(2) xl(1)],[1 1 1 1 1]*ys(i),[zl(1) zl(2) zl(2) zl(1) zl(1)],'k','linewidth',0.5)
end
for i=1:length(zs)
    plot3([xl(1) xl(2) xl(2) xl(1) xl(1)],[yl(1) yl(1) yl(2) yl(2) yl(1)],[1 1 1 1 1]*zs(i),'k','linewidth',0.5)
end
% Plot the intersection lines
% - vertical
for i=1:length(xs)
    for j=1:length(ys)
        plot3([xs(i) xs(i)],[ys(j) ys(j)],[zl(1) zl(2)],':k','linewidth',0.25)
    end
end
% - and horizontal
for i=1:length(zs)
    for j=1:length(ys)
        plot3([xl(1) xl(2)],[ys(j) ys(j)],[zs(i) zs(i)],':k','linewidth',0.25)
    end
end
for i=1:length(zs)
    for j=1:length(xs)
        plot3([xs(j) xs(j)],[yl(1) yl(2)],[zs(i) zs(i)],':k','linewidth',0.25)
    end
end
hold off
axis normal
