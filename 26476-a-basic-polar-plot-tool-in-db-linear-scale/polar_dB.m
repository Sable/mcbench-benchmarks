% polar_dB makes plot of gdb=10*log10(g) versus phi
% phi       = polar angles over [0,2*pi]
% gain      = gain (gain is in absolute units)
% rangedb	= maximum range for the plot
% increments= increments for the gain circles
% rays      = number of rays default is 16  use series of 4
% examples: polar_dB(phi, gain);
%           polar_dB(phi, gain, 20, 2.5, 16)

% Hakan Cakmak 
% University of Duisburg-Essen,
% General and Theoretical Electrical Engineering
% hakan.cakmak@stud.uni-due.de

function h = polar_dB(phi, gain, rangedb, increments, rays)

if nargin < 5, rays = 16; end
if nargin < 4, increments = 2.5; end
if nargin < 3, rangedb = 20; end
% phi=linspace(0,2*pi,1000); % test
% gain=(sin(phi));
if nargin < 2
    warning('myApp:argChk', 'Not enough input arguments.');
    help polar_dB; 
  return;
end


gain1 = 10 * log10(abs(gain));        % test = (isinf(gain1)-1).*gain1;
gain1(gain1==-Inf) = -rangedb;        % avoids -Inf's
gain1 = gain1 .* (gain1 > -rangedb) + (-rangedb) * (gain1 <= -rangedb);      % lowest is rangedb dB
gain1 = (gain1 + rangedb)/rangedb;                                     % scale to unity max.

x = gain1 .* cos(phi);
y = gain1 .* sin(phi);

 
%R = 1.2; axis([-R, R, -R, R]);


N0 = 360;
phi0=linspace(0,2*pi,N0);
x0 = sin(phi0); % gain circles
y0 = cos(phi0); 

patch('xdata',x0,'ydata',y0, ...
     'edgecolor','black','facecolor','w');
 hold on
 
%changed coordinates
h = plot( y, x,'LineStyle','-','color','blue');  %,'LineWidth', 2
hold on 

title({'Linear Scale               ',...
  sprintf('Range:%3.2fdB           ',rangedb),...
  sprintf('Increments:%3.2fdB      ',increments)},'horizontalalignment','right');%



c_log=(-rangedb:increments:0);
c = (c_log)/-rangedb;  

for k=2:length(c_log) %gain circles
    plot(x0*c(k), y0*c(k),'LineStyle',':','color','black');
end

for k=1:length(c_log) %gain circles markers 
    text(0,c(k), sprintf('%.3g dB',c_log(length(c_log)-k+1)),...
            'horiz', 'center', 'vert', 'middle'); %,'fontsize', 13 
end

phi_s=linspace(0,2*pi,rays+1);
x_s = sin(phi_s); % rays
y_s = cos(phi_s);

for k=1:rays
    line([x_s(k)/rangedb*increments,x_s(k)],...
        [y_s(k)/rangedb*increments,y_s(k)],'LineStyle',':','color','black');
    text(1.1*x_s(k),1.1*y_s(k),...
        sprintf('%.3g°',phi_s(k)/pi*180),...
        'horiz', 'center', 'vert', 'middle'); %,'fontsize', 15 
end


axis square;
axis off


%hold off