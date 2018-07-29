function interactive_move(varargin)
%
%function interactive_move(tag)
%
%Click and drag curves interactively
%Automatically select the pointed curve
%
%- Focus on figure first
%- Enable with interactive_move
%- Click outside of axes (gray area) to disable
%- Press x or y while draging to constraint x or y movements
%
%Copyright J.P. Rueff, Aout 2004, modified Juin 2005

% set(gca,'XLimMode','manual','YLimMode','manual');

%---handle initialization
handles = guidata(gca);
handles.macro_active=0;
%handles.lineObj = findobj(gca, 'Type', 'line');
handles.lineObj=[findobj(gca, 'Type', 'line');findobj(gca, 'Type', 'patch')];
handles.currentlineObj=0;
handles.key='';
guidata(gca,handles);

if nargin==0,tag=1;,else tag=varargin{1};end

%---define callback routine on setup
if tag==1
%     disp('interactive_move enable')
    handles.init_state = uisuspend(gcf);guidata(gca,handles); %--save initial state

    
    set(gcf, 'windowbuttondownfcn', {@myclick,1});
    set(gcf, 'windowbuttonmotionfcn', {@myclick,2});
    set(gcf, 'windowbuttonupfcn', {@myclick,3});
    set(gcf, 'keypressfcn', {@myclick,4});
    %---define callback routine on delete
else
%      disp('interactive_move disable')
      uirestore(handles.init_state);
end

%--------function to handle event
function myclick(h,event,type)

handles=guidata(gca);

switch type
    case 1 %---Button down
        out=get(gca,'CurrentPoint');
        handles.lineObj=[findobj(gca, 'Type', 'line');findobj(gca, 'Type', 'patch')];
        set(gca,'NextPlot','replace')
        set(gcf,'Pointer','fullcrosshair');
        handles.macro_active=1;
        handles.xpos0=out(1,1);%--store initial position x
        handles.ypos0=out(1,2);%--store initial position y
        xl=get(gca,'XLim');yl=get(gca,'YLim');
        if ((handles.xpos0 > xl(1) & handles.xpos0 < xl(2)) & (handles.ypos0 > yl(1) & handles.ypos0 < yl(2))) %--disable if outside axes
            [handles.currentlineObj,handles.currentlinestyle]=line_pickup(handles.lineObj,[out(1,1) out(1,2)]);%--choose the right curve via line_pickup
            if handles.currentlineObj~=0 %--if curve foundd
                handles.xData = get(handles.lineObj(handles.currentlineObj), 'XData');%--assign x data
                handles.yData = get(handles.lineObj(handles.currentlineObj), 'YData');%--assign y data 
            end
            handles.currentTitle=get(get(gca, 'Title'), 'String');
            guidata(gca,handles)
            
            title(['[' num2str(out(1,1)) ',' num2str(out(1,2)) ']']);
        else
            interactive_move(0);
        end    
    case 2%---Button Move
        if handles.macro_active
            out=get(gca,'CurrentPoint');
            set(gcf,'Pointer','fullcrosshair');
            title(['[' num2str(out(1,1)) ',' num2str(out(1,2)) ']']);
            if handles.currentlineObj~=0
                switch handles.key
                    case ''%--if no key pressed
                        set(handles.lineObj(handles.currentlineObj),'XData',handles.xData-(handles.xpos0-out(1,1)));%-move x data
                        set(handles.lineObj(handles.currentlineObj),'YData',handles.yData-(handles.ypos0-out(1,2)));%-move y data    
                        handles.xData-(handles.xpos0-out(1,1));%-update x data
                        handles.yData-(handles.ypos0-out(1,2));%-update y data
                        title(['[' num2str(out(1,1)) ',' num2str(out(1,2)) '], offset=[' num2str(handles.xpos0-out(1,1)) ',' num2str(handles.ypos0-out(1,2)) ']']);
                    case 'x'%--if x pressed
                        set(handles.lineObj(handles.currentlineObj),'XData',handles.xData-(handles.xpos0-out(1,1)));%--move x data
                        handles.xData-(handles.xpos0-out(1,1));%-update x data
                        title(['[' num2str(out(1,1)) ',' num2str(out(1,2)) '], offset=[' num2str(handles.xpos0-out(1,1)) ',0]']);
                    case 'y'%--if y pressed
                        set(handles.lineObj(handles.currentlineObj),'YData',handles.yData-(handles.ypos0-out(1,2)));%--move y data
                        handles.yData-(handles.ypos0-out(1,2));%-updata y data
                        title(['[' num2str(out(1,1)) ',' num2str(out(1,2)) '], offset=[0,' num2str(handles.ypos0-out(1,2)) ']']);
                    case 'a'%--if a pressed, move all curves
                        for i=1:length(handles.lineObj)
                        handles.yData=get(handles.lineObj(i), 'YData');
                        set(handles.lineObj(i),'YData',handles.yData-(handles.ypos0-out(1,2)));%--move y data
                        handles.yData-(handles.ypos0-out(1,2));%-updata y data
                        title(['[' num2str(out(1,1)) ',' num2str(out(1,2)) '], offset=[0,' num2str(handles.ypos0-out(1,2)) ']']);
                        end
                end              
            end
            
            guidata(gca,handles)
        end
        
    case 3 %----Button up (cleanup some variable)
        set(gcf,'Pointer','arrow');
        set(gca,'NextPlot','add')
        if handles.currentlineObj~=0,set(handles.lineObj(handles.currentlineObj),'LineStyle',handles.currentlinestyle),end
        handles.macro_active=0;
        handles.key='';
        title(handles.currentTitle);
        guidata(gca,handles)
        
    case 4 %----Button press
        handles.key=get(gcf,'CurrentCharacter');
        guidata(gca,handles)
    end
    
    %---------function to pickup to pointed curve
    function [col,lstyle]=line_pickup(list_line_obj,pos)
    
    col=0;
    lstyle='-';
    
    %-define searching windows
    xl=get(gca,'XLim');
    xwin=abs(xl(1)-xl(2))/100;
    yl=get(gca,'YLim');
    ywin=abs(yl(1)-yl(2))/100;
    
    %-load all datasets
    for i=1:length(list_line_obj)
        xData{i}=get(list_line_obj(i), 'XData');
        yData{i}=get(list_line_obj(i), 'YData');
    end
    
%     %--look for matches in x and y direction
    for i=1:length(list_line_obj)
        candidate{i}=find((abs(pos(1,2)-yData{i})<ywin) & (abs(pos(1,1)-xData{i})<xwin));
    end
           
    %---find the right guy
 for i=1:length(list_line_obj)
     if ~isempty(candidate{i})
         col=i;
         lstyle=get(list_line_obj(col),'LineStyle');
         if lstyle==':'
         set(list_line_obj(col),'LineStyle','-');
         else
         set(list_line_obj(col),'LineStyle',':');
         end
     end
 end
    
