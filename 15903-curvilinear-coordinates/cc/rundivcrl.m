function rundivcrl(vxyz,cordname,tn)
% rundivcrl(vxyz,cordname,tn)
% This program tests the vector operations of divergence 
% and curl in a general curvilinear coordinate system. The
% analysis process employs a symbolic vector vxyz expressed
% as a function of cartesian coordinates x,y,z. Then a 
% curvilinear coordinate system defined by function cordname
% is chosen along with a numerical vector tn to specify a
% particular set of curvilinear coordinate values for which
% the divergence and curl of vxyz are computed using both
% cartesian and curvilinear coordinates. Agreement of values
% obtained by the two methods indicates that quantities such 
% as the base vectors, metric tensors, Christoffel symbols 
% and covariant derivatives are evaluated correctly.
% vxyz      - a symbolic vector typified by the form
%             [x^2*y*z+1; x*y^2*z+2; x*y*z^2+3]
% cordname  - a function specifying the cartesian vector X=
%             [x;y;z] as a function of curvilinear coordinate
%             coordinate variables. See function cone as an
%             example.
% tn        - a numerical vector having three curvilinear
%             coordinate values for which numerical values 
%             of divergence and curl are evaluated.
%
% Among the functions provided to define cordinate systems
% are: cylin, sphr, cone, parab, oblate, elipcyl, toroid, and
% elipsod.
%
% In addition the function cordname, which is input to specify
% the coordinate system, other functions used by the program are
% crldivxyz, metric, ndiverge, curls, covardifn, and curv2cart.
% The program call list is indicated by rundivcrl(vxyz,cordname).
% If no input parameters are given, these are read interactively.

%             by Howard Wilson, July, 2007
syms x y z real
disp(' ')
disp('TEST OF DIVERGENCE AND CURL COMPUTATION IN')
disp(' CARTESIAN AND IN CURVILINEAR COORDINATES')
disp(' ')
if nargin==0
  disp('Input the cartesian components of a vector')
  disp('in symbolic form such as: x*y, y*z, z*x')
  str=input('> ?  ','s');
  vxyz=sym(['[',str,']']);
  disp(' ')
  disp('Input a function name for the coordinate system')
  disp('(such as sphr for spherical coordinates)')
  str=input('> ?  ','s');
  cordname=str2func(str);
  disp(' ')
  disp('Input curvilinear coordinate values to specify')
  disp('a position for the divergence and curl to be')
  disp('computed ( for example, typical values for')
  disp('function sphr could be 2.5,pi/3,pi/4 )')
  str=input('> ?  ','s');
  tn=eval(['[',str,']']);
elseif isstr(cordname)
  cordname=str2func(cordname);
end
vxyz=vxyz(:);
% Obtain the divergence and curl of the input
% vector expressed in cartesian form
[vdivxyz,vcrlxyz]=crldivxyz(vxyz(1),vxyz(2),vxyz(3));

% Get base vectors, metric tensor,and Christoffel
% symbols
[X,t,bco,bcn,gco,gcn,cs1,cs2]=metric(cordname); 

fprintf('Coordinate function:')
type([func2str(cordname),'.m']), disp(' ')
disp('Test vector V(x,y,z):'), disp(vxyz(:))
disp('Numerical curvilinear coordinate values:')
disp(tn(:).')

% Express the cartesian vector in terms of
% curvilinear coordinates
vxyzc=subs(vxyz,{x,y,z},{X(1),X(2),X(3)});

% Transform vcxyz to curvilinear coordinates. Get
% both covariant and contravariant components.
vcovar=simple(bco.'*vxyzc); vcontr=simple(bcn.'*vxyzc); 
%%vcovar=simple(bco'*vxyzc); vcontr=simple(bcn'*vxyzc); 

% Obtain the divergence and the curl
vdivcn=ndiverge(vcontr,t,bco,tn);
% pcontr=curls(vcovar,names,bcovar,cs2,tn) 
% gives contravariant components in numerical form
vcrlcn=curls(vcovar,t,bco,cs2,tn);  
bcon=subs(bco,{t(1),t(2),t(3)},{tn(1),tn(2),tn(3)});
detbcn=double(det(bcon));
bcnn=subs(bcn,{t(1),t(2),t(3)},{tn(1),tn(2),tn(3)});
vcrlcnxyz=curv2cart(vcrlcn,1,bcnn,bcon,t);
vcrlcnxyz=double(vcrlcnxyz);

% Make numerical evaluations using the test vector 
% in cartesian form. First evaluate the x,y,z values
% corresponding to the chosen numerical values of the
% curvilinear coordinates.  
Xn=subs(X,{t(1),t(2),t(3)},{tn(1),tn(2),tn(3)});

% Then evaluate the vector vxyz, the divergence and
% the curl at position Xn
vxyzn=subs(vxyz,{x,y,z},{Xn(1),Xn(2),Xn(3)});

% The divergence of vxyz at position Xn
vdivxyzn=subs(vdivxyz,{x,y,z},{Xn(1),Xn(2),Xn(3)});

% The curl of vxyz at position Xn 
vcrlxyzn=subs(vcrlxyz,{x,y,z},{Xn(1),Xn(2),Xn(3)});

% Print results for the chosen vector and 
% coordinate position
vcrlxyzn=vcrlxyzn(:)'; vcrlcnxyz=vcrlcnxyz(:)'; 
disp('Cartesian coordinate position for test')
disp('vector evaluation:'), disp(Xn(:).')
disp('Jacobian determinant value')
disp(detbcn)
disp('Divergence using cartesian coordinates:')
disp(vdivxyzn)
disp('Divergence using curvilinear coordinates:')
disp(vdivcn)
disp('Curl components using cartesian coordinates:')
disp(vcrlxyzn)
disp('Curl components computed in curvilinear coordinates')
disp('and then transformed back to cartesian components:')
disp(vcrlcnxyz)
disp('All Done') 