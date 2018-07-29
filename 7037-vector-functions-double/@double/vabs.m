%o=vabs(s)
%---------
%
%Vector length.
%
%  Leutenegger Marcel © 3.3.2005
%
%Input:
% s      vector
%
%Output:
% o      scalar: |s| = sqrt(dot(s,s))
%
function o=vabs(s)
switch nargin
case 0
   fprintf('\nVector length.\n\n\tLeutenegger Marcel © 3.3.2005\n');
case 1
   if isempty(s)
      o=[];
   else
      if size(s,1) ~= 3
         error('Incompatible dimensions.');
      end
      o=sqrt(sum(real(conj(s).*s)));
   end
otherwise
   error('Incorrect number of arguments.');
end
