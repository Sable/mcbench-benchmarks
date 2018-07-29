function sh = pairsFun(x,data,scaling,cost)
% define pairs to accept vectorized inputs and return only sharpe ratio
%%
% Copyright 2010, The MathWorks, Inc.
% All rights reserved.

[row,col] = size(x);
sh  = zeros(row,1);
x = round(x);

if ~exist('scaling','var')
    scaling = 1;
end
if ~exist('cost','var')
    cost = 0;
end

% run simulation
parfor i = 1:row
    if col == 2
        [~,~,sh(i)] = pairs(data, x(i,1), x(i,2), 1, scaling,cost);
    else
        [~,~,sh(i)] = pairs(data, x(i,1), x(i,2), x(i,3), scaling,cost);
    end
end