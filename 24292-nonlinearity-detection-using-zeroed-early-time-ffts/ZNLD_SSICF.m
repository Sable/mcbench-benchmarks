global ZNLD
% ZNLD.Hmat ZNLD.ws ZNLD.ts_zc ZNLD.fline_ind ZNLD.lhands

% Messages to user
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp('Stochastic Subspace Curve Fitting Initialized')
% disp('Click on finished under AMI-Menu on Figure 1000 when finished');
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

% Create ZNLD.lhands if needed
if ~isfield(ZNLD,'lhands')
    ZNLD.lhands.hands = []; ZNLD.lhands.legend = [];
end

	% Add this to the list of lines to keep - this should be the first in
    % the list.
    ZNLD.lhands.hands = fit_lineh; ZNLD.lhands.legend = [];
    ZNLD.lhands.legend{1} = num2str(ZNLD.ts_zc(ZNLD.fline_ind)*1e3,3);

% Low-pass filter and decimate data to try to help System ID
fs=1/(ZNLD.t(2)-ZNLD.t(1));   %Sampling freq
nu_lp = max(ZNLD.ws)*1.5/(2*pi*fs/2);
[b,a]=butter(8,nu_lp,'low'); 
a_filt=filtfilt(b,a,ZNLD.a);
n_decim = round(1/(2*nu_lp)); % gives new bandwidth = 2*lp filter bandwidth
a_filt = a_filt(1:n_decim:end);
t_filt = ZNLD.t(1:n_decim:end); % this may have different zero crossings

% Ask user how many block rows to use
% Typically: NBHank = 2 * (max order)/(#outputs)
nbh_str = inputdlg('Enter Number of Block Rows in Hankel Matrix (typically 2*max model order)',...
    'N Block Rows',1,{num2str(50)});
NBHank = str2num(nbh_str{1});
    
% Run SSI
% t_band = find(ZNLD.t >= ZNLD.ts_zc(ZNLD.fline_ind));
% [A,B,C,D,K,R] = subid(ZNLD.a(t_band),[],NBHank);
t_band = find(t_filt >= ZNLD.ts_zc(ZNLD.fline_ind));
[A,B,C,D,K,R] = subid(a_filt(t_band),[],NBHank);

% Convert eigenvalues to continuous time and sort
lamd = eig(A);
% lamc = ln(lamd)/(ZNLD.t(2)-ZNLD.t(1));
lamc = ln(lamd)/(t_filt(2)-t_filt(1));
[junk,sind] = sort(abs(lamc)+ 1e-4*abs(lamc).*(imag(lamc > 0)));
lamc = lamc(sind);
% view_vecs(lamlin/2/pi, lamc/2/pi);

% Eliminate some spurrious eig from lamc
lamc_orig = lamc;
lamc = sortcceig(lamc);
lamc = lamc(1:end/2); % keep eig with positive imag parts only.
% Eliminate eigenvalues that are way out of band - can't find their
% Residues accurately.
lamc = lamc(find(abs(lamc) < 1.2*max(ZNLD.ws)));
lamc = lamc(find(abs(lamc) > 0.8*min(ZNLD.ws)));

% Find data around peaks for curve fit.
[band_inds] = FindPeakBand(ZNLD.ws,lamc,1);

% The following is probably not as elegant as it could be, but for now it
% is easier than identifying B and D from the time series.
[A_fit,Pex] = mvecs(ZNLD.Hmat(band_inds,ZNLD.fline_ind),ZNLD.ws(band_inds),...
    lamc,0,[],'D');


%% Filter Eigenvalues by examining backwards propagation
% Eliminate heavily damped modes until backwards prediction over a short
% time interval is sucessful.
    % Ask user how far back to compare and what level of error is
    % acceptable
    val_str = inputdlg({'Enter time (ms) to backup','Enter maximum allowable error (1.0 = 100%)'},...
        'Elim. Heavily Damped',1,{num2str(10),num2str(0.1)});
    t_back = str2num(val_str{1})/1e3;
    tb_used_ind = find(ZNLD.ts_zc > ZNLD.ts_zc(ZNLD.fline_ind) - t_back,1);
    tb_used = ZNLD.ts_zc(tb_used_ind);
    err_limit = str2num(val_str{2});
    
    % Ask user how far out in frequency to go
    fmax_str = inputdlg('Enter Maximum Frequency for Metric (Hz)',...
        'Max. Freq.',1,{num2str(max(ZNLD.ws/2/pi))});
    band_ind = find(ZNLD.ws <= str2num(fmax_str{1})*2*pi);
    
    A_fit_back = A_fit.*exp(-lamc*(ZNLD.ts_zc(ZNLD.fline_ind) - ZNLD.ts_zc(tb_used_ind)));
    IntHdata = trapz(ZNLD.ws(band_ind),abs(ZNLD.Hmat(band_ind,tb_used_ind)));
    
    % Eliminate most heavily damped modes one at a time until the error is
    % acceptable.
    curr_err = 1;
    while curr_err > err_limit & length(lamc) > 0;
        % Compute fit FRF and integral error metric
        H_fit_back = ss_model(lamc,A_fit_back,ZNLD.ws,'D','s');
        HDiff = abs(ZNLD.Hmat(band_ind,tb_used_ind))-abs(H_fit_back(band_ind,1));
        IntHD = trapz(ZNLD.ws(band_ind), abs(HDiff));
        curr_err = IntHD./IntHdata; % IntHDn
        if curr_err > err_limit
            [junk,lamc_elim_ind] = min(real(lamc)); % real parts are negative
            lamc_keep_ind = setdiff([1:length(lamc)],lamc_elim_ind);
            lamc = lamc(lamc_keep_ind);
            A_fit = A_fit(lamc_keep_ind,:);
            A_fit_back = A_fit_back(lamc_keep_ind,:);
        end
    end
    
    if isempty(lamc)
        disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
        warning('Subspace Identification Unsucessfull - no modes remain after filtering!');
        disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    end
    
%% Create final model and plot
H_fit = ss_model(lamc,A_fit,ZNLD.ws,'D','s');

% Add line to figure
figure(102);
hl = line(ZNLD.ws/2/pi,abs(H_fit),'Color','k','LineWidth',3,'LineStyle',':',...
    'UserData',['Fit ',num2str(ZNLD.fline_ind)])
    % Note:  A robust version of this program would have a plotting
    % function that would add lines to the plot so that changes could be
    % made in one place only.

    % Add this to the list of lines to keep
    ZNLD.lhands.hands = [ZNLD.lhands.hands; hl];
    ZNLD.lhands.legend{length(ZNLD.lhands.legend)+1} = ['Fit to ',num2str(ZNLD.ts_zc(ZNLD.fline_ind)*1e3,3)];

% Add Data to ZNLD structure
ZNLD.lam_fit = lamc;
ZNLD.A_fit = A_fit;

    
    