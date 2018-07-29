function move_vline(handle,DoneFcn)
%MOVE_VLINE implements horizontal movement of line.
%
%  Example:
%    plot(sin(0:0.1:pi))
%    h=vline(1);
%    move_vline(h)
%
%Note: This tools strictly requires MOVEX_TEXT, and isn't much good
%      without VLINE by Brandon Kuczenski, available at MATLAB Central.
%<http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=1039&objectType=file>

% Copyright 2004-2010 The MathWorks, Inc.

% This seems to lock the axes position
set(gcf,'Nextplot','Replace')
set(gcf,'DoubleBuffer','on')

h_ax=get(handle,'parent');
h_fig=get(h_ax,'parent');
setappdata(h_fig,'h_vline',handle)
if nargin<2, DoneFcn=[]; end
setappdata(h_fig,'DoneFcn',DoneFcn)
set(handle,'ButtonDownFcn',@DownFcn)


function DownFcn(hObject,eventdata,varargin)
set(gcf,'WindowButtonMotionFcn',@MoveFcn)
set(gcf,'WindowButtonUpFcn',@UpFcn)


function UpFcn(hObject,eventdata,varargin)
set(gcf,'WindowButtonMotionFcn',[])
DoneFcn=getappdata(hObject,'DoneFcn');
if isstr(DoneFcn)
  eval(DoneFcn)
elseif isa(DoneFcn,'function_handle')
  feval(DoneFcn)
end


function MoveFcn(hObject,eventdata,varargin)
h_vline=getappdata(hObject,'h_vline');
h_ax=get(h_vline,'parent');
cp = get(h_ax,'CurrentPoint');
xpos = cp(1);
x_range=get(h_ax,'xlim');
if xpos<x_range(1), xpos=x_range(1); end
if xpos>x_range(2), xpos=x_range(2); end
XData = get(h_vline,'XData');
XData(:)=xpos;
set(h_vline,'xdata',XData)
%update text
text_obj = findobj('Type','Text','Tag','cbar_text');
movex_text(text_obj,xpos)
