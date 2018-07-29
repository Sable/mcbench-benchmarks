function a=screensnap(b)
%   screensnap is a mex file to snap the screen
%   the input b is double data
%   when b=0,the snapped screen excluding the matlab window
%   else, the snapped screen including the matlab window
%    compile to use>> mex screensnap.c user32.lib gdi32.lib
%   usage:1, >>a=screensnap(0)     %exclude the matlab window
%            >>imshow(a);
%         2, >>a=screensnap(1);    %include the matlab window
%            >> imshow(a);
%   designed by darnshong 
%   chenzushang@sina.com  http://darnshong.52blog.net
%   2005-12-18