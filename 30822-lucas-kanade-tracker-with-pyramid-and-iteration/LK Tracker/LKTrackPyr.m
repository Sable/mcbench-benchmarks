function [ X2 Y2 ] = LKTrackPyr( img1, img2, X1, Y1 )
% [ X2 Y2 ] = LKTrackPyr( img1, img2, X1, Y1 )
%	Lucas-Kanade Tracker with pyramid and iteration.
%	img1 and img2 are 2 images of a same scene with little time-lag,
%	X's and Y's are coordinates to be tracked.


winR = 5;
th = .01;
maxIter = 20;
minImgSz = 64; % if pyramid level is too high, corners may be blurred
maxPyrLevel = floor(log2(min(size(img1))/minImgSz));

img1pyrs = genPyr(img1,'gauss',maxPyrLevel);
img2pyrs = genPyr(img2,'gauss',maxPyrLevel);
h = fspecial('sobel');

ptNum = size(X1,1);
X2 = X1/2^maxPyrLevel;
Y2 = Y1/2^maxPyrLevel;

for level = maxPyrLevel:-1:1
	img1 = img1pyrs{level};
	img2 = img2pyrs{level};
	[M N] = size(img1);
	
	img1x = imfilter(img1,h','replicate');
	img1y = imfilter(img1,h,'replicate');
	
	for p = 1:ptNum
		xt = X2(p)*2;
		yt = Y2(p)*2;
		[iX iY oX oY isOut] = genMesh(xt,yt,winR,M,N);
		if isOut, continue; end % if the window of a point is out of image bound
		Ix = interp2(iX,iY,img1x(iY,iX),oX,oY); % notice the order of X and Y
		Iy = interp2(iX,iY,img1y(iY,iX),oX,oY);
		I1 = interp2(iX,iY,img1(iY,iX),oX,oY);
		
		for q = 1:maxIter
			[iX iY oX oY isOut] = genMesh(xt,yt,winR,M,N);
			if isOut, break; end
			It = interp2(iX,iY,img2(iY,iX),oX,oY) - I1;
			
			vel = [Ix(:),Iy(:)]\It(:);
			xt = xt+vel(1);
			yt = yt+vel(2);
			if max(abs(vel))<th, break; end
		end
		X2(p) = xt;
		Y2(p) = yt;
	end
	
end

end

function [iX iY oX oY isOut] = genMesh(xt,yt,winR,M,N)

l = xt-winR;
t = yt-winR;
r = xt+winR;
b = yt+winR;

[oX,oY] = meshgrid(l:r,t:b);
fl = floor(l);
ft = floor(t);
cr = ceil(r);
cb = ceil(b);
iX = fl:cr;
iY = ft:cb;

isOut = false;
if fl<1 || ft<1 || cr>N || cb>M
% 	error('out of image bound.');
	isOut = true;
end
end