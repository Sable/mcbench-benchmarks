function speechdemo
% This is a demo on how to use the ActiveX VideoLAN.VLCPlugin.2 in combination with the unofficial google text
% to speech (TTS) engine to generate speech from text.
% You need to install the VLC-Media-Player and have a internetconnection to call the google service.
%
% In this demo is a popup where you can select the language in which the text from the edit-field (type in at
% least 100 characters) should be read.
% 
% Four languages are implemented actually (english, german, spanish and french) and the written text should be
% in the selected language.
%
% e.g:  english:  Good Morning!
%       german:   Guten Morgen!
%       spanish:  Buenos dias!
%       french:   Bonjour!
%
%
% Bugs and suggestions:
%    Please send to Sven Koerner: koerner(underline)sven(add)gmx.de
% 
% You need to download and install first:
%    The VLC Media Player:  http://www.videolan.org/vlc/
%
%
% Programmed by Sven Koerner: koerner(underline)sven(add)gmx.de
% Date: 2011/11/04


% Create a small figure
fig = figure('units','characters','position', [100 20 120 30] ,'Toolbar','none','DoubleBuffer', 'on', 'Name', 'TTS', 'NumberTitle', 'off','MenuBar','none');

% insert the vlc-component invisible to figure
vlc1 = actxcontrol('VideoLAN.VLCPlugin.2', [1 1 0 0], fig);

% insert label for VLC-Version
st_vlc = uicontrol(fig,'Style','text',...
                'units','characters',...
                'String',['VLC-Version: ',vlc1.VersionInfo],...
                'Position',[3 27 50 1], 'HorizontalAlignment','left');
vlc1.delete;


% insert an language popup
mh = uicontrol(fig,'Style','popupmenu',...
                'units','characters',...
                'String',{'english','german', 'spanish', 'french'},...
                'Value',1,'Position',[3 22 30 2]);

% insert label for popup
sth = uicontrol(fig,'Style','text',...
                'units','characters',...
                'String','Select a language:',...
                'Position',[3 24.5 30 1], 'HorizontalAlignment','left');

% insert an edit-box
eth = uicontrol(fig,'Style','edit',...
                'String','Always look on the bright side of life.',...
                'units','characters',...
                'Position',[3 15 100 2], 'HorizontalAlignment','left');

% insert label for editbox
sth2 = uicontrol(fig,'Style','text',...
                'units','characters',...
                'String','Type in at least 100 characters to read:',...
                'Position',[3 17.5 50 1], 'HorizontalAlignment','left');
            
% Insert Read Button
pbhr = uicontrol(fig,'Style','pushbutton','String','Read',...
                'units','characters',...
                'Position',[3 12 30 2], 'Callback', {@read_callback,mh, eth, fig});
            
            
% Insert close Button
pbhc = uicontrol(fig,'Style','pushbutton','String','Close',...
                'units','characters',...
                'Position',[3 5 30 2],'Callback','close');

            

function read_callback(hObject, eventdata, mh, eth, fig)
% Get Language
val = get(mh,'Value');
switch val
    case 1
        lang = 'en';
    case 2
        lang = 'de';
    case 3
        lang = 'es';
    case 4
        lang = 'fr';
end;

% Get String to Read
str_read = get(eth,'String');

% Preapare String:
% limit string to at least 100 characters and replace blanks
try 
    str = strrep(str_read(1:100),' ','+');
catch
    str = strrep(str_read,' ','+');
end;

% insert the vlc-component invisible to figure via actxcontrol
vlc1 = actxcontrol('VideoLAN.VLCPlugin.2', [1 1 0 0], fig);
vlc1.Volume   = 50;   % Set Volume
vlc1.AutoLoop = 0;    % Set Autoloop
vlc1.playlist.add(['http://translate.google.com/translate_tts?tl=',lang ,'&q=', str] );  % Unofficial text to speech  by google
vlc1.playlist.play;   % play it 



            
