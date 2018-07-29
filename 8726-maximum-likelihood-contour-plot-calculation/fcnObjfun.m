function out=fcnObjfun(BaseCasecoeff, param)
% sample obj. function
% REPLACE THIS FUNCTION WITH YOURS!!!
% input
% BaseCasecoeff - base case coefficients
% param - additional parameters (strucure or vector)
% output: scalar

 out = sum(sqrt((BaseCasecoeff).^5) * .100);
% out = sum(sin(BaseCasecoeff));

