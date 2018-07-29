function [h]=disp_console(h,m)
%
%
%

mm = get(h,'string');
mm{end+1} = m;
set(h,'string',mm);