function [username,password]=GetAuthentication(defaultuser)
%GetAuthentication prompts a username and password from a user and hides the
% password input by *****
%
%   [user,password] = GetAuthentication;
%   [user,password] = GetAuthentication(defaultuser);
%
% arguments:
%   defaultuser - string for default name
%
% results:
%   username - string for the username
%   password - password as a string
%
% Created by Felix Ruhnow, MPI-CBG Dresden
% Version 1.00 - 20th February 2009
%

if nargin==0
    defaultuser='';
end
    
hAuth.fig = figure('Menubar','none','Units','normalized','Resize','off','NumberTitle','off', ...
                   'Name','Authentication','Position',[0.4 0.4 0.2 0.2],'WindowStyle','normal');

uicontrol('Parent',hAuth.fig,'Style','text','Enable','inactive','Units','normalized','Position',[0 0 1 1], ...
          'FontSize',12);
                  
uicontrol('Parent',hAuth.fig,'Style','text','Enable','inactive','Units','normalized','Position',[0.1 0.8 0.8 0.1], ...
                      'FontSize',12,'String','Username:','HorizontalAlignment','left');
                  
                 
hAuth.eUsername = uicontrol('Parent',hAuth.fig,'Style','edit','Tag','username','Units','normalized','Position',[0.1 0.675 0.8 0.125], ...
                       'FontSize',12,'String',defaultuser,'BackGroundColor','white','HorizontalAlignment','left');
                   
uicontrol('Parent',hAuth.fig,'Style','text','Enable','inactive','Units','normalized','Position',[0.1 0.5 0.8 0.1], ...
          'FontSize',12,'String','Password:','HorizontalAlignment','left');
                  
hAuth.ePassword = uicontrol('Parent',hAuth.fig,'Style','edit','Tag','password','Units','normalized','Position',[0.1 0.375 0.8 0.125], ...
                            'FontSize',12,'String','','BackGroundColor','white','HorizontalAlignment','left');                   
                        
uicontrol('Parent',hAuth.fig,'Style','pushbutton','Tag','OK','Units','normalized','Position',[0.1 0.05 0.35 0.2], ...
                            'FontSize',12,'String','OK','Callback','uiresume;');                   
                        
uicontrol('Parent',hAuth.fig,'Style','pushbutton','Tag','Cancel','Units','normalized','Position',[0.55 0.05 0.35 0.2], ...
                            'FontSize',12,'String','Cancel','Callback',@AbortAuthentication);                                           

set(hAuth.fig,'CloseRequestFcn',@AbortAuthentication)
set(hAuth.ePassword,'KeypressFcn',@PasswordKeyPress)

setappdata(0,'hAuth',hAuth);
uicontrol(hAuth.eUsername);
uiwait;

username = get(hAuth.eUsername,'String');
password = get(hAuth.ePassword,'UserData');
delete(hAuth.fig);

function PasswordKeyPress(hObject,event)
hAuth = getappdata(0,'hAuth');
password = get(hAuth.ePassword,'UserData');
switch event.Key
   case 'backspace'
      password = password(1:end-1);
   case 'return'
      uiresume;
      return;
   otherwise
      password = [password event.Character];
end
set(hAuth.ePassword,'UserData',password)
set(hAuth.ePassword,'String',char('*'*sign(password)))

function AbortAuthentication(hObject,event)
hAuth = getappdata(0,'hAuth');
set(hAuth.eUsername,'String','');
set(hAuth.ePassword,'UserData','');
uiresume;