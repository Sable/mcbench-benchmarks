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


% The total raw stress.

function f=MDS_training_cost_total(X,Dist)
% X: matrix of MDS codes
% Dist: distance matrix
% f: raw stress

N=size(Dist,1);
f=0;
for i=1:N-1
    x=X(i,:);
    XX=X(i+1:N,:);
    V_dist=Dist(i+1:N,i);
    
    XX=bsxfun(@minus,XX,x);
    V=sum(XX.*XX,2);
    V=sqrt(V)-V_dist;
    f = f + sum(V.*V);
end
