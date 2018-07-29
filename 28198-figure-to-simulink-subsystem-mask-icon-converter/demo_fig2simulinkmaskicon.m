% Demo script for fig2simulinkmaskicon
h = figure; hold on;
plot([0:0.1:10],sin([0:0.1:10]));
plot([0:0.5:12],cos([0:0.5:12]));
fig2simulinkmaskicon(gcf);
fig2simulinkmaskicon(h,'yellow');
fig2simulinkmaskicon(h,{'cyan','black'});