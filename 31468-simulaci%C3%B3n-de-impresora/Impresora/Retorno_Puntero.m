function Retorno_Puntero()
    global Puntero
        vect_Punt = getfield(Puntero, 'translation');
        Pos_actual = vect_Punt(1,2);
            despl_retor = Pos_actual:0.01:2.5;
        for r=1:length(despl_retor)
            Puntero.translation = [ 0 despl_retor(r) vect_Punt(1,3)];
            pause(0.01);
        end
end