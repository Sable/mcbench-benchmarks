function varargout = Impresora3D(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Impresora3D_OpeningFcn, ...
                   'gui_OutputFcn',  @Impresora3D_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function Impresora3D_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
function varargout = Impresora3D_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function original_CreateFcn(hObject, eventdata, handles)
function Procesada_CreateFcn(hObject, eventdata, handles)
function Imagen_Impresa_CreateFcn(hObject, eventdata, handles)

function Abrir_Callback(hObject, eventdata, handles)

[nombre dire]=uigetfile('*.jpg;*.png','Escoger Imagen');
if nombre == 0
    return
end
imagen=imread(fullfile(dire,nombre));

[f c] = size(rgb2gray(imagen));

if f > 1000 || c > 500
    errordlg('Imagen demasiado grande, rango permitido 1000px x 500px','Error');
    img_error = imread('button_cancel.png');
    waitforbuttonpress
    axes(handles.original);
    imshow(img_error);
else
    axes(handles.original);
    imshow(imagen);
    handles.img = imagen;
    guidata(hObject, handles);
end

function Procesar_Callback(hObject, eventdata, handles)

imagen = handles.img;
img=rgb2gray(imagen);
[f c] = size(img);
axes(handles.Procesada);
imshow(img);
new = zeros(f,c);
global f
global c
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
 pause(2);
 axes(handles.Procesada);
 imshow(binarizada);
 
 retorn = zeros(f,1);
 for e=1:1:f
     retorn(e,1)=2;
 end
 binarizada=[binarizada retorn];
 MB=binarizada;
 dlmwrite('Matriz_Bin.txt', binarizada);
 %% Algoritmo de Secuencias
     
 global M_Control
 global M_Control_inv
 global M_Pasos
A=0;
P=0;
Msec  = cell(f,c);
Msec_inv= cell(f,c);
M_Control= cell(f,c);
M_Control_inv= cell(f,c);
M_Pasos= cell(f,c);
Fin  = 'SL_RC';  % se llenan con un espacio vacio , siendo este un idicador de fin de linea
for i = 1:1:f % estos for llenan la matriz con 'fin'
     for j = 1:1:c
         Msec(i,j)={Fin};
         Msec_inv(i,j)={Fin};
         M_Control(i,j)={Fin};
         M_Control_inv(i,j)={Fin};
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

function Imprimir_Callback(hObject, eventdata, handles)

        
 global M_Control
 global M_Control_inv
 global M_Pasos
%% Modelo VRML
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

    global f
    global c
    
        filp = f; % fila para plotear
        colp = c; % columna para plotear
        
        xmin = round(0 - colp/2);
        xmax = round(colp + colp/2);
        
        ymin = round(0 - filp/2);
        ymax = round(filp + filp/2);
        
        axes(handles.Imagen_Impresa);
        hold on
        axis([xmin xmax ymin ymax]);
        
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

