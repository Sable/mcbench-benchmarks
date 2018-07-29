%% demo

plotFlag = 1;
depth = 6;

alef1 = imread('alef1.png');   %% Binary image
alef2 = imread('alef2.png');   %% Intensity image
tav = imread('tav.png');       %% Binary image

subplot(1,3,1);
vec1 = hierarchicalCentroid(alef1,depth,plotFlag);
subplot(1,3,2);
vec2 = hierarchicalCentroid(alef2,depth,plotFlag);
subplot(1,3,3);
vec3 = hierarchicalCentroid(tav,depth,plotFlag);

dist_1_2 = sum((vec1 - vec2) .^ 2);
dist_1_3 = sum((vec1 - vec3) .^ 2);

fprintf('The distance between alef1 and alef2: %1.3f\n', dist_1_2);
fprintf('The distance between alef1 and tav: %1.3f\n', dist_1_3);
