function [gradp,varlist] = gradient(sp)
% sympoly/gradient: gradient vector of a sympoly
% usage: [gradp,varlist] = gradient(sp);
% 
% arguments: (input)
%     sp - scalar sympoly object
%
% arguments: (output)
%  gradp - sympoly (row vector) object containing the gradient vector
%
%  varlist - cell array of variable names used for the gradient

if numel(sp)>1
  error 'Gradient only works for scalar sympoly objects.'
end

varlist = setdiff(sp.Var,{''});
nvar=length(varlist);

if nvar==0
  % sympoly had no variables, i.e., it was a constant
  gradp=sympoly(0);
else
  % loop over the variables
  gradp = sympoly(zeros(1,nvar));
  for i=1:nvar
    gradp(i)=diff(sp,1,varlist{i});
  end
end


