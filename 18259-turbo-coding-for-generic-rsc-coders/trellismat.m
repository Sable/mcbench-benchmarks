function trellismat

trellis = evalin('base','trellis');

% Hago una matriz cuya primera dimension sea el estado anterior, 
% la segunda el estado actual y la tercera la es el vector de salida 
%( 1: sistematico, 2: salida codif )

Mat = zeros(trellis.numStates,trellis.numStates,2);

% Mat(u',u,bits)
polar = [-1 ; +1];
for col = 1:2,
    for i = 1:trellis.numStates,
        Mat(i,trellis.nextStates(i,col)+1,1) = polar(col); 
        % la primera columna esta asociada a las transiciones del 0 (-1 
        % en polar)
        % la segunda columna esta asociada a las transiciones del 1 (+1 en
        % polar)
    end                                                    
end

for k = 1:trellis.numStates,
    for j = 1:trellis.numStates,
        % esta condicion detecta si la transicion de j a k es posible
        if Mat(j,k,1) ~= 0;
           % guardo en la matriz la salida codificada a partir del estado
           % actual y el bit entrante al codif; la paso a polar (0 -> -1 ,
           % 1 -> +1)
        Mat(j,k,2) = bin2polar(trellis.outputs(j, ...
            polar2bin(Mat(j,k,1)) + 1));
        end        
    end
end

assignin('base','Mat',Mat);