function [h1,h2] = directedplot(x,y,d,varargin)
% DIRECTEDPLOT Plot with directions
%
%   DIRECTEDPLOT(X,Y) plots vector Y versus vector X, with arrows on 
%   alternative points. If X or Y is a matrix, then the vector is plotted
%   versus the rows or columns of the matrix,whichever line up.  
%   DIRECTEDPLOT(X,Y,N) places arrows on each N-th point, starting from the 
%   first.
%   DIRECTEDPLOT(X,Y,N,LINESPEC) uses the plot linestyle specified for the
%   plots and the arrows. See PLOT for other possibilities.
%   [H1,H2] = DIRECTEDPLOT(...) also returns the handles for the plot and
%   the arrows
%
% Example:
% x = linspace(0,2*pi,10)';
% y = [cos(x) sin(x)];
% [h1,h2] = directedplot(x,y);
% axis equal

% Mukhtar Ullah
% mukhtar.ullah@informatik.uni-rostock.de
% December 8, 2004

if nargin < 3, d = []; end
if isempty(d), d = 2; end
if isvector(y), y = y(:); end
[m,n] = size(y);
if isvector(x)
    x = x(:);
    x = x(:,ones(1,n));
end
k = 2:d:m;
x0 = x(k-1,:);
y0 = y(k-1,:);
u = x(k,:) - x0;
v = y(k,:) - y0;
h1 = plot(x,y,varargin{:}); 
hold on
h2 = quiver(x0,y0,u,v,0,varargin{:}); 
hold off 