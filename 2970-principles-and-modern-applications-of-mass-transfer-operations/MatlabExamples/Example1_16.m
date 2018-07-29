function Example1_16
%Example 1.16 Multicomponent gaseous diffusion with chemical reaction, p.44 Text.
% Uses the function BVP4C to numerically solve the boundary-value problem.
% BVPINIT is used to form an initial guess for the solution on 
% a mesh of ten equally spaced points. A guess for the unknown parameter 
% (the ethanol flux) is the last argument of BVPINIT.
% BVP4C returns the solution as the structure 'sol'. The ethanol flux is 
% returned in the field sol.parameters. The other two fluxes are determined
% by stoichiometry. The calculated concentration profiles are plotted.

solinit = bvpinit(linspace(0,1,10),[1, 1], 1.601);
options = bvpset('stats','on'); 
sol = bvp4c(@ex116ode,@ex116bc,solinit,options);
x = sol.x;
y = sol.y;
y(3,:) = 1-y(1,:) -y(2,:);
fprintf('\n')
fprintf(' Computed N1 in mole/m2-s =%7.6f.\n',sol.parameters)
fprintf('\n')
fprintf(' Computed N2 in mole/m2-s=%7.6f.\n',-sol.parameters)
fprintf('\n');
fprintf(' Computed N3 in mole/m2-s=%7.6f.\n',-sol.parameters)
fprintf('\n')
fprintf(' Interfacial ethanol mole fraction = %7.6f.\n',sol.y(1,10))
fprintf('\n')
fprintf(' Interfacial acetaldehyde mole fraction = %7.6f.\n',sol.y(2,10))
fprintf('\n')
clf reset
plot(x,y(1,:),'k-*',x,y(2,:),'k:+',x,y(3,:),'k-.o')
axis([0 1 0 0.6])
title('Concentration profiles with chemical reaction') 
xlabel('Distance from the bulk of the gas phase, mm.')
ylabel('Mole fraction')
legend('Ethanol', 'Acetaldehyde', 'Hydrogen')
shg


% --------------------------------------------------------------------------

function dydx = ex116ode(x,y,par)
N(1) = par;
N(2) = -par;
N(3) = -par;
F12 = 1.601;
F13 = 5.114;
F23 = 5.114;
dydx = [ (y(1)*N(2)-y(2)*N(1))/F12+(y(1)*N(3)-(1-y(1)-y(2))*N(1))/F13
         (y(2)*N(1)-y(1)*N(2))/F12+(y(2)*N(3)-(1-y(1)-y(2))*N(2))/F23 ];

% --------------------------------------------------------------------------
  
function res = ex116bc(ya,yb,par)
kr = 10;
res = [ya(2)- 0.2 
      ya(1) - 0.6
      yb(1) - par/kr];
    
  
% --------------------------------------------------------------------------
  
