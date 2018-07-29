function Ry = getRy(y)
% get 3x3 rotation matrix about y
%
% © Copyright Phil Tresadern, University of Oxford, 2006

Ry = getR(y,'y');
return

	cy	= cos(y);	sy	= sin(y);
	Ry 	= [	cy 	0 	sy;
					0 	1 	0;
					-sy 0 	cy];
