function d=diverge(vcontr,names,gcovar)
% d=diverge(vcontr,names,gcovar) computes
% the divergence of a vector.

% vcontr - contravariant vector components
% names  - character string or a symbolic
%          vector containing the coordinate
%          variable names
% gcovar - covariant metric tensor components
% d      - divergence of vector vcontr
if ischar(names), t=sym(['[',names,']']);
else, t=names; end 
gsq=simple(sqrt(det(gcovar))); v=gsq*vcontr;
d=diff(v(1),t(1))+diff(v(2),t(2))+diff(v(3),t(3));
d=simple(d/gsq);