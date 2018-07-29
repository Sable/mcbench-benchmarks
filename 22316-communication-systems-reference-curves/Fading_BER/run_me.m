%% Display Start message
disp('Running Fading Channel BER Simulation set')
disp('To produce smoother simulation curves, increase')
disp('maxNumErr inside Fading_Simulate.m to collect more')
disp('errors.')
disp('By default, this script does not run the Monte Carlo simulations.')
disp('It simply loads results from a previous run.')
sim_mode = input('Do you want to (R)un simulations or (L)oad results from disk? [R/L]','s');
if isempty(sim_mode)
    sim_mode = 'l';
end
sim_mode = lower(sim_mode);

%% Plot theoretical curves
SNRs = 0:25;
[h_fig, h_lines] = Fading_BER_Curves(SNRs);
%% Run Monte Carlo simulations
total_time = tic;
% Pre-allocate
fBER = zeros(6,length(SNRs));
figure(h_fig)
drawnow
if strcmp(sim_mode,'r')
    hold on
    % Create place-holder plots
    simLines = semilogy(SNRs, fBER,'*');
    fBER = Fading_Simulate(SNRs, simLines);
else
    % Load from Disk (NO SIMULATIONS ARE RUN)
    load fBER  % Loads simulation results from disk instead of running them
    hold on
    simLines = semilogy(SNRs, fBER,'*');
end
toc(total_time)

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

figure1 = h_fig;
% Create textbox
annotation(figure1,'textbox',[0.6046 0.6266 0.1248 0.04538],...
    'String',{'No Diversity'},...
    'EdgeColor','none',...
    'BackgroundColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',[0.63 0.4612 0.07359 0.04538],...
    'String',{'L = 2'},...
    'EdgeColor','none',...
    'BackgroundColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',[0.6018 0.3718 0.07359 0.04538],...
    'String',{'L = 3'},...
    'EdgeColor','none',...
    'BackgroundColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',[0.321 0.2733 0.08804 0.04538],...
    'String',{'AWGN'},...
    'EdgeColor','none',...
    'BackgroundColor',[1 1 1]);

% Create textarrow
annotation(figure1,'textarrow',[0.2853 0.4502],[0.5005 0.5],...
    'TextEdgeColor','none',...
    'TextBackgroundColor',[1 1 1],...
    'String',{'L = 4'});

% Create textarrow
annotation(figure1,'textarrow',[0.2912 0.4502],[0.4445 0.4455],...
    'TextEdgeColor','none',...
    'TextBackgroundColor',[1 1 1],...
    'String',{'L = 6'});

% Create textarrow
annotation(figure1,'textarrow',[0.3091 0.4517],[0.3945 0.3955],...
    'TextEdgeColor','none',...
    'TextBackgroundColor',[1 1 1],...
    'String',{'L = 8'});

figure(h_fig)