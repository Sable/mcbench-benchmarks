function [ pos_fin ] = Despl_Puntero(pos_ini, pos_fin)
    global Puntero
    pos_fin = pos_ini + pos_fin;
    vect_Punt = getfield(Puntero, 'translation');
    despl_p = 2.5:-0.01:-2.5;
        for a = pos_ini:1:pos_fin
            Puntero.translation = [ 0 despl_p(a) vect_Punt(1,3)];
            pause(0.01);
        end
end
