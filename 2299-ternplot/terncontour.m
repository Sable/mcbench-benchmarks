% TERNCONTOUR plot contours on ternary phase diagram
%   TERNCONTOUR(A, B, Z) plots contours of Z on ternary phase diagram for three components.  C is calculated
%      as 1 - A - B. 
%
%   TERNCONTOUR(A, B, C, Z) plots contours of Z on ternary phase data for three components A B and C.  If the values 
%       are not fractions, the values are normalised by dividing by the total.
%
%   TERNPLOT(A, B, C, Z, I) the same as the above, but with a user specified contour interval (see CONTOUR
%       for specification).
%   
%   NOTES
%   - An attempt is made to keep the plot close to the default contour type.  The code has been based largely on the
%     code for TERNPLOT.
%   - The regular TITLE and LEGEND commands work with the plot from this function, as well as incrimental plotting
%     using HOLD.  Labels can be placed on the axes using TERNLABEL
%
%   See also TERNCONTOURF TERNPLOT TERNLABEL PLOT POLAR CONTOUR CONTOURF 

%       c
%      / \
%     /   \
%    a --- b 

% Author: Peter Selkin 20030507 based on TERNPLOT by Carl Sandrock 20020827

% To do
% Make TERNCONTOURF and TERNSURF

% Modifications
% 20070107 (CS) Modified to use new structure (more subroutines)

% Modifiers
% CS Carl Sandrock

function [Hcl, Hha] = terncontour(A, B, C, Z, I)
majors = 5;

if nargin < 4
    Z = C;
    C = 1 - (A+B);
end;

if nargin < 5
    I=10;
end;

[fA, fB, fC] = fractions(A, B, C);
[x, y] = terncoords(fA, fB, fC);

% Sort data points in x order
[x, i] = sort(x);
y = y(i);
Z = Z(i);

% Now we have X, Y, Z as vectors. 
% use meshgrid to generate a grid
Ngrid = 100;
xr = linspace(min(x), max(x), Ngrid);
yr = linspace(min(y), max(y), Ngrid);
[xg ,yg] = meshgrid(xr, yr);

% ...then use griddata to get a plottable array
zg = griddata(x, y, Z, xg, yg, 'cubic');

[hold_state, cax, next] = ternaxes(majors);

% plot data
[Cl, Ha] = contour(xg, yg, zg, I, 'k-');


if nargout > 0
    Hcl=Cl;
    Hha=Ha;
end

if ~hold_state
    set(gca,'dataaspectratio',[1 1 1]), axis off; set(cax,'NextPlot',next);
end
