
% The functions polyeval and polymake were meant
% for the approximations of control matrices over
% multidimensional spaces, and their use for 
% ordinary interpolation problems is not immediate.
% 
% This example can be used for the approximation 
% or interpolations of multivariable funcions
% given their values over a set of points.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% one dimension interpolation example

% define X and then find Y=f(X)
X=1:.1:10;Y=3*X.^2;

% combinations and coefficient vector 
Nx=3;[W,V]=meshgrid(0:Nx,X);M=V.^W;
C=M\Y(:);is_it_ok=length(X)>rank(M)

% evaluation
x=.5;y=((x*ones(1,length(C))).^[0:Nx])*C;y-3*x^2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% two dimensions interpolation example

% define X and Y and then find Z=f(X,Y)
X=rand(1,10);Y=rand(1,10);Z=2*X.^2-Y.^2;

% combinations and coefficient vector
Nx=2;Ny=2;xc=polycomb(0:Nx,0:Ny);
P=[];for i=1:length(X),P=[P;prod( ([X(i);Y(i)]*ones(1,size(xc,2))).^xc )];end
C=pinv(P)*Z(:); is_it_ok=length(X)>rank(P)

% evaluation
x=-.3;y=.1;z=prod((([x;y]*ones(1,size(xc,2))).^xc))*C;z-(2*x^2-y^2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% three dimensions interpolation example

% define X, Y and Z and then find W=f(X,Y,Z)
X=rand(1,100);Y=rand(1,100);Z=rand(1,100);W=2*X.^2-Y.^2+Z;

% combinations and coefficient vector
Nx=2;Ny=2;Nz=2;xc=polycomb(0:Nx,0:Ny,0:Nz);
P=[];for i=1:length(X),P=[P;prod( ([X(i);Y(i);Z(i)]*ones(1,size(xc,2))).^xc )];end
C=pinv(P)*W(:); is_it_ok=length(X)>rank(P)

% evaluation
x=-.3;y=.1;z=1.2;w=prod( (([x;y;z]*ones(1,size(xc,2))).^xc) )*C;w-(2*x^2-y^2+z)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Note #1:
% Normally the function to be approximated is known
% only in SOME points, so in those cases X,Y,Z and W
% will just be the vectors of known values.
% 
% Note #2:
% setting Nx=Ny=length(X) assures that the final 
% polinomial will exactly cover ALL the given points
% 
% Note #3:
% if the conditions length(X) > rank(P) is not satisfied
% we have an underdetermined problem and more points (measurements)
% need to be added to solve the problem properly.
