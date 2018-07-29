% Author : FUAT COGUN
% Date   : 16.07.2009
%
%
% Draws a window around the estimated region
% 
%
% Inputs  : -I                                                  (uint8 Matrix)
% ======    -estimated x position                               (Integer)
%           -estimated y position                               (Integer)
%
% Outputs : -frame with detected region                         (Integer)
% =======   

function Id = drawDetectionWindow(I,estPositionX,estPositionY,size)

Id = I;
Id(estPositionY:estPositionY+size-1,estPositionX) = 255;
Id(estPositionY:estPositionY+size-1,estPositionX+size-1) = 255;
Id(estPositionY,estPositionX:estPositionX+size-1) = 255;
Id(estPositionY+size-1,estPositionX:estPositionX+size-1) = 255;
