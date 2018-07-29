function E = cedge(E, ln)
%
% Clears the unimportant edges on the binary image based on the edge
% length removing all those edges that are composed by a number of pixels 
% below the threshold. It also clears the border edges that can cause 
% distorsion in the later pattern recognition processment.

% clearing border edges
npixels = 2;
E(1:npixels,:) = false;
E(end-npixels+1:end,:) = false;
E(:,1:npixels) = false;
E(:,end-npixels+1:end) = false;

% clearing unimportant edges
[L, num] = bwlabel(E,8);
for i=1:num
    acc(i) = numel(find(L == i));
end
ind = find(acc >= ln);
ind1 = [];
for i=1:length(ind)
    ind1 = [ind1; find(L == ind(i))];
end
E = logical(zeros(size(E)));
E(ind1) = true;

