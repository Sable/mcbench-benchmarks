%% Modelo CNC
%% cargar modelo
    model_cnc = vrworld('cnc5.wrl');
    open(model_cnc)
    cnc3D = view(model_cnc);
    
%% Definicion de Nodos 
    H.puntero = vrnode(model_cnc, 'puntero');
    H.riel_horiz = vrnode(model_cnc, 'riel_horizontal');
    
% %% Inicializacion de objectos 
%     H.riel_horiz.translation = [-5 0.3 0];
%     H.puntero.translation = [ 0 0 -0.5];
    
 %% rutina 
    H.riel_horiz.translation = [-5 0.3 0];
    H.puntero.translation = [ 0 2.5 -0.5];
    
    %% desplazamiento del puntero atravez del riel que lo traslada
    
    pause(3)
    despl_p = 2.5:-0.01:-2.5;
    tan_desp = length(despl_p);
    global Puntero
        Puntero = H.puntero;
    % Avanzar de izquierda a derecha
%     fin = Despl_Puntero(1,100);
%     pause(2)
%     Bajar_Puntero()
%     pause(2)
%     fin1 = Despl_Puntero(100, 250);
%     pause(2)
%     Subir_Puntero()
%     fin2 = Despl_Puntero(250, 349);
%     Bajar_Puntero()
%     pause(2)
%     fin3 = Despl_Puntero(350, 400);
%     pause(2)
% %     Subir_Puntero()
% %     
% %     msgbox('Retornando', 'Retornando')
% %     Retorno_Puntero();
    
%% Avanzar un paso 
    global Riel
        Riel = H.riel_horiz;
%     Avanzar()
%     pause(4)
%     Avanzar()
%     Subir_Puntero()
%     msgbox('Retornando', 'Retornando')
%     Retorno_Puntero();