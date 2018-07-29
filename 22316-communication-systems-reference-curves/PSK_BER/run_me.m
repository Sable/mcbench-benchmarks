%% Display Start message
disp('Starting PSK BER Simulation set.')
%% Plot theoretical curves
disp('Plotting theoretical curves.')
SNRs = -5:28;
[h_fig, h_lines] = PSK_BER_Curves(SNRs);
%% Run Monte Carlo simulations
disp('Running Monte Carlo simulations.')

PSK_BER = zeros(6,length(SNRs));
hold on
simLines = semilogy(SNRs, PSK_BER,'*');

tic
[PSK_BER, PSK_SER] = PSK_Simulate(SNRs, simLines);
toc
%% Plot simulation results
% Simulation results are plotted inside the PSK_Simulate function.

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

disp('Note that the BER for BPSK and QPSK signaling is identical.')