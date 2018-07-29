function x=logistic(n,level,a,x0)
%Syntax: x=logistic(n,level,a,x0)
%________________________________
%
% Simulation of the Quadratic map.
%    x'=ax(1-x)
%
% x is the simulated time series.
% n is the number of the simulated points.
% level is the noise standard deviation divided by the standard deviation of the
%   noise-free time series. We assume Gaussian noise with zero mean.
% a is the parameter.
% x0 is the initial value for x.
%
%
% Reference:
%
% May R M (1976): Simple mathematical modelswith very complicated dynamics. 
% Nature 261: 459-467
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
    % level must be a scalar
    if sum(size(level))>2
        error('level must be scalar.');
    end
    % level must be positive
    if level<0
        error('level must be positive.');
    end
end

if nargin<3 | isempty(a)==1
    a=4;
else
    % a must be scalar
    if sum(size(a))>2
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


% Initialize
x(1,1)=a*x0*(1-x0);

% Simulate
for i=2:n
    x(i,1)=a*x(i-1,1)*(1-x(i-1,1));
end

% Add normal white noise
x=x+randn(n,1)*level*std(x);
