function CursorWindowButtonMotionFcn(fhandle, EventData, UserFunction)
% CursorWindowButtonMotionFcn - figure motion callback to support cursors
%
% Example:
% To activate, use
% set(figurehandle, 'WindowButtonMotionFcn', {@CursorWindowButtonMotionFcn});
% This property is set automatically by CreateCursor
%
% CursorWindowButtonMotionFcn does not need to be active - if is interferes
% with graphics rendering clear the WindowButtonMotionFcn property
%
% CursorWindowButtonMotionFcn displays the cursor movement pointer when the
% cursor location is over a line object that belongs to a cursor created by
% CreateCursor. Over a cursor means within 3 pixels of it.
%
% Note: When the pointer is not over a cursor CursorWindowButtonMotionFcn
% resets the cursor to the default arrow. It will not restore the pointer
% to e.g. an hour glass.
%
% -------------------------------------------------------------------------
% Author: Malcolm Lidierth 01/07
% Copyright © The Author & King's College London 2007
% -------------------------------------------------------------------------
%
% Changes:
% 22/5/07 whichaxes now handles non-cell rect
% 30/01/08 now handles axes contained in a uipanel


% Get axes under cursor
ax=hittest(fhandle);
if ~strcmp(get(ax, 'Type'), 'axes')
    ax=ancestor(ax, 'axes');
end

if isempty(ax)
    % Not over an axes - so reset pointer & return
    % 15.11.09
    %set(fhandle, 'Pointer', 'arrow');
    return;
end

% Main code
CData=[NaN	NaN	NaN	NaN	NaN	2	2	2	2	2	NaN	NaN	NaN	NaN	NaN	NaN;...
    NaN	NaN	NaN	NaN	NaN	2	1	2	1	2	NaN	NaN	NaN	NaN	NaN	NaN;...
    NaN	NaN	NaN	NaN	NaN	2	1	2	1	2	NaN	NaN	NaN	NaN	NaN	NaN;...
    NaN	NaN	NaN	NaN	2	2	1	2	1	2	2	NaN	NaN	NaN	NaN	NaN;...
    NaN	NaN	NaN	2	1	2	1	2	1	2	1	2	NaN	NaN	NaN	NaN;...
    NaN	NaN	2	1	1	2	1	2	1	2	1	1	2	NaN	NaN	NaN;...
    NaN	2	1	1	1	1	1	2	1	1	1	1	1	2	NaN	NaN;...
    2	1	1	1	1	1	1	2	1	1	1	1	1	1	2	NaN;...
    NaN	2	1	1	1	1	1	2	1	1	1	1	1	2	NaN	NaN;...
    NaN	NaN	2	1	1	2	1	2	1	2	1	1	2	NaN	NaN	NaN;...
    NaN	NaN	NaN	2	1	2	1	2	1	2	1	2	NaN	NaN	NaN	NaN;...
    NaN	NaN	NaN	NaN	2	2	1	2	1	2	2	NaN	NaN	NaN	NaN	NaN;...
    NaN	NaN	NaN	NaN	NaN	2	1	2	1	2	NaN	NaN	NaN	NaN	NaN	NaN;...
    NaN	NaN	NaN	NaN	NaN	2	1	2	1	2	NaN	NaN	NaN	NaN	NaN	NaN;...
    NaN	NaN	NaN	NaN	NaN	2	2	2	2	2	NaN	NaN	NaN	NaN	NaN	NaN;...
    NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN	NaN];


% Get objects associated with the cursors
Cursors=getappdata(fhandle, 'VerticalCursors');
h=[];
for i=1:length(Cursors)
    if ~isempty(Cursors{i})
        h=horzcat(h,Cursors{i}.Handles);
    end
end

% Return if there are none
if isempty(h) || ~any(ishandle(h))
    return
end

% We may be in the process of deleting the objects or their parents - use
% only valid handles
h=findobj(h, 'Type', 'line', 'Tag', 'Cursor', 'Parent', ax);
h=h(ishandle(h));

% Return if there are none
if isempty(h)
    return
end


% Get the axes position in pixels
saveunits=get(ax, 'Units');
set(ax, 'Units', 'pixels');
axpos=get(ax, 'Position');
set(ax, 'Units', saveunits);

% Current point (axis units)
pos=get(ax,'CurrentPoint');
% Get the cursor positions (axis units)
CursorPos=get(h,'XData');
if iscell(CursorPos)
    CursorPos=cell2mat(CursorPos);
end

% Remove offset and scale 0 to 1
XLim=get(ax, 'XLim');
CursorPos=(CursorPos-XLim(1))/(XLim(2)-XLim(1));
pos=(pos-XLim(1))/(XLim(2)-XLim(1));
% Convert to pixels
CursorPos=CursorPos*axpos(3);
pos=pos*axpos(3);

% MATLAB selects an item when the pointer is within 5 pixels.
% Change the pointer when we are within 3 pixels
idx=find(abs(CursorPos(:,1)-pos(1))<3,1);
if ~isempty(idx)
    % Yes - activate the cursor pointer
    %setptr(fhandle,'lrdrag');
    set(fhandle,'PointerShapeCData',CData);
    set(fhandle,'Pointer','custom');
    set(fhandle, 'PointerShapeHotSpot',[8 8]);
else
    % No -
    set(fhandle, 'Pointer', 'arrow');
end



end

%----------------------------------------------------------------------

% %-------------------------------------------------------------------
% REPLACED FUNCTION
% function ax = whichaxes(pts,rect)
% %------------------------------------------------------------------
% % whichaxes determines which axes the cursor is over
% %  Example:
% %  ax=whichaxes(pts, rect)
% %  pts are the cursor coordinates 1x2
% %  rect are the coordinates for the axes positions Nx4 in the figure
% %
% % This is a modification of the pinrect function that is used in several
% % MATLAB files
%
%
% ax=0;
% if iscell(rect)
%     rect=cell2mat(rect);
% end
% rect(:,3)=rect(:,1)+rect(:,3);
% rect(:,4)=rect(:,2)+rect(:,4);
% for k=1:size(rect,1)
%     bool = (pts(1)>rect(k,1) && pts(1)<rect(k,3)) &&...
%         (pts(2)>rect(k,2) && pts(2)<rect(k,4));
%     if bool
%         ax=k;
%         return
%     end
% end
% end
% %------------------------------------------------------------------------
