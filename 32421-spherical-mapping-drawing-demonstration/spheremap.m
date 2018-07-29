function spheremap(status)
%SPHEREMAP - Map planar points to unit sphere
%    This function takes points drawn on x-y axis and maps them to a sphere
%    in real time.  Click and drag on the planar area to draw.
%
% Michael Hanchak, Dayton, OH, USA  2000-2011


if nargin <1
    status = 'build';
end

switch status
    case 'build'
        clf;set(gcf,'position',[100 100 500 500]);
        axes('units','normalized','position',[.05 .05 .9 .45],'xlim',[-180 180],...
            'ylim',[-90 90],'tag','plane','xtick',[-180 -135 -90 -45 0 45 90 135 180],...
            'ytick',[-90 -45 0 45 90]);hold on;grid
        line(190,0,'marker','.','linestyle','none','markersize',5,...
            'tag','lineplane','color','black');
        axes('units','normalized','position',[.05 .5 .9 .45],'xlim',[-1 1],...
            'ylim',[-1 1],'zlim',[-1 1],'tag','sphere','visible','off');hold on;
        
        axis vis3d
        [X,Y,Z] = sphere(24);
        h0 = mesh(X,Y,Z);
        set(h0,'facecolor',[1 1 1],'edgecolor',[0 0 0]);
        line(0,0,0,'marker','.','linestyle','none','markersize',5,...
            'tag','linesphere','color','black');
        view(100,30);
        set(gcf,'windowbuttondownfcn',...
            'spheremap(''mouse'');set(gcf,''windowbuttonmotionfcn'',''spheremap(''''mouse'''')'')',...
            'windowbuttonupfcn','set(gcf,''windowbuttonmotionfcn'','' '')');
        clbk = ['h = findobj(''tag'',''lineplane'');set(h,''xdata'',[],''ydata'',[]);',...
            'h = findobj(''tag'',''linesphere'');set(h,''xdata'',[],''ydata'',[],''zdata'',[]);'];
        uicontrol('style','pushbutton','units','normalized','position',[.02 .85 .1 .05],...
            'callback',clbk,'string','Clear');
        set(gcf,'toolbar','figure')
        
    case 'mouse'
        whichclick = get(gcf,'selectiontype');
        switch whichclick
            case 'normal'
                temp = get(findobj('tag','plane'),'currentpoint');
                point = temp(1,1:2)*pi/180;
                if point(1) <= pi && point(1) >= -pi && point(2) <= pi/2 &&...
                        point(2) >= -pi/2
                    
                    h = findobj('tag','lineplane');
                    x = get(h,'xdata');
                    y = get(h,'ydata');
                    set(h,'xdata',[x, point(1)*180/pi],'ydata',[y, point(2)*180/pi]);
                    
                    h = findobj('tag','linesphere');
                    x = get(h(1),'xdata');
                    y = get(h(1),'ydata');
                    z = get(h(1),'zdata');
                    set(h,'xdata',[x, cos(point(1))*cos(point(2))],...
                        'ydata',[y, sin(point(1))*cos(point(2))],...
                        'zdata',[z, sin(point(2))]);
                    
                    drawnow
                end
                
            %case 'alt'
            %    set(gcf,'windowbuttondownfcn','','windowbuttonmotionfcn','');
            %    axes(findobj('tag','sphere'));
            %    rot3d;view(100,30);
        end
        
        
end


