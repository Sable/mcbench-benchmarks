function [ lines ] = findlines( imge,map,theta,rho,minLen,maxLineNum,maxPeakNum,resol,maxGap )
%FINDLINE Find line features in the image using Hough transform
%   LINES = FINDLINES(IMGE,MAP,THETA,RHO,MINLEN,MAXLINENUM,MAXPEAKNUM,RESOL,MAXGAP)	
%	IMGE is the binary edge image; 
%	MAP,THETA,RHO is the output of HOUGH;
%	MINLEN is the minimum length of lines that will be found;
%	No more MAXLINENUM lines will be returned;
%	MAXPEAKNUM is the maximum peaks	that will be detected on the map;
%	MAXGAP is the maximum gap length that will be merged;
%	RESOL is the resolution of the detected lines, the smaller, the lines
%	must be further away from each other. A suggest value is 100.
%	LINES is a struct array with members: theta,rho,point1([row,col]),point2. 
%		
%	Yan Ke @ THUEE, 20110123, xjed09@gmail.com

% imge = edge(img);
% [map theta rho] = hough1(imge,[]);
[pri pti] = findpeaks(map,minLen,maxPeakNum,resol);
peakNum = length(pri);
prho = rho(pri); % peak points
pthe = theta(pti)*pi/180;
rhoThres = abs(rho(2)-rho(1))/2;

fitPts = cell(1,peakNum);
fitPtsNum = zeros(1,peakNum);
for p = 1:peakNum
	 % store points which are on the lines
	fitPts{p} = zeros(2,ceil(map(pri(p),pti(p))*1.2));
end
[Y X] = find(imge);
X = X-1; % The origin is the bottom-left corner.
M = size(imge,1);
Y = M-Y;

% find the points that's on the selected lines
for p = 1:length(X)
	rho1 = X(p)*sin(pthe)+Y(p)*cos(pthe);
	isOnPeak = find(abs(rho1-prho)<=rhoThres);
	fitPtsNum(isOnPeak) = fitPtsNum(isOnPeak)+1;
	for q = isOnPeak
		fitPts{q}(:,fitPtsNum(q)) = [X(p);Y(p)];
	end
end

% track the points on each line, find the start points and the end points,
lines = [];
tempLine = struct;
for p = 1:peakNum
	t1 = [-cos(pthe(p)),sin(pthe(p))]; % the unit directional vector of the line
	dist1 = t1*fitPts{p}(:,1:fitPtsNum(p)); % dist along the line
	[ordDist ordIdx] = sort(dist1,'ascend');
	ordPts = fitPts{p}(:,ordIdx);
	
	% handle with the gaps
	dist2 = diff(ordDist); % dist with each other
	gapPos = [0 find(dist2>maxGap) length(ordDist)];
	lineLen = diff(gapPos);
	for q = find(lineLen>=minLen)
		tempLine.theta = pthe(p);
		tempLine.rho = prho(p);
		tempLine.point1 = [M-ordPts(2,gapPos(q)+1),ordPts(1,gapPos(q)+1)+1];
		tempLine.point2 = [M-ordPts(2,gapPos(q+1)),ordPts(1,gapPos(q+1))+1];
		lines = [lines,tempLine];
		if length(lines) == maxLineNum, break; end
	end
	if length(lines) == maxLineNum, break; end
end
	
end

function [rows cols] = findpeaks(map,minLen,maxPeakNum,resol)
%	Find the at most maxLinNum points that's no less than minLen in map, meanwhile not
%	8-adjacent to each other, in MAP. Rows and cols are returned.

if max(max(map)) < minLen, return; end
rows = zeros(1,maxPeakNum);
cols = rows;
sz = size(map);
sup = ceil(sz/resol);
for p = 1:maxPeakNum
	[V,I] = max(map(:));
	if V<minLen
		rows = rows(1:p-1);
		cols = cols(1:p-1);
		break;
	end
	[rows(p),cols(p)] = ind2sub(sz,I);
	
	% non-maximal suppression
	left = max(1,cols(p)-sup(2));
	lr = min(sup(2)*2+1,sz(2)-left);
	up = max(1,rows(p)-sup(1));
	ud = min(sup(1)*2+1,sz(1)-up);
	map(up:up+ud,left:left+lr) = 0;
end

% if max(max(map)) < minLen, return; end
% map(map<minLen) = 0;
% mapMax = ordfilt2(map,25,ones(5));
% mapPeak = (mapMax == map) & map; % non-maximal suppression
% pt = find(mapPeak);
% pv = map(pt);
% [pvo,idx] = sort(pv,'descend');
% pt = pt(idx);
% if length(pvo) > maxPeakNum, pt = pt(1:maxPeakNum); end
% [rows cols] = ind2sub(size(map),pt);

end