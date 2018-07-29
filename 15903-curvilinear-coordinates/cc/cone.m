function [X,names]=cone
% [X,names]=cone defines a non-orthogonal
% coordinate system using a conical surface
% with a planar base
syms z t p real; names=[z t p];
X=[z*tan(t)*cos(p); z*tan(t)*sin(p); z];