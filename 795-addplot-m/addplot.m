function out=addplot(ax_handle,l_handle,option)
% function addplot(ax_handle,l_handle)
%
% This function allows a user to interactively vary the data stored in a line by clicking on the axes.
% The user can add datapoints to a line by clicking on the axes, and delete points from the line by use of a
% context menu.
%
% If the function is called with no input arguments, then it is applied to the output of the gca command:
%
%  * if the current axes exist and have at least one child of type 'line', then the first such child object
%    is used as the l_handle input.
%
%  * if the current axes exist but are devoid of any line objects, a line object is created with a data
%    set containing the points (0,0),(1,1)
%
%  * if no current axes exist, one is created with an empty line object child
%
% If the function is called on an axes with multiple line objects, and no l_handle specified, the first 
% line object is used.  
% 
% A further option exists to specify l_handle as a vector of two or more line objects - in this case, the 
% function determines which line the user clicked closest to, and invokes moveplot and adds data to that 
% line.  It is not recommended to use this option for more than two separate lines - beyond that point it 
% can become difficult for the program to determine which line object the user wished to indicate.
% 
% To delete a point, right-click on it and select 'delete' (the only option) from the context menu that 
% appears. 
%
% To disable the function, enter the syntax addplot(ax_handle,'off')
%
% This function requires the function 'moveplot.m'
%
% UPDATE 21 May 2002:  - fixed addplot to conform to Moveplot updates
%                      - Added output option - if output argument is specified, Addplot will output the
%                           handle of the line object(s) being adjusted.
%
% Written by Brandon Kuczenski for Kensington Labs
% brandon_kuczenski@kensingtonlabs.com
% 19 September 2001

if nargin==3 % self-invoked
    switch option
    case 1
        pos=get(gca,'currentpoint');
        xl=get(gca,'xlim');
        if pos(1,1)<xl(1) % click too far left
            return % was 'break' - thanks to patrick.drechsler@biozentrum.uni-wuerzburg.de
        else
        % how many lines?
        s=length(l_handle);
        if s>1 % if multiple, determine which is closest (cumulatively)
            for I=1:s
                x=get(l_handle(I),'Xdata')-pos(1,1);
                y=get(l_handle(I),'Ydata')-pos(2,2);
                d(I)=sum(sqrt(y.^2))/length(x); % just the y axis to determine which line
            end
        else
            d=0;
        end
        ch=l_handle(find(d==min(d))); % choose the one with the minimum average distance
        x=get(ch,'xdata');
        y=get(ch,'ydata');
        index=max(find(x<pos(1,1)));
        if index
            x=[x(1:index) pos(1,1) x(index+1:end)];
            y=[y(1:index) pos(2,2) y(index+1:end)];
        else % index must have been empty
            x=[pos(1,1) x];
            y=[pos(2,2) y];
        end
    
        k=get(ch,'userdata');  % from here down is mostly copied from moveplot
    
        k.index=index+1;
        k.axesdata=get(gca,'userdata');
        k.doublebuffer=get(gcf,'doublebuffer');
        k.winbmfcn = get(gcf,'windowbuttonmotionfcn');  %  save current window motion function
        k.winbupfcn = get(gcf,'windowbuttonupfcn');  %  save current window up function
        k.winbdfcn = get(gcf,'windowbuttondownfcn');  %  save current window down function
        set(ch,'userdata',k,'xdata',x,'ydata',y);
        set(gcf,'windowbuttonmotionfcn',['moveplot(get(gca,''userdata''),''xy'',2)'],'doublebuffer','on');
        set(gca,'userdata',ch);
        set(gcf,'windowbuttonupfcn',['moveplot(get(gca,''userdata''),''xy'',3)']);
        end     % the outside-the-box test
    case 2 % delete point selected
        pos=get(ax_handle,'currentpoint');
        x=get(l_handle,'xdata');
        y=get(l_handle,'ydata');
        d=sqrt((x-pos(1,1)).^2+(y-pos(2,2)).^2);
        index=find(d==min(d));
        x=[x(1:index-1) x(index+1:end)];
        y=[y(1:index-1) y(index+1:end)];
        set(l_handle,'xdata',x,'ydata',y);
        
    end
else % user-invoked
    if nargin<1
        ax_handle=gca;
    end
    if nargin<2
        a=findobj('parent',ax_handle','type','line');
        if ~isempty(a)
            l_handle=a(1);
        else
            l_handle=line('parent',ax_handle,'xdata',[0 1],'ydata',[0 1]);
            % other parameters are unnecessary - default
        end
    end
    if nargin==2&ischar(l_handle)&strcmp(l_handle,'off')
        % disable the function
        set(ax_handle,'ButtonDownFcn','','tag','');
        set(get(gca,'userdata'),'uicontextmenu','')
        moveplot(get(gca,'userdata'),'off'); % turn off moveplot too.
    else
        if ~strcmp(get(l_handle,'tag'),'moveplot')
            moveplot(l_handle,'xy');
        end
        set(ax_handle,'userdata',l_handle,'ButtonDownFcn','addplot(gca,get(gca,''userdata''),1)','tag','addplot');
        cmenu=uicontextmenu;
        set(l_handle,'uicontextmenu',cmenu)
        uimenu(cmenu,'Label','Delete Point','callback','addplot(gca,gco,2)');
    end
    if nargout
        out=l_handle;
    end
end
