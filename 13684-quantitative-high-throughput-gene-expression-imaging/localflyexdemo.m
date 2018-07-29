%% FlyEx local computing demo
% This file illustrates how to batch-process a number of files using a
% MATLAB script. A directory is scanned, and all files in the directory are
% processed using the same algorithm (in this case flyproc.m, a version of
% the algorithm contained in flyexdemo.m). Timings are taken for comparison
% with the distributed version of this batch-processing script
% (dctflyexdemo.m).

%% Get pathname to folder of images
% Change this directory name to the location to which you have downloaded
% the images.

pathname = 'D:\samdemos\flyex\rot_images';

%% Get filenames for processing

d = dir(pathname);
files = {d(3:end).name};
numfiles = size(files, 2);

%% Get a timestamp before starting the processing

tic;

%% Process the files one by one

for i = 1:numfiles
    
    % Display start message
    disp(['Starting processing for image ', files{i}]);
    
    % Process the image
    [rsmooth,gsmooth,bsmooth,stdim] = ...
        flyproc(fullfile(pathname, files{i}));
    
    % Store the results
    results{i,1} = rsmooth;
    results{i,2} = gsmooth;
    results{i,3} = bsmooth;
    
    % Display completion message
    disp(['Processing for image ', files{i}, ' done']);
end

%% Display the total time taken for processing

disp(sprintf( ...
    '\nSequential time for processing %d images: %3.2f seconds', ...
    numfiles, toc));

%% Plot the results

figure('WindowStyle', 'docked')
hold on
title('Results of Local Processing of Images');

for i = 1:numfiles
    plot(0:100, results{i,1}, 'r');
    plot(0:100, results{i,2}, 'g');
    plot(0:100, results{i,3}, 'b');
end