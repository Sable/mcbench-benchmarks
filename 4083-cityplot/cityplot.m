function varargout = cityplot(Z,C)
% CITYPLOT - create cityplot of an array
% CITYPLOT(Z) uses a surface object to create a basic 'cityplot', similar to the
% plots here:
%
%   http://math.nist.gov/MatrixMarket/cityplots.html
%
% CITYPLOT(Z,C) uses the colors specified in C to set the CData of the
% surface object.
% H = CITYPLOT(...) returns the handle of the surface object.
%
% Example:
%
%  cityplot(pascal(5) + magic(5))


% Author: Steve Simon  (ssimon@mathworks.com)

if nargin < 2
    C = Z;
end

% see if C is truecolor(RGB)
CisRGB = size(C,3) == 3;

% determine size of data
[m,n] = size(Z);

new_m = 2 * (m + 1);
new_n = 2 * (n + 1);

%initialize structure vertex data
sX = repmat(kron(0:n,[1 1]),new_m,1);
sY = repmat(kron([0:m]',[1;1]),1,new_n);
sZ = [zeros(1,new_n); [zeros(new_m-2,1), kron(Z,ones(2)), zeros(new_m-2,1)]; zeros(1,new_n)];
if CisRGB
    sC(:,:,1) = [zeros(1,new_n); [zeros(new_m-2,1), kron(C(:,:,1),ones(2)), zeros(new_m-2,1)]; zeros(1,new_n)];
    sC(:,:,2) = [zeros(1,new_n); [zeros(new_m-2,1), kron(C(:,:,2),ones(2)), zeros(new_m-2,1)]; zeros(1,new_n)];
    sC(:,:,3) = [zeros(1,new_n); [zeros(new_m-2,1), kron(C(:,:,3),ones(2)), zeros(new_m-2,1)]; zeros(1,new_n)];
else
    
    sC = [zeros(1,new_n); [zeros(new_m-2,1), kron(C,ones(2)), zeros(new_m-2,1)]; zeros(1,new_n)];
end

% add NaNs
[sX,sY,sZ,sC] = addNaNs(sX,sY,sZ,sC);

% prepare figure and axes for plot
ax = newplot;
fig = get(ax,'Parent');

% create surface
h = surf(sX,sY,sZ,sC);

% set figure renderer
set(fig,'Renderer','opengl');
  
% 3D view
view(ax,3)

% add colorbar, if the C input was not RGB values
if ~CisRGB
    colorbar('peer',ax);
end

% get handles, if out put is requested
if nargout
    varargout{1} = h;
end

% --------------------------------------------------------------
function varargout = addNaNs(varargin)
% ADDNANS add NaNs to the corners of the arrays.

for n = 1:nargin
    tmp = varargin{n};
    tmp(1,1) = NaN;
    tmp(1,end) = NaN;
    tmp(end,1) = NaN;
    tmp(end,end) = NaN;
    varargout{n} = tmp;
end