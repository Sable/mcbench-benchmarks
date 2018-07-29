function testRansac

% real model coef
k = .5;
b = 10;
ptNum = 200;
outlrRatio = .4;
inlrStd = 5;
pts = genRansacTestPoints(ptNum,outlrRatio,inlrStd,[k b]);
figure,plot(pts(1,:),pts(2,:),'.'),hold on
X = -ptNum/2:ptNum/2;
plot(X,k*X+b,'k')
err0 = sqrError(k,b,pts(:,1:ptNum*(1-outlrRatio)))

% RANSAC
iterNum = 300;
thDist = 2;
thInlrRatio = .1;
[t,r] = ransac(pts,iterNum,thDist,thInlrRatio);
k1 = -tan(t);
b1 = r/cos(t);
plot(X,k1*X+b1,'r')
err1 = sqrError(k1,b1,pts(:,1:ptNum*(1-outlrRatio)))

% least square fitting
coef2 = polyfit(pts(1,:),pts(2,:),1);
k2 = coef2(1);
b2 = coef2(2);
plot(X,k2*X+b2,'g')
err2 = sqrError(k2,b2,pts(:,1:ptNum*(1-outlrRatio)))

end

function err = sqrError(k,b,pts)
%	Calculate the square error of the fit

theta = atan(-k);
n = [cos(theta),-sin(theta)];
pt1 = [0;b];
err = sqrt(sum((n*(pts-repmat(pt1,1,size(pts,2)))).^2));

end