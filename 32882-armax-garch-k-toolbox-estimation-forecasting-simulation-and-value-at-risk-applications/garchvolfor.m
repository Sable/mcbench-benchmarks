function [results, forecast, summary] = garchvolfor(data, model, distr, ar, ma, p, q, P, max_forecast, int_forecasts, VaR, alpha, options)
%{ 
-----------------------------------------------------------------------
 PURPOSE: 
 Applications in Volatility Forecasting & Value-at-Risk. 

 It allows the comparison of volatility and Value-at-Risk estimates for a 
 (TxN) data vector and for a variety of GARCH models and distributions as 
 specified in the model & distribution variables (i.e. model = char('GARCH', 'GJR', etc)
 and distr = char('GAUSSIAN', 'T', 'GED' etc)) at different forecast periods
 (i.e. max_forecasts) as well as sort the results according to only a sub-set 
 of forecast periods.

 For example we may want to forecast volatility for upto to 22 days. In this case 
 max_forecasts will equal 22, but we are only interested for the
 1-day, 1- and 2-weeks and 1-month trading periods and therefore we specify 
 int_forecasts as [1, 5, 10, 22]. 

 Additionally, VaR forecasts are estimated by specifying a vector of a% 
 losses. For example we may be interested in the 95% and 99% losses and thus
 alpha = [0.95;0.99]. 
 
 It also allows the estimation of a rolling window forecasts for example: lets
 assume that our sample consists of 1000 observations, we want to estimate the
 volatility and VaR forecasts for the past 100 days therefore we set P = 100. 
 The following graph illustrates this:
                T = 1000, P = 100, t = T - P = 900
                1 ---------------- t ----------- T         Step 1
                ---- k ----------------- t + k ------- T   Step k

 This function also allows the estimation of a number volatility loss functions
 such as: mean square erro, R2LOG, among others; as well as a number of VaR
 back-testing metrics such as conditional coverage, interval and regulatory tests.

 Other features of this function is that it enables plotting the volatility 
 and VaR forecasts by adjusting the fields in the options variables. One may
 also supply series names, time steps, size of plots and a path where the plots
 are to be saved.  

 Please note, that in this example the evaluation metrics are estimated based on the 
 differences between forecasted variance and squared realised returns. 
 This application can be extended to incorporate for example realized 
 volatilities.
-----------------------------------------------------------------------
 USAGE: 
 results =  garchvolfor(data, model, distr, GARCH, ARCH, P, max_forecasts,
 int_forecasts, VaR, alpha)

 INPUTS:
 data:      (T x N) matrix
 model: 	a vector of supported models
 distr:     a vector of supported distributions
 ar:        positive scalar integer representing the order of AR
 am:        positive scalar integer representing the order of MA
 p:         positive scalar integer representing the order of ARCH
 q:         positive scalar integer representing the order of GARCH
 P:         rolling window (i.e. 100, 200, 300 last observations)
 max_forecasts: maximum number of forecasts (i.e. 1-trading months 22 days)
 int_forecasts: number of forecasts of interest 
 alpha:     vector of a% of VaR Losses
 options:   set of options:
            - options.formatresults, 'models'/'names': formats results according to models or names: default models
            - options.names: vector of names must have the same size as the number of data columns
            - options.plot,'on'/'off': plots volatility and VaR estimates: default 'off'
            - options.colnames, names used in the plots and must have the same size as the number of data columns
            - options.timesteps, time vector with length equal to the data
            - options.timestepformat, how to format time steps (i.e. mm-yyyy)
            - options.hight, plot hight
            - options.length, plot length
            - options.pathfig, path where the plots are to be saved
            - options.OutputResults,'on'/'off': presents the results of back-testing tests: default 'off'
    
 OUTPUTS: 
 results:  volatility and VaR back-testing results
 forecast: forecasted estimated of volatility, VaR and returns, organised
           either by model or by name
 summary:  summary of results

 NOTES:
 1. If int_forecasts is left empty then is considered 1:max_forecasts.
 2. If P is empty then  P = T.
-----------------------------------------------------------------------
 Author:
 Alexandros Gabrielsen, a.gabrielsen@city.ac.uk
 Date:     09/2010
 Update 1: 10/2010
 Update 2: 10/2011
-----------------------------------------------------------------------
 Notes:
 1. The estimation of VaR with Cauchy-Lorentz is for educational purposes only.
 2. Some combinations of specifications and distributions may not converge.
-----------------------------------------------------------------------
%}

if nargin == 0 
    error('Data, Model, Distribution, GARCH, ARCH, Period, Maximum number of forecasts, Number of forecasts of interest');
end

[T N] = size(data);

if isempty(P),       
    P = T;
end

if isempty(int_forecasts)
    int_forecasts = [1:1:max_forecast];
end

if nargin < 13 | isempty(options)
      options.OutputResults = 'off';
      options.plot = 'off';
      options.formatresults = 'models';
end

if isfield(options,'formatresults') & strcmp(options.formatresults,'names') 
    a=size(options.names,1);
    if a~=N
        error('Format results: names have different dimensions than data vector')
    end
    clear a
end

if isfield(options,'plot') & strcmp(options.plot,'on')
    if isempty(options.colnames) 
        error('Specify Plot Names')
    end
    if isempty(options.timesteps) 
        error('Specify Plot Time Steps')
    end
    [a b] = size(options.timesteps);
    if a~=T
        error('Plot timesteps have different length than the data vector');
    end
    clear a
    if isempty(options.timestepformat)
        error('Specify Plot Time Step Format')
    end
    if isempty(options.pathfig)
        error('Specify path where plots will be saved')
    end
    if isfield(options,'hight') 
        options.higth = 800;
    end
    if isfield(options,'length') 
        options.length = 250;
    end
end

%if nargin < 12 | isequal('VaR', VaR)
%    [a,b] = size(alpha);
%    if a>b
%        alpha = alpha';
%        [a,b] = size(alpha);
%    end
%end

t = T - P; % forecast period
tic % Keeping time

for m = 1:size(model,1)
    for d=1:size(distr,1)
        for i = 1:N % loop for the different time series
            k = 0; % time index
            for j = t:T-1 % forecast loop
                % Estimate the model
                [parameters, stderrors, LLF, ht, resids] = garch(data(1+k:j,i), strcat(model(m,:)), strcat(distr(d,:)), ar, ma, 0, p, q, 0,[],options);
                % Pass the parameters to estimate volatility and VaR forecasts to garchfor2 and garchvar2 functions
                [holder1, holder2, CM_holder, CV_holder] = garchfor2(data(1+k:j,i), resids, ht, parameters, strcat(model(m,:)), strcat(distr(d,:)), ar, ma, p, q, max_forecast);
                for hh = int_forecasts
                    eval(['VF_',num2str(hh),'(k+1,i)= CV_holder(hh,1);']);
                    if nargin < 12 | isequal('VaR', VaR)
                        for zz=1:size(alpha,1)
                            V_holder = garchvar2(data(1+k:j,i), resids, ht, parameters, strcat(model(m,:)), strcat(distr(d,:)), ar, ma, p, q, max_forecast, alpha(zz));                
                            pp = sprintf('%1.0f\n',alpha(zz)*100);
                            eval(['VaR',strcat(pp),'_',num2str(hh),'(k+1,i) =  V_holder(hh,2);']);
                        end
                    end
                end
                k=k+1; %index
            end
                % Organizing matrices and match time steps
                % FData: The out-of-sample time series are estimated as T = N - P;
                for hh = int_forecasts
                    eval(['forecast.VF_',strcat(model(m,:)),'_',strcat(distr(d,:)),'_',num2str(hh),'(:,i) = VF_',num2str(hh),'(hh:end,i);']); 
                    if nargin < 12 | isequal('VaR', VaR)
                        for zz=1:size(alpha,1)
                            pp = sprintf('%1.0f\n',alpha(zz)*100);
                            eval(['forecast.VaR_',strcat(pp),'_',strcat(model(m,:)),'_',strcat(distr(d,:)),'_',num2str(hh),'(:,i) = VaR',strcat(pp),'_',num2str(hh),'(hh:end,i);']);
                        end
                    end
                    for jj=0:P-hh
                        eval(['forecast.FData_',num2str(hh),'(jj+1,i)=sum(data(t+jj+1:t+jj+hh,i));']); 
                    end
                end
        end  
    end
end
clear i k j parameters stderrors LLF ht resids hh holder1 holder2 CM_holder CV_holder V_holder


if strcmp(options.formatresults,'models')
    % Format results according to models
    % Volatility & VaR Back-Testing
    for m = 1:size(model,1)
        for d=1:size(distr,1)
            for i=1:N
                for hh = int_forecasts
                    eval(['results.VF_',strcat(model(m,:)),'_',strcat(distr(d,:)),'_',num2str(hh),'= VFLF(forecast.FData_',num2str(hh),'.^2,','forecast.VF_',strcat(model(m,:)),'_',strcat(distr(d,:)),'_',num2str(hh),',options);']);       
                    if nargin < 12 | isequal('VaR', VaR)
                        for z = 1:size(alpha,1)
                            pp=sprintf('%1.0f\n',alpha(z)*100);
                            eval(['results.VaR_',strcat(pp),'_',strcat(model(m,:)),'_',strcat(distr(d,:)),'_',num2str(hh),' =VaRLR(forecast.FData_',num2str(hh),',forecast.VaR_',strcat(pp),'_',strcat(model(m,:)),'_',strcat(distr(d,:)),'_',num2str(hh),', 1-alpha(z), ''Long'',options);']);       
                        end
                    end
                end
            end
        end
    end
elseif strcmp(options.formatresults,'names')
    %k=0;
    for m = 1:size(model,1)
        for d=1:size(distr,1)
            for i=1:N
                for hh = int_forecasts
                    eval(['VF_holder_',num2str(hh),'=forecast.VF_',strcat(model(m,:)),'_',strcat(distr(d,:)),'_',num2str(hh),';']);
                    eval(['results.VF_',strcat(options.names(i,:)),'_',num2str(hh),'= VFLF(forecast.FData_',num2str(hh),'.^2,VF_holder_',num2str(hh),',options);']);
                    if nargin < 12 | isequal('VaR', VaR)
                        for z = 1:size(alpha,1)
                            pp=sprintf('%1.0f\n',alpha(z)*100);
                            eval(['VaR',strcat(pp),'_holder_',num2str(hh),'=forecast.VaR_',strcat(pp),'_',strcat(model(m,:)),'_',strcat(distr(d,:)),'_',num2str(hh),';']);
                            eval(['results.VaR_',strcat(pp),'_',strcat(options.names(i,:)),'_',num2str(hh),'= VaRLR(forecast.FData_',num2str(hh),',VaR',strcat(pp),'_holder_',num2str(hh),', 1-alpha(z), ''Long'',options);']);
                        end
                    end
                end
            end
            %k=k+1;
        end
    end
    %clear k 
end

% Plot Volatilities & VaR Forecasts
if strcmp(options.plot,'on') 
    k=0;
    for m = 1:size(model,1)
        for d=1:size(distr,1)
            modelnames(k+1,:) = [model(m,:),' ',distr(d,:)];
            for i=1:N
                for hh = int_forecasts
                    eval(['holder_',num2str(N),'_',num2str(hh),'(:,k+1)=forecast.VF_',strcat(model(m,:)),'_',strcat(distr(d,:)),'_',num2str(hh),'(:,i);']);
                    if nargin < 12 | isequal('VaR', VaR)
                        for z = 1:size(alpha,1)
                            pp=sprintf('%1.0f\n',alpha(z)*100);
                            eval(['VaR',strcat(pp),'_holder_',num2str(N),'_',num2str(hh),'(:,k+1)=forecast.VaR_',strcat(pp),'_',strcat(model(m,:)),'_',strcat(distr(d,:)),'_',num2str(hh),'(:,i);']);
                        end
                    end
                end
            end
            k=k+1;
        end
    end
    clear k
    % Volatility
    for i=1:N
        for hh = int_forecasts
            eval(['plot(options.timesteps(end-P+hh:end,1),holder_',num2str(N),'_',num2str(hh),');']);      
            datetick('x',options.timestepformat,'keepticks');
            xlim([options.timesteps(end-P+hh), options.timesteps(end)]);
            legend(modelnames, 'Location','EastOutside');
            xlabel('Time');
            ylabel('Volatility');
            set(gcf,'Position',[100,100,options.hight,options.length])
            saveas(gca, [options.pathfig,'\VF_',strcat(options.colnames(:,i)),'_',num2str(hh),'.emf']);
        end
    end
    delete(gcf)
    
    % VaR
    if nargin < 12 | isequal('VaR', VaR)
    for i=1:N
        for hh = int_forecasts
            for z = 1:size(alpha,1)
                pp=sprintf('%1.0f\n',alpha(z)*100);
                eval(['plot(options.timesteps(end-P+hh:end,1),[FData_',num2str(hh),',VaR',strcat(pp),'_holder_',num2str(N),'_',num2str(hh),']);']);      
                datetick('x',options.timestepformat,'keepticks');
                xlim([options.timesteps(end-P+hh), options.timesteps(end)]);
                legend({'Returns',modelnames}, 'Location','EastOutside');
                xlabel('Time');
                ylabel('Returns');
                set(gcf,'Position',[100,100,options.hight,options.length])
                saveas(gca, [options.pathfig,'\VaR',strcat(pp),'_',strcat(options.colnames(:,i)),'_',num2str(hh),'.emf']);
            end
        end
    end
    end
    delete(gcf)
end




% Saving Information
summary.Models = model;
summary.Distribution = distr;
summary.Forecast_Period = P;
summary.Max_Forecast = max_forecast;
summary.Time = toc/60; % minutes


end