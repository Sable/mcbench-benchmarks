function [x,y,z]=rossler(n,level,a,b,c,x0,y0,z0,h)
%Syntax: [x,y,z]=rossler(n,level,a,b,c,x0,y0,z0,h)
%_________________________________________________
%
% Simulation of the Lorentz ODE.
%    dx/dt=-y-z
%    dy/dt=x+ay
%    dz/dt=b+z(x-c)
%
% x, y, and z are the simulated time series.
% n is the number of the simulated points.
% level is the noise standard deviation divided by the standard deviation of the
%   noise-free time series. We assume Gaussian noise with zero mean.
% a, b, and c are the parameters
% x0 is the initial value for x.
% y0 is the initial value for y.
% z0 is the initial value for z.
% h is the step size.
%
%
% Notes:
% The time is n*h.
% The integration is obtained by the Euler's method.
%
%
% Reference:
%
% Rossler O E (1976): An equation for continuous chaos. Physics Letters A 57:
% 397-398
%
%
% Alexandros Leontitsis
% Department of Education
% University of Ioannina
% 45110 - Dourouti
% Ioannina
% Greece
% 
% University e-mail: me00743@cc.uoi.gr
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421
%
% 16 Nov 2001

if nargin<1 | isempty(n)==1
    n=500;
else
    % n must be scalar
    if sum(size(n))>2
        error('n must be scalar.');
    end
    % n must be positive
    if n<0
        error('n must be positive.');
    end
    % n must be an integer
    if round(n)-n~=0
        error('n must be an integer.');
    end
end

if nargin<2 | isempty(level)==1
    level=0;
else
    % level must be scalar
    if sum(size(level))>2
        error('level must be scalar.');
    end
    % level must be positive
    if level<0
        error('level must be positive.');
    end
end

if nargin<3 | isempty(a)==1
    a=0.2;
else
    % a must be scalar
    if sum(size(a))>2
        error('a must be scalar.');
    end
end

if nargin<4 | isempty(b)==1
    b=0.4;
else
    % b must be scalar
    if sum(size(b))>2
        error('b must be scalar.');
    end
end

if nargin<5 | isempty(c)==1
    c=5.7;
else
    % c must be scalar
    if sum(size(c))>2
        error('c must be scalar.');
    end
end

if nargin<6 | isempty(x0)==1
    x0=0.1;
else
    % x0 must be scalar
    if sum(size(x0))>2
        error('x0 must be scalar.');
    end
end

if nargin<7 | isempty(x0)==1
    y0=0.1;
else
    % y0 must be scalar
    if max(size(y0))>2
        error('y0 must be scalar.');
    end
end

if nargin<8 | isempty(z0)==1
    z0=0.1;
else
    % z0 must be scalar
    if max(size(z0))>2
        error('z0 must be scalar.');
    end
end

if nargin<9 | isempty(h)==1
   h=0.1;
else
    % h must be scalar
    if max(size(h))>2
        error('h must be scalar.');
    end
    % h must be positive
    if h<0
        error('h must be positive.');
    end
end

% Initialize
y(1,:)=[x0 y0 z0];

% Simulate
for i=2:n
    ydot(1)=-y(i-1,2)-y(i-1,3);
    ydot(2)=y(i-1,1)+a*y(i-1,2);
    ydot(3)=b+y(i-1,3)*(y(i-1,1)-c);
    y(i,:)=y(i-1,:)+h*ydot;
end

% Separate the solutions
x=y(:,1);
z=y(:,3);
y=y(:,2);

% Add normal white noise
x=x+randn(n,1)*level*std(x);
y=y+randn(n,1)*level*std(y);
z=z+randn(n,1)*level*std(z);
