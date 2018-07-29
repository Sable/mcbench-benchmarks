% function to simulate the observations
%  this function uses f_h() which is the implementation of the measurment
%  model
% Inputs:
%  X - all the state variables
%  noise - std of Gaussian noise to be added to observations
% Ouputs:
%  OBS - observations
%  OBSn - observations with noise
function [OBS, OBSn] = f_Observe(X,noise)

n = size(X,2); % number of frames

OBS = zeros(2,n); % make room

for i = 1:n
    OBS(:,i) = f_h(X(:,i));
end

OBSn = OBS + noise*randn(2,n); % add noise
    
