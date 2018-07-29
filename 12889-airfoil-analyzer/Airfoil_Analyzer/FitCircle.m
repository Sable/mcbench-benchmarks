function x = RofCurve(X,Y)

% X=[10 0 -8];
% Y=[0 10 0];

% Defining the three nonlinear equations to be solved (equation of circle
% passing through the 3 points)
defn1=['[ ( x(1)-' num2str(X(1)) ' )^2+( x(2)-' num2str(Y(1)) ')^2-x(3)^2 ;' ];
defn2=[  '( x(1)-' num2str(X(2)) ' )^2+( x(2)-' num2str(Y(2)) ')^2-x(3)^2 ;' ];
defn3=[  '( x(1)-' num2str(X(3)) ' )^2+( x(2)-' num2str(Y(3)) ')^2-x(3)^2 ]' ];
inlinedef=[defn1 defn2 defn3];

%Defining the inline function that will compute  the error, which has to be
%minimized
myfun=inline(inlinedef,'x');


options = optimset('Display','off','TolX',1e-10);
x0=[0;0;0];
[x,fval] = fsolve(myfun,x0,options);
x=[x(1) x(2) abs(x(3))];