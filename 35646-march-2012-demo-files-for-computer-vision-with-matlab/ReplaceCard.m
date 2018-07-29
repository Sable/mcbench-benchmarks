%% Copyright 2011-2012 The MathWorks, Inc.                                 
function ReplaceCard()
% This is a simple demo to show a match & replace of the video
% data. 
% 
% To try this, 
% 1. Get a deck of playing cards with "MATLAB & Simulink" logo or print
% the file "MWqueen_crop_small.bmp" on a color printer. 
% 2. Run this script in MATLAB
% 3. Show printed queen of diamond in front of the usb web camera.
% 4. Press either 1 or 2 of your keyboard to see the image changing
% 5. Press 0 of your keyboard to reset it back to queen of diamonds
% 
% Original version created by Takuya Otani
% Senior Application Engineer, MathWorks, Japan
%

clear all; close all; clc; imaqreset;
global process_flag;
process_flag = false;

%% Define Geometric Transformation Objects
gte = vision.GeometricTransformEstimator; 
gte.Method = 'Random Sample Consensus (RANSAC)';
gte.Transform = 'Nonreflective similarity';
gte.NumRandomSamplingsMethod = 'Desired confidence';
gte.MaximumRandomSamples = 500;
gte.DesiredConfidence = 99.8;

agt = vision.GeometricTransformer;
agt.OutputImagePositionSource = 'Property';
agt.OutputImagePosition = [1 1 480 640];

halphablender = vision.AlphaBlender( ...
    'Operation', 'Binary mask', 'MaskSource', 'Input port');

%% Setup Image Acquisition
hCamera = videoinput('winvideo', 1, 'RGB24_640x480');
hCamera.ReturnedColorspace = 'rgb';
hCamera.FramesPerTrigger =  1;

% Initialization of the camera
triggerconfig(hCamera, 'manual');
start(hCamera);

%% Load reference image data (queen of diamond) Pad the image data
%% to match 480x640 dimension
ref_img = imread('MWqueen_crop_small.bmp'); 
ref_img_pad = padarray(ref_img, [140 0], 'pre'); %340x240
ref_img_pad = padarray(ref_img_pad, [0 400], 'pre');
ref_img_gray = rgb2gray(ref_img_pad);
ref_keys = detectSURFFeatures(ref_img_gray, 'MetricThreshold', 1000);
% Extract SURF Features
[ref_features  ref_validPts] = extractFeatures(ref_img_gray,  ref_keys, 'SURFSize', 64);

% Open a Figure window which accepts keyboard inputs
figure('KeyPressFcn', @keycontrol);
himg = imshow(zeros(480, 640, 3, 'uint8'));

%% image data to replace 
global rep_img_pad;

while ishandle(himg) 
    
  %% Capture data from the camera, and extrace SURF features, and descriptors
  vid_img = getsnapshot(hCamera);
  vid_img = im2single(vid_img);  vid_img_gray = rgb2gray(vid_img);
  vid_keys = detectSURFFeatures(vid_img_gray, 'MetricThreshold', 1000);
  [vid_features vid_validPts] = extractFeatures(vid_img_gray, vid_keys, 'SURFSize', 64);

  %Here, I am using a MATLAB Coder compiled version of matchFeatures
  %To speed things up. 
  %index_pairs = matchFeatures(ref_features, vid_features, 'MatchThreshold', 2);
  index_pairs = matching_fcn_mex(ref_features, vid_features, 2);

  if process_flag == true & size(index_pairs,1) > 60

    ref_matched_points = ref_validPts(index_pairs(:,1));
    vid_matched_points = vid_validPts(index_pairs(:,2));

    
    % Estimate the transformation matrix
    [tform_matrix inlierIdx] = step(gte, ...
                                    ref_matched_points.Location, ...
                                    vid_matched_points.Location);

    % peform a geometric transformation
    rep_img_trans = step(agt, rep_img_pad, tform_matrix);
    
    % Replace the card
    mask = rep_img_trans(:,:,1) > 0;
    mosaic = step(halphablender, vid_img, rep_img_trans, mask);

    set(himg, 'CData', mosaic);
  else
    set(himg, 'CData', vid_img);
  end
  
  drawnow;
end



% When keyboard is pressed, replace rep_img data.
function keycontrol(src,evnt)
global rep_img_pad;
global process_flag;

if evnt.Character == '0'
    process_flag = false;
elseif evnt.Character == '1'
    process_flag = true;
    rep_img = imread('MWJoker_crop_small.bmp');
    rep_img = im2single(rep_img);
    rep_img_pad = padarray(rep_img, [140 0], 'pre');
    rep_img_pad = padarray(rep_img_pad, [0 400], 'pre');
elseif evnt.Character == '2'
    process_flag = true;
    rep_img = imread('MWspade_crop_small.bmp');
    rep_img = im2single(rep_img);
    rep_img_pad = padarray(rep_img, [140 0], 'pre');
    rep_img_pad = padarray(rep_img_pad, [0 400], 'pre');    
end
