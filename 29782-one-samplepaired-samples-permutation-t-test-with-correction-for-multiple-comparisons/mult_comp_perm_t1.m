%function [pval, t_orig, crit_t, est_alpha, seed_state]=mult_comp_perm_t1(data,n_perm,tail,alpha_level,mu,reports,seed_state)
%
% mult_comp_perm_t1-One sample/paired sample permutation test based on a 
% t-statistic.  This function can perform the test on one variable or 
% simultaneously on multiple variables.  When applying the test to multiple
% variables, the "tmax" method is used for adjusting the p-values of each
% variable for multiple comparisons (Blair & Karnisky, 1993).  Like 
% Bonferroni correction, this method adjusts p-values in a way that controls 
% the family-wise error rate.  However, the permutation method will be more 
% powerful than Bonferroni correction when different variables in the test 
% are correlated.
%
% Required Input:
%  data   - 2D matrix of data (Observation x Variable)
%
% Optional Inputs:
%  n_perm      - Number of permutations used to estimate the distribution of
%                the null hypothesis. If the number of observations is less
%                than or equal to 12, all possible permutations are used and
%                this optional input has no effect.  If the number of 
%                observations is greater than 12, n_perm specifies the 
%                number of random permutations computed. Manly (1997) 
%                suggests using at least 1000 permutations for an alpha level 
%                of 0.05 and at least 5000 permutations for an alpha level of
%                0.01. {default=5000}
%  alpha_level - Desired family-wise alpha level. Note, because of the finite
%                number of possible permutations, the exact desired family-wise
%                alpha may not be possible. Thus, the closest approximation 
%                is used and output as est_alpha. {default=.05}
%  tail        - [1, 0, or -1] If tail=1, the alternative hypothesis is that the
%                mean of the data is greater than 0 (upper tailed test).  If tail=0,
%                the alternative hypothesis is that the mean of the data is different
%                than 0 (two tailed test).  If tail=-1, the alternative hypothesis
%                is that the mean of the data is less than 0 (lower tailed test).
%                {default: 0}
%  mu          - The mean of the null hypothesis.  Must be a scalar or
%                1 x n vector (where n=the number of variables). {default: 0}
%  reports     - [0 or 1] If 0, function proceeds with no command line
%                reports. Otherwise, function reports what it is doing to
%                the command line. {default: 1}
%  seed_state  - The initial state of the random number generating stream
%                (see MATLAB documentation for "randstream"). If you pass
%                a value from a previous run of this function, it should
%                reproduce the exact same values. Note, this input only has
%                an effect if you have more than 12 observations.
%
% Outputs:
%  pval       - p-value (adjusted for multiple comparisons) of each
%               variable
%  t_orig     - t-score for each variable
%  crit_t     - Lower and upper critical t-scores for given alpha level. 
%               t-scores that exceed these values significantly deviate from 
%               the null hypothesis.  For upper tailed tests, the lower
%               critical t-score is NaN. The opposite is true of lower
%               tailed tests.
%  est_alpha  - The estimated family-wise alpha level of the test.  With 
%               permutation tests, a finite number of p-values are possible.
%               This function tries to use an alpha level that is as close 
%               as possible to the desired alpha level.  However, if the 
%               sample size is small, a very limited number of p-values are 
%               possible and the desired family-wise alpha level may be 
%               impossible to approximately achieve.
%  seed_state - The initial state of the random number generating stream
%               (see MATLAB documentation for "randstream") used to 
%               generate the permutations. You can use this to reproduce
%               the output of this function.  If the number of observations
%               is less than or equal to 12, seed_state='exact' since
%               all possible permutations are used in lieu of random
%               permutations.
%
% Note:
% -Unlike a parametric test (e.g., an ANOVA), a discrete set of p-values
% are possible (at most the number of possible permutations).  Since the
% number of possible permutations grows exponentially with the number of
% participants, this is only an issue for small sample sizes (e.g., 6
% participants).  When you have such a small sample size, the
% limited number of p-values may make the test overly conservative (e.g., 
% you might be forced to use an alpha level of .0286 since it is the biggest
% possible alpha level less than .05).
%
% -The null hypothesis of the permutation test is that the data come from a
% distribution that is symmetric around the mean of the null hypothesis.
% This is probably a generally reasonable assumption for
% paired-sample/repeated measures tests, but it might not be appropriate for
% one-sample tests.
%
%
% One Sample Example:
% >> data=randn(16,5);  %5 variables, 16 observations
% >> data(:,1:2)=data(:,1:2)+1; %mean of first two variables is 1
% >> [pval, t_orig, crit_t, est_alpha, seed_state]=mult_comp_perm_t1(data,50000);
% >> disp(pval); %adjusted p-values
%
% Paired-Sample/Repated Measures Example:
% >> dataA=randn(16,5);  %data from Condition A (5 variables, 16 observations)
% >> dataA(:,1:2)=dataA(:,1:2)+1; %mean of first two variables is 1
% >> dataB=randn(16,5); %data from Condition B (all variables have mean of 0)
% >> dif=dataA-dataB; %difference between conditions
% >> [pval, t_orig, crit_t, est_alpha, seed_state]=mult_comp_perm_t1(dif,50000);
% >> disp(pval); %adjusted p-values
%
% References:
% Blair, R.C. & Karniski, W. (1993) An alternative method for significance
% testing of waveform difference potentials. Psychophysiology.
%
% Manly, B.F.J. (1997) Randomization, Bootstrap, and Monte Carlo Methods in
% Biology. 2nd ed. Chapman and Hall, London.
%
%
%
% For a review on permutation tests and other contemporary techniques for 
% correcting for multiple comparisons see:
%
%   Groppe, D.M., Urbach, T.P., & Kutas, M. (2011) Mass univariate analysis 
% of event-related brain potentials/fields I: A critical tutorial review. 
% Psychophysiology, 48(12) pp. 1711-1725, DOI: 10.1111/j.1469-8986.2011.01273.x 
% http://www.cogsci.ucsd.edu/~dgroppe/PUBLICATIONS/mass_uni_preprint1.pdf
%
%
% Author:
% David Groppe
% Dec, 2010
% Kutaslab, San Diego
%


function [pval, t_orig, crit_t, est_alpha, seed_state]=mult_comp_perm_t1(data,n_perm,tail,alpha_level,mu,reports,seed_state)

if nargin<1,
    error('You need to provide data.');
end

if nargin<2,
    n_perm=5000;
end

if nargin<3,
    tail=0;
elseif (tail~=0) && (tail~=1) && (tail~=-1),
    error('Argument ''tail'' needs to be 0,1, or -1.');
end

if nargin<4,
    alpha_level=0.05;
elseif (alpha_level>=1) || (alpha_level<=0),
   error('Argument ''alpha_level'' needs to be a number between 0 and 1.'); 
end

if nargin<5,
    mu=0;
end

if nargin<6,
    reports=1;
end

defaultStream=RandStream.getDefaultStream; %random # generator state
if (nargin<7) || isempty(seed_state),
    %Store state of random number generator
    seed_state=defaultStream.State;
else
    defaultStream.State=seed_state; %reset random number generator to saved state
end

[n_obs n_var]=size(data);
if n_obs<2,
    error('You need data from at least two observations to perform a hypothesis test.')
end

if n_obs<7,
    n_psbl_prms=2^n_obs;
    if reports,
        watchit(sprintf(['Due to the very limited number of observations,' ...
            ' the total number of possible permutations is small.\nThus only a limited number of p-values (at most %d) are possible and the test might be overly conservative.'], ...
            n_psbl_prms));
    end
end

%% Remove null hypothesis mean from data
if isscalar(mu),
    data=data-mu;
elseif isvector(mu)
    s_mu=size(mu);
    if s_mu(1)>1,
        mu=mu';
        s_mu=size(mu);
    end
    if s_mu(2)~=n_var,
        error('mu needs to be a scalar or a 1 x %d vector (%d is the number of variables).',n_var,n_var);
    end
    data=data-repmat(mu,n_obs,1);
else
    error('mu needs to be a scalar or a 1 x %d vector (%d is the number of variables).',n_var,n_var);
end

if reports,
    fprintf('mult_comp_perm_t1: Number of variables: %d\n',n_var);
    fprintf('mult_comp_perm_t1: Number of observations: %d\n',n_obs);
    fprintf('t-score degrees of freedom: %d\n',n_obs-1);
end


%% Set up permutation test
if n_obs<=12,
    n_perm=2^n_obs; %total number of possible permutations
    exact=1;
    seed_state='exact';
    if reports,
        fprintf('Due to the limited number of observations, all possible permutations of the data will be computed instead of random permutations.\n');
    end
else
    exact=0;
end

if reports,
    fprintf('Executing permutation test with %d permutations...\n',n_perm);
    fprintf('Permutations completed: ');
end


%% Compute permutations

%Constant factor for computing t, speeds up computing t to precalculate
%now
sqrt_nXnM1=sqrt(n_obs*(n_obs-1));
if exact,
    %Use all possible permutations
    mxt=zeros(1,n_perm);
    for perm=1:n_perm
        if ~rem(perm,100)
            if reports,
                if ~rem(perm-100,1000)
                    fprintf('%d',perm);
                else
                    fprintf(', %d',perm);
                end
                if ~rem(perm,1000)
                    fprintf('\n');
                end
            end
        end
        %set sign of each participant's data
        if exist('de2bi.m','file') %% ?? check
            temp=de2bi(perm-1);
        else %% check ??
            temp=perm-1; %% check ??
        end %% check ??
        n_temp=length(temp);
        sn=-ones(n_obs,1);
        sn(1:n_temp,1)=2*temp-1;
        sn_mtrx=repmat(sn,1,n_var); 
        d_perm=data.*sn_mtrx;
        
        %computes t-score of permuted data across all channels and time points
        sm=sum(d_perm,1);
        mn=sm/n_obs;
        sm_sqrs=sum(d_perm.^2,1)-(sm.^2)/n_obs;
        stder=sqrt(sm_sqrs)/sqrt_nXnM1;
        t=mn./stder;
        
        %get most extreme t-score
        [dummy mxt_id]=max(abs(t));
        mxt(perm)=t(mxt_id); %get the most extreme t-value with its sign (+ or -)
    end
else
    %Use random permutations
    mxt=zeros(1,n_perm*2);
    for perm=1:n_perm
        if ~rem(perm,100)
            if reports,
                if ~rem(perm-100,1000)
                    fprintf('%d',perm);
                else
                    fprintf(', %d',perm);
                end
                if ~rem(perm,1000)
                    fprintf('\n');
                end
            end
        end
        %randomly set sign of each participant's data
        sn=(rand(n_obs,1)>.5)*2-1; 
        sn_mtrx=repmat(sn,1,n_var);
        
        d_perm=data.*sn_mtrx;
        
        %computes t-score of permuted data across all channels and time points
        sm=sum(d_perm,1);
        mn=sm/n_obs;
        sm_sqrs=sum(d_perm.^2,1)-(sm.^2)/n_obs;
        stder=sqrt(sm_sqrs)/sqrt_nXnM1;
        t=mn./stder;
        
        %get most extreme t-score (sign isn't immportant since we asumme
        %symmetric distribution of null hypothesis for one sample test)
        mxt(perm)=max(abs(t));
    end
    mxt(n_perm+1:2*n_perm)=-mxt(1:n_perm); %add the negative of all values since we assumme
    %null hypothesis distribution is symmetric
end

%End permutations completed line
if reports && rem(perm,1000)
    fprintf('\n');
end


%% Computes t-scores of observations at all variables and time points
sm=sum(data,1);
mn=sm/n_obs;
sm_sqrs=sum(data.^2,1)-(sm.^2)/n_obs;
stder=sqrt(sm_sqrs)/sqrt_nXnM1;
t_orig=mn./stder;


%% Compute p-values
pval=zeros(1,n_var);
for t=1:n_var,
    if tail==0,
        pval(t)=mean(mxt>=abs(t_orig(t)))*2;
    elseif tail==1,
        pval(t)=mean(mxt>=t_orig(t));
    elseif tail==-1,
        pval(t)=mean(mxt<=t_orig(t));
    end
end

%% Compute critical t-scores for specified alpha level,
if tail==0,
    %two-tailed
    crit_t(1)=prctile(mxt,100*alpha_level/2);
    crit_t(2)=-crit_t(1);
    est_alpha=mean(mxt>=crit_t(2))*2;
elseif tail==1,
    %upper tailed
    crit_t(1)=NaN;
    crit_t(2)=prctile(mxt,100-100*alpha_level);
    est_alpha=mean(mxt>=crit_t(2));
else
    %tail=-1, lower tailed
    crit_t(1)=prctile(mxt,alpha_level*100);
    est_alpha=mean(mxt<=crit_t(1));
    crit_t(2)=NaN;
end
if reports,
    fprintf('Desired family-wise alpha level: %f\n',alpha_level);
    fprintf('Estimated actual family-wise alpha level for returned values of crit_t: %f\n',est_alpha);
end


function watchit(msg)
%function watchit(msg)
%
% Displays a warning message on the Matlab command line.  Used by 
% several Mass Univariate ERP Toolbox functions.
%

disp(' ');
disp('****************** Warning ******************');
disp(msg);
disp(' ');
