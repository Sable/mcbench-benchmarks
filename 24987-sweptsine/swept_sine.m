function [t, u] = swept_sine(f,cyc,res,plt)
% generate a swept sine curve
% function [t, u] = swept_sine(f,cyc,res,plt)
%
% inputs 4 - 3 optional
% f      frequency interval ([low high] (Hz)       class real
% cyc    number of cycles to cover (total)         class real      - optional
% res    number of points per cycle (resolution)   class integer   - optional
% plt    plot function (0 / 1)                     class integer   - optional
%
% outputs 2
% t      time increment vector (non-linear)        class real
% u      steering input content                    class real
%
% michael arant - Aug 7, 2009
%
% ex
%	[t u] = swept_sine([.1 5],25,25,1,0)

if nargin < 1; help swept_sine; error('Need inputs'); end
if ~exist('cyc','var'); cyc = ceil((f(2) / f(1)) / 5); end
if ~exist('res','var'); res = 50; end
if ~exist('plt','var'); plt = 0; end

% define sine cycles
a = linspace(0,pi*cyc*2,res*cyc)';
% generate sine
u = sin(a);

% time step vector (time between points)
ti = linspace(1/(res * f(1)),1/(res * f(2)),res*cyc)';
% time vector (point location in time) - scale by number of points and cycles
t = (cumsum(ti) - ti(1)) * cyc / res;

% proof of linear time reduction
% diff(diff(t(1:res:end)))

% debug plot
if plt
	figure; set(gcf,'color','w'); plot(u); grid on;
	title('Steering Input'); ylabel('Amplitude (deg)'); xlabel('Increment')
	figure; set(gcf,'color','w'); plot(t,u); grid on;
	title('Steering Input'); ylabel('Amplitude (deg)'); xlabel('Time (s)')
end
