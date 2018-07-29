function [res,ires]=pend(t,y,yp,rpar)

g = rpar(1);
L = rpar(2);
dae_index = rpar(3);

res(1) = yp(1) - y(3);
res(2) = yp(2) - y(4);
res(3) = yp(3) + y(5)*y(1);
res(4) = yp(4) + y(5)*y(2) + g;

switch (dae_index)
	case 0
   	res(5) = yp(5) + 3*y(4)*g/(L*L); % index 0 formulation
	case 1
   	res(5) = y(3)*y(3)+y(4)*y(4)-g*y(2)-L*L*y(5); % index 1 formulation
	case 2
  	 	res(5) = y(1)*y(3)+y(2)*y(4); % index 2 formulation
	case 3
   	res(5) = y(1)*y(1)+y(2)*y(2)-L*L; % index 3 formulation
	otherwise
      disp('Invalid index.')
      ires = -1;
end

ires = 0;
