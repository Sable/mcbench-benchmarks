%% Mean-Shift Video Tracking
% by Sylvain Bernhardt
% July 2008
% Updated March 2012
%% Description
% Import a AVI video file from its 'path'.
% The output is its length, size (height,width)
% and the video sequence read by Matlab from
% this AVI file.
%
% [lngth,h,w,mov]=Import_mov(path)

function [lngth,h,w,mov]=Import_mov(path)
infomov = mmreader(path);
lngth = infomov.NumberOfFrames;
h = infomov.Height;
w = infomov.Width;
mov(1:lngth) = struct('cdata', zeros(h, w, 3, 'uint8'), 'colormap', []);
% Read one frame at a time.
for k = 1 : lngth
    mov(k).cdata = read(infomov, k);
end