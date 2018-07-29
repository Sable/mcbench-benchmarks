function plotNNPresults
load nnpresults
figure
warning off
[W,D,M]=ndgrid(WW,DD,NN);
isoplot2(W,D,M,SH)