% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function MC_ou_clock  % Monte Carlo simulation for VG OU

intstep = 100;              % Discretisation for clock
step = 10;                  % Discretisation of [0,T]
allsteps = intstep * step;  % All steps that have to be simulated
T = 10;                     % Time horizon 

%%%%%%%%%%%%%%%%%%%%%%%% Parameter setting %%%%%%%%%%%%%%%%%%%
lambda = 1.6790;  % parameter of OU
a = 0.3484;       % parameter of OU
b = 0.7664;       % parameter of OU

%%%%%%%%%%%%%%%%%%%%%%%% Generating time change %%%%%%%%%%%%%%
yy = ones(1,allsteps+1);        % initializing matrix for OU process
Np = poissrnd(a*lambda*1/allsteps*T,allsteps);
       

for j = 1 : allsteps                  % generating OU process
    if Np(j) > 0
        Ex = -log(rand(Np(j),1))/b; % RVs with exponential law
        U = exp(-lambda * T / allsteps * rand(Np(j),1));          % Uniforms
        yy(j+1) = (1-lambda*T/allsteps)*yy(j) + sum(Ex .* U);
    else
        yy(j+1) = (1-lambda*T/allsteps)*yy(j);
    end
end

Tscale = ones(1,intstep*step+1); Tscale = cumsum(Tscale)*T/(intstep*step+1);
figure('Color', [1 1 1]);plot(Tscale,yy,'Color', [0 0 0]);

% Integrated clock - fast
ZZ = T*cumsum(yy,2)/allsteps;       %Integrated Time
Y = zeros(1,step+1);
Y(2:end) = ZZ(intstep:intstep:step*intstep);

figure('Color', [1 1 1]); hold on;
Tscale = ones(1,step+1); Tscale = cumsum(Tscale)*T/(step+1);
plot(Tscale,Y,'Color', [0 0 0],'Marker','v','LineStyle',':');

% Integrated clock - slow
for j = 1 : step
    xline = (j-1)*T/step : T/step/intstep : j*T/step;
    yline = yy((j-1)*intstep+1:j*intstep+1);
    Y(j+1) = Y(j) + trapz(xline,yline);
end
plot(Tscale,Y,'Color', [0 0 0], 'Marker','o','LineStyle','-'); hold off;
end
