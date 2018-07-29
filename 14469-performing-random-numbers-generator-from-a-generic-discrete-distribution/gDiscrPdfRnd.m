function [] = gDiscrPdfRnd();

% generic Discrete Pdf Random numbers generator
% 
% this function extracts numbers that are randomly distributed over a discrete set of N elements, 
% the probability distribution function is user-defined.
% 
% 
% syntax:
% 
% Y = gDiscrPdfRnd(pdf)
% Y = gDiscrPdfRnd(pdf,n)
% Y = gDiscrPdfRnd(pdf,n,m)
% 
% pdf is a vector; the i-th component of pdf is the
% probability for the i-th element to be extracted
% 
% REMARK: the value sum(pdf) does NOT have to be equal to one. Due to the limited
% precision of double numbers, such condition is often hard to be verified. For this
% reason, THE ONLY CONDITION FOR THE ELEMENT OF pdf IS TO BE NONNEGATIVE 
% (i.e. pdf(i) >= 0 , for each 1 <= i <= length(pdf))
%     
% 
%     
% Y = gDiscrPdfRnd(pdf)   
% Y is a integer from 1 to length(pdf), randomly generated, according to pdf
% 
% Y = gDiscrPdfRnd(pdf,n)
% Y is a  n-by-n  matrix of intergers from 1 to length(pdf), randomly generated, according to pdf
% 
% Y = gDiscrPdfRnd(pdf,n,m)
% Y is a  n-by-m  matrix of intergers  from 1 to length(pdf), randomly generated, according to pdf
% 
% 
% 
% examples 1
% 
% The following line creates a 3-by-2 matrix of intergers equally distributed from 1 to 6 
% gDiscrPdfRnd([1/6 1/6 1/6 1/6 1/6 1/6],3,2)
% 
% which is identical to the following
% gDiscrPdfRnd([1 1 1 1 1 1],3,2)
% 
% 
% 
% 
% 
% example 2
% 
% the following example generates 10000 samples 
% a triangular pdf and displys the frequencies
% 
% ^
% |
% |           *
% |       *   *   *
% |___*___*___*___*___*______
%     1   2   3   4   5
% 
% 
% pdf = [1/9 2/9 3/9 2/9 1/9];  % or simply pdf = [1 2 3 2 1];
% Y = gDiscrPdfRnd(pdf,10000,1);
% hist(Y,[1:length(pdf)]);
% 
% 
% 
% 
% example 3
% similar to the previous, but this time pdf look
% rather sinusoidal...
% 
% t = [1:.2:3*pi]; pdf = 1 + t.*sin(t); pdf = pdf - min(pdf); 
% 
% figure
% bar(pdf,'r');
% 
% Y = gDiscrPdfRnd(pdf,100000,1);
% 
% figure;
% hist(Y,[1:length(pdf)]);
% 
% 
% 
% author Gianluca Dorini
% 
% g.dorini@ex.ac.uk
% 
% for compiling type 
%     
% mex gDiscrPdfRnd.c


error('gDiscrPdfRnd mex file absent, type mex gDiscrPdfRnd.c to compile');