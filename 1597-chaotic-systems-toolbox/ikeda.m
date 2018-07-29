function [x,y]=ikeda(n,level,mu,x0,y0)
%Syntax: [x,y]=ikeda(n,level,mu,x0,y0)
%_____________________________________
%
% Simulation of the Ikeda map.
%    x'=1+mu(xcos(t)-ysin(t)
%    y'=mu(xsin(t)+ycos(t))
%
% x and y are the simulated time series.
% n is the number of the simulated points.
% level is the noise standard deviation divided by the standard deviation of
%   the noise-free time series. We assume Gaussian noise with zero mean.
% mu is the parameter.
% x0 is the initial value for x.
% y0 is the initial value for y.
%
%
% Reference:
%
% Ikeda K (1979): Multiple-valued stationary state and its instability of the
% transmitted light by a ring cavity system. Optics Communications 30: 257
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
% 17 Nov 2001

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
    mu=0.9;
else
    % mu must be scalar
    if sum(size(mu))>2
        error('a must be scalar.');
    end
end

if nargin<4 | isempty(x0)==1
    x0=0.1;
else
    % x0 must be scalar
    if sum(size(x0))>2
        error('x0 must be scalar.');
    end
end

if nargin<5 | isempty(y0)==1
    y0=0.1;
else
    % y0 must be scalar
    if sum(size(y0))>2
        error('y0 must be scalar.');
    end
end


% Initialize
t=0.4-6/(1+x0^2+y0^2);
x(1,1)=1+mu*(x0*cos(t)-y0*sin(t));
y(1,1)=mu*(x0*sin(t)+y0*cos(t));

% Simulate
for i=2:n
    t=0.4-6/(1+x(i-1,1)^2+y(i-1,1)^2);
    x(i,1)=1+mu*(x(i-1,1)*cos(t)-y(i-1,1)*sin(t));
    y(i,1)=mu*(x(i-1,1)*sin(t)+y(i-1,1)*cos(t));
end

% Add normal white noise
x=x+randn(n,1)*level*std(x);
y=y+randn(n,1)*level*std(y);
