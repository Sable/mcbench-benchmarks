function Ex1_15
%Example 1.15 Multicomponent gaseous diffusion in a Stefan tube, p. 40 Text.
% Uses the function BVP4C to numerically solve the boundary-value problem.
% BVPINIT is used to form an initial guess for the solution on 
% a mesh of ten equally spaced points. A guess for unknown parameters 
% (the two fluxes) is the last argument of BVPINIT.
% BVP4C returns the solution as the structure 'sol'. The computed fluxes are 
% returned in the field sol.parameters.
% The calculated concentration profiles are plotted.

solinit = bvpinit(linspace(0,1,10),[1, 1], [0.001286, 0.001286]);
options = bvpset('stats','on'); 
sol = bvp4c(@ex115ode,@ex115bc,solinit,options);
x = 24*sol.x;
y = sol.y;
y(3,:) = 1-y(1,:) -y(2,:);
fprintf('\n');
fprintf(' Computed N1 in mole/m2-s =%7.6f.\n',sol.parameters(1))
fprintf('\n')
fprintf(' Computed N2 in mole/m2-s=%7.6f.\n',sol.parameters(2))
fprintf('\n')
clf reset
plot(x,y(1,:),'k-*',x,y(2,:),'k:+',x,y(3,:),'k-.o')
axis([0 25 0 1])
title('Concentration profiles in a Stefan tube') 
xlabel('Distance along the diffusion path, cm.')
ylabel('Mole fraction')
legend('Acetone', 'Methanol', 'Air')
shg


% --------------------------------------------------------------------------

function dydx = ex115ode(x,y,N)
N3 = 0;
F12 = 0.001286;
F13 = 0.002081;
F23 = 0.003019;
dydx = [ (y(1)*N(2)-y(2)*N(1))/F12+(y(1)*N3-(1-y(1)-y(2))*N(1))/F13
         (y(2)*N(1)-y(1)*N(2))/F12+(y(2)*N3-(1-y(1)-y(2))*N(2))/F23 ];

% --------------------------------------------------------------------------
  
function res = ex115bc(ya,yb,N)
res = [ya(2)-0.528 
       yb(2) 
       ya(1) - 0.319
       yb(1) ];
  
% --------------------------------------------------------------------------
  
