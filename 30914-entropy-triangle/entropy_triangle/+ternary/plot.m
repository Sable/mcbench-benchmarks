function handles = plot(A, B, C, varargin)
% TERNARY.PLOT plot ternary phase diagram
%   TERNARY.PLOT(A, B) plots ternary phase diagram for three components.  C is calculated
%      as 1 - A - B.
%
%   TERNARY.PLOT(A, B, C) plots ternary phase data for three components A B and C.  If the values 
%       are not fractions, the values are normalised by dividing by the total.
%
%   TERNARY.PLOT(A, B, C, LINETYPE) the same as the above, but with a user specified LINETYPE (see PLOT
%       for valid linetypes).
% 
%   h = TERNARY.PLOT(...) returns handles to the axes issued from the plot.
%
%   NOTES
%   - An attempt is made to keep the plot close to the default plot type.  The code has been based largely on the
%     code for POLAR and TERNPLOT, although inverting the increasing value
%     direction.
%   - The regular TITLE and LEGEND commands work with the plot from this function, as well as incrimental plotting
%     using HOLD.  Labels can be placed on the axes using TERNARY.LABEL
%
%   See also TERNARY.LABEL PLOT POLAR

%       b
%      / \
%     /   \
%    c --- a 

% Author: Carl Sandrock 20020827
% Modifications: Francisco Valverde 20091123
majors = 5;

if nargin < 3
    C = 1 - (A+B);
end;

%[fA, fB, fC] = fractions(A, B, C);
Total = (A+B+C);
fA = A./Total;
fB = B./Total;
fC = 1-(fA+fB);

[x, y] = ternary.coords(fA, fB, fC);

% Sort data points in x order
[x, i] = sort(x);
y = y(i);

% Make ternary axes and query their state
[hold_state, cax, next] = ternary.axes(majors,'fraction');

% plot data and get the axes if any
q = plot(x, y, varargin{:});
if nargout > 0
    handles = q;
end
if ~hold_state
    set(gca,'dataaspectratio',[1 1 1]), axis off; set(cax,'NextPlot',next);
end
return%handles
