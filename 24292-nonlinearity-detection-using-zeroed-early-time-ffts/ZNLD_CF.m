global ZNLD
% ZNLD.Hmat ZNLD.ws ZNLD.ts_zc ZNLD.fline_ind ZNLD.lhands

% Messages to user
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp('Curve Fitting Initialized')
disp('Click on finished under AMI-Menu on Figure 1000 when finished');
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');

% Get the index of the currently selected line on figure 102
fit_lineh = gco;
ZNLD.fline_ind = get(fit_lineh,'UserData');
    if isempty(fit_lineh) | isempty(get(get(fit_lineh,'Parent'),'Parent'))
        error('No Line on Figure 102 was selected. Select a line and run the script again.');
    end
    if get(get(fit_lineh,'Parent'),'Parent') ~= 102;
        error('No Line on Figure 102 was selected. Select a line and run the script again.');
    end

% Increase this line's width
set(gco,'LineWidth',2);
% save debugdata.mat

% Create ZNLD.lhands if needed
if ~isfield(ZNLD,'lhands')
    ZNLD.lhands.hands = []; ZNLD.lhands.legend = [];
end

    % Add this to the list of lines to keep - this should be the first in
    % the list.
    ZNLD.lhands = [];
    ZNLD.lhands.hands = fit_lineh;
    ZNLD.lhands.legend{1} = num2str(ZNLD.ts_zc(ZNLD.fline_ind)*1e3,3);

% Run AMI
global AMI_set
if isempty(AMI_set); % one can specify these earlier.
    AMI_set = AMIG_def_opts;
    % Modify some options for ZNLD
    AMI_set.IsolIter = 200; % Iterations are fast for this data - do lots
    AMI_set.AutoSubLevel = 1.1; % Don't keep any modes automatically
    AMI_set.FRF_RF = 0; % So AMI won't ask if you want to do a higher order fit.
    AMI_set.ShowIsolSteps = 'n'
end

% AMI_set.DVA = 'A';
% These are Accelerations, but this doesn't work so well.  Maybe the
% spectrum is not flat?  Maybe Mode at DC causes this artifact?

ami(ZNLD.Hmat(:,ZNLD.fline_ind),ZNLD.ws,AMI_set);

    % Bring in data and wait until AMI is done
    global AMIMODES AMIDISPLAY AMIDATA AMI_set
    waitfor(AMIDISPLAY.hmain,'UserData','finished');

Hfit = sum(AMIMODES.X_model,4);

% Add line to figure
figure(102);
hl = line(ZNLD.ws/2/pi,abs(Hfit),'Color','k','LineWidth',3,'LineStyle',':',...
    'UserData',['Fit ',num2str(ZNLD.fline_ind)])
    % Note:  A robust version of this program would have a plotting
    % function that would add lines to the plot so that changes could be
    % made in one place only.

    % Add this to the list of lines to keep
    ZNLD.lhands.hands = [ZNLD.lhands.hands; hl];
    ZNLD.lhands.legend{length(ZNLD.lhands.legend)+1} = ['Fit to ',num2str(ZNLD.ts_zc(ZNLD.fline_ind)*1e3,3)];

% Add Data to ZNLD structure
ZNLD.lam_fit = AMIMODES.mode_store(:,3);
ZNLD.A_fit = AMIMODES.A_store;



    