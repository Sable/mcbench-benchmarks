function movex_text(h_txt,x_pos)
%MOVEX_TEXT moves text horizontally.

% Copyright 2004-2010 The MathWorks, Inc.

FmtSpec=getappdata(get(get(h_txt,'parent'),'parent'),'FmtSpec');
msg=sprintf(FmtSpec,x_pos);
pos=get(h_txt,'position');
pos(1)=x_pos;
set(h_txt,'Position',pos,'String',msg)
