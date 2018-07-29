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


% Using trained MDS model to encode new data points. 

function [X2]=MDS_encoding(X1,Dist,display_flag)
% X1: training set MDS codes, N1*d
% Dist: distance matrix from training set to encoding set, N1*N2
% display_flag: whether to display intermediate output
%     0: no display
%     1: display iteration
% X2: encoding set MDS code, N2*d

if nargin==2
    display_flag=1;
end

[~, N2]=size(Dist);
d=size(X1,2);
X2=zeros(N2,d);

options = optimset('Display', 'off', 'Algorithm', ...
    {'levenberg-marquardt',0.01},'MaxIter',10,'MaxFunEvals',100);

%% encoding
meanX1=mean(X1);
for k=1:N2
    if display_flag~=0
        fprintf('Encoding: point %d\n',k);
    end
    x=meanX1;
    V_dist=Dist(:,k);
    x=lsqnonlin(@(x)MDS_cost_vector(x,V_dist,X1),x,[],[],options);
    X2(k,:)=x;
end


