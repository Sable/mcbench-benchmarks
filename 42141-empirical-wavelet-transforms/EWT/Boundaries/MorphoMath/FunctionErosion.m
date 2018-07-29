function s=FunctionErosion(f,sizeel)

%=========================================================
% function s=FunctionErosion(f,sizeel)
%
% This function perform the mathematical morphology 
% erosion operator for functions according to structural
% element of size sizeel.
%
% Inputs:
%   -f: input function
%   -sizeel: size of the structural element
%
% Output:
%   -s: the eroded function
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%=========================================================

s=zeros(size(f));

for x=1:length(f)
   if x<=sizeel 
       a=1;
   else
       a=x-sizeel;
   end
   
   if x>length(f)-sizeel
       b=length(f);
   else
       b=x+sizeel;
   end
   s(x)=min(f(a:b));
end