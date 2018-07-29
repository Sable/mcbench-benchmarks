function [f inlierIdx] = ransac1( x,y,ransacCoef,funcFindF,funcDist )
%[f inlierIdx] = ransac1( x,y,ransacCoef,funcFindF,funcDist )
%	Use RANdom SAmple Consensus to find a fit from X to Y.
%	X is M*n matrix including n points with dim M, Y is N*n;
%	The fit, f, and the indices of inliers, are returned.
%
%	RANSACCOEF is a struct with following fields:
%	minPtNum,iterNum,thDist,thInlrRatio
%	MINPTNUM is the minimum number of points with whom can we 
%	find a fit. For line fitting, it's 2. For homography, it's 4.
%	ITERNUM is the number of iteration, THDIST is the inlier 
%	distance threshold and ROUND(THINLRRATIO*n) is the inlier number threshold.
%
%	FUNCFINDF is a func handle, f1 = funcFindF(x1,y1)
%	x1 is M*n1 and y1 is N*n1, n1 >= ransacCoef.minPtNum
%	f1 can be of any type.
%	FUNCDIST is a func handle, d = funcDist(f,x1,y1)
%	It uses f returned by FUNCFINDF, and return the distance
%	between f and the points, d is 1*n1.
%	For line fitting, it should calculate the dist between the line and the
%	points [x1;y1]; for homography, it should project x1 to y2 then
%	calculate the dist between y1 and y2.
%	Yan Ke @ THUEE, 20110123, xjed09@gmail.com


minPtNum = ransacCoef.minPtNum;
iterNum = ransacCoef.iterNum;
thInlrRatio = ransacCoef.thInlrRatio;
thDist = ransacCoef.thDist;
ptNum = size(x,2);
thInlr = round(thInlrRatio*ptNum);

inlrNum = zeros(1,iterNum);
fLib = cell(1,iterNum);

for p = 1:iterNum
	% 1. fit using  random points
	sampleIdx = randIndex(ptNum,minPtNum);
	f1 = funcFindF(x(:,sampleIdx),y(:,sampleIdx));
	
	% 2. count the inliers, if more than thInlr, refit; else iterate
	dist = funcDist(f1,x,y);
	inlier1 = find(dist < thDist);
	inlrNum(p) = length(inlier1);
	if length(inlier1) < thInlr, continue; end
	fLib{p} = funcFindF(x(:,inlier1),y(:,inlier1));
end

% 3. choose the coef with the most inliers
[~,idx] = max(inlrNum);
f = fLib{idx};
dist = funcDist(f,x,y);
inlierIdx = find(dist < thDist);
	
end