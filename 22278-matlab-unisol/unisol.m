function unisol
% UNISOL  is a logical puzzle invented by Lawrence Gould that has been
%   printed in the Sydney Morning Herald (Sydney, Australia) and Tele Sept
%   Jeux (Paris, France) since the mid 1980s. It appears in the Sydney
%   Morning Herald on Mondays, Wednesdays and Fridays.
%
%   Example
%       ---------------
%      | X | B | E | J | 27	  A=5; B=8
%      |---------------|
%      | C | D | J | G | 17
%      |---------------|
%      | G | E | F | B | 24
%      |---------------|
%      | H | A | C | F | 15
%       ---------------
%       10  23  23  27   83
%
%   Rules
%   The rules of the puzzle are:
%    * the letters A to H and J represent the numbers 1 to 9
%    * each letter may occur only once in a row or column
%    * seven letters occur twice; two occur only once
%    * one of the letters that occurs twice has been replaced with an X
%    * the sums of each row and column and the whole square are given
%    * the object is to fill in the numbers.
%   Each puzzle has a unique solution. One of the numbers that occurs twice
%   and one that occurs once are given, though the puzzles are often more
%   interesting to solve without them.
%
%   Solving Unisols
%   Things to look for:
%    * the numbers 1 to 9 add to 45, so the sum of eight letters will give
%      you the value of the ninth
%    * since seven letters occur twice and two only once the puzzle sums to
%      90 (2* 1 to 9) minus the sum of the two numbers that occur once
%    * certain sums can only be made up of certain numbers e.g. a row that
%      adds to 11 must be 1,2,3 & 5
%    * lines with three letters in common give you the difference between
%      the two other letters
%    * looking at differences between pairs of letters can give the
%      difference between letters or narrow down possible combinations
%    * try to find areas where you can combine pieces of information to
%      reduce possibilities.
%
%   Reference: http://en.wikipedia.org/wiki/Unisol
%

%   Developed by Per-Anders Ekström, 2003-2008 Facilia AB.

% TODO:
%   Spara parti
%   Ladda parti


% Initialize the board
init()

% Start a new game
newGame()

% Show timer
menuTimerChange(findobj(gcf,'tag','TimerMenu'))

% INIT
%   Initializes a new instance of the game unisol
function init()
% Create main figure
scrsz = get(0,'ScreenSize');
hFigure = figure( ...
    'Name','Unisol', ...
    'Menubar','none',...
    'NumberTitle','off', ...
    'Units','pixels', ...
    'tag','unisol', ...
    'DeleteFcn','stop(get(gcf,''UserData''));delete(get(gcf,''UserData''));delete(gcf)',...
    'Position',[(scrsz(3)-560)/2,(scrsz(4)-580)/2,560,580], ...
    'Color',[.95 .95 .95], ...
    'Colormap',[1 1 1;.93 .97 .93;1 1 .6;.6 .8 1;.6 1 .6;1 .6 .6], ...
    'Visible','on');

% Create timer object and put it in figure user data
set(hFigure,'UserData',timer('TimerFcn',@timerFunction,'Period', 1,...
    'ExecutionMode','fixedrate'));

% Create the menu
createMenu(hFigure)

% Create matrix axes
axes( ...
    'Parent',hFigure, ...
    'Units','normalized', ...
    'Clipping','on', ...
    'Position',[0.02,0.10,0.96,0.85]);
axis('square')

% Create Popups for filling in values
names = {'A','B','C','D','E','F','G','H','J','X'};
arrayfun(@(x)[...
    uicontrol('Style','text',...
    'String',names{x},...
    'BackgroundColor',[.95 .95 .95],...
    'Units','normalized',...
    'FontUnits','normalized', ...
    'FontSize',.3, ...
    'FontWeight','bold',...
    'Position',[(x-1)/10,0,1/10,0.07]);
    uicontrol('Style','popupmenu',...
    'String','|1|2|3|4|5|6|7|8|9',...
    'BackgroundColor',[.95 .95 .95],...
    'Units','normalized', ...
    'tag',names{x},...
    'Callback',@popupChange,...
    'Position',[(x-1)/10,0.0,1/10,0.04]);]...
    ,1:10,'UniformOutput',false);

FontSize = .5/6;

% Create text with numbers not used
uicontrol('Style','text',...
    'tag','nonused',...
    'String','',...
    'BackgroundColor',[.95 .95 .95],...
    'Units','normalized',...
    'FontUnits','normalized', ...
    'FontSize',1, ...
    'HorizontalAlignment','center',...
    'FontWeight','bold',...
    'Position',[0,0.97,1,0.03]);

% Create timer text
text(6,6,'',...
    'FontUnits','normalized', ...
    'FontSize',0.018, ...
    'FontName','FixedWidth',...
    'FontWeight','bold',...
    'VerticalAlignment','bottom', ...
    'HorizontalAlignment','right','tag','timerText');

% Create matrix surface
CData = zeros(6,6);
surface( ...
    zeros(size(CData)),CData, ...
    'Parent',gca, ...
    'EdgeColor',[.6 .6 .6], ...
    'FaceColor',[1 1 1], ...
    'LineWidth',1)
axis off
hold on

% Create extra lines
arrayfun(@(x)plot([1,5],[x,x],'k--','LineWidth',2,...
    'tag',['line',num2str(x-1)]),2:6)
arrayfun(@(x)plot([x,x],[2,6],'k--','LineWidth',2,...
    'tag',['line',num2str(x+5)]),1:5)

% Create text fields with characters
arrayfun(@(x)[text( ...
    'Position',[mod(x-1,4)+1,6-ceil(x/4)]+.5, ...
    'String','', ...
    'FontUnits','normalized', ...
    'FontSize',FontSize, ...
    'tag',num2str(x), ...
    'HorizontalAlignment','center'), ...
    text( ...
    'Position',[mod(x-1,4)+1.35,5.65-ceil(x/4)]+.5, ...
    'String','', ...
    'FontUnits','normalized', ...
    'FontSize',FontSize/3, ...
    'tag',['user',num2str(x)], ...
    'HorizontalAlignment','center')], ...
    1:16,'UniformOutput',false);

% Create text fields with column values
arrayfun(@(x)[text( ...
    'Position',[mod(x-1,4)+1.5,1.5], ...
    'String','', ...
    'Color',[.3,.3,.3],...
    'FontUnits','normalized', ...
    'FontSize',FontSize, ...
    'tag',['sumColumn',num2str(x)], ...
    'HorizontalAlignment','center'),...
    text( ...
    'Position',[mod(x-1,4)+1.9,1.1], ...
    'String','', ...
    'Color',[1,.3,.3],...
    'FontUnits','normalized', ...
    'FontSize',FontSize/3, ...
    'tag',['partialSumColumn',num2str(x)], ...
    'HorizontalAlignment','center')], ...
    1:4,'UniformOutput',false);

% Create text fields with row values
arrayfun(@(x)[text( ...
    'Position',[5.5,6.5-x], ...
    'String','', ...
    'Color',[.3,.3,.3],...
    'FontUnits','normalized', ...
    'FontSize',FontSize, ...
    'tag',['sumRow',num2str(x)], ...
    'HorizontalAlignment','center'),...
    text( ...
    'Position',[5.9,6.1-x], ...
    'String','', ...
    'Color',[1,.3,.3],...
    'FontUnits','normalized', ...
    'FontSize',FontSize/3, ...
    'tag',['partialSumRow',num2str(x)], ...
    'HorizontalAlignment','center')], ...
    1:4,'UniformOutput',false);

% Create text field with total sum value
text( ...
    'Position',[5.5,1.5], ...
    'String','', ...
    'Color',[.3,.3,.3],...
    'FontUnits','normalized', ...
    'FontSize',FontSize, ...
    'tag','sumTotal', ...
    'HorizontalAlignment','center');
text( ...
    'Position',[5.9,1.1], ...
    'String','', ...
    'Color',[1,.3,.3],...
    'FontUnits','normalized', ...
    'FontSize',FontSize/3, ...
    'tag','partialSumTotal', ...
    'HorizontalAlignment','center');

% CREATEMENU
%   Creates the menu
function createMenu(hFigure)
% File Menu
FileMenu = uimenu(hFigure,'Label','File');
uimenu(FileMenu,'Label','New Game','Accelerator','N','Callback',@newGame);
uimenu(FileMenu,'Label','New Game (no givens)','Callback',{@newGame,1});
uimenu(FileMenu,'Label','Open...','Accelerator','O','Callback',@loadGame);
uimenu(FileMenu,'Label','Save As...','Separator','on','Callback',@saveGame);
uimenu(FileMenu,'Label','Exit','Accelerator','Q','Separator','on',...
    'Callback','delete(gcf)');

% Color Menu
ColorMenu = uimenu(hFigure,'Label','Color');

xColorMenu = uimenu(ColorMenu,'Label','X','tag','xColorMenu');
uimenu(xColorMenu,'Label','Black','Callback',@colorChange,'tag','k')
uimenu(xColorMenu,'Label','Red','Callback',@colorChange,'tag','r')
uimenu(xColorMenu,'Label','Green','Callback',@colorChange,'tag','g')
uimenu(xColorMenu,'Label','Blue','Callback',@colorChange,'tag','b')
uimenu(xColorMenu,'Label','Cyan','Callback',@colorChange,'tag','c')
uimenu(xColorMenu,'Label','Magenta','Callback',@colorChange,'tag','m',...
    'Checked','on')
uimenu(xColorMenu,'Label','Yellow','Callback',@colorChange,'tag','y')

singlesColorMenu = uimenu(ColorMenu,'Label','Singles',...
    'tag','singlesColorMenu');
uimenu(singlesColorMenu,'Label','Black','Callback',@colorChange,'tag','k')
uimenu(singlesColorMenu,'Label','Red','Callback',@colorChange,'tag','r')
uimenu(singlesColorMenu,'Label','Green','Callback',@colorChange,'tag','g')
uimenu(singlesColorMenu,'Label','Blue','Callback',@colorChange,'tag','b',...
    'Checked','on')
uimenu(singlesColorMenu,'Label','Cyan','Callback',@colorChange,'tag','c')
uimenu(singlesColorMenu,'Label','Magenta','Callback',@colorChange,'tag','m')
uimenu(singlesColorMenu,'Label','Yellow','Callback',@colorChange,'tag','y')

doublesColorMenu = uimenu(ColorMenu,'Label','Doubles',...
    'tag','doublesColorMenu');
uimenu(doublesColorMenu,'Label','Black','Callback',@colorChange,...
    'tag','k','Checked','on')
uimenu(doublesColorMenu,'Label','Red','Callback',@colorChange,'tag','r')
uimenu(doublesColorMenu,'Label','Green','Callback',@colorChange,'tag','g')
uimenu(doublesColorMenu,'Label','Blue','Callback',@colorChange,'tag','b')
uimenu(doublesColorMenu,'Label','Cyan','Callback',@colorChange,'tag','c')
uimenu(doublesColorMenu,'Label','Magenta','Callback',@colorChange,'tag','m')
uimenu(doublesColorMenu,'Label','Yellow','Callback',@colorChange,'tag','y')

% Help Menu
HelpMenu = uimenu(hFigure,'Label','Help');
uimenu(HelpMenu,'Label','Product Help',...
    'Callback',sprintf('helpwin %s',mfilename));
uimenu(HelpMenu,'Label','Show Non-Used Values','tag','nonusedmenu',...
    'Callback',@menuChoiceChane,'Separator','on');
uimenu(HelpMenu,'Label','Show User Sum','tag','usersummenu',...
    'Checked','on','Callback',@menuChoiceChane);
uimenu(HelpMenu,'Label','Show Chosen Values','tag','chosenvaluesmenu',...
    'Checked','on','Callback',@menuChoiceChane);
uimenu(HelpMenu,'Label','Show Timer','Checked','off',...
    'Callback',@menuTimerChange,'tag','TimerMenu');
uimenu(HelpMenu,'Label','About UNISOL','Callback',@about,'Separator','on');

% ABOUT
%   About popup
function about(varargin)
% Create simple icon matrix
ico = ones(13)*3;
ico(:,1:4:13) = 1; ico(1:4:13,:) = 1;
ico(2:4,2:4) = 2; ico(6:8,2:4) = 2; ico(2:4,6:8) = 2; ico(6:8,6:8) = 2;
map = [0 0 0;.5 .5 .6;1 1 1];
msgbox(sprintf([...
    'Graphical User Interface for playing Unisol.\n\n'...
    'Developed by Per-Anders Ekström, 2003-2008 Facilia AB\n'...
    'E-mail: peranders.ekstrom@facilia.se']),...
    'About UNISOL','custom',ico,map)

% NEWGAME
%   Creates a new game
function newGame(varargin)
% Generate a new game
[ud.matrix,ud.map,ud.values,ud.ind] = generateNewGame(nargin<3);
finalizeNewGame(ud)

% SAVEGAME
%   Saves game structure to file
function saveGame(varargin)
ud = get(gca,'UserData'); %#ok<NASGU>
[FileName,PathName,FilterIndex] = uiputfile( ...
    {'*.ugf','Unisol Game File (*.ugf)'}, ...
    'Save as');
switch FilterIndex
    case 1 
        save(fullfile(PathName,FileName),'ud');
end

% LOADGAME
%   Loads a previously saved game
function loadGame(varargin)
[FileName,PathName,FilterIndex] = uigetfile( ...
    {'*.ugf','Unisol Game File (*.ugf)'; }, ...
    'Pick a file');
switch FilterIndex
    case 1
        tmp = load(fullfile(PathName,FileName),'-mat');
        finalizeNewGame(tmp.ud)
end


% FINALIZENEWGAME
%   finalizes the initiation of a new game
function finalizeNewGame(ud)
names = {'A','B','C','D','E','F','G','H','J','X'};
% Update value in popup according to ud.values
arrayfun(@(x)set(findobj(gcf,'tag',names{x}),'Value',ud.values(x)+1),1:10)
% Create a cell-matrix with correct characters
ud.cellMatrix = arrayfun(@(x)names{x},ud.matrix,'UniformOutput',false);
% Put string names in cell
arrayfun(@(x)set(findobj(gca,'tag',num2str(x)), ...
    'String',ud.cellMatrix{x}),1:16)
% Update row sum text
arrayfun(@(x)set(findobj(gca,'tag',['sumRow',num2str(x)]), ...
    'String',num2str(sum(ud.map(ud.matrix(:,x))))),1:4)
% Update column sum text
arrayfun(@(x)set(findobj(gca,'tag',['sumColumn',num2str(x)]), ...
    'String',num2str(sum(ud.map(ud.matrix(x,:))))),1:4)
% Update sum of total text
set(findobj(gca,'tag','sumTotal'), ...
    'String',num2str(sum(sum(ud.map(ud.matrix)))))
% Store start time
ud.StartTime = now;
ud.EndTime = [];
% Store User Data
set(gca,'UserData',ud)
% Update the Axes
updateAxes()
% Stop and start timer to get immediate response
stop(get(gcf,'UserData'))
start(get(gcf,'UserData'))

% UPDATEAXES
%   Updates the Axes
function updateAxes()
% Obtain the User Data of the axes
ud = get(gca,'UserData');
names = {'A','B','C','D','E','F','G','H','J','X'};
% Compute value of user filled in matrix
matrix = zeros(4);
for i=find(ud.values>0)
    matrix(strmatch(names{i},ud.cellMatrix')) = ud.values(i);
end
matrixT = matrix';
% Find out if want to show chosen numbers
chosenvalues = get(findobj(gcf,'tag','chosenvaluesmenu'),'checked');
% Update chosen values shown in matrix
arrayfun(@(x)set(findobj(gca,'tag',['user',num2str(x)]), ...
    'String',num2str(matrixT(x)),'Visible',chosenvalues),find(matrixT>0))
% Make sure non-chosen values are not shown in matrix
arrayfun(@(x)set(findobj(gca,'tag',['user',num2str(x)]), ...
    'String',''),find(matrixT==0))
% Find out if want to show user sum
usersum = get(findobj(gcf,'tag','usersummenu'),'checked');
% Update help sum of partial rows
arrayfun(@(x)set(findobj(gca,'tag',['partialSumRow',num2str(x)]), ...
    'String',num2str(sum(matrix(x,:))),'Visible',usersum),1:4)
% Update help sum of partial columns
arrayfun(@(x)set(findobj(gca,'tag',['partialSumColumn',num2str(x)]), ...
    'String',num2str(sum(matrix(:,x))),'Visible',usersum),1:4)
% Update help sum of partial total
set(findobj(gca,'tag','partialSumTotal'), ...
    'String',num2str(sum(sum(matrix))),'Visible',usersum)
% Update color of X
xColor = get(findobj(gcf,'tag','xColorMenu'),'Children');
c=get(xColor(strmatch('on',get(xColor,'Checked'))),'tag');
set(findobj(gca,'tag',num2str(find(ud.matrix==10))),'Color',c)
% Update color of singles
singleColor = get(findobj(gcf,'tag','singlesColorMenu'),'Children');
c=get(singleColor(strmatch('on',get(singleColor,'Checked'))),'tag');
arrayfun(@(x)set(findobj(gca,'tag',num2str(x)),'Color',c),find(...
    ud.matrix==ud.ind(7)|ud.matrix==ud.ind(8)|ud.matrix==ud.ind(9)))
% Update color of doubles
doubleColor = get(findobj(gcf,'tag','doublesColorMenu'),'Children');
c=get(doubleColor(strmatch('on',get(doubleColor,'Checked'))),'tag');
arrayfun(@(x)set(findobj(gca,'tag',num2str(x)),'Color',c),find(...
    ud.matrix==ud.ind(1)|ud.matrix==ud.ind(2)|ud.matrix==ud.ind(3)|...
    ud.matrix==ud.ind(4)|ud.matrix==ud.ind(5)|ud.matrix==ud.ind(6)))
% Update list of non-used numbers
nonused = 1:9;
nonused(ud.values(ud.values>0)) = [];
set(findobj(gcf,'tag','nonused'),'String',num2str(nonused),...
    'Visible',get(findobj(gcf,'tag','nonusedmenu'),'checked'))
% Check if solution has been reached
if 0==(sum(0==(sum(matrix,1)'==sum(ud.map(ud.matrix),2)))+...
        sum(0==(sum(matrix,2)'==sum(ud.map(ud.matrix),1))))
    set(gcf,'Color',[.35 .95 .35])
    set(findobj(gcf,'tag','nonused'),'BackgroundColor',[.35 .95 .35])
    ud.EndTime = now;
    % Stop the timer
    stop(get(gcf,'UserData'))
    set(gca,'UserData',ud)
    % Create simple icon matrix
    ico = ones(13)*3;
    ico(:,1:4:13) = 1; ico(1:4:13,:) = 1;
    ico(2:4,2:4) = 2; ico(6:8,2:4) = 2; ico(2:4,6:8) = 2; ico(6:8,6:8) = 2;
    map = [0 0 0;.5 .5 .6;1 1 1];
    msgbox(sprintf([...
        'CONGRATULATIONS!\n\n'...
        'Start time: %s\n'...
        'End time:  %s\n\n'...
        'Elapsed time: %s'],...
        datestr(ud.StartTime,13),...
        datestr(ud.EndTime,13),...
        datestr(ud.EndTime-ud.StartTime,13)),...
        'Finished Unisol-Puzzle','custom',ico,map)
else
    set(gcf,'Color',[.95 .95 .95])
    set(findobj(gcf,'tag','nonused'),'BackgroundColor',[.95 .95 .95])
end

% MENUTIMERCHANGE
%   Switch timer visibility on/off in gui
function menuTimerChange(varargin)
if strcmp(get(varargin{1},'Checked'),'on')
    set(varargin{1},'Checked','off');
    set(findobj(gca,'tag','timerText'),'Visible','off')
else
    set(varargin{1},'Checked','on');
    set(findobj(gca,'tag','timerText'),'Visible','on')

end

% TIMERFUNCTION
%   Timer object function
function timerFunction(varargin)
ud = get(gca,'UserData');
set(findobj(gca,'tag','timerText'),'String',datestr(now-ud.StartTime,13))

% MENUCHOICECHANGE
%   A choice in menu has changed
function menuChoiceChane(varargin)
if strcmp(get(varargin{1}, 'Checked'),'on')
    set(varargin{1}, 'Checked', 'off');
else
    set(varargin{1}, 'Checked', 'on');
end
updateAxes()

% COLORCHANGE
%   Color has changed
function colorChange(varargin)
Children = get(get(varargin{1},'Parent'),'Children');
set(Children,'Checked','off');
set(varargin{1},'Checked','on');
updateAxes()

% POPUPCHANGE
%   Callback from popups
function popupChange(varargin)
% Obtain the User Data of the axes
ud = get(gca,'UserData');
names = {'A','B','C','D','E','F','G','H','J','X'};
% Find position of currently modified popup
namepos = strmatch(get(varargin{1},'tag'),names);
% Obtain its value
value = get(varargin{1},'Value')-1;
% Set its value
ud.values(namepos) = value;
% Store User Data
set(gca,'UserData',ud)
% Update the axes
updateAxes()

% GENERATENEWGAME
%   Generates a new game, if fail; recursive call
function [matrix,map,values,ind] = generateNewGame(givens)
iter = 0;
ind = randperm(9);
map = [randperm(9),0];
map(end) = map(ind(7));
matrix = zeros(4);
freepos = randperm(16);
for k=ind(1:7)
    matrix(freepos(k)) = k;
    freepos(k) = [];
end
for k=ind(1:9)
    pos = ceil(rand*length(freepos));
    [i,j]=ind2sub([4,4],freepos(pos));
    while (sum(k==matrix(:,j))+sum(k==matrix(i,:)))~=0
        if iter>10;
            [matrix,map,values,ind] = generateNewGame(givens);
            return
        end
        iter = iter+1;
        pos = ceil(rand*length(freepos));
        [i,j]=ind2sub([4,4],freepos(pos));
    end
    matrix(freepos(pos)) = k;
    freepos(pos) = [];
end
x = find(ind(7)==matrix);
matrix(x(ceil(rand*2))) = 10;
% Initially none of the numbers are given
values = zeros(1,10);
if givens % Standard difficulty we want 2 givens
    % Randomly chose given numbers
    % One from 2-fields (but not the one that is X...)
    given2Number = ind(ceil(rand*6));
    % And one from 1-fields
    given1Number = ind(ceil(rand*2)+7);
    given = [given2Number(1),given1Number(1)];
    values(given) = map(given);
end
