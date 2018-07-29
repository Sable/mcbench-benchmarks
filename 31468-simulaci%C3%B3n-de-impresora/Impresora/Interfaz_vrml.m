%% Modelo CNC
%% cargar modelo
    model_cnc = vrworld('cnc5.wrl');
    open(model_cnc)
    cnc3D = view(model_cnc);    
%% Definicion de Nodos 
    H.puntero = vrnode(model_cnc, 'puntero');
    H.riel_horiz = vrnode(model_cnc, 'riel_horizontal');
%% Posicion inicial   
    H.riel_horiz.translation = [-5 0.3 0];
    H.puntero.translation = [ 0 2.5 -0.5];
%%
    global Puntero
        Puntero = H.puntero;
    global Riel
        Riel = H.riel_horiz;
%% Algoritmo de lectura de matrices    
    global M_Control
    global M_Pasos
    global f
    global c
    
        filp = f; % fila para plotear
        colp = c; % columna para plotear
        
        xmin = round(0 - colp/2);
        xmax = round(colp + colp/2);
        
        ymin = round(0 - filp/2);
        ymax = round(filp + filp/2);
        
        figure
        hold on
        axis([xmin xmax ymin ymax]);
        
   tic 
    ini = 1;
    fin = 1;
    for i = 1:f %f
        for j = 1:c %c
              senial_control = M_Control(i,j);
              Cantidad = M_Pasos(i,j);
              fprintf('[%d, %d] -> Control %s , pasos %s \n' , i, j, char(senial_control) , char(Cantidad));
              if strcmp(senial_control, 'A')
                   fin = str2double(cell2mat(Cantidad));
                   fin  = Despl_Puntero(ini, fin);
                   ini = fin;
              elseif strcmp(senial_control, 'P')
                   Bajar_Puntero()
                   fin = str2double(cell2mat(Cantidad));
                   fin  = Despl_Puntero(ini, fin);
                   plot(ini:0.1:fin, filp, 'b'); 
                   ini = fin;
                   Subir_Puntero()
              elseif strcmp(senial_control, 'SL_RC')
                  fprintf('Salto de linea\n');
                  ini = 1;
                  fin = 1;
                  Retorno_Puntero()
                  Avanzar(1)
                  break
              elseif strcmp(senial_control, 'EOF')
                  msgbox('Fin de Impresión','Mensaje')
                  Retorno_Puntero()
                  Avanzar(2)
                  break
              end
        end
        filp = filp - 1;
    end
toc