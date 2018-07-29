%% Display Start message
disp('Running PSK SER Simulation set')
%% Plot theoretical curves
SNRs = -4:24;
[h_fig, h_lines] = PSK_SER_Curves(SNRs);
%% Run Monte Carlo simulations

PSK_SER = zeros(5,length(SNRs));
hold on
simLines = semilogy(SNRs, PSK_SER,'*');

tic
[PSK_BER, PSK_SER] = PSK_Simulate(SNRs, simLines);
toc
%% Plot simulation results
% Simulation results are plotted inside the PSK_Simulate function
%% Add Legend
% Do MATLAB graphics magic to create concise legend
% See "Controling Legends" in MATLAB doc

% group lines together
simGrp = hggroup('DisplayName','Simulation');
theoGrp = hggroup('DisplayName','Theoretical');
set(simLines,'Parent',simGrp)
set(h_lines,'Parent',theoGrp)
set(get(get(simGrp,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on'); % Include this hggroup in the legend
set(get(get(theoGrp,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on'); % Include this hggroup in the legend
legend show

disp('Note: Fig. 5-2-10 in Proakis 3rd Edition is labeled incorrectly.')
disp('The y-axis in that figure should be labeled from 10^-5 at the bottom')
disp('rather than 10^-6.  All other labels should be corrected accordingly.')
disp('This figure has been corrected in the 4th Edition.')