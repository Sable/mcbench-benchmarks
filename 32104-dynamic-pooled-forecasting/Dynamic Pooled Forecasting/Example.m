% POOLING FORECASTS - Semin Ibisevic (2011)
% http://www.mathworks.com/matlabcentral/fileexchange/authors/114076
%
%   The full description of this package is given in the attached pdf file
%   'Pooling Forecasts.pdf', along with the explanation of the terms used.
%   
%   To combine the different sources of information we discuss two 
%   techniques. The first relates to combining forecasts which is widely 
%   applied and used in literature (Rapach et al.,2010). Second we pay 
%   attention to principal component regressions. This techniques is 
%   especially useful when dealing with a large amount of explanatory 
%   factors. Both techniques are based on a real time framework.
%
%   The (minimal) input requirements are:
%   'X'     :n-by-k matrix of n observations and k explanatory factors
%   'y'     :n-by-1 vector of n observations representing the dependent 
%           variable 
%   'm'     :The start of the holdout period
%   
%   The user has the choice to specify the following parameters
%
%           'rol'           length of the rolling window. In case 'rol' is 
%           set equal to zero, the corresponding individual forecasts and 
%           pooled regression are made through an expanding window 
%           framework. IMPORTANT, it should always hold that m >> rol to 
%           prevent large estimation errors.
%
%           'lag'           the number of lags in the regressions 
%                           Y(t) = c1 + c2*X(t-lag)
%
%           'distr'         type of regression. Acceptable values for DISTR 
%           are 'normal', 'binomial', 'poisson', 'gamma', and 'inverse 
%           gaussian'.  The distribution is fit using the canonical link 
%           corresponding to DISTR. See also the GLMFIT function for 
%           further explanation.
%
%           'type'          the combination technique applied to combine
%           the individual forecasts. The current available methods are the
%           simple averaging schemes 'mean' and 'median', and the weighted
%           discount method of Stock and Watson (2004), aproached through 
%           typing 'weight'. In case one selects for 'weight' additional
%           parameters values are needed for the input: 'q0' and
%           (optionally) 'theta', see below for the description.
%
%           'q0'            the length of the hold-out-period
%
%           'theta'         the discount factor in case of weighted
%           combination of the individual forecasts. Smaller than 1 means 
%           that recent observations have more infuence in calculating the 
%           weights. In case this value is not specified, the combinefc
%           function sets this parameter equal to 0.9 as default.
%
%           'J'             the number of principal components to include
%           in the pooled regression. J is set equal to 1 as default.
%
%           'Zbin'          defines whether de principal components should
%           be obtained through taking the eigenvectors of the correlation
%           matrix of X accessed through 'Zbin' = 'corr', or on the 
%           covariance matrix 'Zbin' = 'cov'. 

%EXAMPLE DATASET
% load dataset on monthly closing prices (2005m01-2010m12) retrieved from 
% yahoo; 
%
% identify FTSE, DJI, XETRA, CAC40 and AEX as the predictors, stored in 'X' 
% and AEX as the response stored in 'y'. Note that in this way we assume a 
% minimal lag of 1 as we also use the dependent variable as predictor, i.e. 
% we incorporate an autoregressive component.
% - obligated input
load dataset
m = 30;

% - optional input
rol = 0;
lag = 1;
distr = 'normal';
type = 'weight';
q0 = 10;
theta = 0.95;
J = 5;
Zbin = 'corr';

%INDIVFC: Make individual forecasts
%   [YIV, EIV] = INDIVFC(X, y, m, ...) fits multiple individual generalized 
%   linear models per factor using the predictors stored in matrix X and 
%   response Y with the in-sample ending at M by the means of the GLMFIT 
%   function, and makes multiple one-step ahead forecasts on the base of 
%   Y(t) = c1 + c2 X(t-lag,j). 
[Yiv, Eiv] = indivfc(X, y, m, rol, lag, distr);

%COMBINEFC: Combine the individual forecasts
%   [Yc, Ec] = combinefc(y, Yiv, ... ) combines the individual forecasts
%   YIV through the selected methods: simple averaging schemes or a
%   weighted discounting function.
[Yc, Ec] = combinefc(y, Yiv, type, theta, q0);

%PCFAC: Make forecasts with the principal components
%   [Yp, Ep, ...] = PCAFC(X, Y, M, ...) makes forecasts by taking the 
%   principal components of X as predictors and y as the response variable.
%   The estimates of the coefficients are obtained through GLMFIT.
[Yp, Ep, coeff, score, latent] = pcafc(X, y, m, J, Zbin, rol, lag, distr);


%PLOT1: Forecasts
figure
hold on
startDate = datenum('01-01-2005');
endDate = datenum('12-01-2010');
% Create xdata to correspond to the number of  months between the start 
% and end dates:
xData = linspace(startDate,endDate,size(y,1));

plot(xData,y,'k.-','Linewidth',1);
plot(xData(m+q0+2:size(y,1)),Yc(m+q0+2:size(y,1)), 'g.-', 'Linewidth', 2)
plot(xData(m+q0+2:size(y,1)),Yp(m+q0+2:size(y,1)), 'b.-', 'Linewidth', 2);
legend('Actual',['Combined- ',type], ['PCA -',' J=', num2str(J),' (',Zbin,')']);
title(['AEX index - ','Estimation: ',distr]);
xlabel('Time');
ylabel('Closing Prices');
          
% Convert the x tick labels to year names
set(gca,'XTick',xData)
datetick('x','yy')


%PLOT 2: the total variance explained by j principal components at 
% every point at the time
figure
hold on
plot( xData, cumsum(latent,2)./ repmat(sum(latent,2),1,size(latent,2)), 'Linewidth', 2)
title('Total variance explained by J principal components');
xlabel('Time');
ylabel('Total variance in the components');

% Convert the x tick labels to year names
set(gca,'XTick',xData)
datetick('x','yy')

%FINAL WORD
%   In this example the PCA fails to predict the unconditional mean
%   accurately. Possible explanations could be related to the deduction of
%   the information through the filtering of the noise, which contained
%   some valuable content. Still, in case of large information set with lot
%   of correlated factors, a PCA could be beneficial and outperform the 
%   weighted function significantly (Neely et. al, 2011 and Ibisevic, 2011)

% References:
%   C. J. Neely, D. E. Rapach, J. TU, and G. Zhou. Out-of-sample equity 
%   premium prediction: Fundamental vs. technical analysis. Technical 
%   report, Singapore Management University, 2011.
%
%   S. Ibisevic. Measuring the information content of the dependent 
%   variable: Moments as predictors of the equity premium. Technical 
%   report, 2011.