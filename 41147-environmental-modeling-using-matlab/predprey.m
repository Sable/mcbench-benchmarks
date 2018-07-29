function predprey
% Predator-prey time series and phase diagram    
%    using MATLAB ode                   
%
%   $Ekkehard Holzbecher  $Date: 2006/04/20 $
%--------------------------------------------------------------------------
T = 100;                 % maximum time
r = [.5; .5];            % single specie rates 
a = [1; 1];              % alpha parameter
c0 = [0.1; 0.1];         % initial population

%----------------------execution-------------------------------------------

options = odeset('AbsTol',1e-20);
[t,c] = ode15s(@PP,[0 T],c0,options,r,a);

%---------------------- graphical output ----------------------------------

subplot (2,1,1);
plot (c(:,1)',c(:,2)'); hold on;
legend ('trajectory');
xlabel ('prey'); ylabel ('predator');
subplot (2,1,2);
plot (t,c(:,1)','-',t,c(:,2)','--');
legend ('prey','predator');
xlabel ('time');

%---------------------- function ------------------------------------------

function dydt = PP(t,y,r,a)
dydt = zeros(2,1);
dydt(1) = y(1)*(r(1)-y(2)*a(1));
dydt(2) = y(2)*(-r(2)+y(1)*a(2));
