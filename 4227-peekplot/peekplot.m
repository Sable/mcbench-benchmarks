function peekplot(handle, opt, sys)
% function peekplot(handle, option)
%
% A function that allows you to peek at the values of data contained in a line object.
% It displays the x and y coordinates of the point nearest the one selected by the 
% mouse, for the duration of the time the mouse button is held down.
%
% Its argument should be a line object.  The 'option' argument allows the user to 
% control the behavior of the function or deactivate it, as follows:
% 
% If the first argument is a handle to an axes object, then the function applies 
% itself to all visible children of the axes object that are lines.
%
% Written by Brandon Kuczenski for Kensington Labs
% 15 April 2003

switch nargin
case 0
    error('Must Specify a handle to a line or axes object')
case 1
    opt='';
case 2
    if ~any(strcmp(opt,{'off','foo',''}))
        error(['Second argument ''' opt ''' is an unknown command option.'])
    end
end

if ~ishandle(handle)
    error('Must Specify a handle to a line or axes object')
end

if strcmp(get(handle,'type'),'axes')
    t=findobj(handle,'type','line');
    for I=1:length(t)
        peekplot(t(I),opt);
    end
    return
end

if nargin<3 % user-invoked
    if strcmp(opt,'off') % function being disabled
        k=getappdata(handle,'peekplot');
        if strcmp(k.marker,'none') 
            set(handle,'marker',k.marker,'markersize',k.markersize,'markerfacecolor',k.mfc);
        end
        set(handle,'buttondownfcn',k.bdfcn);
        set(gcf,'doublebuffer',k.db);
        rmappdata(handle,'peekplot');
    else
        % function being enabled
        k.marker = get(handle,'marker');
        if strcmp(k.marker,'none') 
            k.markersize=get(handle,'markersize');
            k.mfc=get(handle,'markerfacecolor');
            set(handle,'marker','.','markersize',4,'markerfacecolor',get(handle,'color'));
        end
        k.bdfcn=get(handle,'buttondownfcn');
        k.db=get(gcf,'doublebuffer');set(gcf,'doublebuffer','on');
        set(handle,'buttondownfcn',['peekplot(gco,''' opt ''',1)']);
        setappdata(handle,'peekplot',k);
    end
else %self-invoked
    switch sys
    case 1 % button down, no moveplot
        k=getappdata(handle,'peekplot');
        eval(k.bdfcn);
        xx=get(handle,'xdata');
        yy=get(handle,'ydata');
        
        cp=get(gca,'currentpoint');
        k.start=cp(1,[1,2]);

        k.index=findindex(xx, yy, k.start);
        
        k.text = placetext(xx(k.index),yy(k.index),handle);
        k.point = placepoint(xx(k.index),yy(k.index), handle);

        k.wbufcn=get(gcf,'windowbuttonupfcn');
        tag=get(handle,'tag');
        k.wbmfcn=get(gcf,'windowbuttonmotionfcn');

        if strcmp(tag,'moveplot')
            set(gcf,'windowbuttonmotionfcn',['peekplot(gco,''' opt ''',3)']);
        else
            set(gcf,'windowbuttonmotionfcn',['peekplot(gco,''' opt ''',4)']);
        end
            
        setappdata(handle,'peekplot',k);
        set(gcf,'windowbuttonupfcn',['peekplot(gco,''' opt ''',2)']);
    case 2 %windowbuttonupfcn
        k=getappdata(handle,'peekplot');
        tag=get(handle,'tag');
        set(gcf,'windowbuttonmotionfcn',k.wbmfcn);
        set(gcf,'windowbuttonupfcn',k.wbufcn);
        eval(k.wbufcn);
        delete(k.text);
        delete(k.point);
    case 3 % moveplot motion function
        k=getappdata(handle,'peekplot');
        delete(k.text);
        delete(k.point);
        eval(k.wbmfcn);
        xx=get(handle,'xdata');
        yy=get(handle,'ydata');

        next=get(gca,'nextplot');set(gca,'nextplot','add');

        k.text = placetext(xx(k.index),yy(k.index),handle);
        k.point = plot(xx(k.index),yy(k.index),'*','color',get(handle,'color'));


        setappdata(handle,'peekplot',k);
    case 4 % non-moveplot motion function
        k=getappdata(handle,'peekplot');
        delete(k.text);
        delete(k.point);
        eval(k.wbmfcn);
        xx=get(handle,'xdata');
        yy=get(handle,'ydata');
        cp=get(gca,'currentpoint');
        cp=cp(1,[1:2]);
        move=cp-k.start;

        k.text = placetext(xx(k.index),yy(k.index),handle,cp);
        k.point = placepoint(xx(k.index)+[0, move(1)],yy(k.index)+[0, move(2)], handle);

        setappdata(handle,'peekplot',k);
        
    end
end

        
%---------------------------------------------------

function a=ppround(number,precision)
% rounding function for peekplot
s=floor(log10(abs(number)));
a=floor(number*10^(precision-s))*10^(s-precision);

%---------------------------------------------------

function index=findindex(xx, yy, cp)

xlimits=get(gca,'xlim');
ylimits=get(gca,'ylim');

if strcmp(get(gca,'xscale'),'log')
    xx=log10(xx);
    cp(1)=log10(cp(1));
    xlimits=log10(xlimits);
end
if strcmp(get(gca,'yscale'),'log')
    yy=log10(yy);
    cp(2)=log10(cp(2));
    ylimits=log10(ylimits);
end

y=abs(yy-cp(2))./(abs(diff(ylimits)));x=abs(xx-cp(1))./(abs(diff(xlimits))); % determine which point the user clicked on
% just use the distance function
d=sqrt(y.^2+x.^2);
index=find(d==min(d));

%---------------------------------------------------

function text_h=placetext(xx, yy, handle, point)
% 'point' is where the mouse goes.  if it's omitted, use xx,yy

if nargin<4
    point=[xx yy];
end

xlogflag=0;ylogflag=0;

xlimits = get(gca,'xlim');
ylimits = get(gca,'ylim');

if strcmp(get(gca,'xscale'),'log')
    xlogflag=1;
    xlimits=log10(xlimits);
    point(1)=log10(point(1));
end
if strcmp(get(gca,'yscale'),'log')
    ylogflag=1;
    ylimits=log10(ylimits);
    point(2)=log10(point(2));
end

xloc = point(1)+0.02*(xlimits(2)-xlimits(1));
yloc = point(2);
ydiff = (ylimits(2)-ylimits(1));
if (abs(yloc - ylimits(1)) < 0.05*ydiff)
    yloc=ylimits(1)+0.05*ydiff;
elseif (abs(yloc - ylimits(2)) < 0.05*ydiff)
    yloc = ylimits(2)-0.05*ydiff;
end
if xloc>(mean(xlimits))
    ha='right';
    xloc = xloc - 0.04*(xlimits(2)-xlimits(1));
else
    ha='left';
end

if xlogflag
    xloc=10^xloc;
end
if ylogflag
    yloc=10^yloc;
end

text_h=text(xloc,yloc,['x=' num2str(ppround(xx,3)) ', y=' num2str(ppround(yy,3))], ...
    'color',get(handle,'color'),'horizontalalignment',ha);

%---------------------------------------------------

function point_h=placepoint(xx, yy, handle)

next=get(gca,'nextplot');set(gca,'nextplot','add');
        
xlimits = get(gca,'xlim');
ylimits = get(gca,'ylim');

xx = min(xx,xlimits(2)*ones(size(xx)));
xx = max(xx,xlimits(1)*ones(size(xx)));

yy = min(yy,ylimits(2)*ones(size(yy)));
yy = max(yy,ylimits(1)*ones(size(yy)));


point_h = plot(xx,yy,':*','color',get(handle,'color'));

set(gca,'nextplot',next);
