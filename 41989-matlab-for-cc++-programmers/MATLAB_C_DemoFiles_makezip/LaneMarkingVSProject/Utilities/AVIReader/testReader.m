%% Verify Reader

%%
% Video Player
hPlayer = vision.VideoPlayer;

%% Display First Frame
[isDone, frame] = readAVIFile;

step(hPlayer, frame);

%% Loop Entire Video
while ~isDone
    step(hPlayer, frame);
    
    [isDone, frame] = readAVIFile;
end


%% Use Mex version
[isDone, frame] = readAVIFile_mex;
while ~isDone
    step(hPlayer, frame);
    
    [isDone, frame] = readAVIFile_mex;
end