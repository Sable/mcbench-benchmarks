%o=vmul(s,t)
%-----------
%
%Vector multiplication.
%
%  Leutenegger Marcel © 3.3.2005
%
%Input:
% s      vector
% t      scalar
%
%Output:
% o      vector: s*t = s.*repmat(t,3,1)
%
function o=vmul(s,t)
switch nargin
case 0
   fprintf('\nVector multiplication.\n\n\tLeutenegger Marcel © 3.3.2005\n');
case 2
   if isempty(s) | isempty(t)
      o=[];
   else
      if size(s,1) ~= 3 | size(t,1) ~= 1
         error('Incompatible dimensions.');
      end
      if numel(t) == 1
         o=s.*t;
      elseif numel(s) == 3
         o=repmat(s,size(t)).*repmat(t,3,1);
      else
         o=s.*repmat(t,3,1);
      end
   end
otherwise
   error('Incorrect number of arguments.');
end
