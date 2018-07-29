function [ imgout ] = imMosaic( img1,img2,adjColor )
%[ imgout ] = imMosaic( img1,img2,adjColor )
%	img1 and img2 can (both) be rgb or gray, double or uint8.
%	If you have more than 2 images to do mosaic, call this function several
%	times.
%	If you set adjColor to 1, imMosaic will try to try to adjust the
%	color(for rgb) or grayscale(for gray image) of img1 linearly, so the 2 
%	images can join more naturally.
%	Yan Ke @ THUEE, 20110123, xjed09@gmail.com

% use SIFT to find corresponding points
[matchLoc1 matchLoc2] = siftMatch(img1, img2);

% use RANSAC to find homography matrix
[H corrPtIdx] = findHomography(matchLoc2',matchLoc1');
H  %#ok
tform = maketform('projective',H');
img21 = imtransform(img2,tform); % reproject img2
figure,imshow(img1)
figure,imshow(img21)

% adjust color or grayscale linearly, using corresponding infomation
[M1 N1 dim] = size(img1);
[M2 N2 ~] = size(img2);
if exist('adjColor','var') && adjColor == 1
	radius = 2;
	x1ctrl = matchLoc1(corrPtIdx,1);
	y1ctrl = matchLoc1(corrPtIdx,2);
	x2ctrl = matchLoc2(corrPtIdx,1);
	y2ctrl = matchLoc2(corrPtIdx,2);
	ctrlLen = length(corrPtIdx);
	s1 = zeros(1,ctrlLen);
	s2 = zeros(1,ctrlLen);
	for color = 1:dim
		for p = 1:ctrlLen
			left = round(max(1,x1ctrl(p)-radius));
			right = round(min(N1,left+radius+1));
			up = round(max(1,y1ctrl(p)-radius));
			down = round(min(M1,up+radius+1));
			s1(p) = sum(sum(img1(up:down,left:right,color))); % 取四周点色度
		end
		for p = 1:ctrlLen
			left = round(max(1,x2ctrl(p)-radius));
			right = round(min(N2,left+radius+1));
			up = round(max(1,y2ctrl(p)-radius));
			down = round(min(M2,up+radius+1));
			s2(p) = sum(sum(img2(up:down,left:right,color)));
		end
		sc = (radius*2+1)^2*ctrlLen;
		adjcoef = polyfit(s1/sc,s2/sc,1);
		img1(:,:,color) = img1(:,:,color)*adjcoef(1)+adjcoef(2);
	end
end

% do the mosaic
pt = zeros(3,4);
pt(:,1) = H*[1;1;1];
pt(:,2) = H*[N2;1;1];
pt(:,3) = H*[N2;M2;1];
pt(:,4) = H*[1;M2;1];
x2 = pt(1,:)./pt(3,:);
y2 = pt(2,:)./pt(3,:);

up = round(min(y2));
Yoffset = 0;
if up <= 0
	Yoffset = -up+1;
	up = 1;
end

left = round(min(x2));
Xoffset = 0;
if left<=0
	Xoffset = -left+1;
	left = 1;
end

[M3 N3 ~] = size(img21);
imgout(up:up+M3-1,left:left+N3-1,:) = img21;
	% img1 is above img21
imgout(Yoffset+1:Yoffset+M1,Xoffset+1:Xoffset+N1,:) = img1;

end

