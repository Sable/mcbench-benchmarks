function connect4_start
%CONNECT4_START   Connect-4 game played on a 7x7 board. Start of the game user-interface.
%
% The game is played by two players each of which can be human or computer. You can choose between 3 levels 
% corresponding to the depth of evaluation by the program. It plays far from optimal but may still be challenging to some casual players.
% For additional details see help connect4

%By Mathias Benedek 09/2011

close all;
bgcol = [0 0 .4];
figure('Units','normalized', 'Position',[.4 .4 .2 .2], 'NumberTitle','off', 'MenuBar','none', 'Name','Connect-4', 'Color',bgcol)

uicontrol('Style','text','Units','normalized','Position',[.1 .84 .35 .1],'String','Player-1','ForegroundColor',[1 0 0],'BackgroundColor',bgcol,'FontSize',12);
uicontrol('Style','popupmenu','Units','normalized','Position',[.1 .7 .35 .1],'String',{'Human','Computer'},'Value',1,'FontSize',11,'Tag','player1','Callback',{@player_select,1});
uicontrol('Style','text','Units','normalized','Position',[.55 .84 .32 .1],'String','Player-2','ForegroundColor',[1 1 0],'BackgroundColor',bgcol,'FontSize',12);
uicontrol('Style','popupmenu','Units','normalized','Position',[.55 .7 .35 .1],'String',{'Human','Computer'},'Value',2,'FontSize',11,'Tag','player2','Callback',{@player_select,2});

%Depth
%uicontrol('Style','text','Units','normalized','Position',[.4 .54 .2 .1],'String','Depth','ForegroundColor',[0 0 0],'BackgroundColor',bgcol,'FontSize',11);
uicontrol('Style','popupmenu','Units','normalized','Position',[.10 .48 .35 .08],'String',{'Level 1','Level 2','Level 3'},'Value',2,'FontSize',10,'Tag','depth1','Visible','off');
uicontrol('Style','popupmenu','Units','normalized','Position',[.55 .48 .35 .08],'String',{'Level 1','Level 2','Level 3'},'Value',2,'FontSize',10,'Tag','depth2');

uicontrol('Style','pushbutton','Units','normalized','Position',[.3 .1 .4 .15],'String','Start Game','FontSize',12,'Callback',@c4_proceed);


function c4_proceed(scr,evnt)

playerChar = {'H','C'};
depthL = [40 1600 3000];
kids = get(gcf,'Children');
idx_pl(1) = find(strcmp(get(kids,'Tag'),'player1'));
idx_pl(2) = find(strcmp(get(kids,'Tag'),'player2'));
player_setting = [playerChar{get(kids(idx_pl(1)),'Value')}, playerChar{get(kids(idx_pl(2)),'Value')}];
idx_dp(1) = find(strcmp(get(kids,'Tag'),'depth1'));
idx_dp(2) = find(strcmp(get(kids,'Tag'),'depth2'));
depth_setting = [depthL(get(kids(idx_dp(1)),'Value')), depthL(get(kids(idx_dp(2)),'Value'))];

close(gcf);

connect4(player_setting, depth_setting)


function player_select(scr, evnt, p)

kids = get(gcf,'Children');
idx_pl(1) = find(strcmp(get(kids,'Tag'),'player1'));
idx_pl(2) = find(strcmp(get(kids,'Tag'),'player2'));
idx_dp(1) = find(strcmp(get(kids,'Tag'),'depth1'));
idx_dp(2) = find(strcmp(get(kids,'Tag'),'depth2'));

if get(kids(idx_pl(p)),'Value') == 1
    set(kids(idx_dp(p)),'Visible','off');
else
    set(kids(idx_dp(p)),'Visible','on');
end