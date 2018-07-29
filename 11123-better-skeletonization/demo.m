% read in a sample image -- also see letters.png, bagel.png
img = imread('mushroom.png');
imshow(img);

% the standard skeletonization:
imshow(bwmorph(img,'skel',inf));

% the new method:
imshow(bwmorph(skeleton(img)>35,'skel',Inf));

% in more detail:
[skr,rad] = skeleton(img);

% the intensity at each point is proportional to the degree of evidence
% that this should be a point on the skeleton:
imagesc(skr);
colormap jet
axis image off

% skeleton can also return a map of the radius of the largest circle that
% fits within the foreground at each point:
imagesc(rad)
colormap jet
axis image off

% thresholding the skeleton can return skeletons of thickness 2,
% so the call to bwmorph completes the thinning to single-pixel width.
skel = bwmorph(skr > 35,'skel',inf);
imshow(skel)
% try different thresholds besides 35 to see the effects

% anaskel returns the locations of endpoints and junction points
[dmap,exy,jxy] = anaskel(skel);
hold on
plot(exy(1,:),exy(2,:),'go')
plot(jxy(1,:),jxy(2,:),'ro')
