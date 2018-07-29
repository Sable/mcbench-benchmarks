%
% VLINJEFUNC
%
% Hittar ,givet ett x värde, y värdet där vikingaskeppet skär
% vattenytan. Utnyttjar 'spunkter' som är kända skärningar.

function stop=vlinjefunc(x,spunkter,search)
	if search>size(spunkter,1) | x<spunkter(1,1)
		stop=0;
	else
		if x>spunkter(search,1)
			stop=vlinjefunc(x,spunkter,search+1);
		else
			stop=spunkter(search,2);
		end
	end
