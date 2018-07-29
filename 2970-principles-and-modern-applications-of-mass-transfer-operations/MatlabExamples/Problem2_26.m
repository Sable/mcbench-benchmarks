function Problem2_26
%Problem 2.26 Ternary condensation inside a vertical tube.
% Uses the function BVP4C to numerically solve the boundary-value problem.
% BVPINIT is used to form an initial guess for the solution on 
% a mesh of ten equally spaced points. A guess for unknown parameters 
% (the two fluxes) is the last argument of BVPINIT.
% BVP4C returns the solution as the structure 'sol'. The computed fluxes are 
% returned in the field sol.parameters.
% The calculated concentration profiles are plotted.

% Calculate the mass-transfer coefficients
Re = 9574;
density = 0.882;
viscosity = 0.00001602;
diameter = 0.0254;
% MS diffusion coefficients
D = [1.6*10^-5 1.444*10^-5 3.873*10^-5];
% Calculate Schmidt numbers
Sc(1) = viscosity/(density*D(1));
Sc(2) = viscosity/(density*D(2));
Sc(3) = viscosity/(density*D(3));
% Calculate Sherwood numbers
Sh(1) = 0.023*Re^0.83*Sc(1)^0.44;
Sh(2) = 0.023*Re^0.83*Sc(2)^0.44;
Sh(3) = 0.023*Re^0.83*Sc(3)^0.44;
% Molecular weight of pure components
M = [60.1 18 28];
y1 = [0.1123
      0.4246
      0.4631];
Mav1 = M*y1;
y2 = [0.1457
      0.1640
      0.6903];
Mav2 = M*y2;
Mav = (Mav1+Mav2)/2;
% Calculate total molar density
c = density/Mav;
F12 = Sh(1)*c*D(1)*1000/diameter;
F13 = Sh(2)*c*D(2)*1000/diameter;
F23 = Sh(3)*c*D(3)*1000/diameter;
solinit = bvpinit(linspace(0,1,10),[1, 1], [1, 1]);
options = bvpset('stats','on'); 
sol = bvp4c(@prob226ode,@prob226bc,solinit,options,F12,F13,F23);
x = sol.x;
y = sol.y;
y(3,:) = 1-y(1,:) -y(2,:);
fprintf('\n');
fprintf('Computed Mass-Transfer Coefficients:');
fprintf('\n');
fprintf('F12, mole/m2-s = %7.4f.\n',F12);
fprintf('\n');
fprintf('F13, mole/m2-s = %7.4f.\n',F13);
fprintf('\n');
fprintf('F23, mole/m2-s = %7.4f.\n',F23);
fprintf('\n');
fprintf(' Computed N1 in mole/m2-s =%7.4f.\n',sol.parameters(1))
fprintf('\n')
fprintf(' Computed N2 in mole/m2-s=%7.4f.\n',sol.parameters(2))
fprintf('\n')
clf reset
plot(x,y(1,:),'k-*',x,y(2,:),'k:+',x,y(3,:),'k-.o')
axis([0 1 0 0.7])
title('Concentration profiles in Problem 2.26') 
xlabel('Distance along the diffusion path, cm.')
ylabel('Mole fraction')
legend('Isopropanol', 'Water', 'Nitrogen')
shg


% --------------------------------------------------------------------------

function dydx = prob226ode(x,y,N,F12,F13,F23)
N3 = 0;

%F12 = 0.933;
%F13 = 0.880;
%F23 = 1.530;
dydx = [ (y(1)*N(2)-y(2)*N(1))/F12+(y(1)*N3-(1-y(1)-y(2))*N(1))/F13
         (y(2)*N(1)-y(1)*N(2))/F12+(y(2)*N3-(1-y(1)-y(2))*N(2))/F23 ];

% --------------------------------------------------------------------------
  
function res = prob226bc(ya,yb,N,F12,F13,F23)
res = [ya(2)-0.4246 
       yb(2) - 0.1640 
       ya(1) - 0.1123
       yb(1) - 0.1457 ];
  
% --------------------------------------------------------------------------
  
