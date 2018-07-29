function x=GetCursorLocation(varargin)
% GetCursorLocation returns the position of a cursor in x-axis units
%
% Example:
% x=GetCursorLocation(CursorNumber)
% x=GetCursorLocation(fhandle, CursorNumber)
%
% fhandle defaults to the current figure if not supplied or empty
%
% Returns x,  the x-axis position for the cursor in the figure
%
%--------------------------------------------------------------------------
% Author: Malcolm Lidierth 01/07
% Copyright © The Author & King's College London 2007
%--------------------------------------------------------------------------

switch nargin
    case 1
        fhandle=gcf;
        CursorNumber=varargin{1};
    case 2
        fhandle=varargin{1};
        CursorNumber=varargin{2};
end

Cursors=getappdata(fhandle,'VerticalCursors');
if isempty(Cursors)
    % No cursors in figure
    x=[];
    return
end

try
    %Use try/catch as the selected cursor may not exist
    pos=get(Cursors{CursorNumber}.Handles(1),'XData');
    x=pos(1);
catch %#ok<CTCH>
    x=[];
end

return
end
