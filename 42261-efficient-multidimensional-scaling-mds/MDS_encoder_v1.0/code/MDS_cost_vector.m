% Copyright (C) 2013 Quan Wang <wangq10@rpi.edu>, 
% Signal Analysis and Machine Perception Laboratory, 
% Department of Electrical, Computer, and Systems Engineering, 
% Rensselaer Polytechnic Institute, Troy, NY 12180, USA
% 
% You are free to use this software for academic purposes if you cite our paper: 
% Quan Wang and Kim L. Boyer. 
% Feature Learning by Multidimensional Scaling and its Applications in Object Recognition.
% 2013 26th SIBGRAPI Conference on Graphics, Patterns and Images (Sibgrapi). IEEE, 2013.
% 
% For commercial use, please contact the authors. 


% The target function to be minimized at each step. 

function f=MDS_cost_vector(x,V_dist,X)

X=bsxfun(@minus,X,x);
V=sum(X.*X,2);
f=sqrt(V)-V_dist;