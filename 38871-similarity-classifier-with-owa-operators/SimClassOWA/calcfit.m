function [fitness, class, Simil] = calcfit(data, ideals, y)
%Calculates the classification accuracy for the given data and class
%vectors.
%
% Inputs: 
% data = data matrix
% ideals = class vectors
% y: parameters, in this case
%   y(1)    =    p-value in similarity measure
%   y(2)    =    alpha value for OWA weights
%   y(3)    =    used owa aggregator
%
% Outputs:
%   fitness = classification accuracy
%   class   =    column vector of the classes in which the samples are classified
%   Simil   =    similarity values for each class 
%
[nc, v_dim] = size(ideals);  
d_dim = size(data,1);  
[class, Simil] = classifier(data(:,1:v_dim), ideals, y); 
fitness = length(find(class-data(:, v_dim +1) == 0))/d_dim;