%% Display Start message
disp('Running QAM BER/SER Simulation set')
%% Plot theoretical curves
SNRs = -4:28;
disp('Plot theoretical curves')
[h_fig, h_lines] = QAM_BER_Curves(SNRs);
%% Run Monte Carlo simulations
disp('Run Monte Carlo Simulations')

% Create place-holder plots
QAM_BER = zeros(9,length(SNRs));
hold on
simLines = semilogy(SNRs, QAM_BER,'*');

tic
[QAM_BER, QAM_SER] = QAM_Simulate(SNRs, simLines);
toc
%% Plot simulation results
% The simulation results are plotted inside the QAM_Simulate function.

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

disp('This figure is identical to [1, Fig. 5].')
disp('[1] Cho, K., and Yoon, D., "On the general BER expression of one- and')
disp('    two-dimensional amplitude modulations", IEEE Trans. Commun.,')
disp('    Vol. 50, Number 7, pp. 1074-1080, 2002.')
