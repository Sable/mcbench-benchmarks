function [LambdaHat,LambdaInterval]=boxcoxlm(y,X,PlotLogLike,LambdaValues,alpha)
% This function helps finding a power transformation y^Lambda to a linear
% model (multiple linear regression, as used in the form of the function
% "regress" of MATLAB's statistical toolbox).
% The purpose of using it is finding a good value for lambda, transofrming
% the dependent variable, through a Box-Cox power transformation
%
% It will calculate the Maximum Likelihood (up to a constant) for all
% values in the vector LambdaValues (Default: -2:0.01:2), 
% and plot the relation; in addition it will emphasize the 1-alpha confidence region
% for lambda's best value (the one that maximizes the log-likelihood)
%
% usage: 1) LambdaHat=boxcoxlm(y,X)
%                        y & X are as defined in the function "regress",
%                        LambdaHat is the value of Lambda in -2:.01:2 that
%                        maximizes the Maximum Log-Likelihood(lambda)
%                        This form will also produce a plot
%                2) LambdaHat=boxcoxlm(y,X,0)  - calculate LambdaHat without plotting
%                3) LambdaHat=boxcoxlm(y,X,1,LambdaValues) - enables the user to
%                replace -2:.01:2 by any other region and precision
%                4) LambdaHat=boxcoxlm(y,X,1,LambdaValues,alpha) - chooses a
%                different than the default (alpha=0.05) value for the
%                confidence interval
%                5) [LambdaHat,LambdaInterval]=boxcoxlm(...)   - Gives the
%                confidence interval for lambda in LambdaInterval
%
% Examples:
%       1) X= [ones(10,1) (1:10)'];
%          y = (X * [10;1] + normrnd(0,0.2,10,1)).^2;
%          LambdaHat=boxcoxlm(y,X)
%
%          This should produce LambdaHat of roughly 0.5
%
%       2) X= [ones(10,1) (1:10)'];
%          y = (X * [10;1] + normrnd(0,0.2,10,1)).^2;
%          [LambdaHat,LambdaInterval]=boxcoxlm(y,X)
%
%          This should produce LambdaHat of roughly 0.5, and its confidence
%          interval in LambdaInterval
%
%       3) X= [ones(10,1) (1:10)'];
%          y = (X * [10;1] + normrnd(0,0.2,10,1)).^2;
%          LambdaHat=boxcoxlm(y,X,0)
%
%           Identical to the first example, but does not produce a plot
%
%       4) X= [ones(10,1) (1:10)'];
%          y = (X * [10;1] + normrnd(0,0.2,10,1)).^0.5;  % Note 0.5 replaced 2 in the power
%          LambdaHat=boxcoxlm(y,X,0,[-2:.01:5])
%
%           LambdaHat should be rougly 2, and the Lambda possible range
%           was replaced by [-2:.01:5] for better coverage
%
%       5) X= [ones(10,1) (1:10)'];
%          y = (X * [10;1] + normrnd(0,0.2,10,1)).^0.5;  
%          LambdaHat=boxcoxlm(y,X,0,[-2:.01:5],0.2)
%
%           Same as the last example, 80% confidence interval
%
%
% based on G. E. P. Box, D. R. Cox, "An Analysis of Transformation", Journal of the Royal Statistical Society. Series B (Methodological), Vol. 26, No. 2 (1964) , pp. 211-252
%
% Code written by Hovav Dror, hovav@hotmail.com, March 2006

if nargin<2
    fprintf('minimum form: boxcoxlm(y,X) \n');
    fprintf('optional form:[LambdaHat,LambdaInterval]=boxcoxlm(y,X,PlotLogLike,LambdaValues,alpha) \n');
    fprintf('see function for more details\n');
    return;
end;

% put default values if needed
if nargin<5
    alpha=0.05;
    if nargin<4
        LambdaValues= -2:.01:2 ;
        if nargin<3
            PlotLogLike=1; % Default - plot; if PlotLogLike=0, no plots
        end;
    end;
end;
            

MinY=min(y)-realmin;
if MinY<0 % if y contains non-positive values, the transofmation is slightly different
    fprintf('y contains non-positive values! Using y+min(y) \n');
    y=y+abs(MinY);
end;
SigmaLogY=sum(log(y));

n=length(y);
Xr=eye(n)-X*(X'*X)^(-1)*X';
LogLike=[];
for Lambd=LambdaValues
    if Lambd~=0
        Ylambda=(y.^Lambd-1)/Lambd;
    else
        Ylambda=log(y);
    end;
    VarHat=Ylambda'*Xr*Ylambda/n; % sigma^2 estimate by least squares
    % Now calculate this specific lambda LogLike:
    LogLike(end+1)=-0.5*n*log(VarHat)+(Lambd-1)*SigmaLogY; %  Maximum Log likelihood estimate up to a constant, for a fixed lambda
end;

% Best Lambda:
LambdaHat=mean(LambdaValues(LogLike==max(LogLike)));

% Calculate Confidence Interval
if PlotLogLike==1 || nargout>1 
    LogLike2=max(LogLike)-LogLike;
    LogLikeInterval=LogLike2<0.5*chi2inv(1-alpha,1) ;
    if nargout>1
        LambdaInterval=[min(LambdaValues(LogLikeInterval)) max(LambdaValues(LogLikeInterval)) ];
    end;
end;


% Plots:
if PlotLogLike==1
    plot(LambdaValues,LogLike); % plot the Log-Like estimate (up to a constant) vs. Lambda
    AxisValues=axis;
    hold on
    % plot a dotted line showing the best lambda
    plot([LambdaHat LambdaHat],[AxisValues(3) max(LogLike)],':');
    if LambdaHat<max(LambdaValues) && LambdaHat>min(LambdaValues)
        stext=sprintf('%1.1f',LambdaHat);
    else
        stext=sprintf('out of region',LambdaHat);
    end;
    text(LambdaHat,mean([AxisValues(3) max(LogLike)]),stext,'HorizontalAlignment','center');
    % Now plot the 1-alpha confidence interval
    LogLike2(LogLikeInterval)=min(LogLike(LogLikeInterval));
    LogLike2(~LogLikeInterval)=AxisValues(3);
    stext=sprintf('%2.0f%% confidence interval for \\lambda',round(100*(1-alpha)));
    text(LambdaHat,mean([max(LogLike) max(LogLike2)]),stext,'HorizontalAlignment','center');
    plot(LambdaValues,LogLike2,':');
    hold off
    % last, put titles
    xlabel('\lambda');
    ylabel('Max Log-Likelihood(\lambda), up to a constant');
    title('Box-Cox Power Transformation for a Linear Model');
end;

    
