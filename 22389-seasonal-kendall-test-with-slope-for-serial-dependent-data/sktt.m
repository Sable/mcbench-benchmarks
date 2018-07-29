%% Seasonal Kendall Trend Test for Data with and without Searial Dependance.
% Calculates a non-parameteric trend test of monotonic trends using
% seasons.
%
% *Tau-b seasonal*: takes into account ties (and multiple observations,
% except, the data are preprocessed in a subfucntion and multiple
% observatiosn per a given season are averaged using median).
%
% *Tau-a seasonal*: does not consider multiple observations per season as
%       ties (i.e. all values are included). The data are preprocessed,
%       seasons with multiple observations are summarized with a median value.
%
% This routine will take into account data evenly spaced by seasons.  Compute
% Seasonal Tau-b, Tau, Sen's slope and it's confidence intervals.
%
% Accounting for Serial Correlation is based on the below paper:
%  Hirsch, R. M., Slack, J. R., A Nonparametric Trend Test for Seasonal
%  Data with Serial Dependence.  Water Resources Research Vol 20, No. 6,
%  pages 727-732, June 1984.
%
%  Modifications:
%    12/13/2008 - added Homogeneity test of trends for different seasons.
%    12/17/2008 - added adjustments to significance with serial
%    correlations removed by computing covariance instead of assuming zero.
%    Starting season can be users specified.
%    12/18/2008 - mulitiple observations in a single season are median
%                 averaged.
%    1/17/2009 - checks for anomalies and provides solutions and/or
%                notifications.  Also requires the updated ktaub.m file
%                because of the need for a computed variance with no ties
%                removed.
%    2/2/2009 - modified comments in this file
%    2/21/2012 - when there were multiple values within the same season,
%    the seasonAverage subroutine wasn't storing the averaged data
%    correctly. Fixed in this revision. Thank you to Juan Carlos for pointing
%    this out!  
%
% *Testing for anomalous conditions*
%
% When calculating trends, there are a few situations that create anomalies
% in the estimates. Foremost, when S = 0, significance will always be
% 100-percent, which is not possible. When this occurs the p-value is
% adjusted by using the computed variance, but assuming S = 1.  However,
% the output from the function will still show S=0 when the case arises.
%
% Secondly, a statistically significant slope = 0 can occur when there are
% a large number of ties in the data.  In this case, a second test is done
% assuming the number of ties is equal an even number positive and negative
% differences.  Significance is tested again, but the output is only sent
% to the screen.  The p-value returned in the function is still the
% original p-value (and the adjusted p-value for serial correlation).
%
% These test for anomalies and solutions are based on a paper:
%
% _Anomalies and remedies in non-parametric seasonal trend tests and
% estimates_, by Graham McBride, National Institute of Water & Atmospheric
% Research, Hamilton New Zealand.  March 2000.
%
% Dependencies:
%
% # <http://www.mathworks.com/matlabcentral/fileexchange/11190 ktaub.m> (Updated 1/17/2009)
% # <http://www.mathworks.com/ Statistics Toolbox>
%
% This function does require
% <http://www.mathworks.com/matlabcentral/fileexchange/11190 ktaub.m>
% which has also been revised to support this function, so if you've
% previously downloaded ktuab.m, please check to make sure you have the
% most recent version.
%
%
% *Note:*
%
% Calculating the covariance depends on when your seasons start in
% the year.  For example, the USGS program Kendall.exe will automatically
% assume that Season 1 is the start of a water year (i.e. Season 1 =
% October, Season 12 = September). True that the 1984 Hirsch
% paper is dervied using 12-seasons (i.e. months), it is certainly
% reasonable to assume that the number of seasons can be something other
% than 12 months, and not necessariliy starting in October.  So this
% function allows for the user to specify when Season 1 is to start.  This
% nuance is critical because incomplete years are filled in with mid-ranks
% in the covariance.
%
% There is a slight difference in the USGS Kendall.EXE to this function.
% They divide a year into 12 equal time periods per year, which is close to
% months, but not quite the same. It is worth noting that assuming a
% constant base year starts 0.75 years into it, the starting date for the
% year alternates between leap years and non-leap years, so the assumed
% calendar day-time of the year is not constant.
%
% Their formula is:
%
%  jprd = (dectime(iobs) - base) * nseas + 1 ! Time period.
%
% Using their example, two observations taken from SK1C.txt, have the
% decimal times of: 1979.2614, 1979.3327.
%
%  (1979.2614 – 1974.75) * 12 + 1 = 55.1368
%  (1979.3327 – 1974.75) * 12 + 1 = 55.9924
%
% Thus they are assumed to be from the same season. When in fact those
% decimal years refer to April 5, 1979, and May 1, 1979-- different months.
%
% Surprisingly there is high sensitivity to this issue.  Output from
% Kendall.EXE
%
%  tau = -0.063
%  Z=-0.5841
%  S= -12
%  sig = .5592
%  sig-adjusted = 0.2838
%
% If you force the seasons to monthly, the results would be:
%
%  tau = -0.046
%  Z=-0.4180
%  S= -9
%  sig = .6760
%  sig-adjusted = 0.4229
%
% If you manually adjust that record to match what Kendall.exe would do,
%  sktt.m  would produce the same results as Kendall.EXE.
%
% All said, the differences between the Kendall.EXE and this function
% are more philosophical.  Nonetheless, using the Kendall.exe and using the
% defined seasons option will give the same results as this function. The
% decimal year option is where we differ.  When I get around to it, I'll
% add that option in this function as well.  Always like to have the option
% of consistentcy.
%
% These seasonal statistics were inspired by: Richard O. Gilbert, Pacific
% Northwest National Laboratories, "Statistical methods for Environmental
% Pollution Monitoring", 1987, Van Nostrand Reinhold, New York Publishing,
% ISBN 0-442-23050-8.
%
% A good supporting statistic that may prove useful is performing a global
% trend test evaluating homogeneity of trends for different stations and
% seasons.  See the posted function named:
% <http://www.mathworks.com/matlabcentral/fileexchange/22440
% GlobalTrends.m>
%
% I found a few other resources worth mentioning applying
% this statistic.
%
% THE COMPUTER PROGRAM ESTIMATE TREND (ESTREND), A SYSTEM
%   FOR THE DETECTION OF TRENDS IN WATER-QUALITY DATA
%   By Terry L. Schertz, Richard B. Alexander, and Dane J. Ohe
%       U.S. GEOLOGICAL SURVEY
%       Water-Resources Investigations Report 91-4040
%
% Statistical Methods in Water Resources
%   By D.R. Helsel and R.M. Hirsch
%
% <http://water.usgs.gov/pubs/twri/twri4a3/>
%
% Computer Program for the Kendall Family of Trend Tests
%   by Dennis R. Helsel, David K. Mueller, and James R. Slack
%  Scientific Investigations Report 2005-5275
%
% <http://pubs.usgs.gov/sir/2005/5275/downloads/>
%
% It's my understanding that there is a seasonal statistic done in R as
% well, but I do not have a link to it.
%
% datain structure is assumed to vary as the following:
%
% * datain(:,1) = Time (e.g. year)
% * datain(:,2) = season
% * datain(:,3) = data
% * alpha = assumed level of confidence
% * wantplot = flag if ~= 0 then a figure will be created if Tau-b is
% significant.
% * StartSeason = shift seasons to start with this one.
%
% Example: StartSeason = 10 will shift seasons 10 = 1, then years are
%    adjusted to start with the new season shift.
%
% *Syntax:*
%
%  [taubsea tausea Sens h sig sigAdj Zs Zmod Ss Sigmas CIlower CIupper]
%                 = sktt(datain,alpha,wantplot,StartSeason)
%
% Written by
% Jeff Burkey,
% King County, Department of Natural Resources and Parks
%
% jeff.burkey@kingcounty.gov
function [taubsea tausea Sens h sig sigAdj Zs Zmod Ss Sigmas CIlower CIupper] = sktt(datain, alpha, wantplot,StartSeason)
    
    % StartSeason is a flag to adjust seasons and shift years
    if exist('StartSeason','var') == 0
        % user didn't provide assume one and do not shift
        StartSeason = 1;
    end
    
    % See function at end of this m-file
    datain = AdjustSeasons(datain,StartSeason);
    [m,n] = size(datain);
    
    % wantplot is a flag to create a figure or not default set to no
    if exist('wantplot','var') == 0
        % user didn't provide assume zero (i.e. no plot)
        wantplot = 0;
    end
    
    if n >= 3
        % Sort by Time then by Season (or data value)
        sorteds = [sortrows(datain, [1,2]) ones(m,1)] ;
        Seasons = unique(datain(:,2));
    else
        % there is a problem in the structure of the data
        error('ErrorSeasonalTrend:sktt', 'There is a problem in the structure of the input data.\n');
    end
    
    NumOfSeasons = length(Seasons);
    nyears = max(datain(:,1))-min(datain(:,1)) + 1;
    baseyear = min(datain(:,1))-1;
    
    % set minimum data per season to length of dataset.  This is used to
    % determine if S should be adjusted for approximation of normallacy.
    minn = m;
    sens = [];
    
    for ii = 1:NumOfSeasons
        data = sorteds(sorteds(:,2)==ii,:);
        [taub(ii) tau(ii) h(ii) sig(ii) Z(ii) S(ii) sigma sen(ii) n(ii) splot CIlower CIupper D(ii) Dall(ii) C3 nsigma] = ktaub([data(:,1) data(:,3)], alpha);
        vars(ii) = sigma^2;
        nvars(ii) = nsigma^2;
        sens = [sens; C3];
        if minn > n(ii)
            minn = n(ii);
        end
    end
    
    %% Test for homogeneity of trends for different seasons.
    % If different seasons have different directions, the Seasonal Kendall
    % test and slope will be misleading. - Gilbert page 229
    ChiTotal = sum(Z.^2);
    ChiTrend = NumOfSeasons*(sum(Z)/NumOfSeasons)^2;
    ChiHomog = ChiTotal - ChiTrend;
    % if ChiHomog exceeds the alpha critical value with df = K-1 seasons
    % then Kendall Seasonal test and slope are not valid, individual
    % seasons should be evaluated.
    alphaCritical = chi2inv(1-alpha,NumOfSeasons-1);
    if ChiHomog > alphaCritical
        % Seasonal Kendall not valid, compute individual Tau-b and Slope
        % for each season.
        fprintf('SKTT Warning: Seasonal Kendall test and slope not valid.\n');
    else
        alphaTrend = chi2inv(1-alpha,1);
        if nyears < 10
            fprintf('SKTT Warning: There are less than 10-years of data used per season.\n');
            fprintf('         Type-II error may occur when testing for common trend in all seasons.\n');
        end
        if ChiTrend < alphaTrend
            % There is a common trend for all seasons
            fprintf('\nSKTT Message:  There is a common trend for all seasons.\nChiTrend = %d, \nand a critical value= %d\n', ChiTrend, alphaTrend);
        end
    end
    
    Ss = sum(S);
    taubsea = sum(S)/sum(D);
    tausea = sum(S)/sum(Dall);
    Sigmas = sqrt(sum(vars));
    nSigmas = sqrt(sum(nvars));
    Sens = median(sens);
    SumVars = sum(vars);
    
    ss = Ss;
    
    %% Correction factor for testing null hypothesis
    % Gilbert p. 227
    if minn < 10
        if Ss > 0
            ss = Ss - 1;
        elseif Ss ==0
            ss = 0;
        elseif Ss < 0
            ss = Ss + 1;
        elseif isnan(Ss)
            error('ErrorSeasonalTrend:sktt', 'This function cannot process NaNs. \nPlease remove data records with NaNs.\n');
        end
        if Ss==1
            % Notify user continuity correction is setting S = 0
            fprintf('\nSKTT Message:  When n-years for a season is less than 10 and S=1,');
            fprintf('\n               Continuity correction is setting S = 0.');
            fprintf('\n               This will affect calculated significance.\n');
        end
    end
    
    Zs = ss / Sigmas;
    
    %% Test for significance, requires Statistical Toolbox
    % h = 1 : means significance
    % h = 0 : means not significant (i.e. sig < z(sig))
    if ss==0
        [h, sig] = ztest(1,0,Sigmas,alpha);
        [Zmod sigAdj] = serialAdjusted(datain, SumVars, ss, alpha);
        fprintf('\nSKTT message: S = 0. P-value cannot = 100-percent.');
        fprintf('\n              P-value is adjusted using S = 1 and should be reported as p > %1.5f and p-adjusted > %1.5f.\n',sig,sigAdj);
        if Sens ~= 0
            fprintf('\nSKTT Message:  A non-zero Seasonal Sens slope occurred when Sseasons =0.\n');
            fprintf('\n              This is not an error, more a notification.');
            fprintf('\n              This anomaly may occur because the median may be computed');
            fprintf('\n              on one value equal to zero and one non-zero, etc.\n');
        end
    else
        [h, sig] = ztest(ss,0,Sigmas,alpha);
        [Zmod sigAdj] = serialAdjusted(datain, SumVars, ss, alpha);
    end
    
    % Notify for Sens slope = 0 but is determined significant
    if h==1 && Sens==0
        [hh, nsig] = ztest(ss,0,nSigmas,alpha);
        fprintf('\nSKTT Message:  There was a significant seasonal trend = 0 found.\n');
        fprintf('               Retested with ties set to equal number of positve and negative values.\n');
        fprintf('               New p-value = %1.5f',nsig);
        if hh==1
            fprintf('.  However trend still found to be significant.\n');
        else
            fprintf(', but trend is not found to be significant.\n');
        end
    end
    
    %% Estimate confidence intervals of Sen's slope and plot Seasonal slopes
    % The next line requires STATISTICS Toolbox (norminv)
    Zup = norminv(1-alpha/2,0,1);
    Calpha = Zup * Sigmas;
    Nprime = length(sens);
    M1 = (Nprime - Calpha)/2;
    M2 = (Nprime + Calpha)/2 + 1;
    % 1-tail limits
    CIlower = interp1q((1:Nprime),sort(sens),M1);
    CIupper = interp1q((1:Nprime),sort(sens),M2);
    
    clear M1 M2 NPrime Zup Calpha
    
    if sig<=alpha && wantplot ~= 0
        px = datain(:,1) + datain(:,2)/NumOfSeasons;
        plot(px,datain(:,3),'.')
        CLdiff = Sens - CIlower;
        CUdiff = CIupper - Sens;
        hold on
        %generate points to represent median slope
        %zero time for the calculation is the first time point
        val = datain(:,3)-(Sens*(px-px(1)));
        val(1) = median(val);
        val = val(1) + Sens * (px-px(1));
        senplot = [px val];
        plot(px,val,'-')
        % add confidence intervals
        plot(px,val+CUdiff,'--')
        plot(px,val-CLdiff,'--')
        hold off
        pause
    end
    
end

%% Calculate covariance of Seasonal Kendall
% The function: tiedrank is used and is part of the statistic toolbox
% in matlab. Although this could easily be replaced with an internal
% ranking scheme, but....
%
% Reference:
%
% Hirsch and Slack, A Nonparametric Trend Test for Seasonal Data with
% Serial Dependence. Water Resources Research, Vol 20, Number 6, pg
% 727-732, June 1984.
%
% Unmodified seasonal assumes independance of seasons.  By including
%  the covariance this assumption is no longer needed because the covariance
%  is soemthing other than zero now.
function[Zmod sigAdj] = serialAdjusted(data, SumVars, ss, alpha)
    
    baseyear = min(data(:,1))-1;
    
    % I'm using a sparse matrix because there may be missing values in the
    % data.
    X = sparse(data(:,1)-baseyear,data(:,2),data(:,3));
    
    X1 = full(X);
    Xones = full(spones(X));
    Xones(Xones == 0) = nan;
    X2 = X1.*Xones;
    
    nsea = size(X2,2);
    nyr = size(X2,1);
    L2 = nyr - 1;
    B = zeros(L2);
    B2 = B;
    for gh=1:nsea
        % This routine creates a matrix for a season of the years, need to
        % then sum it up over the number of seasons.
        m1 = repmat((1:L2)',[1 L2]);
        m2 = repmat((2:nyr),[L2 1]);
        
        row1 = X2(:,gh);
        % populate matrixes for analysis
        A1 = triu(row1(m1));
        A2 = triu(row1(m2));
        
        clear m1 m2 row1 row2;
        
        % Perform pair comparison and convert to sign
        A = sign(A2 - A1);
        A(isnan(A)) = 0;
        B = B + A;
        B2 = B2 + A.^2;
    end
    sumkgh = sum(sum(B.^2 - B2));
    % NOTE: tiedrank function requires the Statistics Toolbox for Matlab
    R = tiedrank(X2);
    Ravg = nanmean(R);
    % convert nan's in R to zero so I can add matrices
    R(isnan(R) == 1) = 0;
    % compute mid ranks per season for n-years
    Ravg1 = repmat(Ravg,size(X,1),1);
    R2 = (full(spones(X))-1)*-1.*Ravg1;
    % replace NaN's with zeros, than add in mid-ranks for missing values
    % (i.e. NaN's).
    R3 = R2 + R;
    RR = sum(sum(R3,2).^2 - sum(R3.^2,2));
    
    ng = zeros(1,nsea);
    for g=1:nsea
        ng(g) = nnz(X(:,g));
    end
    ngh2 = sum((ng + 1).^2);
    ngh = sum(ng + 1);
    sumngh = ngh^2-ngh2;
    
    sigmagh = (sumkgh + 4*RR - nyr*sumngh)/3;
    
    % add covariance to variance
    VarSmod = SumVars + sigmagh;
    sigmaMod = sqrt(VarSmod);
    Zmod = ss / sigmaMod;
    % the output of the function does not include hadj.
    if ss==0
        % p-value cannot equal 100% adjust S.
        [hadj, sigAdj] = ztest(1,0,sigmaMod,alpha);
        fprintf('\nSKTT Message: adjusted p-value cannot be 100-percent.');
        fprintf('\n              Re-tested assuming S=1. New adjusted p-value > %1.5f.\n',sigAdj);
    else
        [hadj, sigAdj] = ztest(ss,0,sigmaMod,alpha);
    end
    
end

%% Adjust seasons using Startseasons as first season.
% Example: StartSeason = 10, then the 10th season becomes the first
% season, 11th season becomes the second season, etc.  Then if
% statSeasons is something other than 1, then shift years by one.  This
% will create a season year = actual year where January 1 occurs.  This
% is a general way of describing for example how a 'water year' is
% defined (i.e. Oct - Sept).
%
% However this routine is generalized enough that seasons could be
% any increment less than yearly.
function [datain] = AdjustSeasons(datain, startSeason)
    if startSeason ~= 1
        season = unique(datain(:,2));
        maxseas = max(season);
        delta = maxseas - startSeason + 1;
        seasL = datain(:,2) < startSeason;
        seasU = datain(:,2) >= startSeason;
        datain(seasU,2) = datain(seasU,2)-(startSeason -1);
        datain(seasL,2) = datain(seasL,2)+delta;
        datain(seasU,1) = datain(seasU,1)+1;
    else
        fprintf('\nSKTT Message:  There was no adjustment to the seasons.\n');
    end
    
    % Any observations that occur in the same season, the median of the
    % season is returned.
    datain = seasonAverage(datain);
    
end

%% Observations within a given season are averaged
% The median value.  If the user wants to average with something other than
% median, then see the comment below on where to change it.
function [datain] = seasonAverage(datain)
    dte = datenum(datain(:,1),datain(:,2),1);
    data = [dte datain];
    n = size(data,1);
    sumobs = [];
    data2 = zeros(size(unique(data(:,1)),1),4);
    cnt = 2;
    cntavg = 0;
    
    % Need to evaluate first record
    if data(2,1)~= data(1,1)
        cntavg = cntavg + 1;
        data2(cntavg,:) = data(1,:);
    else
        sumobs = data(1,4);
        data2 = [];
    end
    
    % now process all but the last record
    while cnt < n
        if data(cnt,1)== data(cnt+1,1)
            sumobs = [sumobs; data(cnt,4)];
            fl = 1;
        elseif (data(cnt,1)~= data(cnt+1,1)) && (data(cnt,1)== data(cnt-1,1))
            sumobs = [sumobs; data(cnt,4)];
            fl = 0;
        else
            sumobs = data(cnt,4);
            fl = 0;
        end
        obsavg = median(sumobs);
        if fl == 0
            cntavg = cntavg + 1;
            data2(cntavg,:) = [data(cnt,1:3) obsavg];
            sumobs = [];
        end
        cnt = cnt + 1;
    end
    
    % now process the last record
    if data(cnt,1)== data(cnt-1,1)
        sumobs = [sumobs; data(cnt,4)];
    elseif data(cnt,1)~= data(cnt-1,1)
        sumobs = data(cnt,4);
    end
    
    % If the user wants to summarize with a differnt statistic, this is
    % where you'd do it.
    obsavg = median(sumobs);
    cntavg = cntavg + 1;
    data2(cntavg,:) = [data(cnt,1:3) obsavg];
    
    % now remove matlab datenum from dataset
    datain = data2(:,2:4);
    
end