%o=vcross(s,t)
%-------------
%
%Vector cross product.
%
%  Leutenegger Marcel © 3.3.2005
%
%Input:
% s,t    vectors
%
%Output:
% o      vector: s X t = cross(s,t)
%
function o=vcross(s,t)
switch nargin
case 0
   fprintf('\nVector cross product.\n\n\tLeutenegger Marcel © 3.3.2005\n');
case 2
   if isempty(s) | isempty(t)
      o=[];
   else
      if size(s,1) ~= 3 | size(t,1) ~= 3
         error('Incompatible dimensions.');
      end
      o=[s(2,:).*t(3,:)-s(3,:).*t(2,:);
         s(3,:).*t(1,:)-s(1,:).*t(3,:);
         s(1,:).*t(2,:)-s(2,:).*t(1,:)];
   end
otherwise
   error('Incorrect number of arguments.');
end
