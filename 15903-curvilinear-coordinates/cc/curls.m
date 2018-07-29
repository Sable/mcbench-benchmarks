function pcontr=curls(vcovar,names,bcovar,cs2,tn)
% pcontr=curls(vcovar,names,bcovar,cs2,tn)

% This function computes contravariant components
% of the curl of a vector. Output can be either
% symbolic or numeric.
% vcovar - covaraint components of a vector
% names  - string or symbolic vector containing
%          the coordinate variable names
% tn     - numeric vector of curvilinear coordinate
%          components. This parameter is omitted
%          from the argument list when symbolic
%          output is required.
% bcovar - a matrix with covariant base vector
%          components as the columns  
% cs2    - Christoffel symbols of the second kind

% pcontr - contravariant components of curl(vcovar)
% This function calls covardif and covardifn
if nargin<5
% Obtain symbolic results    
  d=covardif(vcovar,2,names,cs2); 
  f=simple(1/det(bcovar));
  pcontr=f*simple([d(3,2)-d(2,3); d(1,3)-d(3,1);...
                 d(2,1)-d(1,2)]);
else
% Obtain numerical results    
  d=covardifn(vcovar,2,names,cs2,tn); 
  f=subs(bcovar,{names(1),names(2),names(3)},...
                {tn(1),tn(2),tn(3)});  
  pcontr=double([d(3,2)-d(2,3); d(1,3)-d(3,1);...
                 d(2,1)-d(1,2)]/det(f));           
end