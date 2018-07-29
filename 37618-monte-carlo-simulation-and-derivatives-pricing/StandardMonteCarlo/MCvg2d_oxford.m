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



function y = MCvg2d_oxford(NBatches, NSim, Nt, rho, s)
% Discretization of a 2d Variance Gamma process
% Option pricing using the Monte Carlo simulation
% Schoutens / Leoni "Multivariate Smiling"

% Monte Carlo parameters
%NBatches = 1;           % Number of batches 
%NSim = 1;%100000;           % Number of paths per batch
%Nt = 250;                 % Number of time steps until T!
    
% Asset parameters
S0 = [1.0 1.0];             % spot price of stock index
r =  0.042;              % risk free rate
d =  [0.00 0.00];              % dividend yield
T = 0.5;                % Time horizon (in years)
lnS1 = zeros(NSim, Nt+1); % log spot prices asset 1
lnS2 = zeros(NSim, Nt+1); % log spot prices asset 2    

% Model parameters (theta, sigma, nu representation)
theta = [-0.6094 -0.8301];      % parameter of VG
sigma = [0.325 0.9406];         % parameter of VG
nu = 0.2570;                    % parameter of VG
omegaT = -1/nu * [log(1-theta(1)*nu - nu*sigma(1)^2/2) ...
    log(1-theta(2)*nu - nu*sigma(2)^2/2)];
drift = [r-d(1) r-d(2)];        % parameter of VG

%Corr = [1 .6495; .6495 1];
Corr = [1 rho; rho 1];
%Corr = [1 .9; .9 1];
%Corr = [1 -.9; -.9 1];
R = chol(Corr);

% Option parameters
value = ones(NBatches,1);       % Stores the option value per batch

% precomputed constants
deltaT = T / Nt;                % delta for time discretization
lnS1(:,1) = log(S0(1));         % Set the starting spot price
lnS2(:,1) = log(S0(2));

oNs = ones(NSim,1);    
% Start Monte Carlo here
tic;
for number = 1 : NBatches
    % Time discretization
    
    for m=1:Nt
        G = nu * gamrnd(deltaT/nu,oNs); % subordinator
        W = randn(NSim,2);              % std normals
        W = W*R;                        % correlated normals
        lnS1(:,m+1) = lnS1(:,m) + (drift(1)-omegaT(1)) * deltaT ...
                       + theta(1) * G + sqrt(G) * sigma(1) .* W(:,1);
        lnS2(:,m+1) = lnS2(:,m) + (drift(2)-omegaT(2))* deltaT ...
                      + theta(2) * G + sqrt(G) * sigma(2) .* W(:,2);
    end
    
    S1 = exp(lnS1);         % Simulated prices for asset 1
    S2 = exp(lnS2);         % Simulated prices for asset 2
    
    
    if(NSim ==1)
        figure1 = figure('Color', [1 1 1]);
        axes1 = axes('Parent',figure1);
        hold on;
        plot1 = plot(S1,'Parent',axes1,'MarkerSize',4,'Marker','o','Color',[0 0 0],'DisplayName','Asset 1');
        plot1 = plot(S2, 'Marker','.','Color',[0 0 0],'DisplayName','Asset 2');
        %plot(S1,'b');
        %plot(S2,'r');

        % Create xlabel
        xlabel('step');

        % Create ylabel
        ylabel('S(t)');

        % Create title
        title({'2d Variance Gamma Process',s},...
        'FontWeight','bold','FontSize',12,'FontName','Arial');

        % Create legend
        legend1 = legend(axes1,'show');
        set(legend1,'Position',[0.8206 0.831 0.08047 0.06204]);

    end
    
    % Option Pricing comment in the payoff you wish to use
    %value(number) = exp(-r*T)* WorstOfCall(S1,S2);
    value(number) = exp(-r*T)* BestOfCall(S1,S2);
    %value(number) = exp(-r*T)* Spread(S1,S2);

end

y= mean(value);      % Output of Option price
%Elapsed_Time = toc              % Time spend on MC simulation
end
