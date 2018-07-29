% RUNME.m -- example using of the foregorund extractor.
%
% Nicholas R. Howe
% March 10, 2005.
% Please read copyright.txt

disp(' ');
disp('This example shows the basic use of the foreground ');
disp('extraction package.  We''ll use a simple video of ');
disp('someone walking.');
disp(' ');
disp('>> avi = aviread(''SampleVideo.avi'');');
disp('>> frames = {avi.cdata};');

avi = aviread('SampleVideo.avi');
frames = {avi.cdata};
for i = 1:length(frames)
    imagesc(frames{i});
    axis image off
    drawnow;
end;

disp(' ');
disp('First we''ll call extractForeground using the ');
disp('default settings.  (This may take a while.)');
disp(' ');
disp('>> fg = extractForeground(frames);');

fg = extractForeground(frames);
for i = 1:length(fg)
    imagesc(fg{i});
    axis image off
    drawnow;
end;


disp(' ');
disp('This particular video gives better results with a ');
disp('slightly lowered significanceThreshold.');
disp(' ');
disp('>> fg2 = extractForeground(frames,[],[],[],[],4.5);');
disp(' ');

fg2 = extractForeground(frames,[],[],[],[],4.5);
for i = 1:length(fg2)
    imagesc(fg2{i});
    axis image off
    drawnow;
end;
