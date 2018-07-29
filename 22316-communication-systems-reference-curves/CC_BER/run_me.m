%% Display Start message
disp('Running Convolutional Codes BER Simulation set')

disp('By default, this script does not run the Monte Carlo simulations.')
disp('It simply loads results from a previous run.')
sim_mode = input('Do you want to (R)un simulations or (L)oad results from disk? [R/L]','s');
if isempty(sim_mode)
    sim_mode = 'l';
end
sim_mode = lower(sim_mode);

%% Plot theoretical curves
[h_fig, h_lines] = ConvCode_BER_Curves;
%% Run Monte Carlo simulations
disp('By default, this script does not run the Monte Carlo simulations.')
disp('It simply loads results from a previous run.  If you are interested in')
disp('running the simulations, edit run_me.m and uncomment the following')
disp('line:  CC_BER = ConvCode_Simulate;')

SNRs = 0:0.5:7;
total_time = tic;
% Pre-allocate
CC_BER = zeros(6,length(SNRs));
figure(h_fig)
drawnow
if strcmp(sim_mode,'r')
    hold on
    % Create place-holder plots
    simLines = semilogy(SNRs, CC_BER,'*-');
    CC_BER = ConvCode_Simulate(SNRs, simLines);
else
    % Load from Disk (NO SIMULATIONS ARE RUN)
    load CC_BER  % Loads simulation results from disk instead of running them
    hold on
    simLines = semilogy(SNRs, CC_BER,'*-');
end
toc(total_time)

%% Plot simulation results
% hold on
% simLines = semilogy(0:0.5:7, CC_BER);

%% Add Legend
% Do MATLAB graphics magic to create concise legend
% See "Controling Legends" in MATLAB doc

% group lines together
simGrp = hggroup('DisplayName','Simulation');
theoGrp = hggroup('DisplayName','Theoretical Bound');
set(simLines,'Parent',simGrp)
set(h_lines,'Parent',theoGrp)
set(get(get(simGrp,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on'); % Include this hggroup in the legend
set(get(get(theoGrp,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','on'); % Include this hggroup in the legend
legend show

figure1 = h_fig;
annotation(figure1,'textarrow',[0.3489 0.4267],[0.3911 0.4381],...
    'TextEdgeColor','none',...
    'TextBackgroundColor',[1 1 1],...
    'String',{'Soft-decision','Decoding'});

% Create textarrow
annotation(figure1,'textarrow',[0.3911 0.4956],[0.2974 0.3603],...
    'TextEdgeColor','none',...
    'TextBackgroundColor',[1 1 1],...
    'String',{'3-bit quantization'});

% Create textbox
annotation(figure1,'textbox',[0.5985 0.5804 0.1164 0.04873],...
    'String',{'Hard-decision','Decoding'},...
    'HorizontalAlignment','center',...
    'LineStyle','none',...
    'BackgroundColor',[1 1 1]);

