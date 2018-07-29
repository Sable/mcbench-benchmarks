function  [filenam pathnam]=recibetodo
[filenam,  pathnam] =  uigetfile({'*.$2k'},...%
                                          'seleccione el archivo');      % seleciconando el archivo
    if filenam == 0   
        % si no se selecciona  
    else
        filenam
        pathnam

%     finp=fopen(filenam,'r');
    end