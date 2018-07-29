function [param]=sine_fit(x,y,fixed_params,initial_params,plot_flag)
% Optimization of parameters of the sine function to time series
%
% Syntax:
%       [param]=sine_fit(x,y)       
%
%       that is the same that
%       [param]=sine_fit(x,y,[],[],[])     % no fixed_params, automatic initial_params
%
%       [param]=sine_fit(x,y,fixed_params)        % automatic initial_params
%       [param]=sine_fit(x,y,[],initial_params)   % use it when the estimation is poor
%       [param]=sine_fit(x,y,fixed_params,initial_params,plot_flag)
%
% param = [offset, amplitude, phaseshift, frequency]
%
% if fixed_params=[NaN, NaN , NaN , NaN]        % or fixed_params=[]
% optimization of offset, amplitude, phase shift and frequency (default)
%
% if fixed_params=[NaN, 1 , NaN , 1/(2*pi)]
% optimization of offset and phase shift of a sine of amplitude=1 and frequency=1/(2*pi)
%
% if fixed_params=[0, NaN , NaN , NaN] 
% optimization of amplitude, phase shift and frequency of a sine of offset=0
%
%
% Example:
% %% generate data vectors (x and y)
% fsine = @(param,timeval) param(1) + param(2) * sin( param(3) + 2*pi*param(4)*timeval );
% param=[0 1 0 1/(2*pi)];  % offset, amplitude, phaseshift, frequency
% timevec=0:0.1:10*pi;
% x=timevec;
% y=fsine(param,timevec) + 0.1*randn(size(x));
%
% %% standard parameter estimation
% [estimated_params]=sine_fit(x,y)
%
% %% parameter estimation with forced 1.5 fixed amplitude
% [estimated_params]=sine_fit(x,y,[NaN 1.5 NaN NaN])
%
% %% parameter estimation without plotting
% [estimated_params]=sine_fit(x,y,[],[],0)
%
%
% Doubts, bugs: rpavao@gmail.com


% warning off


if nargin<=1 %fail
    fprintf('');
    help sine_fit
    return
end

automatic_initial_params=NaN(1,4);
automatic_initial_params(1)=median(y);
automatic_initial_params(2)=mean(minmax(y));
automatic_initial_params(3)=0;
[~,pos]=findpeaks(smooth(y,10));
automatic_initial_params(4)=1/max(diff(x(pos)));

% phas_shift estimator, not working...
% [~,pos]=max(y);
% automatic_initial_params(3)=mod(x(pos),automatic_initial_params(4));

if nargin==2 %simplest valid input
    fixed_params=NaN(1,4);
    initial_params=automatic_initial_params;
    plot_flag=1;    
end
if nargin==3
    initial_params=automatic_initial_params;
    plot_flag=1;    
end
if nargin==4
    plot_flag=1;    
end

if exist('fixed_params','var')
    if isempty(fixed_params)
        fixed_params=NaN(1,4);
    end
end
if exist('initial_params','var')
    if isempty(initial_params)
        initial_params=automatic_initial_params;
    end
end
if exist('plot_flag','var')
    if isempty(plot_flag)
        plot_flag=1;
    end
end


f_str='f = @(param,timeval)';
free_param_count=0;
bool_vec=NaN(1,4);
for i=1:4;
    if isnan(fixed_params(i))
        free_param_count=free_param_count+1;
        f_str=[f_str ' param(' num2str(free_param_count) ')'];
        bool_vec(i)=1;
    else
        f_str=[f_str ' ' num2str(fixed_params(i))];
        bool_vec(i)=0;
    end
    if i==1; f_str=[f_str ' +']; end
    if i==2; f_str=[f_str ' * sin(']; end
    if i==3; f_str=[f_str ' + 2*pi*']; end
    if i==4; f_str=[f_str '*timeval );']; end
end

eval(f_str)

[BETA,RESID,J,COVB,MSE] = nlinfit(x,y,f,initial_params(bool_vec==1));

free_param_count=0;
for i=1:4;
    if isnan(fixed_params(i))
        free_param_count=free_param_count+1;
        param(i)=BETA(free_param_count);
    else
        param(i)=fixed_params(i);
    end    
end
    
if plot_flag==1 
    x_vector=min(x):mean(diff(x))/2:max(x);
    plot(x,y,'k.',x_vector,f(BETA,x_vector),'r-')
    xlim(minmax(x_vector))
end
