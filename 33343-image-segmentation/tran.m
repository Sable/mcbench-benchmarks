function [l] = tran( ~ )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
i=imtool('C:\MATLAB6p1\work\2.jpg');
imshow(i);
u=imread('C:\MATLAB6p1\work\2.jpg');
bin = imfill(u>100, 'holes');
dist = bwdist(bin);
l= watershed(dist,4);
imshow(l);
tmp = uint8(double(i).*(l>0));
ovr = uint8(cat(3, max(i, uint8(255*(l==0))), tmp, tmp));
imshow(ovr);
[n e] = imRAG(l);
for i=1:size(e, 1)
plot(n(e(i,:), 1), n(e(i,:), 2), 'linewidth', 4, 'color', 'g');
end
plot(n(:,1), n(:,2), 'bo', 'markerfacecolor', 'b');
end

