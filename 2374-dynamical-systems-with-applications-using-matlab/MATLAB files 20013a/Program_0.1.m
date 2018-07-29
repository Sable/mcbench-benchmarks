% Chapter 0 - A Tutorial Introduction to MATLAB and the Symbolic Math Package.
% Tutorial One - The Basics.
% Copyright Birkhaser 2013. Stephen Lynch.

% These commands should be run in the Command Window. If you are new to MATLAB
% copy the commands and hit ENTER at the end of each line.
% You can cut and paste the following commands into the Command Window.

clear                               % Remove items from workspace.
3^2*4-3*2^5*(4-2)                   % Simple arithmetic.
sqrt(16)                            % Square root.
u=1:2:9                             % A vector.
v=u.^2                              % Square the elements.
A=[1,2;3,4]                         % A 2x2 matrix.
A'                                  % The transpose.
det(A)                              % The determinant.
B=[0,3,1;.3,0,0;0,.5,0]             % A 3x3 matrix.
eig(B)                              % The eigenvalues of B.
[Vects,Vals]=eig(B)                 % Eigenvectors and eigenvalues.
C=[100;200;300]                     % A 3x1 matrix.
D=B*C                               % Matrix multiplication.
E=B^4                               % Powers of matrices.
z1=1+i                              % Complex numbers.
z2=1-i
z3=2+i
z4=2*z1-z2*z3                       % Complex arithmetic.
abs(z1)                             % Modulus.
real(z1)                            % Real part.
imag(z1)                            % Imaginary part.
exp(i*z1)                           % Exponential.
sym(1/2)+sym(3/4)                   % Symbolic arithmetic.
1/2+3/4                             % Double precision.
vpa(pi,50)                          % Variable precision.
syms x y z                          % Symbolic objects
z=x^3-y^3
factor(z)                           % Factorization.
expand(ans)                         % Expansion.
simplify(z/(x-y))                   % Simplification.
syms x y
[x,y]=solve('x^2-x','2*x*y-y^2')    % Solving simultaneous equations.
syms x mu
f=mu*x*(1-x)                        % Define a function.
subs(f,x,1/2)                       % Evaluate f(1/2).
fof=subs(f,x,f)                     % Composite function.
limit(x/sin(x),x,0)                 % Limits.
diff(f,x)                           % Differentiation.
syms x y
diff(x^2+3*x*y-2*y^2,y,2)           % Partial differentiation.
int(sin(x)*cos(x),x,0,pi/2)         % Integration.
int(1/x,x,0,inf)                    % Improper integration.
syms n s w
s1=symsum(1/n^2,1,inf)              % Symbolic summation.
g=exp(x)
taylor(g,'Order',10)                % Taylor series up to order 10.
syms a w
laplace(x^3)                        % Laplace transform.
ilaplace(1/(s-a))                   % Inverse transform.
fourier(exp(-x^2))                  % Fourier transform.
ifourier(pi/(1+w^2))                % Inverse transform.

% End of Tutorial One.
