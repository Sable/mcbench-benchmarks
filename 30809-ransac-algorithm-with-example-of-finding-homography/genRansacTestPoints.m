function [ pts ] = genRansacTestPoints( ptNum,outlrRatio,inlrStd,inlrCoef )
%GENRANSACTESTPOINTS Generate the points used by RANSAC function
%   PTS = GENRANSACTESTPOINTS(PTNUM,OUTLRRATIO,INLRSTD,INLRCOEF) PTS is
%   2*PTNUM, including PTNUM points, among which ROUND(OUTLRRATIO*PTNUM)
%   are outliers, others are inliers. 
%		The inliers are around the line: y = INLRCOEF(1)*x + INLRCOEF(2),
%   INLRSTD is the standard deviation of, the dist between inliers and the
%	line. The outliers 

outlrNum = round(outlrRatio*ptNum);
inlrNum = ptNum-outlrNum;

k = inlrCoef(1);
b = inlrCoef(2);
X = (rand(1,inlrNum)-.5)*ptNum; % X is in [-ptNum/2,ptNum/2]
Y = k*X+b;

% add noise for inliers
dist = randn(1,inlrNum)*inlrStd;
theta = atan(k);
X = X+dist*(-sin(theta));
Y = Y+dist*cos(theta);
inlrs = [X;Y];

outlrs = (rand(2,outlrNum)-.5)*ptNum;
% outlrs = (rand(2,outlrNum)-[ones(1,outlrNum)*.5;ones(1,outlrNum)*.1])*ptNum;
pts = [inlrs,outlrs];

end

