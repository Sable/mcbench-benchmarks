function v=cart2curv(vcart,typeout,bcontr,bcovar)
% v=cart2curv(vcart,typeout,bcontr,bcovar) converts
% cartesian coordinate components to curvilinear
% components.
% vcart   - cartesian vector components
% typeout - 1 for contravariant output or
%           2 for covariant output
% bcontr  - contravariant base vector components
% bcovar  - covariant base vector components
% v       - vector components in either contravariant
%           or covariant form

if typeout==1, v=bcontr.'*vcart(:);  
else v=bcovar.'*vcart(:); end
v=simple(v);