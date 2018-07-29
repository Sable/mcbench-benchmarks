function [PD,ires]=jacpend(t,y,yp,cj,rpar)

g = rpar(1);
L = rpar(2);
dae_index = rpar(3);

PD = zeros(5,5);
PD(1,1) = cj;
PD(1,3) = -1;
PD(2,2) = cj;
PD(2,4) = -1;
PD(3,1) = y(5);
PD(3,3) = cj;
PD(3,5) = y(1);
PD(4,2) = y(5);
PD(4,4) = cj;
PD(4,5) = y(2);
 
switch (dae_index)
	case 0
 	% index 0 formulation
	 PD(5,4) = 3*y(4)*g/(L*L);
	 PD(5,5) = cj;
	 PD(5,2) = -g;
	case 1
	% index 1 formulation
	 PD(5,3) = y(3);
	 PD(5,4) = y(4);
	 PD(5,5) = -L*L;
	case 2
 	% index 2 formulation
	 PD(5,1) = y(3);
	 PD(5,2) = y(4);
	 PD(5,3) = y(1);
	 PD(5,4) = y(2);
	case 3
 	% index 3 formulation
	 PD(5,1) = 2*y(1);
	 PD(5,2) = 2*y(2);
	otherwise
      disp('Invalid index.')
      ires = -1;
end
PD=PD'; % The iteration matrix must be transposed (due to Matlab storage style)
ires = 0;
