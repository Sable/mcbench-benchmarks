function Avanzar(mod)
     global Riel
     vect_riel = getfield(Riel, 'translation');
  if mod == 1   
     Riel.translation = [(vect_riel(1,1)+0.01) vect_riel(1,2) vect_riel(1,3)];
  elseif mod == 2   
     for r = vect_riel(1,1):-0.01:-5
         Riel.translation = [ r vect_riel(1,2) vect_riel(1,3)];
         pause(0.01)
     end
  end
  
end