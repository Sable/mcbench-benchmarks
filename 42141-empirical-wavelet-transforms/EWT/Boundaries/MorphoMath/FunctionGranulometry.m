function gra=FunctionGranulometry(f)

%=========================================================
% function gra=FunctionGranulometry(f)
%
% This function perform the mathematical morphology 
% granulometry analysis of the functions f
%
% Inputs:
%   -f: input function
%
% Output:
%   -gra: the granulometry distribution
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%=========================================================

smax=length(f);

gra=zeros(size(f));
mo=sum(f);
for s=1:smax
    gra(s)=1-sum(FunctionOpening(f,s))/mo;
end