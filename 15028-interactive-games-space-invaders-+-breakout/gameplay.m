function gameplay
% per jugar !

% EVITAR cridar dos cops
hliveweb = findobj('tag','LIVEGAME');
if (isempty(hliveweb)),

	% crer el figure
	hliveweb = figure;
	set(hliveweb,'numbertitle','off');               % treu el numero de figura
	set(hliveweb,'name',['Gameplay 1.0: University of Lleida  -  Grup de Robotica (http://robotica.udl.es)']);
	set(hliveweb,'MenuBar','none');                  % treiem el menu d'icons
	set(hliveweb,'doublebuffer','on');               % dos buffers de grafics
	set(hliveweb,'CloseRequestFcn',@aturar)          % podem tancar ?
	set(hliveweb,'tag','LIVEGAME');                  % identifiquem la figura

    archiu = uimenu('Label','Start','Tag','WORKING');
        uimenu(archiu,'Label','Connect WebCam...','Callback',@conectar,'Tag','CON');
		uimenu(archiu,'Label','Live...','Callback',@original,'Tag','GAME','enable','off');
		uimenu(archiu,'Label','&E X I T','Callback',@tancar,'separator','on');

	h_fun=uimenu('Label','Play','Tag','WORKING');
        uimenu(h_fun,'Label','Space Invaders','Callback',@invaders,'Tag','GAME','enable','off');
		uimenu(h_fun,'Label','BreakOut','Callback',@breakout,'Tag','GAME','enable','off');
	
        
    global livegame;
    livegame.break_maxims = 0;
    livegame.space_maxims = 0;

else,
	figure(hliveweb);
    set(findobj('Tag','WORKING'),'enable','on');
end,
% ###################################################################################

% ###################################################################################
function aturar(hco,eventStruct)
% aturar el possible while

set(findobj('Tag','WORKING'),'enable','on');
% ###################################################################################

% ###################################################################################
function tancar(hco,eventStruct)
% asegurar que es tanca la camara

clear vcapg2;

closereq;
% ###################################################################################

% ###################################################################################
function conectar(hco,eventStruct)
		
uiwait(warndlg({'PLUG the camera and wait 10 seconds...'},'Attention','modal'));

if (exist('vcapg2.dll'))
    
    % inicialitzar la camara
    vcapg2(0,0);
    
    % capturar una imatge
    a = vcapg2;
    % mirar el tamany
    [n_fil, n_col, n_dim] = size(a);
    
    if (n_fil ~= 240)
        uiwait(warndlg({'The camera is ok but...','change manually the resolution to 320x240 !'},'Resolution Error','modal'));
    end
    
    % tot es correcte
    set(findobj('Tag','GAME'),'enable','on');
    set(findobj('Tag','CON'),'enable','off');
    
else
    uiwait(warndlg('vcapg2.dll is not on the path...','Error','modal'));
end
% ###################################################################################

% ###################################################################################
function original(hco,eventStruct)
% veure el que es captura
hliveweb = findobj('tag','LIVEGAME');

set(findobj('Tag','WORKING'),'enable','off');

figure(hliveweb);
subplot(1,1,1);
imatges = 0;

h_menu = findobj('Tag','WORKING');
t0 = clock;
while (strcmp(get(h_menu,'enable'),'off')),
	% capturar la imatge
	a = vcapg2;
    
    % visualitzar-la com un mirall
    hi = image(a);
    set(gca,'XDir','Reverse');
    
    imatges = imatges +1;

	drawnow;
	refresh;
end,
set(findobj('Tag','WORKING'),'enable','on');
delta_t = etime(clock,t0);
title([num2str(imatges/delta_t) ' frames/s']);
% ###################################################################################

% ###################################################################################
function invaders(hco,eventStruct)
hliveweb = findobj('tag','LIVEGAME');

global livegame;

% verificar el tamany de la imatge
% capturar una imatge
a = vcapg2;
% mirar el tamany
[n_fil, n_col, n_dim] = size(a);

if (n_fil ~= 240)
    warndlg({'The camera is ok but...','change manually the resolution to 320x240 !'},'Resolution Error','modal');
    return;
end

sonido = 1;
if (exist('analogoutput') > 0)
    % utilizar el sonido
    sonido = 1;

    % carregar els sons
    [y_aparicion_nave,fs_aparicion_nave]=wavread(['aparicion_nave.wav']);
    [y_cambio_pantalla,fs_cambio_pantalla]=wavread(['cambio_pantalla.wav']);
    [y_disparo_bomba,fs_disparo_bomba]=wavread(['disparo_bomba.wav']);
    [y_disparo_missil,fs_disparo_missil]=wavread(['disparo_missil.wav']);
    [y_explosion_nave,fs_explosion_nave]=wavread(['explosion_nave.wav']);
    [y_fin_juego2,fs_fin_juego2]=wavread(['fin_juego2.wav']);
    [y_fin_juego,fs_fin_juego]=wavread(['fin_juego.wav']);

    ao = analogoutput('winsound',0);
    addchannel(ao,[1 2]);
    set(ao,'SampleRate',44100);
    putdata(ao,y_fin_juego);
    start(ao);
end

% estructura de les naus
% nau
nau.x = [-10 10 10 3 3 -3 -3 -10];
nau.y = [-5 -5 5 5 10 10 5 5];

% dades particulars
nau.numero = 0;
nau.numero_maxim_en_pantalla = 0;
nau.numero_maxim_acumulat = 0;
nau.proper_disparo_maxim = 0;
nau.vely = 0.25;
nau.velx = 0.05;
nau.atacant.tipo = 0;
nau.atacant.x = 50+ rand(1)*200;
nau.atacant.y = 10;
nau.atacant.visible = 0;
nau.atacant.estat = 0;      % 0 normal, de 15 a 5 predisparo, 5 disparo, de 5 a 1 postdisparo
nau.atacant.h_nau = [];

% bombes
% son nomes 1 punt
bombes.num = 0;
bombes.num_maxim = 8;
bombes.velocitat.y = 0.25;
bombes.disparo.x = 0;
bombes.disparo.y = 0;
bombes.disparo.visible = 0;
bombes.disparo.h_bomba = [];

% missil
% son nomes 1 punt
missil.num = 0;
missil.num_maxim = 1;
missil.velocitat.y = 1;
missil.disparo.x = 0;
missil.disparo.y = 0;
missil.disparo.visible = 0;
missil.disparo.h_bomba = [];

% partida
partida.superada = 1;
partida.pantalla = 0;
partida.punts = 0;

set(findobj('Tag','WORKING'),'enable','off');

figure(hliveweb);
subplot(1,1,1);

blink = 0;

% primera imatge
% primera imatge
a = vcapg2;
image(a);
set(gca,'XDir','Reverse','Position',[0 0 1 1]);

% partida.noujugador = 0;

h_menu = findobj('Tag','WORKING');
while (strcmp(get(h_menu,'enable'),'off')),
	% capturar la imatge
    a_old = a;
	a = vcapg2;
    
%     if (partida.noujugador == 0)
%         % esperar a nou jugador
%         wait_player;
%         
%         partida.noujugador = 1;
%         partida.superada = 1;
%         partida.pantalla = 0;
%         partida.punts = 0;
%     end
	
    if (partida.superada)
        
        % visualitzar la imatge invertida
        hi = image(a);
        set(gca,'XDir','Reverse','Position',[0 0 1 1]);
        set(hi,'EraseMode','none');
        axis off;
        
        % punts
        h_punts = text(315,220,num2str(partida.punts),'color',[1 0 0],'EdgeColor',[0 0 0],'BackgroundColor',[1 1 1],'FontSize',20,'HorizontalAlignment','left');
        
        % incrementar la partida
        partida.superada = 0;
        partida.pantalla = partida.pantalla +1;
        blink = 0;
        
        switch partida.pantalla
        case 1
            % inicialitzar la pantalla 1
            partida.temps = 30;
            
            nau.numero = 0;
            nau.numero_maxim_en_pantalla = 2;
            nau.numero_maxim_acumulat = 10;
            nau.proper_disparo_maxim = 700;
            nau.vely = 0.01;
            nau.velx = 0.15;
            
            bombes.num_maxim = 4;
            bombes.velocitat.y = 2;
            
            missil.num_maxim = 2;
            missil.velocitat.y = 2;
        case 2
            % inicialitzar la pantalla 2
            partida.temps = 60;
            
            nau.numero = 0;
            nau.numero_maxim_en_pantalla = 2;
            nau.numero_maxim_acumulat = 10;
            nau.proper_disparo_maxim = 700;
            nau.vely = 0.05;
            nau.velx = 0.25;
            
            bombes.num_maxim = 4;
            bombes.velocitat.y = 4;
            
            missil.num_maxim = 4;
            missil.velocitat.y = 4;
        case 3
            % inicialitzar la pantalla 3
            partida.temps = 60;
            
            nau.numero = 0;
            nau.numero_maxim_en_pantalla = 2;
            nau.numero_maxim_acumulat = 15;
            nau.proper_disparo_maxim = 500;
            nau.vely = 0.10;
            nau.velx = 0.5;
            
            bombes.num_maxim = 6;
            bombes.velocitat.y = 4;
            
            missil.num_maxim = 4;
            missil.velocitat.y = 4;
        case 4
            % inicialitzar la pantalla 4
            partida.temps = 60;
            
            nau.numero = 0;
            nau.numero_maxim_en_pantalla = 2;
            nau.numero_maxim_acumulat = 15;
            nau.proper_disparo_maxim = 500;
            nau.vely = 0.20;
            nau.velx = 1;
            
            bombes.num_maxim = 6;
            bombes.velocitat.y = 6;
            
            missil.num_maxim = 6;
            missil.velocitat.y = 4;
        case 5
            % inicialitzar la pantalla 5
            partida.temps = 90;
            
            nau.numero = 0;
            nau.numero_maxim_en_pantalla = 3;
            nau.numero_maxim_acumulat = 25;
            nau.proper_disparo_maxim = 500;
            nau.vely = 0.40;
            nau.velx = 1;
            
            bombes.num_maxim = 8;
            bombes.velocitat.y = 6;
            
            missil.num_maxim = 6;
            missil.velocitat.y = 4;
        case 6
            % inicialitzar la pantalla 6
            partida.temps = 90;
            
            nau.numero = 0;
            nau.numero_maxim_en_pantalla = 3;
            nau.numero_maxim_acumulat = 25;
            nau.proper_disparo_maxim = 500;
            nau.vely = 1;
            nau.velx = 2;
            
            bombes.num_maxim = 8;
            bombes.velocitat.y = 6;
            
            missil.num_maxim = 6;
            missil.velocitat.y = 4;
            
        case 7
            % inicialitzar la pantalla 7
            partida.temps = 90;
            
            nau.numero = 0;
            nau.numero_maxim_en_pantalla = 3;
            nau.numero_maxim_acumulat = 25;
            nau.proper_disparo_maxim = 300;
            nau.vely = 2;
            nau.velx = 4;
            
            bombes.num_maxim = 8;
            bombes.velocitat.y = 6;
            
            missil.num_maxim = 6;
            missil.velocitat.y = 4;
            
        otherwise
            % mostrar la puntuacio
            
            if (sonido)
                % sonido de final
                stop(ao);putdata(ao,y_fin_juego);start(ao);
            end

            if (partida.punts > livegame.space_maxims)
                h_text = text(160,100,{'Game Over',['High Score: ' num2str(partida.punts)]},'color',[1 0 0],'EdgeColor',[0 0 0],'BackgroundColor',[0 1 0],'FontSize',35,'HorizontalAlignment','center');

                livegame.space_maxims = partida.punts;
                
                
                if (sonido)
                    pause(5);
                    stop(ao);putdata(ao,y_fin_juego2);start(ao);
                    pause(5);
                end
                
            else
                h_text = text(160,100,{'Game Over',[num2str(partida.punts) ' points'],['High Score: ' num2str(livegame.space_maxims)]},'color',[1 0 0],'EdgeColor',[0 0 0],'BackgroundColor',[0 1 0],'FontSize',35,'HorizontalAlignment','center');
            end

%             partida.noujugador = 0;
            partida.superada = 1;
            partida.pantalla = 0;
            partida.punts = 0;
            break;
            
        end

%         if (partida.noujugador == 1)
            % so canvi pantalla
            if (sonido)
                stop(ao);putdata(ao,y_cambio_pantalla);start(ao);
            end

            h_text = text(160,100,['Pantalla ' num2str(partida.pantalla)],'color',[0 1 0],'EdgeColor',[1 0 0],'BackgroundColor',[0 0 0],'FontSize',35,'HorizontalAlignment','center');
            % petit delay
            for (w =1:1:150)
                % imatge de fons
                a = vcapg2;
                set(hi,'CData',a);

                drawnow;
                refresh;
            end
            delete(h_text);

            % crear les naus
            if (sonido)
                % so de creacio de naus
                stop(ao);putdata(ao,y_aparicion_nave);start(ao);
            end

            hold on;
            for (i=1:1:nau.numero_maxim_en_pantalla)

                nau.atacant(i).x = 50+ rand(1)*(240-50);
                nau.atacant(i).y = 10;
                nau.atacant(i).velx = nau.velx;
                nau.atacant(i).vely = nau.vely;

                nau.atacant(i).visible = 1;
                nau.atacant(i).estat = round(10+ rand(1)*nau.proper_disparo_maxim);

                nau.atacant(i).h_nau = fill(nau.atacant(i).x + nau.x, nau.atacant(i).y + nau.y, [0.5 0.5 0]); % visible per defecte
                nau.numero = nau.numero + 1;
            end

            % crear les bombes
            for (i=1:1:bombes.num_maxim)

                bombes.disparo(i).x = 10;
                bombes.disparo(i).y = 10;
                bombes.disparo(i).visible = 0;

                bombes.disparo(i).h_bomba = plot(bombes.disparo(i).x,bombes.disparo(i).y,'r.','MarkerSize',22,'Visible','off');
            end

            % crear els missils
            for (i=1:1:missil.num_maxim)

                missil.disparo(i).x = 10;
                missil.disparo(i).y = 10;
                missil.disparo(i).visible = 0;

                missil.disparo(i).h_missil = plot(missil.disparo(i).x,missil.disparo(i).y,'g.','MarkerSize',22,'Visible','off');
            end
            hold off;

            % reset del temps
            tic;
%         end
    else
        
        % imatge de fons
        if (blink)
            set(hi,'CData',(255-a));
            blink = 0;
        else
            set(hi,'CData',a);
        end
        
        % puntuacio
        set(h_punts,'string',num2str(partida.punts));

        % actualitzar la posicio de les naus
        for (i=1:1:nau.numero_maxim_en_pantalla)
            
            % es visible
            if (nau.atacant(i).visible)
                
                % actualitzar la seva posicio
                nau.atacant(i).x = nau.atacant(i).x + nau.atacant(i).velx;
                nau.atacant(i).y = nau.atacant(i).y + nau.atacant(i).vely;
                
                % limits horitzontals
                if (nau.atacant(i).x < 50)
                    nau.atacant(i).velx = - nau.atacant(i).velx;
                    nau.atacant(i).x = 50;
                elseif (nau.atacant(i).x > 270)
                    nau.atacant(i).velx = - nau.atacant(i).velx;
                    nau.atacant(i).x = 270;
                end

                % surt fora de limits verticals
                if (nau.atacant(i).y > 200)
                    nau.atacant(i).vely = - nau.atacant(i).vely;
                    nau.atacant(i).y = 200;
                    
                    % 100 menys si no s'ha destruit
                    partida.punts = partida.punts - 100;
                    
                elseif (nau.atacant(i).y < 10)
                    nau.atacant(i).vely = - nau.atacant(i).vely;
                    nau.atacant(i).y = 10;
                    
                    % 100 menys si no s'ha destruit
                    partida.punts = partida.punts - 100;
                end
                
                % disparo ?
                nau.atacant(i).estat = nau.atacant(i).estat -1;
                
                if (nau.atacant(i).estat < 1)
                    % postdisparo
                    color = [0.5 0.5 0];
                    nau.atacant(i).estat = round(10+ rand(1)*nau.proper_disparo_maxim);
                
                elseif (nau.atacant(i).estat == 5)
                    % disparo
                    color = [1 0 0];
                    
                    % actibar una bomba si es pot
                    for (ii=1:1:bombes.num_maxim)
                        
                        if (bombes.disparo(ii).visible == 0)
                            
                            bombes.disparo(ii).visible = 1;
                            bombes.disparo(ii).x = nau.atacant(i).x;
                            bombes.disparo(ii).y = nau.atacant(i).y;
                            
                            set(bombes.disparo(ii).h_bomba,'Visible','on');
                            
                            % 10 punts menys per cada bomba disparada
                            partida.punts = partida.punts - 10;
                            
                            if (sonido)
                                % so del disparo
                                stop(ao);putdata(ao,y_disparo_bomba);start(ao);
                            end
                            break;
                        end
                    end
                    
                elseif (nau.atacant(i).estat < 15 )
                    % predisparo
                    color = [1 0 0];
                else
                    % normal
                    color = [0.5 0.5 0];
                end
                
                % dibuixar la nau
                set(nau.atacant(i).h_nau,'XData',nau.atacant(i).x + nau.x,'YData', nau.atacant(i).y + nau.y,'FaceColor', color);
            
            else
                % la nau no es visible, mirar si es pot crear
                if (nau.numero < nau.numero_maxim_acumulat)
                    % crear una nova nau
                    nau.numero = nau.numero +1;
                    
                    nau.atacant(i).x = 50+ rand(1)*(240-50);
                    nau.atacant(i).y = 10;
                    nau.atacant(i).visible = 1;
                    nau.atacant(i).estat = round(10+ rand(1)*nau.proper_disparo_maxim);
                    
                    % fer-la visible
                    set(nau.atacant(i).h_nau,'Visible','on');
                    
                end
            end
        end
        
        % detectar el disparo de missil (moviment cap dalt)
        c1 = detecta_moviment(a_old(:,:,1),a(:,:,1),[320 240 40 20]);
        b = sum(c1(2:6,:,4));
        b_max = max(b);

        % detectar el disparo
        if (b_max > 20)           
        
            % actibar un missil si es pot
            for (ii=1:1:missil.num_maxim)

                if (missil.disparo(ii).visible == 0)
                    
                    % localitzar la posicio de disparo
                    i_m = find(b == b_max)*20;

                    missil.disparo(ii).visible = 1;
                    missil.disparo(ii).x = i_m(1)+1;
                    missil.disparo(ii).y = 200;
                    set(missil.disparo(ii).h_missil,'Visible','on');
                    
                    % 10 punts menys per cada missil disparat
                    partida.punts = partida.punts - 10;
                    
                    if (sonido)
                        % so de disparo
                        stop(ao);putdata(ao,y_disparo_missil);start(ao);
                    end
                    break;
                end
            end
        end

        % dibuixar els missils
        for (i=1:1:missil.num_maxim)

            if (missil.disparo(i).visible)

                missil.disparo(i).y = missil.disparo(i).y - missil.velocitat.y;
                
                if (missil.disparo(i).y < 5)
                    missil.disparo(i).visible = 0;
                    % amagar
                    set(missil.disparo(i).h_missil,'Visible','off');
                else
                    % detectar la destruccio de naus
                    % actualitzar la posicio de les naus
                    for (ii=1:1:nau.numero_maxim_en_pantalla)

                        % es visible
                        if (nau.atacant(ii).visible)
                            if ( (abs(missil.disparo(i).y - nau.atacant(ii).y) + abs(missil.disparo(i).x - nau.atacant(ii).x)) < 20)

                                % tocado! nau destruida
                                partida.punts = partida.punts + 100;
                                
                                nau.atacant(ii).visible = 0;
                                set(nau.atacant(ii).h_nau,'Visible','off');
                                
                                missil.disparo(i).visible = 0;
                                set(missil.disparo(i).h_missil,'Visible','off');
                                
                                if (sonido)
                                    % so explosio nau
                                    stop(ao);putdata(ao,y_explosion_nave);start(ao);
                                end
                            end
                        end
                    end
                    set(missil.disparo(i).h_missil,'XData',missil.disparo(i).x,'YData',missil.disparo(i).y);
                end
            end
        end
        
        % dibuixar les bombes de les naus
        for (i=1:1:bombes.num_maxim)

            if (bombes.disparo(i).visible)

                bombes.disparo(i).y = bombes.disparo(i).y + bombes.velocitat.y;
                
                % DETECTAR DESTRUCCIO DE LA PERSONA
                if (c1(max([1 round(bombes.disparo(i).y/40)]),max([1 round(bombes.disparo(i).x/20)]),1) > 10)
                    % persona tocada
                    % la bomba ha arribar a un lloc on hi ha moviment
                    bombes.disparo(i).visible = 0;
                    % amagar la bomba
                    set(bombes.disparo(i).h_bomba,'Visible','off');
                    
                    % penalitzar el fet que ens han tocat
                    partida.punts = partida.punts - 100;
                    
                    blink = 1;
                                   
                elseif (bombes.disparo(i).y > 230)
                    bombes.disparo(i).visible = 0;
                    % amagar
                    set(bombes.disparo(i).h_bomba,'Visible','off');

                else
                    % mostrar i actualitzar
                    set(bombes.disparo(i).h_bomba,'XData',bombes.disparo(i).x,'YData',bombes.disparo(i).y);
                end

            end
        end
        
        % fin de pantalla
        if (toc > partida.temps)
            partida.superada = 1;
        end
        if (nau.numero == nau.numero_maxim_acumulat)
            partida.punts = partida.punts + 1000;
            partida.superada = 1;
        end
        
    end
    
	drawnow;
	refresh;
end,
set(findobj('Tag','WORKING'),'enable','on');

if (sonido)
    stop(ao);
    delete(ao);
end
% ###################################################################################

% ###################################################################################
function breakout(hco,eventStruct)
hliveweb = findobj('tag','LIVEGAME');

global livegame;

% verificar el tamany de la imatge
% capturar una imatge
a = vcapg2;
% mirar el tamany
[n_fil, n_col, n_dim] = size(a);

if (n_fil ~= 240)
    warndlg({'The camera is ok but...','change manually the resolution to 320x240 !'},'Resolution Error','modal');
    return;
end

sonido = 1;
if (exist('analogoutput') > 0)
    % utilizar el sonido
    sonido = 1;

    % carregar els sons
    [y_aparicion_nave,fs_aparicion_nave]=wavread(['aparicion_nave.wav']);
    [y_cambio_pantalla,fs_cambio_pantalla]=wavread(['cambio_pantalla.wav']);
    [y_disparo_bomba,fs_disparo_bomba]=wavread(['disparo_bomba.wav']);
    [y_disparo_missil,fs_disparo_missil]=wavread(['disparo_missil.wav']);
    [y_explosion_nave,fs_explosion_nave]=wavread(['explosion_nave.wav']);
    [y_fin_juego2,fs_fin_juego2]=wavread(['fin_juego2.wav']);
    [y_fin_juego,fs_fin_juego]=wavread(['fin_juego.wav']);
    [y_nova_bola,fs_nova_bola]=wavread(['nova_bola.wav']);

    ao = analogoutput('winsound',0);
    addchannel(ao,[1 2]);
    set(ao,'SampleRate',44100);
    putdata(ao,y_fin_juego);
    start(ao);
end

% estructura dels totxos
formatotxo.x = [-10 10 10 -10];
formatotxo.y = [-5 -5 5 5];

% partida
pilotes.activa = 1;
partida.acabada = 0;
partida.superada = 1;
partida.pantalla = 0;
partida.punts = 0;

% 6 nivells de contacte
mapa_colors(6,1:3) = [1   0   0];   % mes dificil
mapa_colors(5,1:3) = [0.5 0.5 1];
mapa_colors(4,1:3) = [0   0.5 1];
mapa_colors(3,1:3) = [0   0.5 0.5];
mapa_colors(2,1:3) = [0.5 0.5 0];
mapa_colors(1,1:3) = [0   1   0];   % mes facil

set(findobj('Tag','WORKING'),'enable','off');

figure(hliveweb);
subplot(1,1,1);

% primera imatge
a = vcapg2;
image(a);
set(gca,'XDir','Reverse','Position',[0 0 1 1]);

[n_fil,n_col,n_dim] = size(a);

blink = 0;
% partida.noujugador = 0;

h_menu = findobj('Tag','WORKING');
while (strcmp(get(h_menu,'enable'),'off')),
	% capturar la imatge
    a_old = a;
	a = vcapg2;
    
%     if (partida.noujugador == 0)
%         % esperar a nou jugador
%         wait_player;
%         
%         partida.noujugador = 1;
%     end
	
    if (partida.acabada)
        % antes de temps
        
        if (sonido)
            % sonido de final
            stop(ao);putdata(ao,y_fin_juego);start(ao);
            pause(5);
        end

        if (partida.punts > livegame.break_maxims)
            h_text = text(160,100,{'Game Over',['High Score: ' num2str(partida.punts)]},'color',[1 0 0],'EdgeColor',[0 0 0],'BackgroundColor',[0 1 0],'FontSize',35,'HorizontalAlignment','center');

            livegame.break_maxims = partida.punts;

            if (sonido)
                stop(ao);putdata(ao,y_fin_juego2);start(ao);
                pause(5);
            end

        else
            h_text = text(160,100,{'Game Over',[num2str(partida.punts) ' points'],['High Score: ' num2str(livegame.break_maxims)]},'color',[1 0 0],'EdgeColor',[0 0 0],'BackgroundColor',[0 1 0],'FontSize',35,'HorizontalAlignment','center');
        end

        % fi de la partida
%         partida.noujugador = 0;
        pilotes.activa = 1;
        partida.acabada = 0;
        partida.superada = 1;
        partida.pantalla = 0;
        partida.punts = 0;
        break;
        
    elseif (partida.superada)
        
        % visualitzar la imatge invertida
        hi = image(a);
        set(gca,'XDir','Reverse','Position',[0 0 1 1]);
        set(hi,'EraseMode','none');
        axis off;
        
        
        % dibuixar la linea central
        hold on;
        plot([20 (n_col-20)],[160 160],'g:');
        plot([20 (n_col-20)],[200 200],'g:');
        % dibujar las lineas laterales
        plot([20 20 (n_col-20) (n_col-20)],[n_fil 10 10 n_fil],'b-','linewidth',3);
        hold off;
        
        % punts
        h_punts = text(315,220,num2str(partida.punts),'color',[1 0 0],'EdgeColor',[0 0 0],'BackgroundColor',[1 1 1],'FontSize',20,'HorizontalAlignment','left');
                
        % incrementar la partida
        partida.superada = 0;
        partida.pantalla = partida.pantalla +1;
        blink = 0;
        
        switch partida.pantalla
        case 1
            % inicialitzar la pantalla 1
            % posicio dels totxos (centre)
            totxos.numero_maxim = 6;
            posicio.x = [260 220 180 140 100 60];
            posicio.y = [20 20 20 20 20 20];
            posicio.dificultat = [1 1 1 1 1 1];
            
            pilotes.num_maxim = 3;
            pilotes.activa = 0;
            pilotes.per_rematar = 0;
            
        case 2
            % inicialitzar la pantalla 2
            % posicio dels totxos (centre)
            totxos.numero_maxim = 7;
            posicio.x = [260 220 180 160 140 100 60];
            posicio.y = [20 20 20 50 20 20 20];
            posicio.dificultat = [2 1 1 3 1 1 2];
            
            pilotes.num_maxim = 3;
            pilotes.activa = 0;
            pilotes.per_rematar = 0;
            
        case 3
            % inicialitzar la pantalla 3
            % posicio dels totxos (centre)
            totxos.numero_maxim = 11;
            posicio.x =          [260 240 220 200 180 160 140 120 100 80  60];
            posicio.y =          [120 100 80  60  40  20  40  60  80  100 120];
            posicio.dificultat = [1   2   3   4   5   6   5   4   3   2   1];
            
            pilotes.num_maxim = 4;
            pilotes.activa = 0;
            pilotes.per_rematar = 0;
            
        case 4
            % inicialitzar la pantalla 4
            % posicio dels totxos (centre)
            totxos.numero_maxim = 117;
            posicio.x =          [280 260 240 220 200 180 160 140 120 100 80  60 40;...
                                  280 260 240 220 200 180 160 140 120 100 80  60 40;...
                                  280 260 240 220 200 180 160 140 120 100 80  60 40;...
                                  280 260 240 220 200 180 160 140 120 100 80  60 40;...
                                  280 260 240 220 200 180 160 140 120 100 80  60 40;...
                                  280 260 240 220 200 180 160 140 120 100 80  60 40;...
                                  280 260 240 220 200 180 160 140 120 100 80  60 40;...
                                  280 260 240 220 200 180 160 140 120 100 80  60 40;...
                                  280 260 240 220 200 180 160 140 120 100 80  60 40];
            posicio.y =          [20*ones(1,13);...
                                  30*ones(1,13);...
                                  40*ones(1,13);...
                                  50*ones(1,13);...
                                  60*ones(1,13);...
                                  70*ones(1,13);...
                                  80*ones(1,13);...
                                  90*ones(1,13);...
                                  100*ones(1,13)];
            posicio.dificultat = [1 6 6 6 1 1 1 1 1 6 6 6 1;...
                                  6 4 6 4 6 1 1 1 6 4 6 4 6;...
                                  6 6 6 6 6 5 5 5 6 6 6 6 6;...
                                  6 3 3 3 6 1 5 1 6 3 3 3 6;...
                                  1 6 6 6 1 6 6 6 1 6 6 6 1;...
                                  1 1 1 1 6 4 6 4 6 1 1 1 1;...
                                  1 1 1 1 6 6 6 6 6 1 1 1 1;...
                                  1 1 1 1 6 2 2 2 6 1 1 1 1;...
                                  1 1 1 1 1 6 6 6 1 1 1 1 1];
            
            pilotes.num_maxim = 5;
            pilotes.activa = 0;
            pilotes.per_rematar = 0;
            
        otherwise
            % mostrar la puntuacio
            
            if (sonido)
                % sonido de final
                stop(ao);putdata(ao,y_fin_juego);start(ao);
                pause(5);
            end

            if (partida.punts > livegame.break_maxims)
                h_text = text(160,100,{'Game Over',['High Score: ' num2str(partida.punts)]},'color',[1 0 0],'EdgeColor',[0 0 0],'BackgroundColor',[0 1 0],'FontSize',35,'HorizontalAlignment','center');

                livegame.break_maxims = partida.punts;
                
                if (sonido)
                    stop(ao);putdata(ao,y_fin_juego2);start(ao);
                    pause(5);
                end
                
            else
                h_text = text(160,100,{'Game Over',[num2str(partida.punts) ' points'],['High Score: ' num2str(livegame.break_maxims)]},'color',[1 0 0],'EdgeColor',[0 0 0],'BackgroundColor',[0 1 0],'FontSize',35,'HorizontalAlignment','center');
            end

            % fi de la partida
%             partida.noujugador = 0;
            pilotes.activa = 1;
            partida.acabada = 0;
            partida.superada = 1;
            partida.pantalla = 0;
            partida.punts = 0;
            break;

        end

        if (sonido)
            % so canvi pantalla
            stop(ao);putdata(ao,y_cambio_pantalla);start(ao);
        end
        
        h_text = text(160,100,['Pantalla ' num2str(partida.pantalla)],'color',[0 1 0],'EdgeColor',[1 0 0],'BackgroundColor',[0 0 0],'FontSize',35,'HorizontalAlignment','center');
        % petit delay
        for (w =1:1:150)
            % imatge de fons
            a = vcapg2;
            set(hi,'CData',a);
            
            drawnow;
            refresh;
        end
        delete(h_text);
        
        % crear els breaks
        hold on;
        for (i=1:1:totxos.numero_maxim)

            totxo(i).x = posicio.x(i);
            totxo(i).y = posicio.y(i);
            
            totxo(i).visible = 1;
            totxo(i).contactes = posicio.dificultat(i); % contactes necessaris per desturir-lo
            
            totxo(i).h_totxo = fill(totxo(i).x + formatotxo.x, totxo(i).y + formatotxo.y, mapa_colors(totxo(i).contactes,:)); % visible per defecte
        end
        
        % crear les pilotes en l'extrem de la pantalla
        offset = 20;
        for (i=1:1:pilotes.num_maxim)
            
            offset = offset +5;
            
            pilota(i).x = offset;
            pilota(i).y = 230;

            pilota(i).visible = 1;
         
            offset = offset +10;
            pilota(i).h_pilota = plot(pilota(i).x,pilota(i).y,'g.','MarkerSize',22);
            
            % mil punts per cada pilota disponible
            partida.punts = partida.punts + 1000;
        end
        hold off;
        
        % reset del temps
        tic;
    else
       
        % imatge de fons
        if (blink)
            set(hi,'CData',(255-a));
            blink = 0;
        else
            set(hi,'CData',a);
        end
        
        % puntuacio
        set(h_punts,'string',num2str(partida.punts));

        if (pilotes.activa == 0)
            % s'ha de tirar una nova pilota
            partida.acabada = 1;
            
            for (i=1:1:pilotes.num_maxim)
                
                if (pilota(i).visible == 1)
                    % encara en queda alguna
                    pilotes.activa = i;
                    
                    % encara no s'ha acabat la partida
                    partida.acabada = 0;
                    
                    % assignar-li velocitat
                    pilotes.vely = -4;
                    pilotes.velx = 4;

                    % evitar rematar mentres puja
                    pilotes.per_rematar = 0;
                    
                    % treure punts
                    partida.punts = partida.punts - 1000;
                    break;
                end
            end
        end

        if (pilotes.activa > 0)
            % moure la pilota
            % actualitzar la seva posicio
            pilota(pilotes.activa).x = pilota(pilotes.activa).x + pilotes.velx;
            pilota(pilotes.activa).y = pilota(pilotes.activa).y + pilotes.vely;

            % limits horitzontals
            if (pilota(pilotes.activa).x < 20)
                pilotes.velx = - pilotes.velx*1.1;
                pilota(pilotes.activa).x = 20;
                
                if (sonido)
                    % so de contacte
                    stop(ao);putdata(ao,y_disparo_missil);start(ao);
                end
                
            elseif (pilota(pilotes.activa).x > 300)
                pilotes.velx = - pilotes.velx*1.1;
                pilota(pilotes.activa).x = 300;
                
                if (sonido)
                    % so de contacte
                    stop(ao);putdata(ao,y_disparo_missil);start(ao);
                end
            end

            % limits verticals
            if (pilota(pilotes.activa).y > 230)
                % hem sortit fora
                set(pilota(pilotes.activa).h_pilota,'Visible','off');
                
                pilota(pilotes.activa).visible = 0;

                pilotes.activa = 0;
                blink = 1;
                
                if (sonido)
                    % so de nova pilota
                    stop(ao);putdata(ao,y_nova_bola);start(ao);
                end

            elseif (pilota(pilotes.activa).y < 10)

                pilotes.vely = - pilotes.vely*1.1;
                pilota(pilotes.activa).y = 10;
                
                if (sonido)
                    % so de contacte
                    stop(ao);putdata(ao,y_disparo_missil);start(ao);
                end
            end

            if (pilotes.activa > 0)
                % pilota
                set(pilota(pilotes.activa).h_pilota,'XData',pilota(pilotes.activa).x,'YData', pilota(pilotes.activa).y);

                partida.superada = 1;

                % detectar xocs de la pilota amb els breaks
                for (i=1:1:totxos.numero_maxim)

                    if (totxo(i).visible)
                        % encada queda algun break

                        partida.superada = 0;
                        
                        contacte_x = abs(totxo(i).x - pilota(pilotes.activa).x);
                        contacte_y = abs(totxo(i).y - pilota(pilotes.activa).y);

                        if ((contacte_x < 12) && (contacte_y < 7))
                            % contacte
                            totxo(i).contactes = totxo(i).contactes -1;
                            
                            % invertir la trajectoria de la bola
                            if (contacte_x < 8)
                                % rebot frontal
                                pilotes.vely = - pilotes.vely;
                            else
                                % rebot lateral
                                pilotes.velx = - pilotes.velx;
                            end
                            
                            % incrementar punts
                            partida.punts = partida.punts + 10;

                            % amagar si cal
                            if (totxo(i).contactes <= 0)
                                totxo(i).visible = 0;
                                set(totxo(i).h_totxo,'Visible','off');
                                
                                partida.punts = partida.punts + 100;
                            else
                                % cambiar el color del totxo
                                set(totxo(i).h_totxo,'FaceColor',mapa_colors(totxo(i).contactes,:));
                            end

                            if (sonido)
                                % so de contacte
                                stop(ao);putdata(ao,y_disparo_bomba);start(ao);
                            end
                        end
                    end
                end
                
                % detectar el toque del jugador (moviment)
                c1 = detecta_moviment(a_old(:,:,1),a(:,:,1),[320 240 40 20]);

                % detectar toque a la pilota
                if (pilota(pilotes.activa).y > 160)

                    if (pilotes.per_rematar == 1)

                        fila = max([1 round(pilota(pilotes.activa).y/40)]);
                        columna = max([1 round(pilota(pilotes.activa).x/20)]);
                        if (c1(fila,columna,1) > 5)
                            % hem tocat la pilota
                            
                            % donar punts
                            partida.punts = partida.punts + 5;

                            % nomes se li pot pegar un cop
                            pilotes.per_rematar = 0;

                            potencia_pujada = double(c1(fila,columna,4)) - double(c1(fila,columna,5));
                            potencia_lateral = double(c1(fila,columna,2)) - double(c1(fila,columna,3));

                            if (potencia_pujada <= 0)
                                % enlentir
                                pilotes.vely = -1;
                            else
                                pilotes.vely = -potencia_pujada/4;
                            end

                            if (potencia_lateral == 0)
                                % invertir
                                pilotes.velx = -pilotes.velx;
                            else
                                % aplicar caña proporcional
                                pilotes.velx = -potencia_lateral/4;
                            end

                            if (sonido)
                                % so de contacte
                                stop(ao);putdata(ao,y_disparo_missil);start(ao);
                            end
                        end
                    end
                else
                    pilotes.per_rematar = 1;
                end
            end
        end
    end
    
	drawnow;
	refresh;
end,
set(findobj('Tag','WORKING'),'enable','on');

if (sonido)
    stop(ao);
    delete(ao);
end
% ###################################################################################