function h = match_plot(img1,img2,points1,points2)
%MATCH_PLOT
%   h = match_plot(img1,img2,points1,points2)
%   plot coresponding points between two images
%
%   points1 = [x1 y1; x2 y2; ...] = coresponding points in img1
%   points2 = [x1 y1; x2 y2; ...] = coresponding points in img2
%
%   origin is the top left of the image
%   x axis pointing right, y axis pointing down.
%   points 2 has to be the same size as points 1
%
%   if 2 images have different size, the smaller one is rescaled.
%
%   coresponding lines are plot in different colors, from red to blue in
%   rainbow order.
%
%   returns the figure handle object h
%   
%   written by Gooly 4/21/2011
%   http://computervisionblog.wordpress.com/

h = figure;
colormap = {'b','r','m','y','g','c'};
height = max(size(img1,1),size(img2,1));
img1_ratio = height/size(img1,1);
img2_ratio = height/size(img2,1);
img1 = imresize(img1,img1_ratio);
img2 = imresize(img2,img2_ratio);
points1 = points1 * img1_ratio;
points2 = points2 * img2_ratio;
points1 = [points1(:,2) points1(:,1)];
points2 = [points2(:,2) points2(:,1)];
match_img = zeros(height, size(img1,2)+size(img2,2), size(img2,3));
match_img(1:size(img1,1),1:size(img1,2),:) = img1;
match_img(1:size(img2,1),size(img1,2)+1:end,:) = img2;
imshow(uint8(match_img));
hold on;
for i=1:size(points1,1)
    plot([points1(i,2) points2(i,2)+size(img1,2)],[points1(i,1) points2(i,1)],colormap{mod(i,6)+1});
end

hold off;

end

