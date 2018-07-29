%% Simulation de monte carlo d'un actif de rpix Spot 100, de volatilité
% sigma, et de drift InterestRate. 
% Vincent Leclercq, The MathWorks, 2007. vincent.leclercq@mathworks.fr
clear all;
close all;
%% Starting parameters
tic;

nActifs = 2;
CorrelationMatrix = [1 0.9;0.9 1];
Vols = [0.5 0.9];
DivYelds = [0 0];
StartValues = [100 100];
ExpCovariance = corr2cov(Vols, CorrelationMatrix);
CholFactor    = chol(ExpCovariance);

InterestRate = 0.03;
TimeToMaturity = 0.5; % in years 

NSimulation  = 10000;
nSteps = 20;

%% Time Step
Dt = TimeToMaturity/nSteps;

%% Generate Random numbers

UniforRandom            = rand  (nSteps , NSimulation, nActifs );
CorrelatedRandomNumbers = zeros (nSteps , NSimulation, nActifs );
RandomNumbers           = norminv(UniforRandom,0,1);

%% To Store the result 

Paths = zeros (nSteps , NSimulation, nActifs);

%% Preserve Correlation for each realisation

for i = 1 : NSimulation
   CorrelatedRandomNumbers (:,i,:) = squeeze(RandomNumbers(:,i,:)) * CholFactor;
end


%%
for i = 1 : nActifs 
    % Generate the dt returns
    Paths(:,:,i) = exp( (InterestRate-DivYelds(i)-Vols(i)^2/2)*Dt + Vols(i)*sqrt(Dt).*  CorrelatedRandomNumbers (:,:,i));
    Paths(:,:,i) = cumprod(Paths(:,:,i), 1);
    Paths(:,:,i) = Paths(:,:,i) * StartValues(i);
    %                    
end;

%% Compare for the first time step the Simualtions of the 2 assets
h1 = figure;plot(Paths(1,:,1),Paths(1, : ,2),'r.');
set(h1,'WindowStyle','Docked');
ylim(gca(h1),xlim);


h2 = figure;plot(1 : 20 ,[Paths(:,1 ,1),Paths(:,1 ,2)],'-');
set(h2,'WindowStyle','Docked');

Correlationcoeff = corrcoef(Paths(:,:,1),Paths(:,:,2))