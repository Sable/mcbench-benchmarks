function [GaitDBDir,probes,numprobe]=testData

GaitDBDir=['USFGait17_32x22x10/'];

%If you want to test on higher resolution, please download them from 
%https://sites.google.com/site/tensormsl/#data
%or http://www.dsp.toronto.edu/~haiping/MSL#data
%and change the directory in this script.
%If you are using 32-bit Matlab, you may have out of memory problem. Please
%try:
%1. clear unused variables
%2. write matrix operations into for-loops
%3. use integer data type instead of single/double float point
%4. when passing variables to functions: save variables to mat files, clear
%the varialbes, load the variables in the calling function so Matlab won't
%keep two copies of the same data.

%GaitDBDir=['USFGait17_64x44x20/'];
%GaitDBDir=['USFGait17_128x88x20/'];

probes=['A','B','C','D','E','F','G'];
numprobe=length(probes);