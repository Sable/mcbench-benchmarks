%% Point Cloud Viewer (OpenCV)
%
% Display point cloud image using OpenCV.
%
% Copyright 2012 The MathWorks, Inc.


%% Input Signals
%
% * Pause (boolean): Pause point cloud image (1: Pause / 0: Not pause).
%
% * Pos (int32): Start position of XYZ and Image input pixel data ([y x]).
% Note that Pos is zero index based. 
%
% * XYZ (double): XYZ data of points.
%
% * Image (uint8): RGB data of points.
%
% * View (double): View point ([x y z]). View input is available when "Set view point by input" block parameter was checked.
%

%% Output Signals
%
% * Image (uint8): RGB point cloud image. Image is available when "Image output" block parameter was checked.
%

%% Block Parameters
%
% * Window size: Size of Point Cloud Viewer window
%
% * Frame size: Size of XYZ and Image input data ([rows colums]).
%
% * Full frame size: Size of whole XYZ and Image data ([rows colums]).
%
% * Background color: Background color (R G B).
%
% * Look at point: Look at point of point cloud image ([x y z]).  
%
% * Set view point by Input: Configure view point is set by an input signal or keyboard input (ON: Input signal / OFF: Keyboard input).
%
% Note that when this parameter was OFF, view point can be changed by keyboard input while point cloud display window is active.
%
% Note that keyboard input is not case sensitive.  
%
% - Press R(r) : Initial view point
%
% - Press K(k) : +y
%
% - Press J(j) : -y
%
% - Press H(h) : +x
%
% - Press L(l) : -x
%
% - Press I(i)  : +z
%
% - Press M(m): -z
%
% * Initial view point: Initial view point when "Set view point by Input" parameter was OFF ([x y z]). 
%
% * View point step: View point step for keyboard input. Step value has to be greater than zero.
% 
% * Camera distortion coefficients: The input vector of camera distortion coefficients ([k1 k2 p1 p2 k3]) Zero value means no distortion.
%
% * Image output: Configure output of point cloud image (ON: Image output/OFF:No image output).
%
