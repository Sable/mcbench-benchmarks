
function GPIB
hMainFigure = figure(...       % The main GUI figure
                    'MenuBar','none', ...
                    'Toolbar','none', ...
                    'HandleVisibility','callback', ...
                    'Color', get(0,...
                             'defaultuicontrolbackgroundcolor'));


%   -----------------------------------------------------------------------

global eje;
global inicial;
global final;
global paso;
global hcontrol;
global ESP300;
global hmanual;
global hautomatico;
global hvar;

clc

h = uicontrol(hMainFigure,'Style', 'pushbutton', 'String', 'Mover',...
    'Position', [400 50 100 20],'Callback',@Mover);
%--------------------------------------------------------------------------
hcerrar = uicontrol(hMainFigure,'Style', 'pushbutton', 'String', 'Cerrar',...
    'Position', [50 50 100 20],'Callback',@Cerrar);
%--------------------------------------------------------------------------
uicontrol(hMainFigure,'Style', 'text','String', 'Eje',...
    'Position', [20 365 80 20])
heje = uicontrol(hMainFigure,'Style', 'edit','String', '1',...
    'Position', [20 350 80 20],'Callback',@heje_call);
eje = str2double(get(heje,'String'));
%--------------------------------------------------------------------------
uicontrol(hMainFigure,'Style', 'text','String', 'Inicial',...
    'Position', [20 315 80 20])
hinicial = uicontrol(hMainFigure,'Style', 'edit', 'String', '0',...
    'Position', [20 300 80 20],'Callback',@hinicial_call);
inicial = str2double(get(hinicial,'String'));
%--------------------------------------------------------------------------
uicontrol(hMainFigure,'Style', 'text','String', 'Final',...
    'Position', [20 265 80 20])
hfinal = uicontrol(hMainFigure,'Style', 'edit', 'String', '0',...
    'Position', [20 250 80 20],'Callback',@hfinal_call);
final = str2double(get(hfinal,'String'));
%--------------------------------------------------------------------------
uicontrol(hMainFigure,'Style', 'text','String', 'Paso',...
    'Position', [20 215 80 20])
hpaso = uicontrol(hMainFigure,'Style', 'edit', 'String', '0.05',...
    'Position', [20 200 80 20],'Callback',@hpaso_call);
paso = str2double(get(hpaso,'String'));
%--------------------------------------------------------------------------
uicontrol(hMainFigure,'Style', 'text','String', 'Control',...
    'Position', [20 165 80 20])
hcontrol = uicontrol(hMainFigure,'Style', 'edit',...
    'Position', [20 150 80 20]);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
hmanual = uicontrol(hMainFigure,'Style', 'radiobutton',...
    'String', 'Manual',...
    'Position', [200 350 100 20],...
    'Callback',@Manual);
%--------------------------------------------------------------------------
hautomatico = uicontrol(hMainFigure,'Style', 'radiobutton',...
    'String', 'Automatico',...
    'Position', [200 320 100 20],...
    'Callback',@Automatico);
%--------------------------------------------------------------------------
heje1 = uicontrol(hMainFigure,'Style', 'radiobutton',...
    'String', 'Eje 1',...
    'Position', [300 350 100 20],...
    'Callback',@Eje1);
%--------------------------------------------------------------------------
heje2 = uicontrol(hMainFigure,'Style', 'radiobutton',...
    'String', 'Eje 2',...
    'Position', [300 320 100 20],...
    'Callback',@Eje2);
%--------------------------------------------------------------------------
heje3 = uicontrol(hMainFigure,'Style', 'radiobutton',...
    'String', 'Eje 3',...
    'Position', [300 290 100 20],...
    'Callback',@Eje3);
%--------------------------------------------------------------------------
ESP300 = gpib('ni',0,1);
ESP300.Timeout = 0.5;
fopen(ESP300);

function Mover(hObject, eventdata)

global eje
global inicial
global final
global paso
global hcontrol;
global ESP300;
global hmanual;
global hautomatico;

%--------------------------------------------
if (get(hmanual,'Value') == get(hmanual,'Max'))
    MovManual(eje,inicial,final,paso,ESP300,hcontrol);
end
if (get(hautomatico,'Value') == get(hautomatico,'Max'))
    MovAutomatico(eje,inicial,final,paso,ESP300,hcontrol);
end

%--------------------------------------------------------------------------

function [PosFinal] = MovManual(eje,inicial,final,paso,ESP300,hcontrol)
ESP300.EOIMode = 'on';
ESP300.EOSMode = 'read';
ESP300.EOSCharCode = 'X';

Send = ([num2str(eje),'PA',num2str(final)]);
fprintf(ESP300,Send);

%--------------------------------------------
fprintf(ESP300,'TS')
Dato1a  = fscanf(ESP300,'%s');

while ~(strcmp(Dato1a,'P'))
    fprintf(ESP300,'TS')
    Dato1a  = fscanf(ESP300,'%s')
end

if Dato1a == 'P'
    
    Send1 = ([num2str(eje),'TP']);
    fprintf(ESP300,Send1);
    Dato1 = fscanf(ESP300,'%s')
   % [Dato1 Resi1] = query(ESP300,Send1,'%s','%s');
    set(hcontrol,'String',num2str(Dato1));
    pause(0.5)
end

function MovAutomatico(eje,inicial,final,paso,ESP300,hcontrol)


var = (inicial)

while final+paso >= var
  
    MovManual(eje,inicial,var,paso,ESP300,hcontrol)
    var = var+paso
end
    
function Eje1(hObject, eventdata)

global ESP300;

ESP300.EOIMode = 'on';
ESP300.EOSMode = 'read';
ESP300.EOSCharCode = 'X';

if (get(hObject,'Value') == get(hObject,'Max'))
	Send1 = (['1','MO']);
    fprintf(ESP300,Send1);
    set(hObject,'String','Eje 1 ON');
else
    Send1 = (['1','MF']);
    fprintf(ESP300,Send1);
	set(hObject,'String','Eje 1');
end

function Eje2(hObject, eventdata)

global ESP300;

ESP300.EOIMode = 'on';
ESP300.EOSMode = 'read';
ESP300.EOSCharCode = 'X';

if (get(hObject,'Value') == get(hObject,'Max'))
	Send1 = (['2','MO']);
    fprintf(ESP300,Send1);
    set(hObject,'String','Eje 2 ON');
else
    Send1 = (['2','MF']);
    fprintf(ESP300,Send1);
	set(hObject,'String','Eje 2');
end

function Eje3(hObject, eventdata)

global ESP300;

ESP300.EOIMode = 'on';
ESP300.EOSMode = 'read';
ESP300.EOSCharCode = 'X';

if (get(hObject,'Value') == get(hObject,'Max'))
	Send1 = (['3','MO']);
    fprintf(ESP300,Send1);
    set(hObject,'String','Eje 3 ON');
else
    Send1 = (['3','MF']);
    fprintf(ESP300,Send1);
	set(hObject,'String','Eje 3');
end

function Cerrar(hObject, eventdata)

global ESP300;

fclose(ESP300);
delete(ESP300);
close all

function Manual(hObject, eventdata)

global hautomatico;

if (get(hObject,'Value') == get(hObject,'Max'))
	set(hautomatico,'Value',0);
else
	% Radio button is not selected-take approriate action
end

function Automatico(hObject, eventdata)

global hmanual;

if (get(hObject,'Value') == get(hObject,'Max'))
	set(hmanual,'Value',0);
else
	% Radio button is not selected-take approriate action
end

function heje_call(hObject, eventdata)
global eje
eje = str2double(get(hObject,'String'));

function hinicial_call(hObject, eventdata)
global inicial
inicial = str2double(get(hObject,'String'));

function hfinal_call(hObject, eventdata)
global final
final = str2double(get(hObject,'String'));

function hpaso_call(hObject, eventdata)
global paso
paso = str2double(get(hObject,'String'));

