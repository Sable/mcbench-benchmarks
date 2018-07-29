function targetModel = createTargetModel(targetImage, targetModelImage)
% gathers the information needed to match the target in a test image.
% targetImage -- the image that only contains the target.
% targetModel -- a struct that contains the informations needed to match
% targetModelImage -- a contour image of the target with absolute white background

% for plot
colormap = {'r*','b*','c*','g*','m*','ro','bo','co','go','mo','r+','b+','c+','g+','m+'};
colormap = [colormap {'rx','bx','cx','gx','mx','rs','bs','cs','gs','ms','rd','bd','cd','gd','md'}];

% transform to gray image
im_mat_g = rgb2gray(targetImage);

% calculate SURF points in target image (See SURFMEX library for detail)
% cr is column row position of all SURF point
% descr is the descriptor for each SURF point
options.hessianThreshold = 100;
[cr, descr, sign, info] = surfpoints(im_mat_g,options);

% ori is the major orientation of the SURF point descriptor
ori = -info(3,:)*pi/180; % need to be modified if use new SURFmex library, see http://computervisionblog.wordpress.com/

figure; 
imshow(targetImage); hold on
plot(cr(1,:),cr(2,:),colormap{1});

% find the midle point of the image
rc_mid = size(im_mat_g)/2;
cr_mid = rc_mid([2 1]);

model.descr = descr;
model.cr = cr;

% for each SURF point
for i=1:size(cr,2)
    % save the angle of the line between the SURF point and the middle point
    model.ori2mid(i) = atan2(cr_mid(2)-cr(2,i),cr_mid(1)-cr(1,i)) -ori(i);
    % save the length of the line between the SURF point and the middle point devide by the scale of the SURF descriptor
    model.scale2mid(i) = ((cr_mid(1) - cr(1,i))^2 + (cr_mid(2) - cr(2,i))^2)^0.5 / info(1,i);
    % save the major orientation of the SURF point descriptor
    model.ori(i) = ori(i);
    % save the scale of the SURF point descriptor
    model.scale(i) = info(1,i);
end
model.maxsize = max(size(im_mat_g));

model.targetImage = targetImage;
model.targetModelImage = targetModelImage;

targetModel = model;


end