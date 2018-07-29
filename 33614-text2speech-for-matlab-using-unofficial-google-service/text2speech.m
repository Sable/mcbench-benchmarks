function text2speech(str, lang, t_play)
% This is a command line demo on how to use the ActiveX VideoLAN.VLCPlugin.2 in combination with the
% unofficial google text to speech (TTS) engine to generate speech from text.
% You need to install the VLC-Media-Player and have a internetconnection to call the google service.
%
% The input parameters are:
%   - the string you want to convert:                       str
%   - then string of language code for the str:             lang   {'en','de','es', 'fr'}
%   - and the time in seconds until programm resumes:       t_play
%     if the time is to short, you'll maybe not hear everything
%
% Function call:
%     text2speech --> says 'Hello World' in english
%     text2speech('Guten Morgen!','de') --> says good morning in german
%     text2speech('Je t'aime.','fr')    --> says I love you in french
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



% Standard time until close is 2 Seconds
if nargin < 3
    t_play = 2; 
end
% Standard language is english
if nargin < 2
    lang = 'en'; 
end

% Standard sentence 
if nargin < 1, 
    str = 'Hello World!'; 
end;

% Create invisible figure
fig = figure('units','characters','position', [1 1 1 1] ,'Toolbar','none','DoubleBuffer', 'on', 'Name', 'Read it!', 'NumberTitle', 'off','MenuBar','none','Visible','off');

% Preapare String:
% limit string to at least 100 characters and replace blanks
try 
    str = strrep(str(1:100),' ','+');
catch
    str = strrep(str,' ','+');
end;

% insert the vlc-component invisible to figure
vlc1 = actxcontrol('VideoLAN.VLCPlugin.2', [1 1 0 0], fig);
vlc1.Volume   = 50;   % Set Volume
vlc1.AutoLoop = 0;    % Set Autoloop
vlc1.playlist.add(['http://translate.google.com/translate_tts?tl=',lang ,'&q=', str] );  % Unofficial text to speech  by google
vlc1.playlist.play;   % play it 
pause(t_play);        % wait a while 
close();              % close the fig

