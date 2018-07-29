clear all;
close all;
clc;


image = 'cow';
% image = 'bungee';
% image = 'man';

Aorg = imread([image '.png']);
Morg = imread([image '-mask.png']);

tic
A=patch_inpaint(Aorg,Morg);
toc

imshow(A)