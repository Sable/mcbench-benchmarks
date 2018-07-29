
% -----------------------------------------------------------------  %
% Matlab Programs included the Appendix B in the book:               %
%  Xin-She Yang, Engineering Optimization: An Introduction           %
%                with Metaheuristic Applications                     %
%  Published by John Wiley & Sons, USA, July 2010                    %
%  ISBN: 978-0-470-58246-6,   Hardcover, 347 pages                   %
% -----------------------------------------------------------------  %
% Citation detail:                                                   %
% X.-S. Yang, Engineering Optimization: An Introduction with         %
% Metaheuristic Application, Wiley, USA, (2010).                     %
%                                                                    % 
% http://www.wiley.com/WileyCDA/WileyTitle/productCd-0470582464.html % 
% http://eu.wiley.com/WileyCDA/WileyTitle/productCd-0470582464.html  %
% -----------------------------------------------------------------  %
% ===== ftp://  ===== ftp://   ===== ftp:// =======================  %
% Matlab files ftp site at Wiley                                     %
% ftp://ftp.wiley.com/public/sci_tech_med/engineering_optimization   %
% ----------------------------------------------------------------   %

% Simulated Annealing (by X-S Yang, Cambridge University)            %
% Usage: B2_sa                                                       %
% For the constrained optimization, please see the file: sa_mincon.m %
% ------------------------------------------------------------------ %

disp('Simulating ... it will take a minute or so!');
% Rosenbrock's function with f*=0 at (1,1)
fstr='(1-x)^2+100*(y-x^2)^2';
% Convert into an inline function
f=vectorize(inline(fstr));
% Show the topography of the objective function
range=[-2 2 -2 2];
xgrid=range(1):0.1:range(2); ygrid=range(3):0.1:range(4);
[x,y]=meshgrid(xgrid,ygrid);
surfc(x,y,f(x,y));
% Initializing parameters and settings
T_init = 1.0;       % Initial temperature
T_min =  1e-10;     % Finial stopping temperature
F_min = -1e+100;    % Min value of the function
max_rej=5000;       % Maximum number of rejections
max_run=500;        % Maximum number of runs
max_accept = 250;   % Maximum number of accept
k = 1;              % Boltzmann constant
alpha=0.95;         % Cooling factor
Enorm=1e-8;         % Energy norm (eg, Enorm=1e-8)
guess=[2 2];        % Initial guess
% Initializing the counters i,j etc
i= 0; j = 0; accept = 0; totaleval = 0;
% Initializing various values
T = T_init;
E_init = f(guess(1),guess(2));
E_old = E_init; E_new=E_old;
best=guess;  % initially guessed values
% Starting the simulated annealling
while ((T > T_min) & (j <= max_rej) & E_new>F_min)
    i = i+1;
    % Check if max numbers of run/accept are met
    if (i >= max_run) | (accept >= max_accept)
    % Cooling according to a cooling schedule
        T = alpha*T;
        totaleval = totaleval + i;
        % reset the counters
        i = 1;  accept = 1;
    end
    % Function evaluations at new locations
      ns=guess+rand(1,2)*randn;
      E_new = f(ns(1),ns(2));
    % Decide to accept the new solution
    DeltaE=E_new-E_old;
    % Accept if improved
    if (-DeltaE > Enorm)
        best = ns; E_old = E_new;
        accept=accept+1;   j = 0;
    end
    % Accept with a small probability if not improved
    if (DeltaE<=Enorm & exp(-DeltaE/(k*T))>rand );
        best = ns; E_old = E_new;
        accept=accept+1;
    else
        j=j+1;
    end
    % Update the estimated optimal solution
    f_opt=E_old;
end
% Display the final results
disp(strcat('Obj function  :',fstr));
disp(strcat('Evaluations   :', num2str(totaleval)));
disp(strcat('Best  solution:', num2str(best)));
disp(strcat('Best objective:', num2str(f_opt)));



