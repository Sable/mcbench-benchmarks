%function h = IsoFreeSurfaceSolver(xend, tend, N, Dt)
%**************************************************************************
%
% Solves nonlinear diffusion equation which can be linearised as shown for
% the general nonlinear diffusion equation in Richtmyer & Morton [1]. The
% approach is to linearise the pde and apply a Crank-Nicolson implicit
% finite difference scheme to solve the equation numerically.
%
% solves the pde:
%
%\frac{\partial h}{\partial t}=\frac{1}{12}\frac{\partial^2 h^4}{\partial x^2}
%
% The pde has the application to isothermal viscous fluid flow spreading on
% a horizonatal substrate under gravity - Huppert [2]. Note that PDE has
% been nondimensionlised.
%
% Initial conditions:
% 
% t=0: h = (1 - x^2)_{+} + 10^-6 (has prewetting film)
% 
% The spatial domain is discretised taking account of symmetry at x = 0:
%
% \frac{\partial h}{\partial x} = 0
%
% and is also used to close the free surface model at the end of the 
% discretised domain (x = xend) - assumes fluid won't reach this boundary.
%
% The pde can be solved analytically using similarity equations as 
% discussed by Barenblatt [3]; used below to validate numerical solution.
%
% Inputs:
%        xend - end of spatial domian
%        tend - run solver until time tend
%        N - number of spatial points
%        Dt - time step
%
% Outputs:
%        h - free surface matrix
%        mymovie.avi - creates movie of results
%
% Ahmos Sansom - May 2010
%
%**************************************************************************
%% Check inputs and discretised spatial domain.
close all;

% Suggested intputs
xend = 3.0;
tend = 50;
N = 1000;   % increase for accuracy
Dt = 0.01; % decrease for accuracy

% Check input data 
if  ~mod(tend,Dt)== 0
    error('Time step Dt must be a factor of tend')
end

% Initial spatial point at x=0.
x0 = 0.0;

% Spatial step
Dx = (xend - x0)/(N-1);

% Number of time steps
tSteps = tend/Dt;

% Initialise spatial and free surface profile.
x=zeros(N,1);
h=zeros(N,tSteps+1);

% set up time array and log for validation plots below
t = zeros(tSteps+1,1);
for i=1:tSteps+1
    t(i) = (i-1)*Dt;
end
tlog = log(t);

%% Initial conditions: set a parabolic profile with pre wetted surface
for i=1:N
    
    if (i-1)*Dx < 1.0
        h(i,1)= 1.0-(i-1)*Dx*(i-1)*Dx; % Set to 1.0 to check if the initial condition affects the solution...
    else
        h(i,1) = 1e-5;
    end
    
    x(i) = (i-1)*Dx;
end 

% Note t

% set up front location array
s = zeros(tSteps+1,1);
% and find front position
temp = find(h(:,1)<=1e-5);
s(1) = temp(1);

% create movie object
aviobj = avifile('mymovie.avi');
plot(x,h(:,1));
xlim([0 xend]);
ylim([0 1]);
title('Free surface spreading under gravity');
xlabel('x');
ylabel('h(x,t)');
F(1) = getframe;
aviobj = addframe(aviobj,F(1));

       
%% Time March the Crank Nicolson finite difference scheme

%Set up constants and intialise arrays:
rx  = Dt/(12.0*Dx*Dx);
d = zeros(N,1);
TriDiag = zeros(N,3);
w = zeros(N,1);

% Counter for movie
count = 1;

for n=1:tSteps  % Time step
    
    % at x = 0 take advantage of symmetry
    d(1) = 2.0* rx * ( -h(1,n)^4 + h(2,n)^4);
    
    % Set up initial tridiagonal matrix
    TriDiag(1,1) = 0.0;
    TriDiag(1,2) = 1.0 + 4.0 * rx * h(1,n)^3;
    TriDiag(1,3) = -4.0 * rx * h(2,n)^3;
    
    for i=2:N-1  % spatial step
        d(i) = rx * ( h(i-1,n)^4 - 2.0*h(i,n)^4 + h(i+1,n)^4 );

        % Set up tridiagonal matrix
        TriDiag(i,1) = -2.0 * rx * h(i-1,n)^3;
        TriDiag(i,2) = 1.0 + 4.0 * rx * h(i,n)^3;
        TriDiag(i,3) = -2.0 * rx * h(i+1,n)^3;

    end

    % at x = end take advantage of symmetry
    d(N) = 2.0* rx * ( -h(N,n)^4 + h(N-1,n)^4);
    
    % Set up end boundary condition of tridiagonal matrix
    TriDiag(N,1) = -4.0 * rx * h(N-1,n)^3;
    TriDiag(N,2) = 1.0 + 4.0 * rx * h(N,n)^3;
    TriDiag(N,3) = 0.0;
    
    % solve tridiagonal matrix using Thomas algorithm
    w = ThomasAlgorithm(TriDiag, d);
    
    % update free surface    
    h(:,n+1) = h(:,n) + w;
    
    % find front location
    temp = find(h(:,n+1)<=1.0e-5);
    s(n+1) = temp(1);
    
    % send every 100th result to movie frame
    if mod(n,100) == 0
       count = count  +1; 
       plot(x,h(:,n+1));
       title('Free surface spreading under gravity');
       xlabel('x');
       ylabel('h(x,t)');
       xlim([0 3]);
       ylim([0 1]);
       F(count) = getframe;
       aviobj = addframe(aviobj,F(count));
    end   
    
end

% close and save
aviobj = close(aviobj);

%% Validation

% The mass should be conserved and is proportional to the sum of each free
% surface profile.
mass = sum(h);

% gradient of mass should be approximately zero.

% Check hmax agrees with similarity solution: hmax ~ t^(-1/5)

% create log-log plot and gradient should be 0.2 for long term solution
hmax = log(h(1,:));
createhmaxfigure(tlog(end-1000:end),hmax(end-1000:end),1);

% Check front location agrees with similarity solution: s ~ t^(1/5)
s = (s-1) * Dx;   % convert to x
logs = log(s)';   % take log
createhmaxfigure(tlog(end-1000:end),logs(end-1000:end),2);

%% References

% [1] "Difference Methods for initial value problems," R. D. Richtmyer and 
% K. W. Morton, John Wiley and Sons, 1967. 

% [2] "The Propagation of two-dimensional and axisymmetric visous gravity
% currents over a rigid horizontal surface," H. E. Huppert, Journal of
% Fluid Mechanics, 1982.

% [3] "On some unsteady motions of a liquid or gas in a porous medium,
% Russian journal Prikladnaya Matematika i Mekhanika, 1952.

