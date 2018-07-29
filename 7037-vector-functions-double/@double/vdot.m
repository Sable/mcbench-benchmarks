%o=vdot(s,t)
%-----------
%
%Vector dot product.
%
%  Leutenegger Marcel © 3.3.2005
%
%Input:
% s,t    vectors
%
%Output:
% o      scalar: s · t = dot(s,t)
%
function o=vdot(s,t)
switch nargin
case 0
   fprintf('\nVector dot product.\n\n\tLeutenegger Marcel © 3.3.2005\n');
case 2
   if isempty(s) | isempty(t)
      o=[];
   else
      if size(s,1) ~= 3 | size(t,1) ~= 3
         error('Incompatible dimensions.');
      end
      if numel(s) == 3
         d=size(t);
         d(1)=1;
         o=sum(repmat(conj(s),d).*t);
      elseif numel(t) == 3
         d=size(s);
         d(1)=1;
         o=sum(conj(s).*repmat(t,d));
      else
         o=sum(conj(s).*t);
      end
   end
otherwise
   error('Incorrect number of arguments.');
end
