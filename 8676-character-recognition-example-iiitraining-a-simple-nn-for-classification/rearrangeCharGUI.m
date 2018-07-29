%% Rearranging CHARGUI to Make it Resizable and Dockable
% This script reverse-engineers |charGUI| and rebuilds it in a way that is
% both resizable and dockable.  It does so using |uipanel| and positioning
% with normalized units.

%% Create a New CHARGUI
% First, create a new instance of |charGUI|.
f = charGUI;

%% Cache the Major GUI Components
% Next, find the major GUI components: |axes|, |uipanel|, and |uicontrol|.
% Keeping references to these items will allow us to lay them out later.
% In the meantime, turn off their visiblity so that the steps taken below
% appear clearly in the GUI.
axs = findobj(f,'type','axes');
pans = findobj(f,'type','uipanel');
uis = findobj(f,'type','uicontrol');

set(axs,'visible','off');
set(pans,'visible','off');
set(uis,'visible','off');

%% Construct a New Layout Framework
% Use |uipanel| to create the framework for the new GUI layout.  Divide the
% space into three portions using normalized units.  The first, occupying
% the upper left-hand portion of the GUI, will contain the main axes.  The
% second, occupying the right-hand quarter of the GUI, will contain the
% every |uicontrol|.  The third, occupuying the bottom 30% of the GUI in
% the left-hand 75%, will contain the processing |axes|.
newpans = zeros(1,3);
for i = 1:3
    newpans(i) = uipanel('parent',f,'units','normalized');    
end
set(newpans(1),'position',[0 .3 .75 .7]);
set(newpans(2),'position',[.75 0 .25 1]);
set(newpans(3),'position',[0 0 .75 .3]);

%% Populate the First Panel
% By putting the main set of |axes| into a |uipanel|, it can be laid out
% relative to the panel, as opposed to the whole GUI.  Use normalized
% units to make sure that the |axes| grow when the |uipanel| grows.
% Position it starting 10% up from the bottom and 10% right from the
% left-hand side of the GUI and have it occupy 80% of the horizontal and
% vertical |uipanel| space.
set(axs(1),'parent',newpans(1),'units','normalized',...
    'position',[.1 .1 .8 .8]);
set(get(newpans(1),'children'),'visible','on');

%% Populate the Second Panel
% Parent the |uicontrol| items to the second |uipanel|.  Maintain the
% use of characters units so that each |uicontrol| will not grow and shrink
% along with the |uipanel|.  Instead, each will maintain the same size and
% placement.
set(uis,'parent',newpans(2));
newuipos = get(uis(1),'position');
newuipos(1:2) = [2 1];
set(uis(1),'position',newuipos);
newuipos = get(uis(3),'position');
newuipos(1:2) = [2 14];
set(uis(3),'position',newuipos);
newuipos(1:2) = [2 18];
set(uis(4),'position',newuipos);
newuipos(1:2) = [2 22];
set(uis(5),'position',newuipos);
newuipos(1:2) = [2 26];
set(uis(6),'position',newuipos);
newuipos(1:2) = [2 30];
set(uis(2),'position',newuipos);
newuipos(1:2) = [2 34];
set(uis(7),'position',newuipos);
set(get(newpans(2),'children'),'visible','on');

%% Populate the Third Panel
% Each processing |axes| are already contained within a |uipanel|, which
% merely needs to be positioned within one containing |uipanel|.  Again,
% use normalized units so that these will grow and shrink with the
% containing |uipanel|.
%
% Also apply normalized units and new positions to the |axes| contained in
% the subpanels.  Doing so will fill in the GUI space and allow us, as the
% GUI grows, to see more detail in the processing.
set(pans,'parent',newpans(3),'units','normalized');
set(pans(4),'position',[.01 .025 .23 .95]);
set(pans(3),'position',[.26 .025 .23 .95]);
set(pans(2),'position',[.51 .025 .23 .95]);
set(pans(1),'position',[.76 .025 .23 .95]);
set(axs(2:5),'units','normalized','position',[.05 .05 .9 .9]);
set(get(newpans(3),'children'),'visible','on');

%% Touch Up the GUI and Make it Resizable
% Put the finishing touches on the GUI.  Apply the same background colors
% that exsited before to each new |uipanel| and remove the border.  The
% |figure| can now be made resizable.  Try docking it by setting its
% |windowstyle| property!
for i = 1:3
    set(newpans(i),'backgroundcolor',get(pans(1),'backgroundcolor'),...
        'bordertype','none');
end
set(f,'resize','on');