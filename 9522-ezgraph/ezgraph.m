function ezgraph(varargin)
%EZGRAPH Format a plot with many basic tools.
% Call as you would 'plot', with the exception that NO formatting calls are
% permitted: all formatting will be done with the GUI. 
% Example:      
%             
%             x=1:10;  y=x.^2;  z=x.^2.1;  v=1:.5:10; w=v.^2.2;
%             ezgraph(x,y,x,z,v,w)
%
% where x,y,z,w,v are all data sets.  Note that as with 'plot', the length
% of the paired vectors must be equal (length(x)==length(y)).
%
% There are 12 colors which will cycle until all data is plotted.  
%
% When all formatting is completed, click on the 'Create Figure' button to
% create a resizable figure for further manipulations.  More than one
% figure can be created by clicking the 'Create Figure' button repeatedly.
% There are three help buttons, marked with a question mark, that give more
% instructions for specific figures. 
% The user may NOT place annotations (arrows, etc.) in the axes until the  
% formatting is completed and a new figure is created.
%
% The user can easily add their own custom colors by specifying a color  
% name and an rgb value.  To do this, open the EZGRAPH M-File and look at  
% the first block of code, which is clearly marked as USER EDITABLE.  
% Follow the directions in the block.  This same method can be used to
% alter the color order used in EZGRAPH.
%
%   
% Author:    Matt Fig 
% Contact:   popkenai@yahoo.com
% Date:      12/05 (Updated 3/09)


% -------------------------------------------------------------------------
% -----------------  USER EDITABLE CUSTOM COLOR LIST  ---------------------
% To add a color, put the string name in the first cell and the rgb value
% in the second cell.  MAKE SURE that any additions are put in the same
% position of each cell!  For example:  Say you want to add a color to the
% list of choices.  Your color is called 'ALPHA' and it has an rgb value of
% [.3 .4 .5].  If you want ALPHA to appear as the third option in the
% pop-up menus, you must add the string 'ALPHA' between 'green' and 'red'
% in the cell array S.cstr, then you must add your rgb vector between 
% [0 .5 0] and [1 0 0] in the cell array S.crgb.  The color 'white' should
% be kept in last place or it will be included in the cycling during a call
% to ezplot.

S.cstr = {'blue';
          'green';
          'red';
          'cyan';
          'magenta';
          'pea soup';
          'black';
          'mid-grey';
          'brown';
          'orange';
          'hot pink';          
          'yellow';
          'white'};
S.crgb = {[0 0 1];          % blue
          [0 .5 0];         % green 
          [1 0 0];          % red
          [0 .75 .75];      % cyan
          [.75 0 .75];      % magenta
          [.75 .75 0];      % pea soup
          [.25 .25 .25];    % black
          [.5 .5 .5];       % mid-grey
          [.65 .16 .16];    % brown
          [1 .55 0];        % orange
          [1 .41 .71];      % hot pink    
          [1 1 0];          % yellow
          [1 1 1]};         % white - Keep this last on the list!
     
% ---------------  END USER EDITABLE CUSTOM COLOR LIST  -------------------
% -------------------------------------------------------------------------


if nargin==0
    error('Not enough input arguments.')  % Self explanitory.
end   
     
% Create figure and axes.
un = get(0,'units');  % We don't want to change user settings.
set(0,'units','pixels');  % Except temporarily.
SCR = get(0,'ScreenSize');  % Center the GUI.
set(0,'units',un);  % Change them back.
fpos = [(SCR(3)-580)/2 (SCR(4)-785)/2 580 785];
S.fig = figure('units','pixels','pos',fpos,'menubar','none',...
               'name','EZ-graph','resize','off','numbertitle','off');           
S.pn(1) = uipanel('units','pix','pos',[100 420 475 360],'bordertype',...
                  'line','borderwidth',2,'highlightcolor','r');         
S.ax = axes('units','pixels','nextplot','add','parent',S.pn(1));
% Check the inputs.      
if nargin==1  % Here the user passed a matrix.
   S.lines = plot(varargin{1});
elseif any(cellfun('isclass',varargin,'char'))  % Formatting not allowed.
    delete(S.fig)
    error(' Formatting not allowed.  Pass in only data pairs.')
elseif rem(nargin,2)==0 % Here the user passed data set pairs.
    S.lines = plot(varargin{1},varargin{2});  % Plot first data pair.
    for jj=2:nargin/2   % Plot rest of the data.
        S.lines(jj) = plot(varargin{2*jj-1},varargin{2*jj},'color',...
                         S.crgb{mod(jj-1,length(S.crgb)-1)+1,:});  
    end
else
    delete(S.fig)
    error('Unmatched data set, or unknown error.  See help.')
end

set(S.ax,'userdata',S.lines(1)); % Store and retrieve info about lines.
% Next create uicontrol elements, by block.
%---------------------------Y-axis editors.--------------------------------
S.pn(2) = uipanel(S.fig,'units','pix','pos',[10 445 80 325],'title',...
                  ' y-axis ','bordertype','line','borderwidth',1,...
                  'highlightcolor','r','foregroundcolor',[0 .5 0],...
                  'fontweight','bold');
S.ed(1) = uicontrol(S.fig,'style','edit','pos',[15 735  70  20],...
                 'string','y-max','backgroundcolor','w',...
                 'tooltipstring','y-max'); 
S.ck(1) = uicontrol(S.fig,'style','checkbox','pos',[15 645  60  20],...
                 'string','Log','callback',{@log_c,S,'yscale'});             
S.ed(2) = uicontrol(S.fig,'style','edit','pos',[15 615  70  20],...
                 'string','y-step','backgroundcolor','w','callback',...
                 {@step_c,S,'ylim','ytick'},'tooltipstring','y-step');             
S.ck(2) = uicontrol(S.fig,'style','checkbox','pos',[15 585  60  20],...
                 'string','Bold','callback',{@xybold_c,S});             
S.pp(1) = uicontrol(S.fig,'style','popupmenu','pos',[15 550 65 20],...
                 'string',{'Fontsize';'8';'10';'12'},'callback',...
                 {@xyfont_c,S});             
S.ed(3) = uicontrol(S.fig,'style','edit','pos',[15 455  70  20],...
                 'string','y-min','backgroundcolor','w','callback',... 
                 {@min_c,S,'ylim','ytick'},'tooltipstring','y-min');
set(S.ed(1),'callback',{@max_c,S,'ylim','ytick'});
%---------------------------X-axis editors.--------------------------------
S.pn(3) = uipanel(S.fig,'units','pix','pos',[85 370 490 45],'title',...
                  ' x-axis ','bordertype','line','borderwidth',1,...
                  'highlightcolor','r','foregroundcolor',[0 .5 0],...
                  'fontweight','bold');
S.ed(4) = uicontrol(S.fig,'style','edit','pos',[150 377 70 20],...
                 'string','x-min','backgroundcolor','w','tooltipstring',...
                 'x-min');
S.ck(3) = uicontrol(S.fig,'style','checkbox','pos',[265 377 53 20],...
                 'string','Log','callback',{@log_c,S,'xscale'});             
S.ed(5) = uicontrol(S.fig,'style','edit','pos',[355 377 70 20],...
                 'string','x-step','backgroundcolor','w','callback',...
                 {@step_c,S,'xlim','xtick'},'tooltipstring','x-step');             
S.ed(6) = uicontrol(S.fig,'style','edit','pos',[480 377 70 20],...
                 'string','x-max','backgroundcolor','w','callback',...
                 {@max_c,S,'xlim','xtick'},'tooltipstring','x-max'); 
set(S.ed(4),'callback',{@min_c,S,'xlim','xtick'});
%---------------------------Title and label editors.-----------------------
S.pn(4) = uipanel(S.fig,'units','pix','pos',[15 245 550 115],'title',...
                  ' Titles and Labels ','borderty','line','borderwid',1,...
                  'highlightcolor','r','foregroundcolor',[0 .5 0],...
                  'fontweight','bold');
S.tx(4) = uicontrol(S.fig,'style','text','pos',[45 317 55 20],...
                 'string','    Title:','fontweight','bold'); 
S.tx(5) = uicontrol(S.fig,'style','text','pos',[45 287 55 20],...
                 'string','x-label:','fontweight','bold'); 
S.tx(6) = uicontrol(S.fig,'style','text','pos',[45 257 55 20],...
                 'string','y-label:','fontweight','bold');             
S.ed(7) = uicontrol(S.fig,'style','edit','pos',[105 320 310 20],...
                 'string','Enter Title','backgroundcolor','w',...
                 'callback',{@label_c,S,'title'});
S.ck(4) = uicontrol(S.fig,'style','checkbox','pos',[425 320 50 20],...
                 'string','Bold','callback',{@bold_c,S,'title'});
S.pp(2) = uicontrol(S.fig,'style','popupmenu','pos',[485 320 70 20],...
                 'string',{'Fontsize';'8';'10';'12';'14';'16'},...
                 'callback',{@font_c,S,'title'});              
S.ed(8) = uicontrol(S.fig,'style','edit','pos',[105  290 310  20],...
                 'string','Enter x-axis label','backgroundcolor','w',...
                 'callback',{@label_c,S,'xlabel'});
S.ck(5) = uicontrol(S.fig,'style','checkbox','pos',[425 290 50 20],...
                 'string','Bold','callback',{@bold_c,S,'xlabel'} );
S.pp(3) = uicontrol(S.fig,'style','popupmenu','pos',[485 290 70 20],...
                 'string','Fontsize|8|10|12|14|16','callback',...
                 {@font_c,S,'xlabel'});              
S.ed(9) = uicontrol(S.fig,'style','edit','pos',[105 260 310 20],...
                 'string','Enter y-axis label','backgroundcolor','w',...
                 'callback',{@label_c,S,'ylabel'});
S.ck(6) = uicontrol(S.fig,'style','checkbox','pos',[425 260 50 20],...
                 'string','Bold','callback',{@bold_c,S,'ylabel'} ); 
S.pp(4) = uicontrol(S.fig,'style','popupmenu','pos',[485 260 70 20],...
                 'string',{'Fontsize';'8';'10';'12';'14';'16'},...
                 'callback',{@font_c,S,'ylabel'}); 
%---------------------------Line editors.----------------------------------
S.pn(5) = uipanel(S.fig,'units','pix','pos',[35 85 150 150],'title',...
                  ' Line Properties ','borderty','line','borderwid',1,...
                  'highlightcolor','r','foregroundcolor',[0 .5 0],...
                  'fontweight','bold');
S.ph(1) = uicontrol(S.fig,'style','pushbutton','pos',[165 210 15 15],...
                 'string','?','fontweight','bold',...
                 'backgroundcolor',[.75 .75 .75],'callback',{@hlp,1});             
S.ck(7) = uicontrol(S.fig,'style','checkbox','pos',[65 195  75  15],...
                 'string','Line On','value',1);             
S.pp(5) = uicontrol(S.fig,'style','popupmenu','pos',[65 160 90 20],...
                 'string',['Line Color';S.cstr],'callback',{@lnclr,S});
S.pp(6) = uicontrol(S.fig,'style','popupmenu','pos',[65 130 90 20],...
                 'string',{'Line Width';'0.5';'2';'3';'4'},'callback',...
                 {@lnwdth,S});              
S.pp(7) = uicontrol(S.fig,'style','popupmenu','pos',[65 100 90 20],...
                 'string',{'Line Style';'solid';'dotted';'dashdot';...
                 'dashed'},'callback',{@lnstl,S});
%---------------------------Data Marker editors.---------------------------
S.pn(6) = uipanel(S.fig,'units','pix','pos',[195  85 150 150],'title',...
                  ' Marker Properties ','borderty','line','borderwid',1,...
                  'highlightcolor','r','foregroundcolor',[0 .5 0],...
                  'fontweight','bold');
S.ph(2) = uicontrol(S.fig,'style','pushbutton','pos',[325 210 15 15],...
                 'string','?','fontweight','bold',...
                 'backgroundcolor',[.75 .75 .75],'callback',{@hlp,1});             
S.pp(8) = uicontrol(S.fig,'style','popupmenu','pos',[225 190 90 20],...
                 'string',{'Data Marker';'none';'point';'circle';...
                 'x-mark';'plus';'star';'square';'diamond';...
                 'triangle (down)';'triangle (up)';'triangle (left)';...
                 'triangle (right)';'pentagram';'hexagram'});
S.pp(9) = uicontrol(S.fig,'style','popupmenu','pos',[225 160 90 20],...
                 'string',{'Marker Size';'4';'5';'6';'9';'12'},...
                 'callback',{@mrkrsz,S});
S.pp(10) = uicontrol(S.fig,'style','popupmenu','pos',[225 130 90 20],...
                  'string',['Edge Color';S.cstr],'callback',{@edgclr,S});              
S.pp(11) = uicontrol(S.fig,'style','popupmenu','pos',[225 100 90 20],...
                  'string',['Face Color';S.cstr],'callback',{@fc_clr,S});
set(S.pp(8),'callback',{@dtmrk,S});              
set(S.ck(7),'callback',{@lnon_c,S})
set(S.lines(:),'buttondownfcn',{@st_usrdta,S});
%---------------------------Box and Grid editors.--------------------------
S.pn(7) = uipanel(S.fig,'units','pix','pos',[360 90 180 130],'title',...
                  ' Box and Grid ','borderty','line','borderwid',1,...
                  'highlightcolor','r','foregroundcolor',[0 .5 0],...
                  'fontweight','bold');
S.ck(8) = uicontrol(S.fig,'style','checkbox','positi',[425 185 75 15],...
                 'string','Box On','callback',{@bxon,S});             
S.ck(9) = uicontrol(S.fig,'style','checkbox','pos',[390 150 75 15],...
                 'string','x-Grid','callback',{@grd,S,'xgrid'});
S.ck(10) = uicontrol(S.fig,'style','checkbox','pos',[470 150 60 15],...
                 'string','y-Grid','callback',{@grd,S,'ygrid'});             
S.pp(12) = uicontrol(S.fig,'style','popupmenu','pos',[410 110 80 20],...
                 'string',{'Grid Style';'solid';'dotted';'dashdot';...
                 'dashed'},'callback',{@grdstl,S});            
%---------------------------Legend editors.--------------------------------
S.pn(8) = uipanel(S.fig,'units','pix','pos',[35 10 350 65],'title',...
                  ' Legend Maker ','borderty','line','borderwid',1,...
                  'highlightcolor','r','foregroundcolor',[0 .5 0],...
                  'fontweight','bold');
S.ph(3) = uicontrol(S.fig,'style','pushbutton','pos',[365 50 15 15],...
                 'string','?','fontweight','bold',...
                 'backgroundcolor',[.75 .75 .75],'callback',{@hlp,2});             
S.ck(11) = uicontrol(S.fig,'style','checkbox','pos',[55 33 60 15],...
                 'string','Visible','value',1);             
S.ed(10) = uicontrol(S.fig,'style','edit','pos',[120 30 225 20],...
                 'string','Enter Label for current selection.',...
                 'backgroundcolor','w','callback',...
                 {@lgstr,S});
set(S.ck(11),'callback',{@lgshow,S})
%---------------------------Create Figure button.--------------------------
S.ph(4) = uicontrol(S.fig,'style','pushbutton','positi',[435 15 130 55],...
                 'string','Create Figure','fontweight','bold',...
                 'callback',{@mkfig,S});
             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% These are callbacks that aren't matched to a particular block in GUI.
function [] = st_usrdta(varargin)
% Callback for the user clicking on the lines in the plot.
% These will set all the values in the 'Line Properties' and 'Marker
% Properties' blocks to match that of the currently selected line.
S = varargin{3};
set(S.ax,'userdata',gco);     % Store the selected line in axes 'userdata'.
lnst = get(gco,'linestyle');

if strcmp(lnst,'none')
    set(S.ck(7),'value',0);
    set(S.pp(5:7),'enable','off');    % No line=>no line color, etc.
else
    set(S.ck(7),'value',1);
    set(S.pp(5:7),'enable','on');
end

% Next set color popup to correct value.
clr = colorslct(get(gco,'color'),S);   % Get string.
clrlst = get(S.pp(5),'string');
vlu = strmatch(clr,clrlst);   % Find which color the line is.
set(S.pp(5),'value',vlu);
% Next set width popup to correct value.
wdth = get(gco,'linewidth');
wdthlst = get(S.pp(6),'string');
vlu = strmatch(num2str(wdth),wdthlst); % Find which width the line is.
set(S.pp(6),'value',vlu);
% Next set linestyle popup to correct value.
lnstl = get(gco,'linestyle');

switch lnstl
    case '-'
        vlu = 2;
    case ':'
        vlu = 3;
    case '-.'
        vlu = 4;
    case '--'
        vlu = 5;
end

set(S.pp(7),'value',vlu);
% Next set datamarker popup to correct value.
dtmrk = get(gco,'marker');

if length(dtmrk)<3
    dtmrk = mrkrslct(dtmrk);  % Get string.
end

dtmlst = get(S.pp(8),'string');
vlu = strmatch(dtmrk,dtmlst);

if vlu==2
    set(S.pp(9:11),'enable','off');
else
    set(S.pp(9:11),'enable','on');
end

set(S.pp(8),'value',vlu);
% Next set markersize popup to correct value.
mrksz = get(gco,'markersize');
mrkszlst = get(S.pp(9),'string');
vlu = strmatch(num2str(mrksz),mrkszlst);
set(S.pp(9),'value',vlu);
% Next set markeredgecolor to value.
mrkec = get(gco,'markeredgecolor');

if ~strcmp(mrkec,'auto')
    mrkec = colorslct(mrkec,S);  % Get string.
    mrkeclst = get(S.pp(10),'string');
    vlu = strmatch(mrkec,mrkeclst);  % Find which one from string array.
    set(S.pp(10),'value',vlu(1));
else
    set(S.pp(10),'value',1);
end

% Next set markerfacecolor to value.
mrkfc = get(gco,'markerfacecolor');

if ~strcmp(mrkfc,'none');
    mrkfc = colorslct(mrkfc,S);  % Get string.
    mrkfclst = get(S.pp(11),'string');
    vlu = strmatch(mrkfc,mrkfclst);
    set(S.pp(11),'value',vlu(1));
else
    set(S.pp(11),'value',1);
end


function anss = colorslct(clr,S)
% Converts a string color input to an rgb vect and an rgb vect to a string.   
if ischar(clr)  % Here a string from lst_ch1 was passed.
   idx = strmatch(clr,S.cstr);
   anss = S.crgb{idx};     
else  % Here an RGB vector from lst_ch1 was passed.
   idx = cellfun(@(x) all(eq(x,clr)),S.crgb);
   anss = S.cstr{idx}; 
end


function stl = mrkrslct(dtmrkstr)
% Converts strings to marker symbols and marker symbols to strings.
mrklst1 = {'none','point','circle','x-mark','plus','star','square',...
           'diamond','triangle (down)','triangle (up)',...
           'triangle (left)','triangle (right)','pentagram','hexagram'};
mrklst2 = {'none','.','o','x','+','*','s','d','v','^','<','>','p','h'};
              
if length(dtmrkstr)>2  % Here the symbol name was passed.
   idx = strmatch(dtmrkstr,mrklst1);
   stl = mrklst2{idx};                                  
else   % Here the marker symbol was passed.
    idx = strmatch(dtmrkstr,mrklst2);
    stl = mrklst1{idx};  
end


function [] = hlp(varargin)
% Callback for help buttons.  Issues a modal messagebox.
if varargin{3}==1  % User wants help from the Line Block.
str = ['To set Line and Marker Properties: First select a line or data',...
       ' point, then set the properties you wish for that set of data.'];
else  % User wants help from the Legend Block.
str = ['Enter the label you wish for the currently selected line or ',...
       'set of data points.  The labels can be changed after you assign'...
       ' them by reselecting the line and entering a new label.  When ',...
       'the new figure is created, you can move the legend by clicking',...
       ' on it and dragging.'];    
end

uiwait(msgbox(str,'ezgraph help','modal'));


%----------------------------Callbacks for x&y-axis blocks.----------------
function [] = max_c(varargin)
% Callback for x&y-max edit, sets the x&y-max value for plot, if legal.
[hand,S,str1,str2] = varargin{[1,3,4,5]};
old = get(S.ax,str1);
new = str2double(get(hand,'string'));

if length(new)==1  && old(1)<new  % Excludes strings and ymax < ymin.
   set(S.ax,str1,[old(1) new]);
else
    set(hand,'string',old(2))
end

if numel(S.ed)==3  % S was different sizes when given as input arg!
    edt = S.ed(2);
else
    edt = S.ed(5);
end

step_c(edt,4,S,str1,str2)


function [] = log_c(varargin)
% Callback for x&y-axis scale checkbox. Toggles between lin and log scales.
[hand,S,str] = varargin{[1,3,4]};

if get(hand,'value')
    set(S.ax,str,'log');
else
    set(S.ax,str,'linear');
end


function [] = step_c(varargin)
% Callback for x&y-step edit.  Sets the increment for the y-axis.
[hand,S,str1,str2] = varargin{[1,3,4,5]};
step = str2double(get(hand,'string'));

if isnan(step)
    ytik = get(S.ax,str2);
    step = ytik(2)-ytik(1);
    set(hand,'string',num2str(step));
end

ylim = get(S.ax,str1);

if length(step)==1  % Excludes user trying a character string.
   set(S.ax,str2,ylim(1):step:ylim(2));
end


function [] = xybold_c(varargin)
% Callback for bold checkbox.  Sets both axes to bold or normal.
[hand,S] = varargin{[1 3]};

if get(hand,'value')
    set(S.ax,'fontweight','bold');
else
    set(S.ax,'fontweight','normal');
end


function [] = xyfont_c(varargin)
% Callback for x&y-font popup.  Lets the user choose a font for both axes.
[hand,S] = varargin{[1 3]};
str = get(hand,'string');
siz = str(get(hand,'value'),:);

if ~strcmp(siz,'Fontsize')
    set(S.ax,'fontsize',str2double(siz));
end


function [] = min_c(varargin)
% Callback for x&y-min edit, sets the x&y-min value for plot, if legal.
[hand,S,str1,str2] = varargin{[1,3,4,5]};
old = get(S.ax,str1);
new = str2double(get(hand,'string'));

if length(new)==1  && old(2)>new  % Excludes strings and y-min > y-max.
   set(S.ax,str1,[new old(2)]);
else
   set(hand,'string',old(1)); 
end

if numel(S.ed)==2
    edt = S.ed(2);
else
    edt = S.ed(5);
end

step_c(edt,4,S,str1,str2)


%-----------------Callbacks for Titles and Labels block.-------------------
function [] = label_c(varargin)
% Callback for title and xlabel, ylabel edit boxes.
[hand,S,str] = varargin{[1,3,4]};
set(get(S.ax,str),'string',get(hand,'string'))


function [] = bold_c(varargin)
% Callback for title bold checkbox. Toggles between bold and normal font.
[hand,S,str] = varargin{[1,3,4]};
titl = get(S.ax,str);

if get(hand,'value')
    set(titl,'fontweight','bold');
else
    set(titl,'fontweight','normal');
end


function [] = font_c(varargin)
% Callback for title group font popup.  Sets the fontsize for title group.
[hand,S,str] = varargin{[1,3,4]};
str2 = get(hand,'string');
siz = str2(get(hand,'value'),:);
titl=get(S.ax,str);

if ~strcmp(siz,'Fontsize')
    set(titl,'fontsize',str2double(siz));
end


%-------------------Callbacks for Line Properties block.-------------------
function [] = lnon_c(varargin)
% Callback for Line On checkbox.
[hand,S] = varargin{[1 3]};
ln = get(S.ax,'userdata');

if get(hand,'value')  % If line is turned on, set popups to correct vals.
    lnstl(S.pp(7),5,S);
    set(S.pp(5:7),'enable','on');
else
    set(ln,'linestyle','none');
    if strcmp(get(ln,'Marker'),'none')   % Prevents data from disappearing.
        set(ln,'marker','o');    % If user turns off a line with no marker.
        set(S.pp(8:9),'value',4);   % Set default marker size and symbol.  
        set(S.pp(10:11),'value',1);
    end
    set(S.pp(5:7),'enable','off');
    set(S.pp(9:11),'enable','on');  % Turn on Marker options.
end


function [] = lnclr(varargin)
% Callback for Line Color popup.  Allows user to select a color for line.
[hand,S] = varargin{[1 3]};
ln = get(S.ax,'userdata');  % Get current line.
str = get(hand,'string');  % Get users choice.
val = str{get(hand,'value')};

if strcmp(val,'Line Color') % User selects the popup label.  No action.
    return
end

clr = colorslct(val,S);  % Get RGB vector.
set(ln,'color',clr)


function [] = lnwdth(varargin)
% Callback for Line Width popup.  Allows user to chose line's width.
[hand,S] = varargin{[1 3]};
ln = get(S.ax,'userdata');  % Get current line.
str = get(hand,'string');  % Get users choice.
val = str{get(hand,'value')};

if strcmp(val,'Line Width')   % User selects the popup label.  No action.
    return
end

set(ln,'linewidth',str2double(val))            


function [] = lnstl(varargin)
% Callback for Line Style popup.  Lets user choose style of line to use.
[hand,S] = varargin{[1 3]};
ln = get(S.ax,'userdata');   % Get current line.
str = get(hand,'string');   % Get users choice.
val = str{get(hand,'value')};

switch val
    case 'solid'
        stl = '-';
    case 'dotted'
        stl = ':';
    case 'dashdot'
        stl = '-.';
    case 'dashed'
        stl = '--';
    otherwise
        stl='-';
end

set(ln,'linestyle',stl)


%-------------------Callbacks for Marker Properties block.-----------------
function [] = dtmrk(varargin)
% Callback for Data Marker popup.  Lets user choose which marker to use.
[hand,S] = varargin{[1 3]};
ln = get(S.ax,'userdata');  % Get current line.
str = get(hand,'string');   % Get users choice.
dtmrkstr = str{get(hand,'value')};

if strcmp(dtmrkstr,'Data Marker')  % User selects the popup label. A nono.
    return
end

stl = mrkrslct(dtmrkstr);
% Call to decide which symbol to use.
if strcmp(stl,'none') % If no symbol, turn on line so data isn't invisible.
    if get(S.ck(7),'value')==0
       set(S.ck(7),'value',1)
       lnon_c(S.ck(7),1,S);             
    end 
    set(S.pp(9:11),'enable','off');  % Turn off marker choices.
else 
    set(S.pp(9:11),'enable','on');  % Turn on marker choices.
end

set(ln,'marker',stl)


function [] = mrkrsz(varargin)
% Callback for Marker Size popup.  Lets user choose size of marker.
[hand,S] = varargin{[1 3]};
ln = get(S.ax,'userdata');  % Get current line.
str = get(hand,'string');  % Get users choice.
val = str{get(hand,'value')};

if strcmp(val,'Marker Size')    % User selects the popup label.  No action.
    return
end

set(ln,'markersize',str2double(val))


function [] = edgclr(varargin)
% Callback for Marker EdgeColor popup.  Lets user select color for M. edge.
[hand,S] = varargin{[1 3]};
ln = get(S.ax,'userdata');  % Get current line.
str = get(hand,'string');  % Get users choice.
val = str{get(hand,'value')};

if strcmp(val,'Edge Color')  % User selects the popup label.  No action.  
    return
end

clr = colorslct(val,S);
set(ln,'markeredgecolor',clr)


function [] = fc_clr(varargin)
% Callback for Marker Facecolor popup.  Lets user select color for M. face. 
[hand,S] = varargin{[1 3]};
ln = get(S.ax,'userdata');  % Get current line.
str = get(hand,'string');  % Get users choice.
val = str{get(hand,'value')};

if strcmp(val,'Face Color')  % User selects the popup label.  No action.   
    return
end

clr = colorslct(val,S);
set(ln,'markerfacecolor',clr)


%----------------------Callbacks for Box and Grid block.-------------------
function [] = bxon(varargin)
% Callback for axes box checkbox.  Toggles between box on and box off.
[hand,S] = varargin{[1 3]};

if get(hand,'value')
    set(S.ax,'box','on');
else
    set(S.ax,'box','off');
end


function [] = grd(varargin)
% Callback for both x and y-axis grid lines checkboxes.
[hand,S,str] = varargin{[1 3 4]};

if get(hand,'value')
   set(S.ax,str,'on');
else
   set(S.ax,str,'off');
end


function [] = grdstl(varargin)
% Callback for Axes Grid Style popup. Lets user choose style of grid lines.
[hand,S] = varargin{[1 3]};
str = get(hand,'string');  % Get users choice.

switch str{get(hand,'value')}
    case 'solid'
        stl='-';
    case 'dotted'
        stl=':';
    case 'dashdot'
        stl='-.';
    case 'dashed'
        stl='--';
    otherwise
        return
end

set(S.ax,'gridlinestyle',stl)


%-----------------------------Callback for Legend Block--------------------
function [] = lgshow(varargin)
% Callback for Legend Visible checkbox.  Toggles between invisible or not.
[hand,S] = varargin{[1 3]};
lg = findobj(get(S.ax,'parent'),'tag','legend');

if get(hand,'value')
    set(S.ed(10),'enable','on');
    if ~isempty(lg), legend(S.ax,'show'), end  % Set legend to visible.
else
    set(S.ed(10),'enable','off');
    if ~isempty(lg), legend(S.ax,'hide'), end  % Set legend to invisible.
end


function [] = lgstr(varargin)
% Callback for Legend edit Box.  Displays a legend when user enters label.
[hand,S] = varargin{[1 3]};
str = get(hand,'string');  % Get string label.
ln = get(S.ax,'userdata');
set(ln,'tag',str);  % Store each lines label in 'tag' property.

for ii = 1:length(S.lines)  % Get all the labels that are available.
    list{ii}= get(S.lines(ii),'tag');  %#ok
end

legend(list,'Location','Best');


%-----------------------------Callback for Create Figure Pushbutton.-------
function [] = mkfig(varargin)
% Callback for Create Figure pushbutton.  Creates the plot user created.
S = varargin{3};
lg = findobj(S.pn(1),'tag','legend');  % Find legend to plot.
fh = figure;
ax2 = copyobj(S.ax,fh);
set(ax2,'units',get(0,'defaultaxesunits'),'outerposition',...
    get(0,'defaultaxesouterposition'))

if ~isempty(lg)
    lgpos = get(lg,'pos');
    legend(ax2,get(lg,'string'),'Location','Best');
    drawnow
    set(lg,'pos',lgpos)
    % There is some kind of bug in 2007a.  If legend is copied using
    % copyobj, the legend will appear only as a little dot on the new plot.
    % If, on the other hand, a legend is assigned to the new plot using the
    % legend command, the legend on the old plot gets moved off-screen!
end
