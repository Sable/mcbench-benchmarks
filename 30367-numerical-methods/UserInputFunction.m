function [out1,out2,out3] = UserInputFunction(x,y)
if nargin==0; x = 0;y = 0; end
%[-------------------------------------]%
% EDIT THE FUNCTION TO YOUR OWN CHOICE%
  G = x + y;
%[-------------------------------------]%
if nargout==2, 
   out1 = x; out2 = y;  out3 = G;
else 
   out1 = G;
end

