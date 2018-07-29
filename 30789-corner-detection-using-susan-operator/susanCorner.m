function [ map r c ] = susanCorner( img )
%SUSAN Corner detection using SUSAN method.
%   [R C] = SUSAN(IMG)	Rows and columns of corner points are returned.
%	Edward @ THUEE, xjed09@gmail.com

maskSz = [7 7];
fun = @(img) susanFun(img);
map = nlfilter(img,maskSz,fun);
[r c] = find(map);

end

function res = susanFun(img)
% SUSANFUN  Determine if the center of the image patch IMG
%	is corner(res = 1) or not(res = 0)


mask = [...
	0 0 1 1 1 0 0
	0 1 1 1 1 1 0
	1 1 1 1 1 1 1
	1 1 1 1 1 1 1
	1 1 1 1 1 1 1
	0 1 1 1 1 1 0
	0 0 1 1 1 0 0];

% uses 2 thresholds to distinguish corners from edges
thGeo = (nnz(mask)-1)*.2;
thGeo1 = (nnz(mask)-1)*.4;
thGeo2 = (nnz(mask)-1)*.4;
thT = .07;
thT1 = .04;

sz = size(img,1);
usan = ones(sz)*img(round(sz/2),round(sz/2));

similar = (abs(usan-img)<thT);
similar = similar.*mask;
res = sum(similar(:));
if res < thGeo
	dark = nnz((img-usan<-thT1).*mask);
	bright = nnz((img-usan>thT1).*mask);
	res = min(dark,bright)<thGeo1 && max(dark,bright)>thGeo2;

else
	res = 0;
end

end
