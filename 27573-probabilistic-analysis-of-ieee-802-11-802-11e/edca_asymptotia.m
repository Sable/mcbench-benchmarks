% The script runs a number of simulations showing asymptotic convergence
% of the simulations to the theory, plots boxplots

% (c) 2013 Pavel Rajmic, Brno University of Technology, Czech Republic


close all
clc

%% input parameters
load scenarios
matrix = M1 %select scenario

station = 2; %station of interest

% bunches = [10 50 100 500];
bunches = [10 50 100 500 1000 5e3 1e4 5e4 1e5];

repeat = 10;

%% prepare outputs
output = zeros(0,size(matrix,1)+1);
groups = zeros(0,1);

%% perform simulations
for cnt_b = 1:length(bunches)
    for cnt_r = 1:repeat
        [freq_coll, freq_win] = edca_simulation(matrix, bunches(cnt_b));
        output = [output; freq_win, freq_coll];
        groups = [groups; bunches(cnt_b)];
    end
end

%% plot results
figure
boxplot(output(:,station),groups)
title(['Boxplot of frequencies: station no. ' num2str(station) ' wins'])
xlabel('Number of trials per simulation')

figure
boxplot(output(:,end),groups)
title(['Boxplot of frequencies: collision occurs'])
xlabel('Number of trials per simulation')