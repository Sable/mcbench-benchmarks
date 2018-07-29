%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This Matlab Script estimates the parameters of the model presented in Schwartz-Smith 
% (2000) paper(Short-Term Variations and Long-Term Dynamics in Commodity Prices).
% NOTE: it can take up to 10 minutes for the estimation to complete.
% 
% Produced by Dominice Goodwin (May 2013) to conduct the empirical study in
% master thesis D. Goodwin (2013):
% (http://www.lunduniversity.lu.se/o.o.i.s?id=24965&postid=3809118)
% 
% Contact: dominice.goodwin@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; format short; load data; % Spot data in first column. All prices in log.

which_model = 1;
% [1 = Schwartz-Smith (2000) Model on the approximately the same Crude Oil
% data as used in this article.]

if which_model == 1 % Schwartz-Smith (2000) on crude oil data
    
    %%% INPUT SETTINGS %%%
    data = ss2000OilData;                   % Specify which variable that contains data for estimation (Column1 = Spot, Column2 = Future(Shortest Maturity)...) 
    include_spot_in_estimation = 0;         % [0 = No, 1 = Yes (Include the first column of Spot data in estimation)]
    Num_Contracts = 5;                      % # of future contracts in data to use
    matur = [1/12,5/12,9/12,13/12,17/12];   % Maturities of included contracts
    frequency = 1;                          % [1 = all observations in data variables are considered, 2 = every second observation is considered, ...] (This data is weekly .. so frequency = 1 -> weekly frequency. 
    dt = 7/360;                             % Time step size (Since weekly data) to get parameters on per year basis.
    start_obs = 1;                          % Start at first observation in data.
    end_obs = 268;                          % End at last observation in data.
    
% The standard errors are obtained from the hessian. However, since the model estimates the parameters 
% so that the one or a couple of futures contracts are matched with close to zero measurement errors, 
% leading to that the measurement error covariance matrix (usually) is positive semi-defined.
% --> Matlab error: Warning: Matrix is close to singular or badly scaled. Results may be inaccurate.

% To be able to invert the hessian and obtain standard errors the following
% ad hoc approach can be used:
%  - Once it is known which of the future contracts is matched with close to zero measurement errors 
% the estimation can be redone with the corresponding elements in measurement error covariance matrix 
% restricted to zero and thus excluded from the estimation. In this way measurement error covariance matrix 
% is positive defined and invertible.
    locked_parameters = 4;                  % [ 0 = No parameter locked, 1 to ... = Forces a measurement error parameter to be Zero] 
                                            % OBS: This data requiers locked_parameters = 4; 
                                            
    %%% SELECT INITIAL VALUES %%%
    k       = 2;                            % NOTE: These initial values have to be changed manually in order to find a Global Maximum Log-Likelihood Score
    sigmax  = 0.2;
    lambdax = 0.2;
    mu      = 0.02;
    sigmae  = 0.2;
    rnmu    = 0.02;
    pxe     = 0.2;
    s_guess = 0.01;
    initial_statevector = [0;3.1307];       % Initial state vector m(t)=E[xt;et] 
    initial_dist = [0.01,0.01;0.01,0.01];   % Initial covariance matrix for the state variables C(t)=cov[xt,et]
end  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ADJUSTING DATA ACCORDING TO INPUTS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_SelectedPeriod = data(start_obs:end_obs,1:end);
num_obs = size(data_SelectedPeriod,1);
if frequency ~= 1
    new_num_obs = floor((num_obs-1)/frequency);
    data_SelectedPeriod_SelectedFrequency = zeros(new_num_obs,size(data_SelectedPeriod,2));
    data_SelectedPeriod_SelectedFrequency(1,:) = data_SelectedPeriod(1,:);
    for t = 1:new_num_obs
        data_SelectedPeriod_SelectedFrequency(t+1,:) = data_SelectedPeriod((t*frequency)+1,:);
    end
else
    data_SelectedPeriod_SelectedFrequency = data_SelectedPeriod;
end


St = data_SelectedPeriod_SelectedFrequency(1:end,1);
if include_spot_in_estimation == 1
    y  = data_SelectedPeriod_SelectedFrequency(1:end,1:Num_Contracts);                 
else
    y  = data_SelectedPeriod_SelectedFrequency(1:end,2:Num_Contracts+1); 
end

% y is a {nobs x N} Matrix, N = number of future contracts, nobs = number of observations
nobs = size(y,1);
N    = size(y,2);
num_locked_parameters = size(locked_parameters,1);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optimizing the parameters with the Kalman filter & MLE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Placeholders & Variable def.
global save_att save_vtt save_vt  save_dFtt_1 save_vFv save_Ptt_1 save_Ftt_1 save_Ptt
lnL_scores = zeros(3,1);
boundary = Inf;

% Running the estimation for The S&S 2 factor model and two benchmark
% models (The GBM model and the Ornstein-Uhlenbeck model).
for model = 1:3 % [1 = The S&S 2 factor model, 2 = The GBM modell, 3 = The Ornstein-Uhlenbeck model.]
    if model == 1 % The S&S 2 factor model
        if sum(locked_parameters) == 0
     
            psi = zeros(7+N,1);
            psi(1:7,1) = [k, sigmax, lambdax, mu, sigmae, rnmu, pxe]';
            psi(8:end,1) = s_guess;
            
            lb = zeros(7+N,1);
            lb(1:7,1) = [0, 0, -boundary, -boundary, 0, -boundary, -1]';
            lb(8:end,1) = 0.0000001;
            
            ub = zeros(7+N,1);
            ub(1:7,1) = [boundary, boundary, boundary, boundary, boundary, boundary, 1]';
            ub(8:end,1) = boundary;
        else
            psi = zeros(7+N-num_locked_parameters,1);
            psi(1:7,1) = [k, sigmax, lambdax, mu, sigmae, rnmu, pxe]';
            psi(8:end,1) = s_guess;
            
            lb = zeros(7+N-num_locked_parameters,1);
            lb(1:7,1) = [0, 0, -boundary, -boundary, 0, -boundary, -1]';
            lb(8:end,1) = 0.0000001;
            
            ub = zeros(7+N-num_locked_parameters,1);
            ub(1:7,1) = [boundary, boundary, boundary, boundary, boundary, boundary, 1]';
            ub(8:end,1) = boundary;         
        end
        a0 = initial_statevector;
        P0 = initial_dist;
    end
    if model == 2 % The GBM model
       locked_parameters(1:end,1) = 0;
        
       psi = zeros(7+N,1);
       psi(1:7,1) = [k, sigmax, lambdax, mu, sigmae, rnmu, pxe]';
       psi(8:end,1) = s_guess;
        
       lb = zeros(7+N,1);
       lb(1:7,1) = [0, 0, 0, -boundary, 0, -boundary, -1]';
       lb(8:end,1) = 0;
            
       ub = zeros(7+N,1);
       ub(1:7,1) = [0.0001, 0, 0, boundary, boundary, boundary, 1]';
       ub(8:end,1) = boundary;
        
        a0 = [0;initial_statevector(1) + initial_statevector(2)];
        P0 = [0,0;0,initial_dist(2,2)];
    end
    if model == 3 % The Ornstein-Uhlenbeck model
        locked_parameters(1:end,1) = 0;
        
        psi = zeros(7+N,1);
        psi(1:7,1) = [k, sigmax, lambdax, mu, sigmae, rnmu, pxe]';
        psi(8:end,1) = s_guess;
        
        lb = zeros(7+N,1);
        lb(1:7,1) = [0, 0, -boundary, 0, 0, 0, -1]';
        lb(8:end,1) = 0;
            
        ub = zeros(7+N,1);
        ub(1:7,1) = [5, boundary, boundary, 0, 0, 0, 1]';
        ub(8:end,1) = boundary;
        
        a0 = [initial_statevector(1,1); mean(ss_att(1:end,2))];
        P0 = [initial_dist(1,1),0;0,0];
    end
    
    % Running estimation
    options = optimset('Algorithm','interior-point','Display','off'); %interior-point active-set
    MaxlnL_Kalman = @(psi) Kalman_Estimation(y, psi, matur, dt, a0, P0, N, nobs, locked_parameters);
    [psi_optimized, log_L,exitflag,output,lambda,grad,hessian] = fmincon(MaxlnL_Kalman, psi, [], [],[], [], lb, ub, [], options);

    % Saving estimation output
    lnL_scores(model,1) = -log_L;

    if model == 1
        ss_att = save_att;
        ss_vtt = save_vtt;
        ss_vt = save_vt;
        ss_dFtt_1 = save_dFtt_1;
        ss_vFv = save_vFv;
        ss_Ptt_1 = save_Ptt_1;
        ss_Ftt_1 = save_Ftt_1;
        ss_Ptt = save_Ptt;
        
        if sum(locked_parameters) == 0
             ss_psi_estimate = [psi_optimized(1:7,1);sqrt(psi_optimized(8:end,1))];
             ss_SE = sqrt(diag(inv(hessian)));
        else      
            prel_SE = sqrt(diag(inv(hessian)));
            prel_ss_psi_estimate = zeros(size(psi,1)+size(locked_parameters,1),1);
            ss_SE = zeros(size(psi,1)+size(locked_parameters,1),1);
            j = 1;
            for i = 1:size(prel_ss_psi_estimate,1)
                 if all(abs(i-(locked_parameters+7))) == 1
                     prel_ss_psi_estimate(i,1) = psi_optimized(j,1);
                     ss_SE(i,1) = prel_SE(j,1);
                     j = j+1;
                 else
                     prel_ss_psi_estimate(i,1) = 0;
                     ss_SE(i,1) = 0;
                 end
            end
            ss_psi_estimate = [prel_ss_psi_estimate(1:7,1);sqrt(prel_ss_psi_estimate(8:end,1))];
         end
    end
       
   
    if model == 2
        gbm_att = save_att;
        gbm_vtt = save_vtt;
        gbm_psi_estimate = [psi_optimized(1:7,1);sqrt(psi_optimized(8:end,1))];
    end
    if model == 3
        ou_att = save_att;
        ou_vtt = save_vtt;
        ou_psi_estimate = [psi_optimized(1:7,1);sqrt(psi_optimized(8:end,1))];
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculating/outputing key statistics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Output
ss_psi_estimate
ss_SE
gbm_psi_estimate
ou_psi_estimate

% S&S Model fit 
ss_Mean_Error = mean(ss_vtt)'
ss_Std_of_Error = std(ss_vtt)'
ss_MAE = mean(abs(ss_vtt))'

% GBM Model fit 
GBM_Mean_Error = mean(gbm_vtt)'
GBM_Std_of_Error = std(gbm_vtt)'
GBM_MAE = mean(abs(gbm_vtt))'

% OU Model fit 
OU_Mean_Error = mean(ou_vtt)'
OU_Std_of_Error = std(ou_vtt)'
OU_MAE = mean(abs(ou_vtt))'

% Performance
lnL_scores

LR_SSvsGBM = -2*(lnL_scores(2,1)-lnL_scores(1,1))
p_value_SSvsGBM = 1-chi2cdf(LR_SSvsGBM, 2) %(Value, DF)

LR_SSvsOU = -2*(lnL_scores(3,1)-lnL_scores(1,1))
p_value_OU = 1-chi2cdf(LR_SSvsOU, 3) %(Value, DF)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputing Graph
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);
set(figure(1), 'Position', [100 100 400 1000])

subplot(3,1,1);
hold on
plot(exp(St),'k','linewidth',1);
plot(exp(ss_att(:,1)+ss_att(:,2)),'r','linewidth',1); 
plot(exp(ss_att(:,2)),'b','linewidth',1);
h = legend('Observed Price','Estimated Price','Equilibrium Price');
title('Schwartz-Smith 2-factor model')
hold off

subplot(3,1,2);
hold on
plot(exp(St),'k','linewidth',1);
plot(exp(gbm_att(:,1)+gbm_att(:,2)),'--r','linewidth',1); 
plot(exp(gbm_att(:,2)),'b','linewidth',1);
h = legend('Observed Price','Estimated Price','Equilibrium Price');
title('geometric Brownian motion')
hold off

subplot(3,1,3);
hold on
plot(exp(St),'k','linewidth',1);
plot(exp(ou_att(:,1)+ou_att(:,2)),'r','linewidth',1); 
plot(exp(ou_att(:,2)),'b','linewidth',1);
h = legend('Observed Price','Estimated Price','Equilibrium Price');
title('Ornstein-Uhlenbeck')
hold off




