        % Rezolvarea unei ecuatii cu derivate partiale
        % direct din programul MAPLE
Sol=maple('pdesolve( diff(f(x,y),x,x)+5*diff(f(x,y),x,y)=3, f(x,y) )')