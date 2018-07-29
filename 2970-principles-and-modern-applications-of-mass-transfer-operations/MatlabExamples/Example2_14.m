function Example2_14
%Example 2-14 Ternary distillation in a wetted-wall column, p.104 Text.
% Uses the function BVP4C to numerically solve the boundary-value problem.
% BVPINIT is used to form an initial guess for the solution on 
% a mesh of ten equally spaced points. Guesses for the unknown parameters 
% (the benzene and toluene fluxes) are the last argument of BVPINIT.
% BVP4C returns the solution as the structure 'sol'. The unknown fluxes are 
% returned in the field sol.parameters. The ethylbenzene flux is determined
% by the specified zero total flux. 
% The calculated concentration profiles are plotted.

solinit = bvpinit(linspace(0,1,10),[1, 1], [-0.367 0.367]);
options = bvpset('stats','on'); 
sol = bvp4c(@ex214ode,@ex214bc,solinit,options);
x = sol.x;
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
axis([0 1 0 1])
title('Concentration profiles in a wetted-wall column') 
xlabel('Dimensionless distance.')
ylabel('Mole fraction')
legend('Benzene', 'Toluene', 'Ethylbenzene')
shg


% --------------------------------------------------------------------------

function dydx = ex214ode(x,y,N)
N(3)= -N(2) - N(1);
F12 = 0.367;
F13 = 0.351;
F23 = 0.328;
dydx = [ (y(1)*N(2)-y(2)*N(1))/F12+(y(1)*N(3)-(1-y(1)-y(2))*N(1))/F13
         (y(2)*N(1)-y(1)*N(2))/F12+(y(2)*N(3)-(1-y(1)-y(2))*N(2))/F23 ];

% --------------------------------------------------------------------------
  
function res = ex214bc(ya,yb,N)
res = [ya(2)- 0.2072 
      ya(1) - 0.7471
      yb(2) - 0.0995
      yb(1) - 0.8906];
    
  
% --------------------------------------------------------------------------
  
