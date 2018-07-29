function DeleteCursor(varargin)
% DeleteCursor deletes a cursor created by CreateCursor
%
% Examples:
% scDeleteCursor(CursorNumber)
% scDeleteCursor(fhandle, CursorNumber)
%
% -------------------------------------------------------------------------
% Author: Malcolm Lidierth 01/07
% Copyright © The Author & King's College London 2007
% -------------------------------------------------------------------------
%
% Revisions:
%   21.08.08    return cleanly when specified cursor does not exist
%   09.03.09    improve 21.08.08 fix

if nargin==1
    fhandle=gcf;
    CursorNumber=varargin{1};
else
    fhandle=varargin{1};
    CursorNumber=varargin{2};
end
    
% Retrieve cursor info
Cursors=getappdata(fhandle, 'VerticalCursors');
% Return cleanly if there is none
if isempty(Cursors) || CursorNumber>length(Cursors) ||...
        (CursorNumber>=length(Cursors) && isempty(Cursors{CursorNumber}))
    return
end

% Delete associated lines and text
delete(Cursors{CursorNumber}.Handles);
% Empty the cell array element - can be re-used
Cursors{CursorNumber}={};
% Trim if last cell is empty
if isempty(Cursors{end})
    Cursors(end)=[];
end
% Update in application data area
setappdata(fhandle, 'VerticalCursors', Cursors);
if isempty(Cursors)
    set(fhandle, 'WindowButtonMotionFcn', []);
end

return
end