function varargout=plot4(x,y,z,c,varargin);

% PLOT4  Plot colored lines and points in 3-D space
%  
%    PLOT3(x,y,z,c), where x, y, z and c are four vectors of the same length N,
%    plots a line in 3-space through the points whose coordinates are the
%    elements of x, y and z, colored occording to the values in c. The line
%    consists of N-1 line segments.
%  
%    Various line types, plot symbols and colors may be obtained with
%    PLOT3(X,Y,Z,s) where s is a 1, 2 or 3 character string made from
%    the characters listed under the PLOT command.
%  
%    Example: A helix:
%  
%        t = 0:pi/50:4*pi;
%        plot4(sin(t),cos(t),t.^2,t,'.-');
%  
%    PLOT4 returns a column vector of handles to lineseries objects, one
%    handle per line segment.
% 
%    See also plot, plot3, line, axis, view, mesh, surf.

% author:  Christophe Lauwerys
% contact: christophe.lauwerys@gmail.com
% date:    22/03/2006

error(nargchk(4,inf,nargin))
error(nargoutchk(0,1,nargout))

x=x(:);
y=y(:);
z=z(:);
c=c(:);

% For all c that are NaN, set x to NaN to overcome plotting
idx = find(isnan(c));
x(idx) = NaN;
c(idx) = min(c);

% Interpolate colormap
cmap=colormap; % get current colormap
yy=linspace(min(c),max(c),size(cmap,1)); % Generate range of color indices that map to cmap
cm = interp1(yy,cmap,c,'linear')';

% Plot data
storeNextPlot = get(gca,'NextPlot');
set(gca,'ColorOrder',cm','NextPlot','ReplaceChildren')
h=plot3([x(1:end-1) x(2:end)]',[y(1:end-1) y(2:end)]',[z(1:end-1) z(2:end)]',varargin{:});
set(gca,'NextPlot',storeNextPlot);
if nargout==1, varargout{1}=h; end