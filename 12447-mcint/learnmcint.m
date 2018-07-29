function learnmcint
%LEARNMCINT See examples of how to use the integrator mcint.m
%
% written by Lee Ferchoff, 2006
% E-mail: umferch1 at cc DOT umanitoba DOT ca

% Function defintions at the bottom of the file

% =====================
% OPTIONS
% =====================

% number of points to use
n = 1e6; % more points = more accuracy. Relative error goes as 1/sqrt(n)
opt.maxArray = 1e5;
opt.noerror = 0;
%opt.tol = 2e-4;
opt.time = 60;
opt.warnOff = 0;
%opt.mcintPar = [];

% =====================
% TESTS
% =====================

% h.b -- bounding parallelpiped
% h.cond -- conditions defining the hypervolume
% h.funcs -- cell array of the functions to be integrated
%  True answers are written under most test definitions,
%  which I calculated by hand.

% integrate the identity function to get the hypervolume,
% which in this case is the length
hident.b = [0,1];
hident.cond = {};
hident.funcs = {@Id};
% answer = 1

% an example in which there are two function handles, and the second
% function handle has two rows defining two different integrands
% The pass of an optional parameter to a function to be integrated
% is also tested.
opt.mcintPar.scale = 2;
htwofuncs.b = [1,Inf]; % bounding parallelpiped
htwofuncs.cond = {}; % conditions defining the hypervolume
htwofuncs.funcs = {@exp1D @inverse1D}; % functions to be integrated
% answer(1,:) = [0.367879441 1]
% answer(2,:) = [0.067667642 0.5]

% example with multi-dimensional integration volume
h1.b = [ [0,1];[0,Inf];[-Inf,-1] ];
h1.cond = {};
h1.funcs = {@one3D};
% answer = 2/3 = 0.666666667

h2total.b = [ [0,Inf]; [0,Inf] ];
h2total.cond = {};
h2total.funcs = {@one2D};
% answer = pi/2 = 1.570796327

% integrated for outside a circle of radius 1 centered at (1,1)
% this includes the piece of the first quadrant to the upper
% right of the circle, and the little piece to the lower left of the
% circle, which is ordinarily very hard to do with a regular integrator.
% you can make whatever weird integration regions you want as long as
% you can express them as logical conditions on the coordinates like is
% done in @outcircle
h2out.b = [ [0,Inf]; [0,Inf] ];
h2out.cond = {@outcircle};
h2out.funcs = {@one2D};
% answer for h2out + answer for h2in should be answer for h2total,
% which is pi/2 = 1.570796327

% integrated for inside a circle of radius 1 centered at (1,1)
% Also an example showing how to find the hypervolume (in this case
% the area). Just integrate the identity function.
h2in.b = [ [0,2]; [0,2] ];
h2in.cond = {@incircle};
h2in.funcs = {@one2D @Id};
% answer for h2out + answer for h2in should be answer for h2total,
% which is pi/2 = 1.570796327
% The second integral should be the area of the circle, pi = 3.141592654

% A one-dimensional singular integral
hsingular1D.b = [0,1];
hsingular1D.cond = {};
hsingular1D.funcs = {@singular1D};
% answer = 2

% A one-dimensional singular integral, above but integrated OVER the
% singularity
hsingular1Do.b = [-1,1];
hsingular1Do.cond = {};
hsingular1Do.funcs = {@singular1D};
% answer = 4

% A two-dimensional singular integral
hsingular2D.b = [ [0,1]; [0,1] ];
hsingular2D.cond = {};
hsingular2D.funcs = {@singular2D};

% mcint works for any coordinate system!!!!
% just tack on the Cartesian to new coordinate
% system Jacobian in your function definition.
% Here, we integrate the volume of a sphere in
% spherical coordinates
hs.b = [ [0,1]; [0,pi]; [0,2*pi] ];
hs.cond = {};
hs.funcs = {@sphereJacobian};
% answer = 4/3*pi = 4.18879020478639

% the above example making use of jacobian.m to
% calculate the Jacobian for you, so you only have
% to integrate identity function to get volume
hsj.b = [ [0,1]; [0,pi]; [0,2*pi] ];
hsj.cond = {};
hsj.funcs = {@sphere};
% answer = 4/3*pi = 4.18879020478639

% cylindrical coordinates example
% I got this one from my Calculus textbook, which
% had the answer in the back.
hc.b = [ [1,4]; [pi/6,pi/3]; [-2,2]; ];
hc.cond = {};
hc.funcs = {@cylindricalExample};
% answer = 5/2*(-8 + 3*log(3))*log(sqrt(5)-2)
%          16.97774195316120

% the above example making use of jacobian.m to
% calculate the cylindrical coordinates Jacobian
% for you
hcj.b = [ [1,4]; [pi/6,pi/3]; [-2,2]; ];
hcj.cond = {};
hcj.funcs = {@cylindrical};
% answer = 5/2*(-8 + 3*log(3))*log(sqrt(5)-2)
%          16.97774195316120



% =====================
% INTEGRATION
% =====================
% Change the selected hypervolume in the call to mcint to change the test

tic;
% change hypervolume !!HERE!! to change test
[I,info] = mcint(h1, n, opt);
toc;
disp(info);
disp('Integral:');
I(:,:,1)
if opt.noerror==0
    disp('Error:')
    I(:,:,2)
end
%disp(['Integral: ' num2str(I(:,:,1))]);
%disp(['Error: ' num2str(I(:,:,2))]);


% =====================
% CONDITION DEFINITIONS
% =====================

function tf = outcircle(x, par)
tf = (x(1,:)-1).^2 + (x(2,:)-1).^2 >= 1;

function tf = incircle(x, par)
tf = (x(1,:)-1).^2 + (x(2,:)-1).^2 <= 1;


% =====================
% FUNCTION DEFINITIONS
% =====================

function f = Id(x, par)
f = ones( 1, size(x,2));

function f = exp1D(x, par)
f(1,:) = exp(-x(1,:));
f(2,:) = exp(-par.scale*x(1,:));

function f = inverse1D(x, par)
f(1,:) = x(1,:).^(-2);
f(2,:) = x(1,:).^(-3);

function f = one3D(x, par)
f = x(1,:).^2 .* 2.*exp(-x(2,:)) .* x(3,:).^(-2);

function f = one2D(x, par)
f = exp( -sqrt( (x(1,:).^2+x(2,:).^2) ) );

function f = singular1D(x, par)
f = abs(x(1,:)).^(-1/2);

function f = singular2D(x, par)
f = abs(x(1,:)-x(2,:)).^(-1/2);

function f = sphereJacobian(x, par)
f = x(1,:).^2 .* sin(x(2,:));

function f = sphere(x,par)
f = jacobian(x,'spherical');

function f = cylindricalExample(x, par)
% the last factor is the Jacobian
f = (tan(x(2,:))).^3 ./ sqrt( 1 + x(3,:).^2 ) .* x(1,:);

function f = cylindrical(x, par);
f = (tan(x(2,:))).^3 ./ sqrt( 1 + x(3,:).^2 ) .* jacobian(x,'cylindrical');