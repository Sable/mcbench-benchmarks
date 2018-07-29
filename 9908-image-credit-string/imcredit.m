function h = imcredit(s)
%IMCREDIT Display image credit string
%   H = IMCREDIT(S) displays the string S at the bottom right of the image
%   displayed in the current axes.  S is wrapped to 30 characters and
%   displayed in a light gray small font.  H is the handle of the text
%   object created by IMCREDIT.
%
%   This function assumes the typical display created using imshow: a
%   single axes containing a single image, with no axes ticks or tick
%   labels.  The credit string is placed just below the bottom edge of the
%   axes box.
%
%   Note: IMCREDIT requires LINEWRAP, which is available on the MATLAB
%   Central File Exchange.
%
%   Example
%       imshow(rand(256,256))
%       imcredit('Image courtesy of Joe and Frank Hardy, MIT, 1993')
%
%   Possible enhancements:
%   * Adjust credit string position if axes tick labels are visible
%   * Adjust text color based on figure background color
%   * Additional syntaxes, including linewrap and text property options
%
%   See also LINEWRAP.

% Steven L. Eddins
% $Revision: 1.2 $  $Date: 2006/02/07 02:39:05 $

ax_handle = gca;
x = getRight(ax_handle);
y = getBottom(ax_handle);
text_handle = text(x, y, linewrap(s, 30), ...
   'VerticalAlignment', 'top', ...
   'HorizontalAlignment', 'right', ...
   'FontSize', 7, ...
   'Color', [.5 .5 .5]);

if nargout > 0
   h = text_handle;
end

%==========================================================================
function right = getRight(ax_handle)
% right = getRight(ax_handle) returns the x-coordinate, in axes data space,
% of the right edge of the axes box.

x_limits = get(ax_handle, 'XLim');
if strcmp(get(ax_handle, 'XDir'), 'normal')
   right = x_limits(2);
else
   right = x_limits(1);
end
%--------------------------------------------------------------------------

%==========================================================================
function bottom = getBottom(ax_handle)
% bottom = getBottom(ax_handle) returns the y-coordinate, in axes data
% space, of the bottom edge of the axes box.
y_limits = get(ax_handle, 'YLim');
if strcmp(get(ax_handle, 'YDir'), 'normal')
   bottom = y_limits(1);
else
   bottom = y_limits(2);
end
%--------------------------------------------------------------------------
