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



function MC_cir_clock   % Monte Carlo simulation for VG CIR

intstep = 100;  % Discretisation for clock
step = 10;      % Discretisation of [0,T]
allsteps = intstep*step;
T= 10;          % Time horizon

%%%%%%%%%%%%%%%%%%%%%%%% Parameter setting %%%%%%%%%%%%%%%%%%%
kappa = 1.2145;         % parameter of CIR
eta = 0.5501;           % parameter of CIR
lambda = 1.7913;        % parameter of CIR

%%%%%%%%%%%%%%%%%%%%%%%% Generating time change %%%%%%%%%%%%%%
yy = ones(1,allsteps+1);       % generating CIR process
deg = 4*eta*kappa/(lambda^2);  % degrees of freedom
fac1 = 4*kappa*exp(-kappa*T/allsteps)/lambda^2/(1-exp(-kappa*T/allsteps));
fac2 = lambda^2*(1-exp(-kappa*T/allsteps))/4/kappa;


for j = 1 : allsteps            % noncentrality parameter
    nonc = fac1*yy(:,j); 
    Nvec = poissrnd(nonc/2);
    CHIvec = chi2rnd(deg+2*Nvec);
    yy(:,j+1) = fac2 * CHIvec;
end


Tscale = ones(1,intstep*step+1); 
Tscale = cumsum(Tscale)*T/(intstep*step+1);
figure('Color', [1 1 1]);plot(Tscale,yy,'Color', [0 0 0]);

% Integrated clock - fast
ZZ = T*cumsum(yy,2)/(allsteps+1);               %Integration (simple)
Y = zeros(1,step+1);
Y(2:end) = ZZ(intstep:intstep:allsteps);

figure('Color', [1 1 1]);  hold on;
Tscale = ones(1,step+1); Tscale = cumsum(Tscale)*T/(step+1); 
plot(Tscale,Y,'Color', [0 0 0],'Marker','v','LineStyle',':');
    
% Integrated clock - slow
for j = 1 : step
    xline = (j-1)*T/step : T/step/intstep : j*T/step;
    yline = yy(1,(j-1)*intstep+1:j*intstep+1);
    Y(1,j+1) = Y(1,j) + trapz(xline,yline);
end
plot(Tscale,Y,'Color', [0 0 0], 'Marker','o','LineStyle','-'); hold off;
end


