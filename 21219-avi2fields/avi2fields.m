function avi2fields(file)
%AVI2FIELDS converts each field of an .avi file .jpg images
% AVI2FIELDS was designed to load a raw .avi movie file and extract each
% field into a jpg image.

global FileDir

if FileDir == 0
    FileDir = [];
end


clc
if ~nargin
    [FileName PathName] = uigetfile('*.avi','Select movie',FileDir);   % Get file
    if ~FileName, return, end
    FileDir = PathName;
else
    [PathName FileName ext] = fileparts(file);
    FileName = [FileName ext];
end
hWait = waitbar(0,['Converting ' FileName ' to pictures']);     % wait bar at 0%;
set(get(get(hWait,'children'),'title'),'Interpreter','None');   % Set interpreter to none
File = fullfile(PathName,FileName);
mov = mmreader(File);                       % Load movie
frames = read(mov);
N_frames = size(frames,4);                  % Get the number fo frames
N_digits = length(num2str(N_frames*2));     % Number of digits to represent all fields
flag = sprintf('%%0%dd',N_digits);          % Flag with the number of digits = ['%0' num2str(N_digits) 'd'];
for i = 1 : N_frames
    waitbar(i/N_frames,hWait);
    frame = frames(:,:,:,i);
    imwrite(frame(2:2:end,:,:),[File(1:end-4) '_' num2str(2*i-1,flag) '.jpg'],'Quality',100);   % Save field 1 (first half picture)
    imwrite(frame(1:2:end,:,:),[File(1:end-4) '_' num2str(2*i,flag) '.jpg'],'Quality',100);     % Save field 2 (second half picture)
end
close(hWait)                                    % Close wait bar
