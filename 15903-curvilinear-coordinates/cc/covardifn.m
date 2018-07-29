function vdifn=covardifn(v,type,names,cs2,tn)
% vdifn=covardifn(v,type,names,cs2,tn)

% This function numerically computes the covariant
% derivatives of a vector expressed in either 
% covariant or contravariant components.
% v     - curvilinear coordinate components
%         of a vector
% type  - 1 if components are contravariant.
%         2 if components are covariant.
% names - a string or a symbolic vector containing
%         the symbolic names of the coordinate
%         variables, such as 'r, theta, z' for 
%         cylindrical coordinates
% cs2   - the Christoffel symbols of the second kind
% tn    - a numerical vector of coordinate values
% vdifn - an array where column j gives the numerical
%         values of the covariant derivatives of the
%         vector v with respect to the j'th coordinate
%         at coordinate position defined by tn

if ischar(names), t=sym(['[',names,']']);
else, t=names; end    
v=v(:); vdif=sym(zeros(3,3)); cs2n=zeros(3,3,3);
for j=1:3, vdif(:,j)=diff(v,t(j)); end

% Evaluate v, vdif and cs2 numerically
vn=double(subs(v,{t(1),t(2),t(3)},{tn(1),tn(2),tn(3)}));
vdifn=double(subs(vdif,{t(1),t(2),t(3)},...
                  {tn(1),tn(2),tn(3)})); 
for j=1:3
  cs2n(:,:,j)= double(subs(cs2(:,:,j),...
               {t(1),t(2),t(3)},{tn(1),tn(2),tn(3)})); 
end
for i=1:3, for j=1:3
  if type ==1 % contravariant components
    u=vn(1)*cs2n(1,j,i)+vn(2)*cs2n(2,j,i)...
      +vn(3)*cs2n(3,j,i);
  else        % covariant components
    u=-vn(1)*cs2n(i,j,1)-vn(2)*cs2n(i,j,2)...
      -vn(3)*cs2n(i,j,3);
  end
  vdifn(i,j)=vdifn(i,j)+u;
end, end 