%%%%%%%%%%Programmed by: Chi-Hang Kwan%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%Completion Date: December 13, 2012%%%%%%%%%%%%%%%%%%%
function AHA_GUI
clear all
close all

%defining the physical size of playing field
tb.fieldw = 1.0;
tb.fieldh = tb.fieldw*1.6;
%defining the size of the goal crease
tb.goalw=0.4;
tb.goalh=tb.goalw*0.6;
%defining the radii of circular objects
r_center = 0.1;
tb.r_puck = 0.05;
tb.r_mallet = 0.065;

%defining how many points are used to draw the circular objectgs
theta_draw=0:pi/50:2*pi;

%calculating the position of the rectangular objects
fieldx = tb.fieldw/2*[-1 -1 1 1 -1];
fieldy = tb.fieldh/2*[-1 1 1 -1 -1];
edgex = (tb.fieldw+0.12)/2*[-1 -1 1 1 -1]; %the edges are 0.06 m wide
edgey = (tb.fieldh+0.12)/2*[-1 1 1 -1 -1];
goaltx = (tb.goalw)/2*[-1 -1.2 1.2 1 -1]; %position for top goal area
goalty = tb.fieldh/2 + 0.06*[0 1 1 0 0];
goalbx = (tb.goalw)/2*[-1 -1.2 1.2 1 -1]; %position for bottom goal area
goalby = -tb.fieldh/2 - 0.06*[0 1 1 0 0];

%calculating the position of the circular objects
tb.geom.puckx = tb.r_puck*cos(theta_draw);
tb.geom.pucky = tb.r_puck*sin(theta_draw);
centerx = r_center*cos(theta_draw);
centery = r_center*sin(theta_draw);
tb.geom.malletx = tb.r_mallet*cos(theta_draw);
tb.geom.mallety = tb.r_mallet*sin(theta_draw);

%Defining the size of objects on screen
winw = 700;
winh = 600;
dispw = 350;
disph = dispw*(tb.fieldh+0.1)/(tb.fieldw+0.1);
hgap = 30; %horizontal gap between different objects
dispy = (winh-disph)/2;
panelw = winw-dispw-3*hgap; 
gamepanelh = 200;

%Drawing the main window
window = figure('unit','pixels','numbertitle','off','menubar','none','resize','off',...
        'position',[0 0 winw winh],'name','Air Hockey Arcade ver. 1.3');
movegui('center');

%Drawing on the game information panel
gamepanel = uipanel('unit','pixels', 'Title','Game Play','FontSize',12,...
                    'Position',[2*hgap+dispw dispy+disph-gamepanelh panelw gamepanelh]);
set(window,'color',get(gamepanel,'backgroundcolor'));

%Creating the game clock
tb.disp.gameclock = uicontrol('style','text','string','Game Time','parent',gamepanel,'units','normalized',...
                         'fontsize',12,'position',[0.2 0.75 0.6 0.2],'fontweight','bold');
tb.disp.min = uicontrol('style','text','string','0','backgroundcolor',[1 1 1],...
                         'parent',gamepanel,'units','normalized','fontname','arial',...
                         'fontsize',25,'position',[0.2 0.6 0.25 0.2],'fontweight','bold');
tb.disp.divisor = uicontrol('style','text','string',':','parent',gamepanel,'units','normalized',...
                         'fontname','arial','fontsize',25,'position',[0.45 0.6 0.1 0.2],'fontweight','bold');
tb.disp.sec = uicontrol('style','text','string','0','backgroundcolor',[1 1 1],...
                         'parent',gamepanel,'units','normalized','fontname','arial',...
                         'fontsize',25,'position',[0.55 0.6 0.25 0.2],'fontweight','bold');

%Creating the scoreboard
tb.disp.score = uicontrol('style','text','string','Score','parent',gamepanel,'units','normalized',...
                         'fontsize',12,'position',[0.2 0.3 0.6 0.2],'fontweight','bold');
tb.disp.user = uicontrol('style','text','string','0','backgroundcolor',[1 1 1],'foregroundcolor','g',...
                         'parent',gamepanel,'units','normalized','fontname','arial',...
                         'fontsize',25,'position',[0.2 0.15 0.25 0.2],'fontweight','bold');
tb.disp.comp = uicontrol('style','text','string','0','backgroundcolor',[1 1 1],'foregroundcolor','m',...
                         'parent',gamepanel,'units','normalized','fontname','arial',...
                         'fontsize',25,'position',[0.55 0.15 0.25 0.2],'fontweight','bold');

%Creating the selection interface for changing the number of goals per game
tb.disp.race = uibuttongroup('units','pixels','Position',[2*hgap+dispw dispy+disph-1.5*gamepanelh panelw gamepanelh/2],...
                             'title','Goals per Game','titleposition','centertop','fontsize',12,'selected','off',...
                             'fontweight','bold','userdata',5,'selectionchangefcn',{@callback_race,window});
tb.disp.radio1 = uicontrol('Style','Radio','String','5','units','normalized', 'position',[0.1 0 0.3 1],...
                           'parent',tb.disp.race,'fontsize',12,'tag','5');
tb.disp.radio2 = uicontrol('Style','Radio','String','10','units','normalized', 'position',[0.4 0 0.3 1],...
                           'parent',tb.disp.race,'fontsize',12,'tag','10');
tb.disp.radio3 = uicontrol('Style','Radio','String','15','units','normalized', 'position',[0.7 0 0.3 1],...
                           'parent',tb.disp.race,'fontsize',12,'tag','15');

%Creating the selection interface for changing the AI difficulty
tb.disp.ai = uibuttongroup('units','pixels','Position',[2*hgap+dispw dispy+disph-2*gamepanelh panelw gamepanelh/2],...
                           'title','AI Difficulty','titleposition','centertop','fontsize',12,'selected','off',...
                           'fontweight','bold','userdata',0,'selectionchangefcn',{@callback_ai,window});
tb.disp.radio4 = uicontrol('Style','Radio','String','Nomal','units','normalized', 'position',[0.2 0 0.3 1],...
                           'parent',tb.disp.ai,'fontsize',12,'tag','normal');
tb.disp.radio5 = uicontrol('Style','Radio','String','Difficult','units','normalized', 'position',[0.5 0 0.3 1],...
                           'parent',tb.disp.ai,'fontsize',12,'tag','difficult');
                      
%Creating the start and end game buttons
tb.disp.start = uicontrol('Style','pushbutton','unit','pixels','string','Start Game',...
                          'position',[2*hgap+dispw dispy panelw 50],'fontsize',20,...
                          'backgroundcolor',0.9*[1 1 1],'foregroundcolor',0.8*[0 1 0],...
                          'callback',{@callback_start,window} );

tb.disp.end = uicontrol  ('Style','pushbutton','unit','pixels','string','End Game',...
                          'position',[2*hgap+dispw dispy+70 panelw 50],'fontsize',20,...
                          'backgroundcolor',0.9*[1 1 1],'foregroundcolor', [1 0 0],...
                          'callback',{@callback_end,window},'enable','off','userdata',0);
                     
%Drawing the "container" which contains all the gameplay objects 
tb.container = axes('parent',window,'unit','pixels');
set(tb.container,'position',[hgap dispy dispw disph],'dataaspectratio',[1 1 1]);
hold on
%Drawing the edge around the hockey table
tb.obj.edge = fill(edgex,edgey,'b','Facecolor',[1 0.55 0.15],'parent',tb.container);
hold on
%Drawing the playing area
tb.obj.field = fill(fieldx,fieldy,'b','facecolor', [0 0 0.6],'edgecolor','none', 'parent',tb.container);
hold on
%Drawing the center circle
tb.obj.centercircle = plot(centerx, centery, 'b','color',[1 0.55 0.15],'linewidth',4, 'parent',tb.container );
hold on
%Drawing the bottom goal crease
tb.obj.creaseb = plot(tb.goalw*[-1/2 -1/2 1/2 1/2], [-tb.fieldh/2 -tb.fieldh/2+tb.goalh -tb.fieldh/2+tb.goalh -tb.fieldh/2],...
               'color',[1 0.55 0.15],'linewidth',2, 'parent',tb.container );
hold on
%Drawing the top goal crease
tb.obj.creaset = plot(tb.goalw*[-1/2 -1/2 1/2 1/2], [tb.fieldh/2 tb.fieldh/2-tb.goalh tb.fieldh/2-tb.goalh tb.fieldh/2],...
               'color',[1 0.55 0.15],'linewidth',2, 'parent',tb.container );
hold on
%Drawing the centerline
tb.obj.centerline = plot([-tb.fieldw/2 tb.fieldw/2],[0 0],'color',[1 0.55 0.15],'linewidth',4, 'parent',tb.container);
hold on
%Drawing the puck
tb.obj.puck = fill(tb.geom.puckx,tb.geom.pucky,'y', 'parent',tb.container);
hold on
%Drawing the user's mallet
tb.obj.maluser = fill(tb.geom.malletx, tb.geom.mallety-tb.fieldh/2+tb.goalh,'g', 'parent',tb.container,'userdata',[0 0]);
hold on
%Drawing the computer's mallet
tb.obj.malcomp = fill(tb.geom.malletx, tb.geom.mallety+tb.fieldh/2-tb.goalh,'m', 'parent',tb.container);
hold on
%Drawing the top goal area
tb.obj.goalt = fill(goaltx,goalty,'b','Facecolor',[0 0 0],'edgecolor', 'none', 'parent',tb.container);
hold on
%Drawing the bottom goal area
tb.obj.goalb = fill(goalbx,goalby,'b','Facecolor',[0 0 0],'edgecolor', 'none', 'parent',tb.container);

%Setting the display limits and hiding the axes
set(tb.container,'xlim',[-tb.fieldw/2-0.05 tb.fieldw/2+0.05]);
set(tb.container,'ylim',[-tb.fieldh/2-0.05 tb.fieldh/2+0.05]);
axis off;

%Calculate the conversion constants from pixels to physical size
windowpos = get(window,'position');
containerpos = get(tb.container,'position');
realx = get(tb.container,'xlim');
realy = get(tb.container,'ylim');
tb.disp.ratio = (realx(2)-realx(1))/containerpos(3);
tb.disp.totaloffset = [windowpos(1) windowpos(2)] + [containerpos(1) containerpos(2)];
tb.disp.corner = [realx(1) realy(1)];

%Creating the textbox for displaying game messages
tb.textbox = text('units', 'pixels', 'string', '', ...
               'Position',[hgap+dispw/2 dispy+disph/2]-[containerpos(1) containerpos(2)],...    
               'Horizontalalignment', 'center','FontSize',30,'color', [1 0 0],...
               'FontWeight', 'bold','verticalalignment','middle');
      
set(window,'UserData', tb); %save the completed tb structure back into the window handle

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%function to start the game%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function callback_start(src, event, window)

tb = get(window,'UserData');
%reset the game clock and scoring display
set(tb.disp.min,'string','0');
set(tb.disp.sec,'string','0');
set(tb.disp.comp,'string','0');
set(tb.disp.user,'string','0');
%get how many goals are required for a win
score = get(tb.disp.race,'userdata');
%disable unnecessary buttons and set the end state to 0
set(tb.disp.radio1,'enable','off');
set(tb.disp.radio2,'enable','off');
set(tb.disp.radio3,'enable','off');
set(tb.disp.radio4,'enable','off');
set(tb.disp.radio5,'enable','off');
set(tb.disp.start, 'enable', 'off');
set(tb.disp.end,'userdata',0); 
AHA_gameplay(window,score);%start the game

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%function to end the game%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function callback_end(src, event, window)
tb = get(window,'UserData');
set(tb.disp.end,'userdata',1); %set the end state to 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%function to change the # of goals to win a game%%%%%%%%%%%%%
function callback_race(src,event,window)
tb = get(window,'UserData');
switch get(get(tb.disp.race,'SelectedObject'),'Tag')
    case '5'
        set(tb.disp.race,'userdata',5)
    case '10'
        set(tb.disp.race,'userdata',10)
    case '15'
        set(tb.disp.race,'userdata',15)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%function to change the AI difficulty level%%%%%%%%%%%%%%%%%%%
function callback_ai(src,event,window)
tb = get(window,'UserData');
switch get(get(tb.disp.ai,'SelectedObject'),'Tag')
    case 'normal'
        set(tb.disp.ai,'userdata',0)
    case 'difficult'
        set(tb.disp.ai,'userdata',1)
end


