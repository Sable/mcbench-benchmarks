function Rx = getRx(x)
% get 3x3 rotation matrix about x
%
% © Copyright Phil Tresadern, University of Oxford, 2006

Rx = getR(x,'x');
return

	cx	= cos(x);	sx	= sin(x);

	Rx 	= [	1 	0 	0;
					0 	cx	-sx;
					0 	sx 	cx];
