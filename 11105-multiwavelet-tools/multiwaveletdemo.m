function multiwaveletdemo
% MULTIWAVELETDEMO an internal function called by MULTIDEMO
%   See also MULTIDEMO.

%   Auth: Dr. Bessam Z. Hassan
%   Date: 3-3-2004
%   Copyright 1995-2002 The MathWorks, Inc.
% $Revision: 1.0 $

h=findall(gcf);
% read the image
a=findall(h,'tag','popupmenu3');
fnum=get(a(1),'Value');
fnam={'Lena';'Saturn';'Rice';'Cameraman'};
x=imread([char(fnam(fnum)),'.tif']);
[n,m]=size(x);
N=2^round(log(n)/log(2));M=2^round(log(m)/log(2));a=x;
x=zeros(max([N,M]));
x(1:n,1:m)=a;
% check normalization
normal=0;
a=findall(h,'tag','togglebutton1');
normal=get(a(1),'Value');
y=double(x);
if normal
    y=y/max(max(y))*256;
end
% check brightness
a=findall(h,'tag','slider2');
ss=get(a(1),'Value');
a=findall(h,'tag','text7');
set(a,'String',num2str(round(ss*255)));
y=y*(10*(ss-.5)+1);
% Type of processing
a=findall(h,'tag','popupmenu1');
pr=get(a(1),'Value');
a=findall(h,'tag','popupmenu2');
tmp=get(a(1),'Value');
if tmp==2
    a=findall(h,'tag','text6');
    set(a,'HandleVisibility','on')
    if pr==1
        Y=GHM(y);
    elseif pr==2
        Y=ghmap(y);
    else
        Y=ghmap2(y);
    end
    if normal
        Y=Y/max(max(Y))*256;
    end
    Y=Y*(10*(ss-.5)+1);
    y=Y;
    a=findall(h,'tag','text6');
    set(a,'Visible','off')
end
% Display image
a=findall(h,'tag','frame1');
set(a,'Visible','off')
image(y),colormap(gray(256))