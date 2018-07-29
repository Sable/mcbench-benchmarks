% 'gfht_demo1.m'
%
% This is a medical application of the generalized fuzzy Hough transform 
% (GFHT) for the autiomatic identification of Regions Of Interest (ROIs) in 
% Cardiac Magnetic Resonance Images (CMRIs).
%
% The original CMRI is loaded and presented. The goal is to identify the
% aorta artery (visually labelled). In this way we used the GFHT customized
% for the aorta defined in the R-table ('SA00_pat').
%
% Copyright (c) 2010 by Pau Micó

close all; clear; clc;
LAB = imread('HLA00_lab.bmp');                                              % labelled source load
click(LAB, 'Original HLA CMRI');
disp('Click ''enter'' to continue...'), pause;

load HLA00_pat                                                              % R-table load (pattern)
SRC = 'HLA00_src';                                                          % raw (unlabelled) source
rhorange = 0.9:0.1:1.2;
thetarange = -pi/40:pi/60:pi/40;
ewidth = 5;
[pratio, scl, rot, x0, y0] = gfht(SRC, patt, rhorange, thetarange, ewidth);