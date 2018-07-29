
%% read an avi file

file = 'numbers_xvid.avi';

info = avsReader(file);
f=figure;
for i=1:info.numFrames
   img = avsReader(file,i);
   pause(0.1)
   imshow(img);
end
close(f);

%% read an avi file using avisynth commands

file = 'numbers_xvid.avi';

info = avsReader(file);
f=figure;
for i=1:info.numFrames
    args = {sprintf('c=DirectShowSource("%s")',file),'c=c.TurnLeft()','return c'};
   img = avsReader(args,i);
   pause(0.1)
   imshow(img);
end
close(f);

%% read an avi file using an avisynth file (text file with avisynth commands)

file = 'numbers_xvid.avs';

info = avsReader(file);
f=figure;
for i=1:info.numFrames   
   img = avsReader(file,i);
   pause(0.1)
   imshow(img);
end
close(f);





