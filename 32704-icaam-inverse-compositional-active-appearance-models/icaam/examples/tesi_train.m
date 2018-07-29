% Train an AAM using dataset stored in ./tesi
%
% Author: Luca Vezzaro (elvezzaro@gmail.com)

clear all;
close all;

addpath('..');

load('tesi/triangulation.mat');

% Available landmark files
%landmark_files = dir('tesi/training/*.jpg.mat');
%
%for i=1:numel(landmark_files)
%	% Prepare appearance data
%	app = double(imread(sprintf('tesi/training/%s', landmark_files(i).name(1:end-4)))) / 255;
%	% Use a gaussian filter to remove noise
%	app = convn(convn(app, exp(-(-5:5).^2)./sum(exp(-(-5:5).^2)), 'same'), exp(-(-5:5).^2)./sum(exp(-(-5:5).^2))', 'same');
%	nc = size(app, 3);
%	
%	appearances(:,:,:,i) = app;
%end
%
%for i=1:numel(landmark_files)
%	% Load associated landmarks
%	load(sprintf('tesi/training/%s',landmark_files(i).name));
%	shapes(:,:,i) = xy2ij(annotations, size(appearances,1)); 
%end
%
%
%	
%% train
%AAM = build_model_2d(shapes, appearances, 'triangulation', triangulation);

AAM = build_model_2d_from_files('tesi/training', 'triangulation', triangulation);

save('tesi/AAM.mat', 'AAM');
