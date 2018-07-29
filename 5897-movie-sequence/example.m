%
% example file for generating a movie from a sequence of viewpoint
%
%% Olivier Salvado, Case Western Reserve University, 16-Sep-04 


% construct a 3D scene
[X,Y] = meshgrid(-3:.125:3);
Z = peaks(X,Y);
surfl(X,Y,Z);
axis vis3d
axis off

% create the structure with current view
cam = CamSeqUpdate([]);
% change to view #2
% normally the new view is changed manually using the camera toolbar
campos([20 20 0]) 
camtarget([1 0 0])
% add the new view to be 5s after view #1
cam = CamSeqUpdate(cam,5);

% change to view #3
% normally the new view is changed manually using the camera toolbar
campos([5 5 50]) 
camtarget([0 1 1])
% add the new view to be 10s after view #2
cam = CamSeqUpdate(cam,10);

% change to view #4
% normally the new view is changed manually using the camera toolbar
zoom(0.8)
% add the new view to be 5s after view #3
cam = CamSeqUpdate(cam,5);

% generate the sequence
fps = 20;   % 20 frames per second
seq = CamSeqGen(cam,fps);

% play the movie and save the file
M = CamSeqPlay(seq,fps,'GoodLookingMovie.avi');

