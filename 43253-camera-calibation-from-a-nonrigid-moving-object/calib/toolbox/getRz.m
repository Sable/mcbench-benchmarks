function Rz = getRz(z)
% get 3x3 rotation matrix about z
%
% © Copyright Phil Tresadern, University of Oxford, 2006

Rz = getR(z,'z');
return

	cz	= cos(z);	sz	= sin(z);
	Rz 	= [	cz 	-sz 0;
					sz 	cz 	0;
					0 	0 	1];
