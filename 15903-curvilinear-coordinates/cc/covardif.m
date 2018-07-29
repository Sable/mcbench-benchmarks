function vdif=covardif(v,type,names,cs2)
% vdif=covardif(v,type,names,cs2)

% This function computes the covariant
% derivatives of a vector expressed in
% either covariant or contravariant
% components.
% v     - curvilinear coordinate components
%         of a vector
% type  - 1 if components are contravariant.
%         2 if components are covariant.
% names - a string containing the symbolic
%         names of the coordinate variables,
%         such as 'r, theta, z' for cylin-
%         drical coordinates
% cs2   - the Christoffel symbols of the
%         second kind
% vdif  - an array where column j gives
%         the covariant derivative of the
%         vector v with respect to the
%         j'th coordinate 

if ischar(names), t=sym(['[',names,']']);
else t=names; end    
v=v(:); vdif=sym(zeros(3,3));
for j=1:3
  vdif(:,j)=simple(diff(v,t(j)));
end
for i=1:3, for j=1:3
  if type ==1 % contravariant components
    u=v(1)*cs2(1,j,i)+v(2)*cs2(2,j,i)...
      +v(3)*cs2(3,j,i);
  else        % covariant components
    u=-v(1)*cs2(i,j,1)-v(2)*cs2(i,j,2)...
      -v(3)*cs2(i,j,3);
  end
  vdif(i,j)=simple(vdif(i,j)+u);
end, end 