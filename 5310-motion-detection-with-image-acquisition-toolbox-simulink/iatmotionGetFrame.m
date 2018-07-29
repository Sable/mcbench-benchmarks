function f = iatmotionGetFrame(vid)
%  IATMOTIONGETFRAME Return a frame to the motion detection demo.
%
%  IATMOTIONGETFRAMES(VID), where VID is a VIDEOINPUT object, returns the
%  first band of the image data returned by GETSNAPSHOT.

% Copyright 2004, The MathWorks, Inc.

f=getsnapshot(vid);
f=double(f(:,:,1));
