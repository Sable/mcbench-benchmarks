%Script that explains how to combine computeGTOM output with a hierarchical
%clustering
%   Joaquin Goñi <jgoni@unav.es> & Iñigo Martincorena
%   <imartincore@alumni.unav.es>
%   University of Navarra - Dpt. of Physics and Applied Mathematics &
%   Centre for Applied Medical Research.  Pamplona (Spain).
%
%   November 22nd 2007
%
load adjExample.mat    %example of an adjacency matrix
step = 3;   %value to compute GTOMstep (GTOM0,GTOM1,GTOM2, etc)
[GTOM]=computeGTOM(adjExample,step);
dist = ones(size(adjExample)) - GTOM;  %GTOM dissimilarity matrix
distVector = squareform(dist,'tovector');   %conversion to vector taking upper triangular values
Z = linkage(distVector,'average');  %linkage with average criteria
subplot(2,1,1), [H,T,PERM] = dendrogram(Z,0,'colorthreshold',0.35); %dendrogram plot with colorthreshold set to 0.35
GTOMOrdered = GTOM(PERM,PERM); %GTOM ordered by dendrogram
subplot(2,1,2), imagesc(GTOMOrdered); axis square; %plot of GTOMordered to check modules detection
%Automatic figure resizing and better merging to be done