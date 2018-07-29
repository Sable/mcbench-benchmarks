function x=mackeyglass(n,level,a,b,c,x0)
%Syntax: x=mackeyglass(n,level,a,b,c,x0)
%_______________________________________
%
% Simulation of the discretized variant of the Mackey-Glass PDE.
%    x(i+1)=x(i)+ax(i-s)/(1+x(i-s)^c)-bx(i)
%
% x is the simulated time series.
% n is the number of the simulated points.
% level is the noise standard deviation divided by the standard deviation of the
%   noise-free time series. We assume Gaussian noise with zero mean.
% a, b, c, and s are the parameter
% x0 is the initial values vector for x.
%
% Note:
% s=length(x0)
%
%
% Reference:
%
% Mackey M C, Glass L (1977): Oscillation and Chaos in Physiological
% Control Systems. Science 177: 287-289
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
    b=0.1;
else
    % b must be scalar
    if sum(size(b))>2
        error('b must be scalar.');
    end
end

if nargin<5 | isempty(c)==1
    c=10;
else
    % c must be scalar
    if sum(size(c))>2
        error('c must be scalar.');
    end
end

if nargin<6 | isempty(x0)==1
    x0=0.1*ones(17,1);
else
    % x0 must be either a scalar or a vector
    if max(size(x0))>2
        error('x0 must be either a scalar or a vector.');
    end
end

s=length(x0);
% n must be greater than or equal to s=length(x0)
if n<s
    error('n must be greater than or equal to s=length(x0).');
end


% Initialize
x(1,1)=x0(s)+a*x0(1)/(1+x0(1)^c)-b*x0(s);
for i=2:length(x0)
    x(i,1)=x(i-1)+a*x0(i)/(1+x0(i)^c)-b*x(i-1);
end

% Simulate
for i=s+1:n
    x(i,1)=x(i-1)+a*x(i-s)/(1+x(i-s)^c)-b*x(i-1);
end

% Add normal white noise
x=x+randn(n,1)*level*std(x);
