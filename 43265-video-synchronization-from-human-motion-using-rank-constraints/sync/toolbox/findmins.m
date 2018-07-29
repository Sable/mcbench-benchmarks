function [ref,tgt,map] = findmins(sim)

% normalize cost function to range [0,1]
sim	= sim - min(sim(:));
sim	= sim / max(sim(:));

% add a border of 1's so that minima on the edge of the cost function are
% also found

% temp	= padarray(sim,[1,1],1);
temp = [ones(1,size(sim,2)); sim; ones(1,size(sim,2))];
temp = [ones(size(temp,1),1) temp ones(size(temp,1),1)];

% non-minimum suppression
map	= 			logical(ones(size(temp)));
map	= map &	logical(conv2(temp,[0 -1 1],'same') > 0);
map	= map & logical(conv2(temp,[1 -1 0],'same') > 0);
map	= map & logical(conv2(temp,[0;-1;1],'same') > 0);
map	= map & logical(conv2(temp,[1;-1;0],'same') > 0);

% threshold at 5%
map	= map(2:end-1,2:end-1) & (sim < 0.05);

% return putative frame correspondences
[tgt,ref] = find(map);
