function divrg=ndiverge(vcontr,names,bcovar,tn)
% divrg=ndiverge(vcontr,names,bcovar,tn) computes
% the divergence of a vector. the output can 
% be either symbolic or numerical. Users should
% be aware that for some coordinate systems and
% input vectors of complex form, the symbolic
% form of the divergence can be very large.

% vcontr - contravariant vector components
% names  - character string or a symbolic
%          vector containing the coordinate
%          variable names
% tn     - a numerical vector of curvilinear
%          coordinate values which is input
%          only if the output value of tn
%          is to be numerical
% bcovar - matrix of covariant base vector
%          components
% divrg  - symbolic or numerical value for the
%          divergence of vector vcontr
if ischar(names), t=sym(['[',names,']']);
else, t=names; end
bvdet=det(bcovar); v=bvdet*vcontr;
v1=diff(v(1),t(1)); v2=diff(v(2),t(2));
v3=diff(v(3),t(3)); v=[v1,v2,v3];
divrg=sum(v)/bvdet;
if nargin==4
  divrg=subs(divrg,{t(1),t(2),t(3)},{tn(1),tn(2),tn(3)});
  divrg=double(divrg); 
end