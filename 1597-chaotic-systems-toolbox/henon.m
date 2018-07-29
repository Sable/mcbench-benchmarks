function [x,y]=henon(n,level,a,b,x0,y0)
%Syntax: [x,y]=henon(n,level,a,b,x0,y0)
%______________________________________
%
% Simulation of the Henon map.
%    x'=1-a*x^2+y
%    y'=b*x
%
% x and y are the simulated time series.
% n is the number of the simulated points.
% level is the noise standard deviation divided by the standard deviation of the
%   noise-free time series. We assume Gaussian noise with zero mean.
% a is the a parameter.
% b is the b parameter.
% x0 is the initial value for x.
% y0 is the initial value for y.
%
%
% Reference:
%
% Henon M (1976):A two-dimensional mapping with a strange attractor. 
% Communications in Mathematical Physics 50: 69-77
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
% 5 Nov 2001

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
    a=1.4;
else
    % a must be scalar
    if sum(size(a))>2
        error('a must be scalar.');
    end
end

if nargin<4 | isempty(b)==1
    b=0.3;
else
    % b must be scalar
    if sum(size(b))>2
        error('s must be a scalar.');
    end
end

if nargin<5 | isempty(x0)==1
    x0=0.1;
else
    % x0 must be scalar
    if sum(size(x0))>2
        error('x0 must be scalar.');
    end
end

if nargin<6 | isempty(y0)==1
    y0=0.1;
else
    % y0 must be scalar
    if sum(size(y0))>2
        error('y0 must be scalar.');
    end
end

% Initialize
x(1,1)=1-a*x0^2+b*y0;
y(1,1)=b*x0;

% Simulate
for i=2:n
    x(i,1)=1-a*x(i-1,1)^2+y(i-1,1);
    y(i,1)=b*x(i-1,1);
end

% Add normal white noise
x=x+randn(n,1)*level*std(x);
y=y+randn(n,1)*level*std(y);
