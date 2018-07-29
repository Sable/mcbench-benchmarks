function gaze_img = linGaze2image(gaze_vec,gaze,ch)
% Convert the gaze vector to image for visualization purposes

imgH = gaze_vec(1:ch*(gaze.highR.ptc_dim)^2);
imgM = gaze_vec(ch*(gaze.highR.ptc_dim)^2+1:ch*(gaze.mediumR.ptc_dim^2-gaze.highR.ptc_dim^2)/(gaze.mediumR.px)^2+ch*(gaze.highR.ptc_dim)^2);
imgL = gaze_vec(ch*(gaze.mediumR.ptc_dim^2-gaze.highR.ptc_dim^2)/(gaze.mediumR.px)^2+ch*(gaze.highR.ptc_dim)^2+1:end);

mask = ones(gaze.mediumR.ptc_dim/gaze.mediumR.px);
mask((gaze.mediumR.ptc_dim-gaze.highR.ptc_dim)/2/gaze.mediumR.px+1:((gaze.mediumR.ptc_dim-gaze.highR.ptc_dim)/2+gaze.highR.ptc_dim)/gaze.mediumR.px,...
    (gaze.mediumR.ptc_dim-gaze.highR.ptc_dim)/2/gaze.mediumR.px+1:((gaze.mediumR.ptc_dim-gaze.highR.ptc_dim)/2+gaze.highR.ptc_dim)/gaze.mediumR.px) = Inf;
mask2 = ones(gaze.lowR.ptc_dim/gaze.lowR.px);
mask2((gaze.lowR.ptc_dim-gaze.mediumR.ptc_dim)/2/gaze.lowR.px+1:((gaze.lowR.ptc_dim-gaze.mediumR.ptc_dim)/2+gaze.mediumR.ptc_dim)/gaze.lowR.px,...
    (gaze.lowR.ptc_dim-gaze.mediumR.ptc_dim)/2/gaze.lowR.px+1:((gaze.lowR.ptc_dim-gaze.mediumR.ptc_dim)/2+gaze.mediumR.ptc_dim)/gaze.lowR.px) = Inf;

imgH = reshape(imgH,[gaze.highR.ptc_dim,gaze.highR.ptc_dim,ch]);
if ch == 3
   mask     = repmat(mask,[1,1,3]);
   mask2    = repmat(mask2,[1,1,3]);
end
mask(mask==1)   = imgM;
mask2(mask2==1) = imgL;

if ch == 1
    imgL = permute(mask2,[2,1]);
    imgM = permute(mask,[2,1]);
    imgH = permute(imgH,[2,1]);
else
    imgL = permute(mask2,[2,1,3]);
    imgM = permute(mask,[2,1,3]);
    imgH = permute(imgH,[2,1,3]);
end

imgM = imresize(imgM,gaze.mediumR.px,'nearest');
imgL = imresize(imgL,gaze.lowR.px,'nearest');


gaze_img = zeros(gaze.highR.ptc_dim,gaze.highR.ptc_dim,ch);
gaze_img(imgH~=Inf) = imgH(imgH~=Inf); % there shouldn't be overlapping!
gaze_img = padarray(gaze_img,[(gaze.mediumR.ptc_dim-gaze.highR.ptc_dim)/2 (gaze.mediumR.ptc_dim-gaze.highR.ptc_dim)/2],0,'both');
gaze_img(imgM~=Inf) = imgM(imgM~=Inf); 
gaze_img = padarray(gaze_img,[(gaze.lowR.ptc_dim-gaze.mediumR.ptc_dim)/2 (gaze.lowR.ptc_dim-gaze.mediumR.ptc_dim)/2],0,'both');
gaze_img(imgL~=Inf) = imgL(imgL~=Inf);
