function [history, stopReason] = lars(yin, xin, XTX, type, stopCriterion, regularization, trace, quiet)
% %{
% This program implements "LARS" algorithm and its lasso modification
% introduced by Efron et. al. 2003.  Read the paper to understand codes
% of this function.  Each line of this file has corresponding equation
% number in Efron et. al. 2003 for reader's convenience.
%
%
% *** CAUTION
% history(1).mu_OLS contains original 'yin' to provide convinience in
% writing user defined stop criterion function. Actual mu_OLS of the first
% step should be just mean of yin which is a simple array of copy of
% history(1).mu. So, if history(1).mu_OLS contains that information, it is
% redundant. In fact, this is also contained in history(1).b, which is a
% bias of the output. Therefore, to provide more information to user who
% want to write his/her own stop criterion function, history(1).mu_OLS
% contains yin.
% 
% 
% Example 1: moderate size x.
%     stopCrioterion = {};
%     stopCrioterion{1,1} = 'maxKernels';
%     stopCrioterion{1,2} = 100;
%
%     XTX = lars_getXTX(x_original);      % this takes long time.
%     sol = lars(y, x, 'lasso', XTX, stopCriterion);
% 
% Example 2: very small size x, or a really really big size x
%     stopCrioterion = {};
%     stopCrioterion{1,1} = 'maxKernels';
%     stopCrioterion{1,2} = 100;
%
%     sol = lars(y, x, 'lasso', XTX, stopCriterion);
% 
% Note:
%     Users can add any kind of stop criterion by editing
%     the corresponding portion of this file.  See the code
%     for existing examples.
% 
% Note 2:
%     This m-file does not implement routine for missing data.
% %}
% 

global USING_CLUSTER;
global RESOLUTION_OF_LARS;
global REGULARIZATION_FACTOR;
lars_init();

regularization_factor = REGULARIZATION_FACTOR; % Tikhonov regularization factor (or the ridge regression factor)
                              % -> This should be small enough in this case to get
                              %    a reasonable pseudoinverse.

stopReason = {};

%%% Check parameters
if length(yin)==0 | length(xin)==0
    warning('\nInput or Output has zero length.\n');
    history.active_set = [];
    stopReason{1} = 'Parameter error';
    stopReason{2} = 0;
    return;
end
if size(yin,1) ~= size(xin,1)
    warning('\nSize of y does not match to that of x.\n');
    history.active_set = [];
    stopReason{1} = 'Parameter error';
    stopReason{2} = 0;
    return;
end
if ~strcmp(type, 'lasso') & ~strcmp(type, 'lars') & ~strcmp(type, 'forward_stepwise')
    warning('\nUnknown type of regression.\n');
    history.active_set = [];
    stopReason{1} = 'Parameter error';
    stopReason{2} = 0;
    return;
end
if strcmp(type, 'forward_stepwise')
    warning('\nForward_stepwise is not implemented.\n');
    history.active_set = [];
    stopReason{1} = 'Parameter error';
    stopReason{2} = 0;
    return;
end
    

if exist('regularization','var') & ~isempty(regularization)
    regularization = 10;
else
    regularization  = 0;
end

if ~exist('trace','var') | isempty(trace)
    trace=0;
end

if ~exist('quiet','var') | isempty(quiet)
    quiet=0;
elseif quiet==1
    trace=0;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data preparation

% Program automatically centers and standardizes predictors.
if ~exist('XTX','var')
    XTX=[];
end
no_xtx = 0;
if ~isempty(XTX)
    if ~quiet & trace >=0
        fprintf('\nLars is using the provided xtx.\n');
    end
elseif size(xin,2)^2 > 10^6
    if ~quiet & trace >=0
        fprintf('Too large matrix (size(x,2)^2 > 10^6). lars will not pre-calculate xtx.\n');
    end
    no_xtx      = 1;
    XTX         = lars_getXTX(xin,no_xtx);
else
%     fprintf('\nCalculating xtx.\n');
    XTX         = lars_getXTX(xin);
end

x               = XTX.x;            % normalized xin
mx              = XTX.mx;           % mean xin
sx              = XTX.sx;           % length of each column of xin
ignores         = XTX.ignores;      % indices for constant terms
all_candidate   = XTX.all_candidate;% indices for all possible columns
if ~no_xtx
    xtx         = XTX.xtx;          % xtx matrix
    dup_columns = XTX.dup_columns;  % duplicated columns which will be automatically ignored.
end

my              = mean(yin);
y               = yin-my;

n               = size(x,1);        % # of samples
m               = size(x,2);        % # of predictors

% Now, we can determine the maximum number of kernels.
%maxKernels = min(maxKernels, min(size(xin,1)-1, length(all_candidate)));
%maxKernels = min(maxKernels, min(rank(xin), length(all_candidate)));
existMaxKernels = 0;
existMSE        = 0;
for is = 1:size(stopCriterion,1)
    if strcmp(stopCriterion{is,1},'maxKernels')
        existMaxKernels = 1;
%        stopCriterion{is,2} = min(stopCriterion{is,2}, min(size(xin,1)-1, length(all_candidate)));
        stopCriterion{is,2} = min(stopCriterion{is,2}, min(rank(xin), length(all_candidate)));
        if stopCriterion{is,2}<1
            warning('Max Kernel is less than 1. It must be larger than 0.\n');
            stopCriterion{is,2} = 1;
        end
    end
    if strcmp(stopCriterion{is,1},'MSE')
        existMSE        = 1;
        if stopCriterion{is,2}<1.0e-10
            warning('Maximum MSE is too small. Automatically set to 1.0e-10\n');
            stopCriterion{is,2} = 1.0e-10;
        end
    end
end
if ~existMaxKernels
    is = size(stopCriterion,1);
    stopCriterion{is+1,1} = 'maxKernels';
%    stopCriterion{is+1,2} = min(size(xin,1)-1, length(all_candidate));  % Stop when size of active set is data.maxKernels.
    stopCriterion{is+1,2} = min(rank(xin), length(all_candidate));  % Stop when size of active set is data.maxKernels.
end
if ~existMSE
    is = size(stopCriterion,1);
    stopCriterion{is+1,1} = 'MSE';
    stopCriterion{is+1,2} = 1.0e-10;
end
    




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialization

active      = [];               % active set
inactive    = all_candidate;    % inactive set

mu_a        = zeros(n,1);       % current estimate (eq. 2.8)
mu_a_plus   = 0;                % next estimate (eq. 2.12)
mu_a_OLS    = 0;                % OLS estimate  (eq. 2.19)

beta        = zeros(1,size(x,2));
beta_new    = beta;
beta_OLS    = beta;

history.active_set          = [];
history.add                 = [];
history.drop                = [];
history.beta_norm           = [];
history.beta                = [];
history.b                   = my;
history.mu                  = my;
history.beta_OLS_norm       = [];
history.beta_OLS            = [];
history.b_OLS               = my;
history.mu_OLS              = my*ones(size(yin));
history.MSE                 = sum(y.^2)/length(y);
history.R_square            = 0;
history.resolution_warning  = [];


if var(yin)==0
    stopReason{1} = 'zeroVarY';
    stopReason{2} = var(yin);
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Main loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


c               = 0;                % correlation vector
C_max           = max(abs(c));
C_max_ind       = [];
C_max_ind_pl    = [];
drop            = [];               % used for 'lasso'
k               = 1;                % iteration index
if ~quiet & trace >= 0
    fprintf('Active predictors / total  :::::  Current iteration\n                            ');
end
while 1

    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%           Exit Criterions
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if exist('stopCriterion','var')     % If there is any stop criterion...
        % Any of these is satisfied, algorithm stops.
        %
        % Other criterions: Make your own cost function.
        
        for is = 1:size(stopCriterion,1)  % there can be a number of stop criterions.

            % Default Criterions.
            % Maximum number of consecutive drops or maximum number of drops within a window.
            if strcmp(stopCriterion{is,1},'maxDrops')
                drop_window = stopCriterion{is,2}(1);   % number of backward history to be considerd. 0 means all history.
                if drop_window==0
                    drop_window=k;
                end
                drop_n      = min(drop_window,stopCriterion{is,2}(2));   % number of maximum drops within the window.
                drop_vector = [];
                for z = max(k-drop_window+1,1):k
                    drop_vector=[drop_vector, history(z).drop];
                end
                if length(drop_vector)>=drop_n
                    stopReason{1} = 'maxDrops';
                    stopReason{2} = drop_n;
                    break;
                end
            end
            % Maximum number of kernels.
            if strcmp(stopCriterion{is,1},'maxKernels')
                if length(active) >= min(stopCriterion{is,2}, min(size(xin,1)-1, length(all_candidate)))
                    stopReason{1} = 'maxKernels';
                    stopReason{2} = length(active);
                    break;
                end
            end
            % Maximum number of iterations.
            if strcmp(stopCriterion{is,1},'maxIterations')
                if k >= stopCriterion{is,2}
                    stopReason{1} = 'maxIterations';
                    stopReason{2} = k;
                    break;
                end
            end
            % MSE.
            if strcmp(stopCriterion{is,1},'MSE')
                if history(k).MSE <= stopCriterion{is,2}
                    stopReason{1} = 'MSE';
                    stopReason{2} = history(k).MSE;
                    break;
                end
            end
            
            % User defined stop criterion.
            if strcmp(stopCriterion{is,1},'userDefinedCriterion')
                fhandle = stopCriterion{is,2}.fhandle;
                r_fhandle = fhandle(history, stopCriterion{is,2}.data);
                if r_fhandle.stop
                    stopReason{1} = 'userDefinedCriterion';
                    stopReason{2} = r_fhandle;
                    break;
                end
            end
            
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    end % end of stop criterion checking :  if exist('stopCriterion','var')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    if length(stopReason)>0 % if there is any reason of stopping the algorithm, exit loop.
        break;
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%           LARS Algorithm
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %if ~USING_CLUSTER
    %fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b%5d/%5d    :::::   %5d',length(active),length(all_candidate),k);
    %end
    % start of algorithm
    c                   = x'*(y-mu_a);                      % eq 2.8
    [C_max,C_max_ind]   = max(abs(c(inactive)));            % eq 2.9
    C_max_ind           = inactive(C_max_ind);
    % active          = sort(union(active,C_max_ind));      % If there is no machine limit, this can be used.
    % But because of machine limit, there can be multiple new predictors.
    % This dramatically improves the overall precision of the result,
    % and speeds up the whole process.
    C_max_ind_pl        = abs(c(inactive))>C_max-RESOLUTION_OF_LARS;
    C_max_ind_pl        = inactive(C_max_ind_pl);
    active          = sort(union(active,C_max_ind_pl));  
    inactive        = setdiff(all_candidate, active);   % eq 2.9
    if strcmp(type,'lasso')
        if ~isempty(drop) & length(find(drop==C_max_ind))==0           % If there is a drop, that must have the maximum correlation in inactive set.
            if ~quiet & trace >=0
                fprintf('\n');
                warning('Dropped item and index of maximum correlation is not the same. But it is being ignored here...');
                fprintf('\n                            ');
            end
            active(find(active==C_max_ind))=[];
        end
        if ~isempty(drop)
            C_max_ind   = [];
            C_max_ind_pl= [];
        end
        active          = setdiff(active,drop);             % eq 3.6
        inactive        = sort(union(inactive,drop));       % eq 3.6
    end

    s       = sign(c(active));              % eq 2.10
    xa      = x(:,active).*repmat(s',n,1);  % eq 2.4
    if ~no_xtx
        ga  = xtx(active,active).*(s*s');   % eq 2.5
    else
        ga  = xa'*xa;                       % eq 2.5
    end
    if regularization > 2
        ga  = ga+eye(length(ga))*regularization_factor; % This routine will make the test below
    end
    invga   = ga\eye(size(ga,1));           % eq 2.5
    aa      = sum(sum(invga))^(-1/2);       % eq 2.5
    wa      = aa*sum(invga,2);              % eq 2.6
    ua      = xa*wa;                        % eq 2.6
    
    % test using eq 2.7
    test_1      = xa'*ua;
    test_2      = aa*ones(size(test_1));
    test_1_2    = sum(sum(abs(test_1-test_2)));
    test_3      = norm(ua) - 1;
    
    history(k+1).resolution_warning=0;
    if test_1_2 > RESOLUTION_OF_LARS*100 | abs(test_3 ) > RESOLUTION_OF_LARS*100
        if regularization <=2
            if ~quiet & trace>0
                fprintf('\n');
                warning('Eq 2.7 test failure.');
                fprintf('\n                            ');
            end
            regularization = regularization + 1;
            if regularization > 2
                if ~quiet & trace>0
                    fprintf('\n');
                    warning('Lots of Eq 2.7 test failure. Regularization will be applied from now on.');
                    fprintf('\n                            ');
                end
            end
        end
        history(k+1).resolution_warning=1;
    end
    


    a               = x'*ua;                % eq 2.11
    tmp_1           = (C_max - c(inactive))./(aa - a(inactive));
    tmp_2           = (C_max + c(inactive))./(aa + a(inactive));
    tmp_3           = [tmp_1, tmp_2];
    tmp             = tmp_3(find(tmp_3>0));
    gamma = min(tmp);                       % eq 2.13
    if length(gamma)==0 % if this is the last step (i.e. length(active)==maxKernels)
        gamma = C_max/aa;                   % eq 2.19, eq 2.21 and 5 lines below eq 2.22
    end
    
    d               = zeros(1,m);
    d(active)       = s.*wa;

    if length(find(d(active)==0))
        fprintf('\n');
        warning('Something wrong with vector d: eq 3.4.');
        fprintf('\n                            ');
    end

    tmp             = zeros(1,m);
    tmp(active)     = -1*beta(active)./d(active);   % eq 3.4
    tmp2            = tmp(find(tmp>0));
    
    drop            = [];
    gamma_tilde = inf;                              % eq 3.5
    if ~isempty(tmp2) & gamma >= min(tmp2)
        gamma_tilde = min(tmp2);                    % eq 3.5
        drop        = find(tmp==gamma_tilde);       % eq 3.6
    end
    
    if strcmp(type, 'lars')
        mu_a_plus   = mu_a + gamma*ua;              % eq 2.12
        beta_new    = beta + gamma*d;               % eq 3.3
        drop        = [];
    elseif strcmp(type, 'lasso')
        mu_a_plus   = mu_a + min(gamma, gamma_tilde)*ua;    % eq 3.6
        beta_new    = beta + min(gamma, gamma_tilde)*d;     % eq 3.3
        active      = setdiff(active,drop);                 % eq 3.6
        inactive    = setdiff(all_candidate,active);
        beta_new(drop) = 0;
    elseif strcmp(type, 'forward_stepwise')
        drop        = [];
        error('forward.stepwise has not been implemented yet.');
        return;
    end
    
    mu_a_OLS    = mu_a + C_max/aa*ua;          % eq 2.19, 2.21
    beta_OLS    = beta + C_max/aa*d;           % eq 2.19, 2.21
    MSE         = sum((y - mu_a_OLS).^2)/length(y);
    
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % update and save
    mu_a = mu_a_plus;
    beta = beta_new;
    
    % history with scale correction
    k = k+1;
    history(k).active_set   = active;
    history(k).drop         = drop;
    history(k).add          = C_max_ind_pl;
    history(k).beta_norm    = beta(active);
    history(k).beta         = beta(active)./sx(active);
    history(k).b            = my - sum(mx./sx.*beta);
    history(k).mu           = xin * (beta./sx)' + history(k).b;
    history(k).beta_OLS_norm= beta_OLS(active);
    history(k).beta_OLS     = beta_OLS(active)./sx(active);
    history(k).b_OLS        = my - sum(mx./sx.*beta_OLS);
    history(k).mu_OLS       = xin * (beta_OLS./sx)' + history(k).b_OLS;
    history(k).MSE          = MSE;
    history(k).R_square     = 1 - var(yin  - history(k).mu_OLS)/var(yin);
    
    
    % exit if exact mathing is achieved.
    if abs(C_max/aa - min(gamma,gamma_tilde)) < RESOLUTION_OF_LARS
        stopReason{1}   = 'ExactMatching';
        stopReason{2}   = 0;
        break;
    end

    
    
    
end % end of while loop
if ~quiet & trace >=0
    fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b%5d/%5d    :::::   %5d\n',length(active),length(all_candidate),k);
end    


return;



