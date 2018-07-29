function [Index] = find_outliers_Thompson(X, alpha, method, pri)
% find_outliers_Thompson
% Find outliers in a data series using the "modified Thompson's Tau method"
% 
% find_outliers_Thompson(X)
%   For vectors or matrix with at least 3 valid values (the routine manages 
%   NaNs), find_outliers_Thompson(X) gives the indexes of elements in X  
%   that are considered outliers as defined by the modified Thompson Tau 
%   method.
%   If no outliers are found an empty matrix is returned.
%   The indexes of the outliers are ordered with respect to their severity.
%   When X is matrix it is taken as a whole sample. To operate on single
%   columns or rows, a series of calls to the routine are needed.
% 
% find_outliers_Thompson(X, alpha)
%   As additional input alpha, the critical value for the test, can be
%   specified (a value between 0 and 0.5 is expected). Otherwise a default
%   value of 0.01(1%) will be used.
%   To skip this use the empty value [].
% 
% find_outliers_Thompson(X, alpha, method)
%   As third input the methods for the calculation of the sample statistics
%   on wich the test is performed can be specified. 
%   The three methods gives usually the same result even if some data can 
%   be an outlier or not depending on the selected method. In case of 
%   outliers the 'biweight'(default) is expected to be the most reilable 
%   method. Available values for 'method' are:
%    'median'  the statistics used are median and pseudo-deviation, very 
%              robust to outliers. The pseudo-deviation is computed 
%              with respect to the normal distribution.
%    'mean'    in this case the statistic is not robust to outliers but it 
%              can be useful to compare the results of robust statistics 
%              with the more used versions of the Tau test.
%              In particular, with the mean statistic if a 3 sample data is
%              given and it includes a very big outlier it will be accepted
%              anyway.
%    'biweight' (default statistics) is only a bit less robust than the 
%               median but it is more efficient for the definition of the 
%               center of the distribution. It is more time consuming then 
%               the other two methods. In this case biweight mean and 
%               biweight standard deviation are used.
%   To skip this use the empty value [].
% 
% find_outliers_Thompson(X, ..., ..., pri)
%   With pri = 1 the routine plots a graph showing the original X values, 
%   the outliers identified with the test, if any, the final deviation 
%   around the center of the sample and the final critical bounders. 
%   If pri = 0 (as default) the routine doesn't plot any figure.
% 
% 
% WARNING: if the statistical toolbox is not installed the routine works
%          aniway but alpha will be fixed to 0.01. A linear interpolation 
%          of table values is used.
% 
%   Example 1: 
%   If 
%     X = [44 -5 45 48 41 45 42 43 44 46 46 150]'
% 
%   then the routine will return the vector: 
% 
%     Index = [12; 2]
% 
%
%   Example 2: 
%   If 
%     X = [34 -5 35 35 33 34; 37 38 35 35 36 150]'
% 
%   then the routine will anyway return the vector: 
% 
%     Index = [12; 2]
%   
%   To obtain a separate analysis of the two columns write:
%   
%     Index1 = find_outliers_Thompson(X(:,1), alpha)
%     Index2 = find_outliers_Thompson(X(:,2), alpha)
%
%   To obtain a separate analysis on many columns:
% 
%     Nc = size(X, 2); % number of columns of X
%     for n = 1:Nc; a = find_outliers_Thompson(X(:,n), alpha);
%     Index1(1:numel(a),n) = a; end
% 
% 
% References:
%
% on the test
%    Measurement Uncertainty, Part I, ASME PTC 19.1 1998
% recommended for the individuation of outliers in a set of repeted
% measurements.
%    Thompson R. 1985. A note on restricted maximum likelihood estimation
% with an alternative outlier model. Journal of the Royal Statistical 
% Society. Series B vol 47, 53-55
%    Christensen R., Pearson LM., Johnson W. 1992. Case deletion
% diagnostics for mixed models. Technometyrics. Vol 34, 38-45.
% 
% on the robust methods and the biweight mean:
%    Lanzante JR. 1996. Resistant, robust and non-parametric techniques for
% the analysis of climate data: theory and examples, including applications
% to historical radiosonde station data. International Journal of
% Climatology, vol.16, 1197-1226.
%
% 
% Author:  Michele Rienzner
% e-mail:  michele.rienzner@unimi.it
% Release: 3.1
% Release date: 5/17/2010

%% checkup script: use it to verify how the test works
% The four lines below generates a vector (X) containing at the most 3
% outliers in the positions 2, 5 and 10 in a sample of 20 data values. and 
% 3 values are missing (index 13:18). Than the routine is called and an 
% estimation of the outliers is donem their indexes are displayed and a
% figure is plotted. This is repeated 5 times giving different results.
% 
% alpha = 0.01; method = 'biweight';
% for n= 1:5; X = randn(20,1); X([2 5 10]) = X([1 5 10])*10; X(13:18) = NaN;
% [Index] = find_outliers_Thompson(X, alpha, method, 1), end
% 

%% Notes on the algorithm:
% 
% tau = t*(N-1) / (sqrt(N)*sqrt(N-2+t^2));
% where t is the value of the Student's-t with cumulate non-passing 
% probability of 1-alpha/2 and N-2 degrees of freedom
% 
% Suspicious = max(abs(x-mean(x)));
% S = std(x);
% if Suspicious > tau*S
% Suspicious is an outlier, its index is recorded and the value is erased 
% in x
% 
% the former steps are executed again until no new outlier is found.


%% Default statements
Def_alpha  = 0.01;          % usual value for alpha
Def_method = 'biweight';    % method for the computation of mean and deviation
Def_pri    = 0;             % default is "do not plot anything"
X = X(:);                   % making X a column array

%% print figure
if nargin>3
    if pri==1
        X0 = X; N0 = numel(X0); maxX = max(abs(X0));
        figure; plot(X0, '.b'); hold on;
        xlabel('Index of the values'); ylabel('Values');
    end
end

%% initializations
I = find(~isnan(X)); 
X = X(I);                      % only the valid data are analyzed
N = numel(X);                  % determine the number of valid values in X
PrAllInd = 10;                 % preallocation size for Index
Index    = zeros(PrAllInd,1);  % preallocation for Index
h        = 0;                  % last writing position on Index;
statTool = license('test', 'statistics_toolbox'); % check the presence of the statistic toolbox

%% Input control
if N<3
    error('Input data must have at least 3 valid values.');
end
if nargin<2
    alpha = [];
end
if isempty(alpha)
    alpha = Def_alpha;
elseif alpha<0 || alpha>0.5
    error('The second input "alpha" must be within 0 and 0.5 .')
elseif alpha ~= Def_alpha
    if ~statTool
        error(['To work with different values of alpha the statistic_toolbox is needed.';
               'Without that toolbox the only available value for alpha is 0.01 (1%).  '])
    end
end
if nargin<3
    method = [];
end
if isempty(method)
    method = Def_method;
end
if nargin<4
    pri = [];
end
if isempty(pri)
    pri = Def_pri;
elseif pri~=0 && pri~=1
    error('Allowed values for ''pri'' are only 0 (do not plot) and 1 (plot)')
end

[X, indx] = sort(X);        % sorting of valid data values (this makes the routine simpler)
indI      = I(indx);        % indexing of the original data values in the sorted vector (needed to point the values on the original vector)
[Mr, Sr]  = meanStd_sub(X, method);      % robust values for mean and standard deviation
tau       = tau_sub(N, alpha, statTool); % value of the tau statistic

%% Find out the outliers
while max(abs(X([1,N])-Mr)) > tau*Sr && N>=3
    if max(abs(X(1)-Mr)) > max(abs(X(N)-Mr)) 
        % the lower value is an outlier, its index is recorded while the
        % value is erised
        h = h+1;        Index(h) = indI(1);     
        X(1) = [];      indI(1) = [];   N = N-1;
    else
        % the higher value is an outlier, its index is recorded while the
        % value is erased
        h = h+1;        Index(h) = indI(N);     
        X(N) = [];      indI(N) = [];   N = N-1;
    end
    [Mr, Sr]  = meanStd_sub(X, method);      % update the values for mean and standard deviation
    tau       = tau_sub(N, alpha, statTool); % update the value of the tau statistic
end

%% Output cleanup
if h<PrAllInd % null elements of Index must be removed
    Index(h+1:PrAllInd) = [];
end

%% Plot of the outliers 
if pri
    n_max = fix(maxX/Sr);
    if numel(I)~=numel(X0)
        I1 = find(isnan(X0));
        plot(I1, ones(numel(I1))*Mr, 's', 'MarkerSize', 3, 'MarkerFaceColor', ...
            [0.5 0.5 0.5], 'Color', [0.5 0.5 0.5])
    end
    plot([1; N0], Mr+Sr*([1; 1]*(-n_max:n_max)), ':', 'Color', [0.75 0.75 0.75])            % plot the final deviations borders
    plot([1; N0], [Mr; Mr], 'k-')
    plot([1; N0], [Mr+tau*Sr, Mr-tau*Sr; Mr+tau*Sr, Mr-tau*Sr], 'r-')
    plot(Index, X0(Index), 'or', 'MarkerSize', 8, 'LineWidth', 2) % highlight the outliers
    title(['Find Outliers with Thompson Tau (\alpha=', num2str(alpha), ', Method=', method, ')']);
end

end

function tau = tau_sub(N, alpha, statTool)
% sub function computing the right value of Tau

if statTool                                 % the statistics toolbox is present 
    t = tinv(alpha/2, N-2);                 % finds the exact critical t-value
    tau = -t*(N-1)/(sqrt(N)*sqrt(N-2+t^2)); % computates tau
    
else % (alpha fixed = 0.01)
    % table of values 
    N_v = [3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 ...
        26 27 28 29 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100];
    tau_v = [1.1546 1.4850 1.7150 1.8722 1.9832 2.0649 2.1271 2.1761 2.2155 2.2478 ...
        2.2749 2.2979 2.3176 2.3347 2.3497 2.3629 2.3747 2.3853 2.3948 2.4034 ...
        2.4112 2.4183 2.4249 2.4309 2.4365 2.4416 2.4464 2.4509 2.4692 2.4829 ...
        2.4934 2.5018 2.5087 2.5144 2.5192 2.5233 2.5268 2.5299 2.5326 2.5351 ...
        2.5372	2.5392];
    tau1000 = 2.5722;
    
    % pick the better value from tau_v
    if N<=30 % the exact (rounded) value is present
        tau = tau_v(N-2);
    elseif N<=100 % an estimation is possible interpolating the table values
        I1 = find(N_v <  N, 1, 'last');
        I2 = find(N_v >= N, 1, 'first');
        tau = tau_v(I1) + (tau_v(I2)-tau_v(I1))/(N_v(I2)-N_v(I1))*(N-N_v(I1));
    elseif N<1000 % an estimation is possible interpolating between tau(100) and tau(1000)
        tau = tau_v(end) + (tau1000-tau_v(end))/900*(N-100);
    else % after N=1000 the value of tau is quite flat
        tau = tau1000;
    end
end
end

function [Mr, Sr] = meanStd_sub(X, method)
% sub function computing Mean and standard deviation of the sample
% in a context of outliers a robust estimation of mean and standard
% deviation is usually suggested.

switch method 
    case 'mean'
        Mr = mean(X);
        Sr = std(X);
    case 'median'
        Mr  = median(X);           % robust estimation of the mean
        a   = quantile(X, [0.25, 0.75]); 
        Sr  = (a(2)-a(1))/1.349;   % robust estimation of the standard deviation
    case 'biweight'
        N   = numel(X);            % number of values in the sample
	    c   = 7.5;                 % censor value, it corresponds to a certain number of standard 
        %                            deviations for a normal distribution:
                                   % c=6 is 4 std; c=7.5 is 5 std; c=9 is 6 std.
        M   = median(X);           % median of the sample
        MAD = median(abs(X-M));    % median absolute deviation that is the median of the sample 
        %                            of the absolute values of the differences from the median
        w   = (X-M)/(c*MAD);       % weights for the computation of the biweight mean
        w(abs(w)>1) = 1;           % censoring of the wheights
        Mr  = M+ sum((X-M).*(1-w.^2).^2)/sum((1-w.^2).^2); % computation of biwheight mean
        Sr  = sqrt(N*sum((X-M).^2.*(1-w.^2).^4))/abs(sum((1-w.^2).*(1-5*w.^2))); % computation of biwheight std
    otherwise
        error('the method parameter has a wrong value; permitted values are: ''mean'', ''median'', ''biweight'' ')
end
end
