function Problem1_31
%Problem 1-31 Molecular diffusion in a ternary gas system, p.64 Text.
% Uses the function BVP4C to numerically solve the boundary-value problem.
% BVPINIT is used to form an initial guess for the solution on 
% a mesh of ten equally spaced points. Guesses for the unknown parameters 
% (the hydrogen and nitrogen fluxes) are the last argument of BVPINIT.
% BVP4C returns the solution as the structure 'sol'. The unknown fluxes are 
% returned in the field sol.parameters. The carbon dioxide flux is determined
% by the specified zero total flux. 
% The calculated concentration profiles are plotted.

solinit = bvpinit(linspace(0,1,10),[1, 1], [-0.01 0.01]);
options = bvpset('stats','on'); 
sol = bvp4c(@prob131ode,@prob131bc,solinit,options);
x = 86*sol.x;
y = sol.y;
y(3,:) = 1-y(1,:) -y(2,:);
N3 = -(sol.parameters(1)+sol.parameters(2));
fprintf('\n')
fprintf(' Computed N1 in mole/m2-s =%7.6f.\n',sol.parameters(1))
fprintf('\n')
fprintf(' Computed N2 in mole/m2-s=%7.6f.\n',sol.parameters(2))
fprintf('\n');
fprintf(' Computed N3 in mole/m2-s=%7.6f.\n',N3)
fprintf('\n')
clf reset
plot(x,y(1,:),'k-*',x,y(2,:),'k:+',x,y(3,:),'k-.o')
axis([0 90 0.2 0.5])
title('Concentration profiles in a ternary system') 
xlabel('Distance , mm.')
ylabel('Mole fraction')
legend('Hydrogen', 'Nitrogen', 'Carbon dioxide')
shg


% --------------------------------------------------------------------------

function dydx = prob131ode(x,y,N)
N(3)= -N(2) - N(1);
F12 = 0.039;
F13 = 0.031;
F23 = 0.07728;
dydx = [ (y(1)*N(2)-y(2)*N(1))/F12+(y(1)*N(3)-(1-y(1)-y(2))*N(1))/F13
         (y(2)*N(1)-y(1)*N(2))/F12+(y(2)*N(3)-(1-y(1)-y(2))*N(2))/F23 ];

% --------------------------------------------------------------------------
  
function res = prob131bc(ya,yb,N)
res = [ya(2)- 0.4 
      ya(1) - 0.2
      yb(2) - 0.2
      yb(1) - 0.5];
    
  
% --------------------------------------------------------------------------
  
