%% Adquisión de la imagen 
%%
tic
clear, clc;
    % resolucion maxima de la imagen 1000 filas x 500 columnas! 
%  img= imread('Shakira.jpg');
 img = imread('cuadrado.jpg');
%  img = imread('evo.jpg');
%  img = imread('anime.jpg');
%  img =  imread('imagenes/SPYBOT.png');
imshow(img);

figure
img=rgb2gray(img);
imshow(img);

global f
global c
[f,c]=size(img);

fprintf(' * Número de filas es %d \n', f );
fprintf(' * Número de columnas es %d \n', c);

new = zeros(f,c);
%% Binarización
 for i = 1:1:f
     for j = 1:1:c
         if img(i,j) > 120 % definir umbral!
             new(i,j)=1;
         else
             new(i,j)=0;
         end
     end
 end
 binarizada=new;
 figure
 imshow(binarizada);
 
 if f > 1000 || c >500
    errordlg('Imagen demasiado grande, rango permitivo 1000px x 500px','Error')
    return
end
 %% Agregación del fin de linea y retorno de carro en la imagen
 retorn = zeros(f,1);
 for e=1:1:f
     retorn(e,1)=2;
 end
 binarizada=[binarizada retorn];
 MB=binarizada;
 dlmwrite('Matriz_Bin.txt', binarizada);
 % hasta este punto se tiene la matriz binarizada + un delimitador que
 % indica el termino de la linea 
 %%
%  Secuencia(A,f,c)
 %----------------------------------------------------------------
% aca se creean las matrices de secuencias tanto invertida con la matriz de
% secuencia original.

%% Inicializando Matrices
    global M_Control
    global M_Pasos
A=0;
P=0;
Msec  = cell(f,c);
Msec_inv= cell(f,c);
M_Control= cell(f,c);
M_Control_inv= cell(f,c);
M_Pasos= cell(f,c);
Fin  = 'SL_RC';  % se llenan con un espacio vacio , siendo este un idicador de fin de linea
for i = 1:1:f % estos for ienan la matriz con 'fin'
     for j = 1:1:c
       %  Msec(i,j)={Fin};
       %  Msec_inv(i,j)={Fin};
         M_Control(i,j)={Fin};
       %  M_Control_inv(i,j)={Fin};
         M_Pasos(i,j)={Fin};
     end
end
% 
%% Creando Matrices de Control y Matrices de Pasos
for x=1:1:f
    i=0; 
    for y=1:1:c
        if MB(x,y)==1
            A=A+1;
            if MB(x,y+1) == 1
                continue
            else
                i=i+1;
               secuen=['A',num2str(A)];
               secuen_inv=['P',num2str(A)];
               Msec(x,i)= {secuen};
               Msec_inv(x,i)={secuen_inv};
                
                M_Control(x,i)={'A'};
                M_Control_inv(x,i)={'P'};
                M_Pasos(x,i)={num2str(A)};
                A=0;
            end
        end
        
        if MB(x,y)==0
            P=P+1;
            if MB(x,y+1) == 0
                continue
            else
                i=i+1;
                secuen=['P',num2str(P)]; 
                secuen_inv=['A',num2str(P)];
                Msec(x,i)= {secuen};
                Msec_inv(x,i)={secuen_inv};
                M_Control(x,i)={'P'};
                M_Control_inv(x,i)={'A'};
                M_Pasos(x,i)={num2str(P)};
                P=0;
            end
        end
    end
end
%cellplot(Msec);
%% Agregando el indicador de fin de archivo EOF (End Of File)
Fin_Arc  = 'EOF';

    for ic = 1:c
        if strcmp(M_Control(f,ic), 'SL_RC')
            M_Control(f,ic) = {Fin_Arc};
            M_Control_inv(f,ic) = {Fin_Arc};
            M_Pasos(f,ic) = {Fin_Arc};
            break
        end
    end
toc   
%% Llamada al interfaz de comunicacion para controlar la simulacion
Interfaz_vrml