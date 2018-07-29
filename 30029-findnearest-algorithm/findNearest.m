function [nearVal, index] = findNearest(x, desiredVal)
%% 
%
% Parameters:
%
% x: the matrix in which you want to search
%
% desiredVal: the data you are looking for in x
%
% Description:
%
% This function finds the closest value to desiredVal that exsists in x
%
% Outputs:
%
% Output one is the nearest value
%
% Output two is the index where the nearest value is found
x = x(:)'; %% this resizes the matrix
if nargin == 2
    if ismember(x,desiredVal) == 1 %% This is the O(1) case
        index = find(x == desiredVal);
        nearVal = x(x==desiredVal);
    else 
        [~, index] = min(abs(desiredVal-x)); %% Thank you Jan Simon for this equation
        nearVal = x(index);
    end
else
    disp('You have not entered the correct amount of parameters');
end