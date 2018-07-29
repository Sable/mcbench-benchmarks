function vcart=curv2cart(vcurv,typein,bcontr,bcovar,t,tn)
% vcart=curv2cart(vcurv,typein,bcontr,bcovar,t,tn) 

% This function converts vector components from 
% curvilinear to cartesian components
% vcurv  - vector curvilinear coordinate components
% typein - 1 if components are contravariant
%          2 if components are covariant
% bcontr - matrix with contravariant base vector
%          components as columns
% bcovar - matrix with covariant base vector
%          components as columns
% t      - symbolic vector containing the names of the
%          curvilinear coordinate variables
% tn     - numerical vector of curvilinear coordinate
%          values. This argument is input only if 
%          numerical output is required.
% vcart  - cartesian components of the vector
if nargin>5
  vcurv=subs(vcurv,{t(1),t(2),t(3)},{tn(1),tn(2),tn(3)});  
  bcontr=subs(bcontr,{t(1),t(2),t(3)},{tn(1),tn(2),tn(3)});  
  bcovar=subs(bcovar,{t(1),t(2),t(3)},{tn(1),tn(2),tn(3)});  
  vcurv=double(vcurv); bcontr=double(bcontr);
  bcovar=double(bcovar);
end
if typein==1, vcart=bcovar*vcurv(:);
else, vcart=bcontr*vcurv(:); end 