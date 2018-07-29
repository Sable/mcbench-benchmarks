function lorenza
% Lorenz convection model 

sigma = 16; rho = 45.92; beta = 4;  % parameters 
N = 1000;         % no. of time steps
span = 0.05;      % inner iteration span
AbsTol = 1.e-5;   % absolute tolerance for ODE solver
RelTol = 1.e-5;   % relative tolerance for ODE solver

H = figure; set(H,'DefaultLineLineWidth',1.0);
options = odeset('RelTol',RelTol,'AbsTol',ones(1,3)*AbsTol);
u0 = [1;1;1];
for i = 1:N
    [t,u] = ode45(@lornz,[0 span],u0,odeset,beta,rho,sigma);
    hold on; 
    plot(u(:,1),u(:,2),'r'); 
    u0 = u(end,:); 
end

title('Attractor of Lorenz System');
xlabel('Component 1'); ylabel('Component 2');
axis off; hold off;

function dydt = lornz(t,y,beta,rho,sigma)
dydt = [sigma*(y(2)-y(1)); rho*y(1)-y(2)-y(1)*y(3); y(1)*y(2)-beta*y(3)];