function getfigure
% this function adds a new menu option to copy other figure Figure plots
% adds to the current Figure the plot of another (mouse selection)
%
% first call adds the menu, second call deletes the menu
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% funcion que añade al Figure actual un menu para capturar la grafica de otros Figures
% es decir, añadir al Figure actual la grafica de otro (seleccionable con el mouse)
%
% la primera ejecucion añade el menu, la segunda lo quita
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% V3.0 - 2008
% Jordi Palacin
% http://robotica.udl.cat

hmenu = findobj(gcf,'Tag','GetFigure');

if (isempty(hmenu))
    h_get = uimenu(gcf,'label','GetFigure','Tag','GetFigure');
	uimenu(h_get,'label','Get the complete Figure','callback',@copiar_figure);
	uimenu(h_get,'label','Get one line','callback',@copiar_line);
    uimenu(h_get,'label','Undo last Get','callback',@undo_copiar,'separator','on','enable','off','Tag','UNDO');
    
    disp('''GetFigure'' menu has been added');
    disp('''GetFigure'' ha sido añadido al menu');
    
    % situar la figura en primer plano
    figure(gcf);
else
    delete(hmenu);
    disp('''GetFigure'' menu has been deleted');
    disp('''GetFigure'' ha sido eliminado del menu');
end
% #########################################################################

% #########################################################################
function copiar_figure(hco,eventStruct)
% funcion para copiar las lineas de otro figure en el figure actual

% figure actual
hfig = gcf;

% avisar el procedimiento
uiwait(msgbox({'Step 1: Close this dialog box','Step 2: Pulse over the figure to be full copied'},'Get Line','modal'));

T = waitforbuttonpress;

% figure seleccionado
hcomb = gcf;

if ((hfig ~= hcomb) & (T == 0))

    % averiguar cuantos lines hay
    hcomb_line = findobj(hcomb,'Type','line');
    n_lines = length(hcomb_line);

    % añadirlos uno a uno
    figure(hfig);
    for (i = 1:1:n_lines)
    
        % extraer los datos a combinar
        x = get(hcomb_line(i),'xData');
        y = get(hcomb_line(i),'yData');
    
        Color = get(hcomb_line(i),'Color');
    	LineStyle = get(hcomb_line(i),'LineStyle');
    	LineWidth = get(hcomb_line(i),'LineWidth');
    	Marker = get(hcomb_line(i),'Marker');
    	MarkerSize = get(hcomb_line(i),'MarkerSize');
        
        if (ishold)
            hplot(i) = plot(x,y,'Color',Color,'LineStyle',LineStyle,'LineWidth',LineWidth,'Marker',Marker,'MarkerSize',MarkerSize);
        else
            hold on;
            hplot(i) = plot(x,y,'Color',Color,'LineStyle',LineStyle,'LineWidth',LineWidth,'Marker',Marker,'MarkerSize',MarkerSize);
            hold off;
        end
    end
    
    % guardar per fer UNDO
    set(findobj('Tag','UNDO'),'UserData',hplot);
    
    % activar undo
    set(findobj('Tag','UNDO'),'enable','on');
    
else
    % avisar
    figure(hfig);
    uiwait(msgbox({'No new figure selected'},'GetFigure','modal'));
end
% #########################################################################

% #########################################################################
function copiar_line(hco,eventStruct)
% funcion para copiar una linea de otro figure en el figure actual

% figure actual
hfig = gcf;

% avisar el procedimiento
uiwait(msgbox({'Step 1: Close this dialog box','Step 2: Pulse over the line to be copied'},'Get Line','modal'));

T = waitforbuttonpress;

% figure seleccionado
hcomb = gcf;

% obtener el handle del objeto seleccionado
hselect = gco;

if ((hfig ~= hcomb) & (strcmp(get(hselect,'Type'),'line')) & (T == 0))
    
    % añadir la linea seleccionada
    figure(hfig);
        
	% extraer los datos a combinar
	x = get(hselect,'xData');
	y = get(hselect,'yData');

	Color      = get(hselect,'Color');
	LineStyle  = get(hselect,'LineStyle');
	LineWidth  = get(hselect,'LineWidth');
	Marker     = get(hselect,'Marker');
	MarkerSize = get(hselect,'MarkerSize');

	if (ishold)
		hplot = plot(x,y,'Color',Color,'LineStyle',LineStyle,'LineWidth',LineWidth,'Marker',Marker,'MarkerSize',MarkerSize);
    else
		hold on;
		hplot = plot(x,y,'Color',Color,'LineStyle',LineStyle,'LineWidth',LineWidth,'Marker',Marker,'MarkerSize',MarkerSize);
		hold off;
	end,
    
    % guardar per fer UNDO
    set(findobj('Tag','UNDO'),'UserData',hplot);
    
    % activar undo
    set(findobj('Tag','UNDO'),'enable','on');
    
else
    % avisar
    figure(hfig);
    uiwait(msgbox({'No line selected'},'GetFigure','modal'));
end
% #########################################################################

% #########################################################################
function undo_copiar(hco,eventStruct)
% funcion para deshacer la copia

% recuperar para UNDO
hplot = get(findobj('Tag','UNDO'),'UserData');

% eliminar uno a uno
for (i = 1:1:length(hplot))
    if (ishandle(hplot(i)))
        delete(hplot(i));
    end
end

% desactivar undo
set(findobj('Tag','UNDO'),'enable','off');
% #########################################################################