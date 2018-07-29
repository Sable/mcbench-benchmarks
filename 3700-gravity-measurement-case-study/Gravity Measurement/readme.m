function readme
% OVERVIEW
% 
% Welcome to the Gravity Case Study. This is an expansion of a demo, parts
% of which shipped with version 4.0 of the Image Processing Toolbox and
% version 1.0 of the Image Acquisition Toolbox.
% 
% The goal of this case study is to show how MATLAB and various toolboxes
% can be used together to solve an imaging problem. The specific problem
% shown here is a science experiment. Given a pendulum, measure gravity.
% The mathematics are well defined by classical physics. Gravity depends on
% the length of the pendulum and the period of oscillation. An example data
% set is included in which a ball suspended by a string was used as a
% pendulum. A captured video of the swinging ball and the time stamps for
% each video frame are stored in a native MATLAB data file. Another such
% file contains the predetermined pixel resolution associated with this
% camera setup.
% 
% The Image Acquisition Toolbox was originally used to acquire a video of
% the oscillating pendulum directly into MATLAB. One advantage of this
% approach over importing video data from an AVI file was having direct
% control of the desired image resolution and frame rate of the camera at
% the device level. It was also convenient being able to work with the
% camera from within the MATLAB environment instead of having to deal with
% additional applications and intermediate movie files.
% 
% The Image Processing Toolbox was used to find and extract the location of
% the moving ball in each frame. A circle was then fitted to the ball
% positions to find the center of rotation, average radius and radial
% variation or spatial measurement error. The positions were transformed
% from cartesean to polar coordinates, which produced a damped harmonic
% motion of angular positions versus time. 
% 
% The System Identifaction Toolbox was used to fit an autoregressive moving
% average (ARX) model to the damped sinusoid. This resulted in a
% discrete-time transfer function description of the harmonic motion. The
% discrete mathematical model was then transformed to a continuous-time
% domain transfer function expressed in the frequency domain using Laplace
% "s" notation. From the complex poles of the transfer function, the radian
% frequency of oscillation was extracted and then inverted to get the
% period of oscillation. In addition, variation in time stamps for each
% frame were determined to estimate temporal measurement error. 
% 
% Finally, the Symbolic Math Toolbox was used to manipulate the governing
% equations of motion from physics. This simplified the algebraic task of
% solving for the measured gravity value. It also simplified the calculus
% to determine total stack-up error in the gravity measurement.
% 
% 
% REQUIREMENTS
% 
% This case study requires the following MathWorks products.
% 
% 	MATLAB
% 	Image Acquisition Toolbox
% 	Image Processing Toolbox
% 	System Identification Toolbox
% 	Symbolic Math Toolbox
% 
% If you want to set up your own experiment, you will also need a video
% camera. To see a list of video hardware supported by the Image Acquistion
% Toolbox, you can visit the product page on the MathWorks web site.
% <http://www.mathworks.com/products/supportedio.jsp?prodDir=imaq>
% 
% 
% INSTRUCTIONS
% 
% To run this demo, point MATLAB to the folder containing the following
% files, which should have been bundled together in the original ZIP file.
% 
%   calculate_gravity.m         calibrate_resolution.m
%   captured.mat                fit_circle.m
%   get_video_data.m            gravity_demo.m
%   load_captured_data.m        locate_ball_positions.m
%   model_system.m              pixRes.mat
%   ReadMe.txt                  remove_background.m
%   segment_by_threshold.m      select_region.m
%   setup_live_capture.m        suppress_noise.m
%   transform_to_polar.m        limits.m
% 
% Run the main script M-file. It will call other script M-files in
% sequence.
% 
% 	>> gravity_demo
% 
% If an IMAQ device is detected, you can select to use it to reproduce the
% experiment. If not, a dialog box appears automatically. The rest of these
% notes assume you continue working with saved data that was originally
% provided with this package. 
%
% Select the captured.mat file. A 50-frame full color video plays as an
% animation in a MATLAB figure window. To see how MATLAB graphics commands
% were used to display this animation view the get_video_data.m file. 
% 
% Press any key to advance to next step - region selection. Some image
% processing is done to isolate the moving parts of the video without the
% static background. To see the details of how that was done view the
% select_region.m file. 
% 
% Now select a rectangular region around the motion area. Press and hold
% the left button to select one corner, then drag to the opposite corner
% before releasing. A rubber band box will help you see the region you are
% selecting. 
% 
% After you click, drag and release, a blue box highlights the region you
% selected and a cross hair appears. If you like the region you selected,
% left click once inside the box. If not, click outside the box, then try
% selecting the region again. 
% 
% After you accepted the selected region, you should then see a smaller
% video animation in grayscale now instead of color. The ball should not be
% cropped off by your region selection or the demo may not work right. If
% not, stop the program (ctrl-C) and start over.
% 
% Press any key to remove the background. You should see another small
% grayscale video of a dark ball on a light background. To see how the
% background was removed view the remove_background.m file.
% 
% Press any key to segment the ball in each video frame. You should see the
% first frame after thresholding. Press any key again to advance to the
% next segmented frame. Repeat until you reach frame 9. Beginning with
% frame 10 the rest of the frames play automatically as an animation. For
% more details about how the segmentation was performed view the
% segment_by_threshold.m file.
% 
% Press any key to suppress stray noise in the segmented images. Before you
% do so notice the small isolated pixels in the shadow of the ball in frame
% 50. After you press a key you should see another animation. This time the
% noise should be removed. Some frames may still show a shadow of the ball
% but further processing will deal with that. To see how the noise removal
% was done view the suppress_noise.m file.
% 
% Press any key to locate the ball positions in each frame. You should see
% a grayscale image of the background scenery with blue points at all 50
% ball locations, one per frame. If you look carefully, you can see ghosts
% of a ball around each point. To see details of how this step was done
% view the locate_ball_positions.m file.
% 
% Press any key to fit a circle to the ball XY positions. Notice the center
% and radius are annotated on the figure window along with the background
% scene and individual ball positions from each frame. Although the pivot
% point was well outside the field of view of the camera when the video
% frames were acquired, its position was determined. We'll see more about
% how precisely shortly. To see how the curve fitting was done view the
% fit_circle.m file. Note that MATLAB's basic curve fitting abilities were
% exercised here. To learn about additional fitting capabilities of the
% Curve Fitting Toolbox, visit the product page on the MathWorks website.
% <http://www.mathworks.com/products/curvefitting/>
% 
% Next, press any key to transform the ball positions to polar coordinates.
% You should see a new figure with a decaying sinusoid above and its
% frequency spectrum below. Notice the frequency is less than 0.5. Also, if
% you look back at the command line you can see that the circle radius or
% pendulum length was consistent within a fraction of a pixel! To see how
% this was done view the transform_to_polar.m file.
% 
% Press any key to fit a vibration model to the angular positions versus
% time. In the editor the model_system.m file should be open. If you
% examine the code you can see how an ARX model was fitted to the harmonic
% data and how the period of oscillation was extracted from the fitted
% model parameters. The System Identification Toolbox makes easy work of
% the otherwise challenging task of fitting a sinusoid to data. In the
% command windows you should see the output results since this script
% should already have been run.
% 
% Press any key to calibrate the pixel size. You should see a dialog box
% asking if this image contains 3-4-5 triangle calibration marks. The
% captured video file does not contain such calibration marks so select no.
% In the command window you should see that the image resolution was about
% 5 mm per pixel. This value was simply loaded from a file based on an a
% priori calibration process.
% 
% Press any key to calculate gravity. In the command window you should see
% the result is 9.6 +/- 1.1 meters per second squared. Compare this to a
% handbook value of 9.81 and it's within 3 percent. Measurement error was
% 11 percent so the accuracy of the measurement was reasonably acceptable.
% 
% The calculate_gravity.m file should already be opened in the editor. You
% can see how the Symbolic Math Toolbox was used to make short work of the
% algebra and calculus. The textbook equation for pendulum motion was
% expressed as period, T as a funciton of length, L and gravity, g. So the
% equation was inverted to get g as a function of L and T. Partial
% derivatives of g with respect to both L and T were then computed and used
% to determine stack-up measurement error from both the spatial and
% temporal contributions. Which contributed more? Evaluate the temporal
% contribution
% 
% 	>> abs(eval(dgdT))*dT
% 	ans =
% 	      0.90186
% 
% along with the spatial contribution
% 
% 	>> abs(eval(dgdL))*dL
% 	ans =
% 	      0.20245
% 
% to see that most of the measurement error was due to time stamp
% variability not pixel accuracy. This is somewhat understandable. The
% camera used is an inexpensive, consumer grade web cam that was not
% designed for scientific measurements ... and yet the results were quite
% good. So if you needed better measurement precision you would know where
% to focus your energy.
% 
% 
% DISCLAIMER
% 
% I hope you found this demo useful. If you encounter any unresolvable
% problems with this demo, or if you want to share comments or suggestions,
% feel free to contact me.
% 
% 	-rbemis@mathworks.com
help(mfilename), return
