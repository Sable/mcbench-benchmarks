function gaze_vec = image2linGaze(img,x,y,gaze)
% Convert a image in a gaze vector as in the training protocol, where the 
% center of the gaze is given by (x,y)
% image can be both greyscale or RGB

% gaze is a struct that defines the retina. For example:
% gaze.highR.ptc_dim  = 8;
% gaze.highR.px       = 1; % pixel for each vis. unit
% gaze.mediumR.ptc_dim= 16;
% gaze.mediumR.px     = 2; % pixel for each vis. unit
% gaze.lowR.ptc_dim   = 24;
% gaze.lowR.px        = 4; % pixel for each vis. unit

% results in a 24x24 retina, using only 132 numbers (instead of 24x24= 576)

x=x- gaze.lowR.ptc_dim/2;
y=y- gaze.lowR.ptc_dim/2;

[~,~,ch] = size(img);

boxL = [x,y,gaze.lowR.ptc_dim,gaze.lowR.ptc_dim];
boxM = [x+(gaze.lowR.ptc_dim-gaze.mediumR.ptc_dim)/2,...
    y+(gaze.lowR.ptc_dim-gaze.mediumR.ptc_dim)/2,gaze.mediumR.ptc_dim,gaze.mediumR.ptc_dim];
boxH = [x+(gaze.mediumR.ptc_dim-gaze.highR.ptc_dim)/2+(gaze.lowR.ptc_dim-gaze.mediumR.ptc_dim)/2,...
    y+(gaze.mediumR.ptc_dim-gaze.highR.ptc_dim)/2+(gaze.lowR.ptc_dim-gaze.mediumR.ptc_dim)/2,gaze.highR.ptc_dim,gaze.highR.ptc_dim];
 
if nargin>4
    rectangle('Position',boxL,'EdgeColor',[0 0 1]);
    rectangle('Position',boxM,'EdgeColor',[0 1 0]);
    rectangle('Position',boxH,'EdgeColor',[1 0 0]);
end

imgL = imresize(img(boxL(2):boxL(2)+boxL(4)-1,boxL(1):boxL(1)+boxL(3)-1,:),1/gaze.lowR.px,'bilinear');
imgM = imresize(img(boxM(2):boxM(2)+boxM(4)-1,boxM(1):boxM(1)+boxM(3)-1,:),1/gaze.mediumR.px,'bilinear');
imgH = img(boxH(2):boxH(2)+boxH(4)-1,boxH(1):boxH(1)+boxH(3)-1,:);
if ch == 1
    imgL = permute(imgL,[2,1]);
    imgM = permute(imgM,[2,1]);
    imgH = permute(imgH,[2,1]);
else
    imgL = permute(imgL,[2,1,3]);
    imgM = permute(imgM,[2,1,3]);
    imgH = permute(imgH,[2,1,3]);
end
mask = ones(size(imgM,1),size(imgM,2));
mask((gaze.mediumR.ptc_dim-gaze.highR.ptc_dim)/2/gaze.mediumR.px+1:((gaze.mediumR.ptc_dim-gaze.highR.ptc_dim)/2+gaze.highR.ptc_dim)/gaze.mediumR.px,...
    (gaze.mediumR.ptc_dim-gaze.highR.ptc_dim)/2/gaze.mediumR.px+1:((gaze.mediumR.ptc_dim-gaze.highR.ptc_dim)/2+gaze.highR.ptc_dim)/gaze.mediumR.px) = 0;
mask2 = ones(size(imgL,1),size(imgL,2));
mask2((gaze.lowR.ptc_dim-gaze.mediumR.ptc_dim)/2/gaze.lowR.px+1:((gaze.lowR.ptc_dim-gaze.mediumR.ptc_dim)/2+gaze.mediumR.ptc_dim)/gaze.lowR.px,...
    (gaze.lowR.ptc_dim-gaze.mediumR.ptc_dim)/2/gaze.lowR.px+1:((gaze.lowR.ptc_dim-gaze.mediumR.ptc_dim)/2+gaze.mediumR.ptc_dim)/gaze.lowR.px) = 0;

if ch == 3
   mask     = repmat(mask,[1,1,3]);
   mask2    = repmat(mask2,[1,1,3]);
end
gaze_vec = [imgH(:)',imgM(logical(mask))',imgL(logical(mask2))'];
