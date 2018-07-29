clear all
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demo file for deconvtv
% Video disparity denoise
% 
% Stanley Chan
% University of California, San Diego
% 20 Jan, 2011
%
% Copyright 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Prepare video
folder_name = './data/';

fname = sprintf('%sdata%04d.jpg', folder_name, 1);
f     = im2double(imread(fname));
[rows cols frames] = size(f);
g     = zeros(rows,cols,frames);

for fidx = 1:10
    fname = sprintf('%sdata%04d.jpg', folder_name, fidx);
    f = im2double(imread(fname));
    if size(f,3)>1
        g(:,:,fidx) = rgb2gray(f);
    else
        g(:,:,fidx) = f;
    end
end

% Setup parameters (for example)
opts.beta    = [1 1 10];
opts.print   = true;
opts.method  = 'l1';

% Setup mu
mu           = 1;

% Main routine
tic
out = deconvtv(g, 1, mu, opts);
toc

% Display results
figure(1);
imshow(g(:,:,5));
title('input');

figure(2);
imshow(out.f(:,:,5));
title('output');