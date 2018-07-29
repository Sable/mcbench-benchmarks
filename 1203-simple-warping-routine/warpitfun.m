function pinkw  = warpitfun(pink,get,Zp,Zg)

% The function a very simple Thin-Plane spline warping of the two images.
% Image [pink] is warped onto image [get]. The warping is defined
% by a set of reference points [Zp=[Xp Yp]] on the [pink] image and a set 
% of corresponding points on the template image [get]. The warping implemented 
% will translate Zp -> Zg exactly. 

% The function does not perfom any interpolation as it can be very application specific

% Reference: F.L. Bookstein, "Principal Warps: Thin-Plate splines and the decomposition 
% of deformations", IEEE Tr. on Pattern Analysis and Machine Intel, vol. 11, No. 6, June 1989   

% SEE ALSO warpingfunsup.m 


NPs = size(Zp,1);

Xp = Zp(:,1)';
Yp = Zp(:,2)';
Xg = Zg(:,1)';
Yg = Zg(:,2)';

rXp = repmat(Xp(:),1,NPs);
rYp = repmat(Yp(:),1,NPs);

wR = sqrt((rXp-rXp').^2 + (rYp-rYp').^2);

wK = 2*(wR.^2).*log(wR+1e-20);
wP = [ones(NPs,1) Xp(:) Yp(:)];
wL = [wK wP;wP' zeros(3,3)];
wY = [Xg(:) Yg(:); zeros(3,2)];
wW = inv(wL)*wY;

pink_grey = double(sum(pink,3))/3;
[X Y] = meshgrid(1:size(pink_grey,1),1:size(pink_grey,2));
X = X(:)'; Y = Y(:)'; 
NWs = length(X);

rX = repmat(X,NPs,1); 
rY = repmat(Y,NPs,1); 

rXp = repmat(Xp(:),1,NWs);
rYp = repmat(Yp(:),1,NWs);

wR = sqrt((rXp-rX).^2 + (rYp-rY).^2);
wK = 2*(wR.^2).*log(wR+1e-20);
wP = [ones(NWs,1) X(:) Y(:)]';
wL = [wK;wP]';

Xw  = wL*wW(:,1); 
Yw  = wL*wW(:,2); 

Xw = fix(max(min(Xw,size(get,1)),1));
Yw = fix(max(min(Yw,size(get,2)),1));

iw = sub2ind([size(get,1),size(get,2)],Xw,Yw);
ip = sub2ind([size(pink,1),size(pink,2)],X',Y');

pinkw = zeros(size(get,1),size(get,2));
pinkw(fix(iw)) = pink_grey(fix(ip));




