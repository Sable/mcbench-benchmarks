function kbinfo2(cmd)
% KBINFO keyboard information
%   This simple example assists you to understand how to get the keyboard information 
%
%   Author: Fu-Sung Wang, E-mail: fusung@webmail.pme.nthu.edu.tw , Update: 23-Dec-2004 11:29:53
%   $Revision

%% Initialization
global Hfig Htxt;        % Htxt: text handle, Hfig: figure handle
global MAXWORDLEN;       % MATWORDLEN: maximum word length

%% Create figure and text, and MAXWORDLEN is also initialized
if nargin == 0           % no input argument needed
Hfig = figure('Name','Keyboard Infomation','Numbertitle','off','Menubar','none',...         % Hfig: figure handle
              'Color',[0.831373 0.815686 0.784314],'Resize','off','DoubleBuffer','on',...
              'Position',[150,150,220,400],'KeyPressFcn',[mfilename,'(''RUN'')']);  
Htxt = uicontrol('Tag','typelist','Style', 'ListBox', ...                                      % Htxt: text handle
                 'Position',[0 0 220 400],'FontSize',10, ...
                 'HorizontalAlignment','Left','KeyPressFcn',[mfilename,'(''RUN'')']);
MAXWORDLEN = 200;       % maximum word length  
end

%% Retrieve keyboard information
% keyIn = get(Hfig, 'CurrentCharacter');
keyIn = num2str(keyinfo');
rec = getappdata(Hfig,'rec');           % get value from figure object (Hfig)
rec = strvcat(rec,keyIn);                % string concatenation

%% Reset rec
if size(str2num(rec),1) > MAXWORDLEN
    rec = [];
    rec = keyIn;
end

%% Update data
set(Htxt,'String',rec);
len_str = size(str2num(rec),1);
set(Htxt,'Value',len_str);
set(Hfig,'Name',[num2str(len_str) ' / ' num2str(MAXWORDLEN)] );
setappdata(Hfig,'rec',rec);