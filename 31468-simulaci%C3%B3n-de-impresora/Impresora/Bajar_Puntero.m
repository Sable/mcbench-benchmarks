function Bajar_Puntero()
    global Puntero
        bajar_P = -0.5:0.1:0.5;
        vect_Punt = getfield(Puntero, 'translation');
        for b=1:length(bajar_P)
            Puntero.translation = [0 vect_Punt(1,2) bajar_P(b)];
            pause(0.01);
        end
end