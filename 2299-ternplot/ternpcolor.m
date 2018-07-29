% TERNPCOLOR plot pseudo color diagram on ternary axes
%   TERNPCOLOR(A, B, Z) plots surface fitted over Z on ternary phase diagram for three components.  C is calculated
%      as 1 - A - B. 
%
%   TERNPCOLOR(A, B, C, Z) plots surface of Z on ternary phase data for three components A B and C.  If the values 
%       are not fractions, the values are normalised by dividing by the total.
%   
%   NOTES
%   - An attempt is made to keep the plot close to the default trisurf type.  The code has been based largely on the
%     code for TERNPLOT.
%   - The regular TITLE and LEGEND commands work with the plot from this function, as well as incrimental plotting
%     using HOLD.  Labels can be placed on the axes using TERNLABEL
%
%   See also TERNSURF TERNCONTOUR 

% Author : Carl Sandrock 20070107

% To do: Better error checking

function ternpcolor(varargin)
ternsurf(varargin{:});
view(0, 90);