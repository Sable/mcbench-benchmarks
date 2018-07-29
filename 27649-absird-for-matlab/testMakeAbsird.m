%% Demonstrate the absird matlab implementation

%% Background
% This makeAbsird function interprates the input data as a height-map and
% converts it to a random dot autostereogram. A random dot autosterogram is
% an image that can be percieved as 3-dimensional by viewing it in the
% proper way. For more information on random dot sterograms, see  
% http://en.wikipedia.org/wiki/Autostereogram   
%
% The algorithm used is abSIRD, published in 2004 by Lewey Geselowitz. It
% is a fast, in-place algorithm that is exquisitly simple to implement. For
% more information, see http://www.leweyg.com/download/SIRD/index.html
%
% It is very important that the images be shown at full size for the
% 3d-effect to appear. 
%
% Daniel Armyr, 2010

%% Shark demo
% A shark taken from Wikipedia
% (http://en.wikipedia.org/wiki/File:Stereogram_Tut_Shark_Depthmap.png)
ScrData = imread('shark.png');
makeAbsird( mean(ScrData,3), 64 );

%% Matlab logo demo
% The Matlab logo as seen from above.
clear;
ScrData = membrane(1,250,9,2);
makeAbsird( ScrData, 32 );

%% Peaks demo
% The classical peaks() function from above.
clear;
ScrData = peaks(500);
makeAbsird( ScrData, 32 );

%% Algorithm code
type ( 'makeAbsird.m' );

