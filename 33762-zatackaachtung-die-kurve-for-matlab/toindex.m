function [i, j] = toindex(x, y)
global F;

j = ceil(x);
i = size(F,1) - floor(y);