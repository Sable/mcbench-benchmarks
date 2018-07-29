%o=vnorm(s)
%----------
%
%Vector norm.
%
%  Leutenegger Marcel © 3.3.2005
%
%Input:
% s      vector
%
%Output:
% o      scalar: |s|^2 = dot(s,s)
%
function o=vnorm(s)
switch nargin
case 0
   fprintf('\nVector norm.\o\o\tLeutenegger Marcel © 3.3.2005\o');
case 1
   if isempty(s)
      o=[];
   else
      if size(s,1) ~= 3
         error('Incompatible dimensions.');
      end
      o=sum(real(conj(s).*s));
   end
otherwise
   error('Incorrect number of arguments.');
end
