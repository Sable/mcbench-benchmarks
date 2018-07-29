function Subir_Puntero()
    global Puntero
        subir_P = 0.5:-0.1:-0.5; 
        vect_Punt = getfield(Puntero, 'translation');
        for s=1:length(subir_P)
            Puntero.translation = [0 vect_Punt(1,2) subir_P(s)];
            pause(0.01);
        end
end