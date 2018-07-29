%% Mean-Shift Video Tracking
% by Sylvain Bernhardt
% July 2008
%% Description
% Insert in the image I a rectangle
% which size is H,W and thickness is
% expressed in pixels.
%
% I = Draw_target(x,y,W,H,I,thick)

function I = Draw_target(x,y,W,H,I,thick)
R=1; G=2; B=3;
I(y:y+thick-1,x:x+W,R) = 255;
I(y:y+thick-1,x:x+W,G) = 0;
I(y:y+thick-1,x:x+W,B) = 0;

I(y+H-thick+1:y+H,x:x+W,R) = 255;
I(y+H-thick+1:y+H,x:x+W,G) = 0;
I(y+H-thick+1:y+H,x:x+W,B) = 0;

I(y:y+H,x:x+thick-1,R) = 255;
I(y:y+H,x:x+thick-1,G) = 0;
I(y:y+H,x:x+thick-1,B) = 0;

I(y:y+H,x+W-thick+1:x+W,R) = 255;
I(y:y+H,x+W-thick+1:x+W,G) = 0;
I(y:y+H,x+W-thick+1:x+W,B) = 0;