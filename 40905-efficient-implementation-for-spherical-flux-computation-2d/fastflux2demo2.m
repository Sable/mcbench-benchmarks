clear all; close all; clc;
%%

img = zeros(128,128);
center = 64;
radius = 4;
img(:, center-radius:center+radius)=1;

scaleStep = 1;
r = 2:scaleStep:15;
sigma = 1;
tic
response = fastflux2(img, r, sigma);
toc

m = min(response(:));
M = max(response(:));
MM = zeros(size(r));
%%
for i = 1:length(r)
    MM(i) = max(max(response(:,:,i)));
    
end
SS_response = squeeze(response(64, :, :));

figure;
imagesc(r, 1:128, SS_response);
title('scale space response')

figure;
plot(r, MM, 'linewidth', 2)
hold on;
plot(r(MM == max(MM)), max(MM), 'or', 'markersize', 8)
%%
Response = max(response, [], 3);
Response = max(Response, 0);
% 
figure, 
subplot(1, 2, 1), imshow(img, []);
subplot(1, 2, 2), imshow(Response, []);