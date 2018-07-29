%% Clear the environment
clear all;
close all;

%% Select a method
% 3 Choices : standard merssone twister (rand function), halton sequences ,
% or Sobol sequences

Method = 'Standard'; 

%% Create a Random Polygon
maxsize = 100;
NbMaxPoints = 8;

[xpoly, ypoly , h] =CreateConvexPolygon(maxsize,NbMaxPoints);

%% Compute tis real area using MATLAB function
disp(['Area of the polygon is ' num2str(polyarea(xpoly,ypoly)) ]);


%%
NbSimu = (10000 : 10000 : 50000)';
NbIter = numel(NbSimu);
CI   = zeros(NbIter,2);
Area = zeros(NbIter,1);
Time = zeros(NbIter,1);
CI_bis = zeros(NbIter,2);
StdUniforme = (1/12) * 100*100;
%%
for i = 1 : NbIter
    tic;
    [Area(i),CI(i,:)] = EstimateAreaMC(xpoly,ypoly,maxsize,NbSimu(i) ,100, Method,false);
    RelativePercent = 100 * (CI(i,2) - CI(i,1)) ./ (2 * Area(i));
    disp(['Computing with '   num2str(NbSimu(i)) ' simulations, and estimated Area is ' num2str(Area(i)) ' , + or - ' num2str(RelativePercent) '% at 95% confidence']);
    Time(i)= toc;
end

%% Display the results with the confidence interval
h = figure;
color = [0 1 0];
FaceAlpha = 0.4;


FillBetween(NbSimu,CI(:,1),CI(:,2),color,FaceAlpha);
hold on;
plot(NbSimu,Area,'LineWidth',1.5,'Color','r');
plot(NbSimu,repmat(polyarea(xpoly,ypoly),NbIter,1),'LineWidth',1.5,'Color','b');
xlim([NbSimu(1) NbSimu(end)]);
MyLimits = ylim;

%plot(NbSimu,CI,'g');

ylim(gca, [0.98.*min(CI(:,1)) 1.02 .* max(CI(:,2))]);
grid on;


%% Display the simulation time as a function of number of simulation

h3 = figure;
plot(NbSimu,Time);
save('Resultats.mat');