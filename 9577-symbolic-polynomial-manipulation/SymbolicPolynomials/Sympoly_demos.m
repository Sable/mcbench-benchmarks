% Sympoly demos

%% Various ways to create a sympoly

% A scalar (zero) sympoly
z = sympoly;

% Scalar sympolys 'x', 'y', 'u', 'v' created in the current workspace
sympoly x y u v

% A sympoly (identity matrix) array. The numeric element format is
% specified by the command window format style.
format short g
ayuh = sympoly(eye(3));

% Use deal to replicate a sympoly into several 
[a,b] = deal(sympoly);

% Deal can also create a sympoly array
S(1:2) = deal(sympoly('x'));

% As can repmat
R = repmat(sympoly('x'),2,3);

whos

%% Arithmetic between sympolys, add, subtract, multiply, divide.

% add 1 to x
1 + x

%%

% double times a sympoly
2*y

%%

% subtraction, and a simple power
(x - y)^2

%%

% More complex expressions
(x - 2*y)^3/x + sqrt(y^3)

%% Synthetic division
[quotient,remainder] = syndivide(x^2+2*x-1,x+1)

%% Arrays of sympolys
[x , y ; 1 , x+y]

%%

% Arrays of sympolys
v = [1 x y x+y]

%% matrix multiplication
A = v*v'
B = v'*v
%% Selective extraction of terms
% The second term
terms(A,2)

%%
terms(A,x^2,'extract')

%%
% Delete a term
p = (1 + x^2 + x^7)^3
terms(p,x^2,'delete')

%% Selective deletion of terms
B = terms(A,x,'extract')

%%
% Operations on arrays
sympoly lambda
(rand(3) - lambda*eye(3))

%% Even eigenvalues, using det, then roots 
roots(det(hilb(4) - lambda*eye(4)))

%% Sum on any dimension
sum(v,2)

%% And prod
prod(A(:))

%% Orthogonal polynomials from a variety of familes

% 3rd and 4th order Legendre polynomials
p3 = orthpoly(3,'legendre')
p4 = orthpoly(4,'legendre')

%% 

% Orthogonal polynomials are orthogonal over the proper domain
defint(p3*p4,'x',[-1,1])

%%

% 2nd and 5th order Jacobi polynomials
p2 = orthpoly(2,'jacobi',2,3)
p5 = orthpoly(5,'jacobi',2,3)

%% 

% Orthogonal polynomials are orthogonal over the proper domain.
% Numerical issures left this just eps shy from zero.
defint(p2*p5*(1-x)^2*(1+x)^5,'x',[-1,1])

%% Roots of the derivative of a sympoly
sort(roots(diff(orthpoly(6,'cheby2'))))

%% Error propagation through a sympoly

%  Given a unit Normal N(0,1) random variable, compute the
%  mean and variance of p(x) = 3*x + 2*x^2 - x^3
  
sympoly x
[polymean, polyvar] = polyerrorprop(3*x + 2*x^2 - x^3,'x',0,1)

%%

% Compute the mean and variance of x*y + 3*y^3, where x and y are
% respectively N(mux,sx^2), and N(muy,sy^2)

sympoly x y mux muy sx sy
[polymean,polyvar] = polyerrorprop(x*y+3*y^3,{'x' 'y'},[mux,muy],[sx,sy])

%% A simple construction for a Newton-Cotes integration rule
% Here I'll generate Simpson's 3/8 rule.
%
% <http://mathworld.wolfram.com/Simpsons38Rule.html |Simpson's 3/8 rule|>
%
M = vander(0:3);
sympoly x f0 f1 f2 f3
% an interpolating polynomial on this set of points
% { (0,f0), (1,f1), (2,f2), (3,f3) }
P_of_x = [x^3, x^2, x, 1]*pinv(M)*[f0;f1;f2;f3];

%% sympoly uses the command window format style to write out the coefficients
% Here, I'll force it to be in rational form
format rat

%%
% integrate the polynomial over its support
defint(P_of_x,'x',[0 3])

%%
% Or here, a 4 point open Newton-Cotes rule
M = vander(1:4);
sympoly x f1 f2 f3 f4
% an interpolating polynomial on this set of points
% { (1,f1), (2,f2), (3,f3) (4,f4) }
P_of_x = [x^3, x^2, x, 1]*pinv(M)*[f1;f2;f3;f4]

%%
% integrate the polynomial over the full domain of the rule
defint(P_of_x,'x',[0 5])






