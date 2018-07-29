clc; clear all; close all;

% Recompile mex code
mex -g 'ray_trace_mex.c';

% profile off;
% profile on -timer real

% Parameters in volume
dimension = 256;
output_size = uint32([dimension,dimension]');
% output_size = uint32([512,226]');
raystep = 1;

%Creates a sample volume
load('volume_in');

% Loads the image, color map, and opacity map (black, light blue 
colormap = [ -100000 0  600  1000 1300  2000 100000 %Value
             0       0  128  255  255   255  255    %R
             0       0  255  64   128   255  255    %G
             0       0  255  64   128   255  255]'; %B

opacitymap = [-10000 600  1000 1600 1800 100000 %Value
              0       0   .05  .1   .8    1]';   %Opacity

% Makes image of type double for math operations
volume_in = double(volume_in);

%Calculate volume gradients
tic
[gx gy gz] = gradient(volume_in);
gradient_calc_time = toc

% Create rays
tic;
rays = ParallelRayGenerator3d(volume_in, output_size(1), output_size(2), raystep);
ray_generation_time = toc

tic;
% renderedImage = volumeRender(volume_in, gx, gy, gz, rays, output_size, colormap, opacitymap);
rays = rays-1; %Account for C/MATLAB indexing differences
renderedImage = ray_trace_mex(volume_in, gx, gy, gz, rays, output_size, colormap, opacitymap, uint32(0));
rendering_time = toc

imshow(renderedImage/255);

% profile viewer

% sz = size(volume_in);
% xdim=1:raystep_pct:sz(1);
% rays_reshape = reshape(rays,[3 length(xdim) output_size(1) output_size(2)]);
% figure()
% hold on;
% for y=1: output_size(1) %y dim
%     for z=1: output_size(2) %zdim
%         xloc = squeeze(rays_reshape(1,:,y,z));
%         yloc = squeeze(rays_reshape(2,:,y,z));
%         zloc = squeeze(rays_reshape(3,:,y,z));
%
%         plot3(xloc,yloc,zloc,'-x');
%     end
% end
% hold off;
% clear rays_reshape;
% xlabel('x');
% ylabel('y');
% zlabel('z');
% title('Rays');
