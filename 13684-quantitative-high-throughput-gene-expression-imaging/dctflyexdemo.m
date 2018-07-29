%% FlyEx distributed computing demo
% This file illustrates how to batch-process a number of files using a
% MATLAB script with the Distirbuted Computing Toolbox. A directory is
% scanned, and all files in the directory are processed using the same
% algorithm (in this case flyproc.m, a version of the algorithm contained
% in flyexdemo.m). Timings are taken for comparison with the local version
% of this batch-processing script (dctflyexdemo.m).

%% Find a scheduler
% Replace 'matrix-op1' with the hostname of your job manager.

jm=findResource('scheduler', 'type', 'jobmanager', ...
    'hostname', 'matrix-op1');

%% Create a job on the scheduler

job = createJob(jm);

%% Add the m-file to the job's file dependencies

job.FileDependencies = {'flyproc.m'};

%% Create a task for processing each image
% Replace this directory with the network path to the directory containing
% the images.

d = dir('\\matrix-op1\DistCompDemos\flyexdemo\rot_images');
files = {d(3:end).name};
numfiles = size(files, 2);

% Replace this directory with the path on the cluster to the directory
% containing the images.

pathname = 'C:\DistCompDemos\flyexdemo\rot_images';

for i = 1:numfiles
    filename = fullfile(pathname, files{i});
    task = createTask(job, @flyproc, 4, {filename});
    set(task, 'UserData', files{i});
end

%% Add callbacks to update us on task progress

set(job.Tasks, 'RunningFcn', ...
    @(task, eventData)  disp(sprintf( ...
    'Starting processing for image %s on host %s', ... 
    task.UserData, task.worker.Hostname)));

set(job.Tasks, 'FinishedFcn', ...
    @(task, eventData)  disp(sprintf( ...
    'Processing for image %s done', ... 
    task.UserData)));

%% Get a timestamp before starting the processing

tic;

%% Submit the job to the cluster

submit(job);

%% Wait for the job to complete

waitForState(job, 'finished');

%% Display the total time taken for processing

disp(sprintf( ...
    '\nParallel time for processing %d images: %3.2f seconds', ...
    numfiles, toc));

%% Get the results

results = getAllOutputArguments(job);

%% Destroy the job

destroy(job);

%% Plot the results

figure('WindowStyle','docked')
hold on
title('Results of Distributed Processing of Images');

for i = 1:numfiles
    plot(0:100, results{i,1}, 'r');
    plot(0:100, results{i,2}, 'g');
    plot(0:100, results{i,3}, 'b');
end