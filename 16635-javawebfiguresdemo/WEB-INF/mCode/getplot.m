function w = getplot
f = figure;
plot(1:10);
w = webfigure(f);
close(f);