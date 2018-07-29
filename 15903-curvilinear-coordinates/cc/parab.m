function [X,names]=parab
% [X,names]=parab defines parabolic coordinates
syms u v p real; names=[u,v,p];
X=[u*v*cos(p); u*v*sin(p); (u^2-v^2)/2];