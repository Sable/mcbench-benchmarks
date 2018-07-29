% Author : FUAT COGUN
% Date   : 16.07.2009
%
%
% Gets the dimensions of the screen.
% 
%
% Inputs  :
% ======
%
% Outputs : -Width of the screen                                (Integer)
% =======   -Height of the screen                               (Integer)
 

function [screenWidth screenHeight] = getScreenSize()

    screenSize = get(0,'ScreenSize');
    screenWidth = screenSize(3);
    screenHeight = screenSize(4);