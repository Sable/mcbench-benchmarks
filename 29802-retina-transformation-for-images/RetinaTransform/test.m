%defines a 24x24 gaze retina
gaze.highR.ptc_dim  = 8;
gaze.highR.px       = 1; % pixel for each vis. unit
gaze.mediumR.ptc_dim= 16;
gaze.mediumR.px     = 2; % pixel for each vis. unit
gaze.lowR.ptc_dim   = 24;
gaze.lowR.px        = 4; % pixel for each vis. unit

%silly picture
A= eye(50,50);
A(30:40, 30:40)= 1;

%crucial stuff here
vec= image2linGaze(A, 25, 30, gaze); %25,30 is the center of fovea
Aback= linGaze2image(vec, gaze, 1); %need to pass in number of channels of original

%draw 
subplot(1,2,1);
imshow(A);
subplot(1,2,2);
imshow(Aback);