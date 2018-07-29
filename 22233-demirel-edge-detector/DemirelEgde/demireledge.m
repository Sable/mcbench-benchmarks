function h=demireledge(im,thr,T)
%h=demireledge(im,thr,T);
%im is an input image, thr is a threshold between 0-1, T is the thickness 
%of the line to indicate the edge.
%h is an uint8 balck and white image with values of 0 and 255.
%This programme has been written by me, G. Anbarjafari (Shahab) months ago
%but I finalized today 17-11-2008 and Dr Hasan Demirel and I decided to
%post it now 17/11/2008.
%(c) Demirel and Anbarjafari - 2008
clear memory
h=demirel(im,thr,T);
clc