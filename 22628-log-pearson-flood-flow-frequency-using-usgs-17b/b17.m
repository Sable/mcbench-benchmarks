%% Flood Flow Frequency Analysis - Bulletin #17B USGS
%% b17.m - This function estimates Flood Frequencies
% Using U.S. Water Resources
% Council publication Flood Flow Frequencies, Bulletin #17B (1976, revised
% 1981,1982).  This method uses a Log Pearson Type-3 distribution for estimating
% quantiles. See url: http://water.usgs.gov/osw/bulletin17b/bulletin_17B.html
% for further documentation.
%
% NaN need to be removed in the dataset. If any years have missing data, it
% will still assume to include that year as part of the sample size-- as
% stipulated in 17B guidelines. An exmaple MAT file is provided for the
% user to test. Further down in these comments is some sample script to
% pre-process the examples.mat file provided.
%
% There are only a couple of loops in this function and subfunctions, most
% of this is vectorized for speed.
%
% A nice enhancement to this function is a plot of the analyses.  It is
% *plotted in probability space-- SKEWED probability space!*  Because data
% may not be normally distributed, plotting in skewed space maintains a
% straight line for the final frequency curve.  Again, no need of any
% special toolboxes to create this figure. All self contained in this
% function.
%
% Modifications:
%
% * January 28, 2009 - Tweaked the figure created by cleaning up the
%    legend, reference lines can be turned on/off and are hard coded to
%    display: Upper/Lower 100yr CIs, 100yr, 25yr, 10yr, 5yr, and 2yr.  Also
%    changed a few of the default tick placements used to make the grid.
%
% * March 13, 2009 - Removed the lower confidence reference line on the
%    figure.  Also now will project the last water year in the data set to
%    the final frequency curve and plot a drop down reference line
%    annotating what the interpreted return period would be.
%
% * April 20, 2009 - Modified plotting function pplot to either create a
%    plot like the original of this funciton, or to create a plot and
%    located the legend outside the figure and create a table summarizing a
%    subset of flow frequencies likely to be of interest.  Added a bit more
%    in the legend, cleaned up the title block.  Made the comments in this
%    m-file Report friendly as well. 
%
% * December 2, 2009 - People were mistakenly downloading a different
%    version of lagrange.  My version
%    (http://www.mathworks.com/matlabcentral/fileexchange/14398-a-parabolic
%    -lagrangian-interpolating-polynomial-function) should have been the
%    one to use.  I've removed the lagrange interpolator and used the
%    intrinsic function in Matlab (interp1 'spline').  This should have no
%    significant effect of change, but if it does it only will make it more
%    accurate.  Thanks to Shan Zou for sleuthing out this problem.  Also,
%    if you're not familiar with matlab reporting, you'll notice somewhat
%    extraneous symbols (e.g. #, *, etc).  Those are symbols used in the
%    reporting interpretor for organizing the text.
%
% Outputs of this function include:
%
% # estimates of a final frequency (based on a weighted skew),
% # confidence intervals (95%) for the final frequency,
% # expected frequency curve based on an adjusted conditional
%   probability,
% # observed data with computed plotting positions using Gringorten and
%   Weibull techniques (no toolbox required),
% # various Skews,
% # mean of log10(Q),
% # standard deviation of log10(Q),
% # and the coup de grâce,
% # a probability plot that does not require a toolbox to create, but
% also plots the probability space using the computed weighted skew
% and not just the normal probability.
%
% *Note:*
% This added feature yields a straight line plot for the final
%      frequency curve even if the data are not normally distributed.
%
% *Important*
%
% The one important aspect not included in this funtion is the assumed
% generalized skew (which is variable throughout the country), which can be
% obtained from Plate 1 in the bulletin. Using the USGS program PKFQWin,
% this generalized skew is automatically estimated with given lat/long
% coordinates.  For this function, the user must specify a generalized
% skew, if no generalized skew is provided, 0.0 is assumed.
%
% Even though this function computes probabilities, skews, etc., no
% toolboxes are required.  All necessary tables are provided as additional
% MAT files supporting this function.  These tables are created from the
% published USGS 17B manual, and not taken from any Matlab toolboxes, so there are no
% conflicts or copyright violations.
%
% Other files required to support this function are:
%
% # KNtable.mat - using normal distribution, a table of 10-percent
%        significance level of K values per N sample size.
% # ktable.mat - Appendix 3 table Pearson distributions
% # PNtable.mat - Table 11-1 in Appendix 11.  Table of probabilities
%        adjusted for sample size.
% # pscale.mat - table used to define tick/grid intervals when creating a
%   probability plot of the results. Can be modified by user if other than
%   the default values.
% # examples.mat - dataset presented in the 17B publication.
%
% *NOTE: lagrange is no longer needed for this function.
% Parabolic interpolation of Pearson Distribution is dependant on
% function: lagrange.m (written by Jeff Burkey 3/23/2007).  Can be
% downloaded from Mathworks user community.
%
% Syntax
%    [dataout skews pp XS SS hp] = b17(datain, gg, imgfile, gaugeName, plotref, plottype);
%
% Where
%    datain = Nx2 double
%           datain(:,1) = year or datenum
%           datain(:,2) = peak annual flow rate
%    gg = a generalized weighted skew
%    imgfile = full path and file name to export the figure
%         example: imgfile = 'd:\temp\figure.png'
%    gaugeName = string used to populate title of figure
%         example: 'USGS 12108500'
%    plotref = integer set to 1 means reference lines will be plotted,
%      any other value and reference lines will not be plotted.  By default,
%      the function will assume set to 1 if not provided.
%    plottype = integer, set to 1 means original plot, other than 1 creates
%      plot with legend outside of figure and summary table of frequencies
%      outside of figure.
%
%    *note: confidence intervals are hard coded to 0.95 at present
%
% Output is in the form of a N x 6 double, and all flows are in Log10
%
% * dataout(:,1) = Return Period (in years)
% * dataout(:,2) = Probability
% * dataout(:,3) = Final Frequency curve
% * dataout(:,4) = upper CI frequency curve
% * dataout(:,5) = lower CI frequency curve
% * dataout(:,6) = Expected Probability (N-1)
%
% * skews(1) = Station Skew
% * skews(2) = Station Skew outliers, zero removed
% * skews(3) = Synthetic Skew
% * skews(4) = Weight adjusted skew
%
% * pp(:,1) = gringorten plotting position
% * pp(:,2) = weibull plotting position
% * pp(:,3) = observations
%
% * XS = mean of Log10(Flow rates)
% * SS = standard deviation Log10(flow rates)
%
% * hp = historically adjusted weibull plotting position where historical
% peaks our high outliers are ranked in integer values (e.g. 1,2,3,etc.)
% and systematic observations are adjusted.
%
% Subfunctions contained in this function are:
%    stationStats- Used to calculate Station Statistics Skew and Standard
%                  Deviation
%                  gw = generalized regional skew coefficient
%                  for Puget Sound = 0.0
%    freqCurve- compute curve statistics
%    plotpos - calculate plotting positions of data using Gringorten and
%              Weibull.
%    historical- adjust statistics using historical peaks, also recomputes
%                plotting positions when including historical.
%    pplot- creates a customized probability plot.
%    procFreqData - creates text table with summary of frequencies
%
% Some example script to process the examples.mat file also provided
%
%   ex1 = examples(~isnan(examples(:,2)),1:2);
%   ex2 = [examples(~isnan(examples(:,3)),1) examples(~isnan(examples(:,3)),3)];
%   ex3 = [examples(~isnan(examples(:,4)),1) examples(~isnan(examples(:,4)),4)];
%   ex4 = [examples(~isnan(examples(:,5)),1) examples(~isnan(examples(:,5)),5)];
%
%  written by
%    Jeff Burkey
%    King County- Department of Natural Resources and Parks
%    Seattle, WA
%    email: jeff.burkey@kingcounty.gov
%    January 6, 2009
%
%   [dataout skews pp XS SS hp] = b17(ex1, .590537, 'c:\temp\test.png', 'Demo Station',1,2);
%
function [dataout skews pp XS SS hp] = b17(datain, gg, imgfile, gaugeName, plotref, plottype)
    
    
    if exist('gg','var') == 0
        % user didn't provide assume zero (i.e. no plot)
        fprintf('\nNo generalized skew was entered.\nAssumed equal to zero.\n');
        gg = 0.d0;
    end
    if exist('imgfile','var') == 0
        % user didn't provide assume zero (i.e. no plot)
        fprintf('\nNo image filename given. Figure will not be exported to a file.\n');
        imgfile = '';
    end
    if exist('plotref','var') == 0
        % user didn't provide assume zero (i.e. no plot)
        plotref = 1;
    end
    
    % Remove all zero flood years before any calculations are done.
    nonZeroFlood = datain(datain(:,2)>0,:);
    
    [G N S Xmean] = stationStats(nonZeroFlood);
    skews = G;
    
    
    load KNtable.mat;
    load ktable.mat;
    % structure of ktable is:
    %   Column 1 = Skew
    %   Column 2 = Probability
    %   Column 3 = k value
    
    n = length(datain);
    QLcnt = 0;
    QHcnt = 0;
    
    if G >= -.40 && G <= 0.40
        % Estimate outliers thresholds on full record
        % Per Appendix 4, one-sided 10-percent KNtable
        xh = Xmean + KNtable(KNtable(:,1)==N,2)*S;
        qh = 10^xh; % High threshold
        xl = Xmean - KNtable(KNtable(:,1)==N,2)*S;
        ql = 10^xl; % Low threshold
        
        % remove high and low outliers and recompute Station statistics
        datafilter = nonZeroFlood(ql < nonZeroFlood(:,2) & nonZeroFlood(:,2) < qh,[1 2]);
        
        % check for low/zero records removed
        QLcnt = sum(datain(:,2) < ql);
        if QLcnt > 0
            [G N S Xmean] = stationStats(datafilter);
        end
        
        % check for high records removed
        QHcnt = sum(datain(:,2) > qh);
        
        
    elseif G > 0.40
        % Test for high outliers, recompute stats, then test for low
        % outliers, then recompute stats again
        xh = Xmean + KNtable(KNtable(:,1)==N,2)*S;
        qh = 10^xh; % High threshold
        
        datafilter = nonZeroFlood(nonZeroFlood(:,2) < qh,[1 2]);
        
        xl = Xmean - KNtable(KNtable(:,1)==N,2)*S;
        ql = 10^xl; % Low threshold
        
        % remove outliers and recompute Station statistics
        datafilter = datafilter(ql < datafilter(:,2),[1 2]);
        
        % check for low/zero records removed
        QLcnt = sum(datain(:,2) < ql);
        if QLcnt > 0
            [G N S Xmean] = stationStats(datafilter);
        end
        
        % check for high records removed
        QHcnt = sum(datain(:,2) > qh);
    elseif G < -0.40
        % Test for low outliers, recompute stats, then test for high
        % outliers, then recompute stats again
        xl = Xmean - KNtable(KNtable(:,1)==N,2)*S;
        ql = 10^xl; % Low threshold
        
        % remove outliers and recompute Station statistics
        datafilter = nonZeroFlood(ql < nonZeroFlood(:,2),[1 2]);
        
        % check for low/zero records removed
        QLcnt = sum(datain(:,2) < ql);
        if QLcnt > 0
            [G N S Xmean] = stationStats(datafilter);
        end
        
        xh = Xmean + KNtable(KNtable(:,1)==N,2)*S;
        qh = 10^xh; % High threshold
        
        datafilter = datafilter(datafilter(:,2) < qh,[1 2]);
        
        % check for high records removed
        QHcnt = sum(datain(:,2) > qh);
    end
    
    % Recompute with Historical/high outlier data
    Xz = log10(datain(datain(:,2) > qh,:));
    X = log10(datafilter);
    skews = [skews G];
    Z = QHcnt;
    H = n;
    L = QLcnt;
    %
    % H = number of years in historic record
    % L = Number of low outliers and/or zero flood years
    % Z = Number of historic peaks including high outliers
    % X = Log10 of peaks not including outliers, zero floods, etc.
    % Xz = Log10 of historic peaks and high outliers (not low outliers)
    [G M S hp] = historical(H, L, Z, X(:,2), Xz(:,2));
    % hp = historical plot with outliers removed
    
    skews = [skews G];
    
    if abs(G - gg) > 0.5
        % Notify user more weight should be given to station skew
        fprintf('\nThere is a large discrepency (> 0.5) between the\ncalculated station skew (G = %d) and the generalized skew (G = %d).',G,gg);
        fprintf('\nMore weight should be given to the Station skew.\n');
    end
    
    clear KNtable
    
    if QLcnt > 0
        % If low flow outliers or zero flow records occur adjust P with
        % Pest.
        % Apply conditional probability adjustment (Appendix 5)
        Pest = N/n;
        if Pest < .75
            warning('MATLAB:B17','Too many years considered outliers or with zero flow.\nFunction is terminated. Calculated thresholds are low= %s and high = %s\n', ql, qh);
            return;
        end
    else
        Pest = 1;
    end
    if N ~= n
        % notify user of outliers
        outliers = datain(ql > datain(:,2) | datain(:,2) > qh,[1 2]);
        fprintf('\nNote: These years were removed as outliers %s\n',mat2str(outliers));
    end
    
    [K floodfreq Gzero] = freqCurve(Xmean, S, G, ktable);
    floodfreq = [floodfreq floodfreq(:,1)*Pest];
    
    % P's outside of adjusted probabilities are extrapolated when using
    % spline method.
    adjfreq = [floodfreq(:,1) interp1(floodfreq(:,3), floodfreq(:,2), floodfreq(:,1), 'pchip')];
    
    if QLcnt > 0
        % Interpolate P back from adjusted P
        Q01 = 10^adjfreq(adjfreq(:,1)==.01,2);
        Q10 = 10^adjfreq(adjfreq(:,1)==.10,2);
        Q50 = 10^adjfreq(adjfreq(:,1)==.50,2);
        
        %% Generate synthetic Log-Pearson statistics
        % the below equation is valid for skews between -2.0 < GS < +2.5
        GS = -2.5 + 3.12*(log10(Q01/Q10)/log10(Q10/Q50));
        
        skews = [skews GS];
        
        % Only using freqCurve to grab K, variables Xmean, S, have no baring
        % for this instance.
        KS = freqCurve(Xmean, S, GS, ktable);
        
        K01 = KS(KS(:,2)==.01);
        K50 = KS(KS(:,2)==.50);
        SS = log10(Q01/Q50)/(K01 - K50);
        
        XS = log10(Q50) - K50*SS;
        
        %%
        % Per step 4 of Appendix 5
        if GS < -2 || GS > 2.5
            warning('MATLAB:skew','Synthetic skew exceeds acceptable limits.\nUser should plot data for further evaluation.\n')
        end
    else
        GS = G;
        XS = Xmean;
        SS = S;
    end
    % Based on 17B Plate I documentation.  If generalized skew is not read
    % from Plate I, then MSEGbar will need to be calculated.
    MSEGbar = 0.302;
    
    if abs(G) <= 0.90
        A = -.33 + 0.08*abs(G);
    else
        A = -.52 + .30*abs(G);
    end
    if abs(G) <= 1.50
        B = 0.94 - .26*abs(G);
    else
        B = .55;
    end
    
    MSEG = 10^(A-B*log10(H/10));
    % Weighted Skew calculation
    GW = (MSEGbar*GS + MSEG*gg)/(MSEGbar + MSEG);
    % Adopted skew (i.e. round skew to nearest tenth
    %GD = round(GW*10)/10;
    GD = GW;
    
    skews = [skews GD];
    
    [K finalfreq Gzero] = freqCurve(XS, SS, GD, ktable);
    
    % Equation 11-1 in Appendix 11
    load PNtable;
    pnn = unique(Pntable(:,2));
    % lookup and interpolate adjusted probability based on sample size
    for i = 1:length(pnn)
        pn2 = Pntable(Pntable(:,2)==pnn(i),:);
        pexp(i) = interp1(pn2(:,1),pn2(:,3),N-1,'pchip');
    end
    pexp = [pnn pexp'];
    
    [c, ia, ib] =  intersect(pexp(:,1),finalfreq(:,1),'rows');
    
    % Recalculate P using expected probabilities
    % 'pchip' is used because it better plots linearly in log space w.r.t.
    % identified expected probabilities of: .9999, .999, .99, .95, .9, .7,
    % .5, .3, .1, .05, .01, .001, and .0001
    expectedP = [finalfreq(:,1) interp1(pexp(:,2), finalfreq(ib,2), finalfreq(:,1),'pchip')];
    
    % Not sure if the below comment is still valid. 1/5/2009.
    % USGS PKFQWin seems to not use the adopted, rather the weighted. At
    % least with version 5.0 Beta 8 5/6/2005.  It also infers a generalized
    % skew with more resolution than is available with the published 17B
    % documentation.
    
    % In the next line when Find is working again, replace 0.05 with
    % cialpha variable.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Galpha = Gzero(Gzero(:,2)==0.05,:);  %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    a = 1 - (Galpha(:,3).^2)/(2*(H-1));
    b = K(:,1).^2 - (Galpha(3).^2)/H;
    Ku = (K(:,1) + sqrt(K(:,1).^2 - a.*b))./a;
    Kl = (K(:,1) - sqrt(K(:,1).^2 - a.*b))./a;
    
    LQu = XS + Ku*SS;
    LQl = XS + Kl*SS;
    
    % expected probabilities breaks down for probabilities less than 0.002,
    % replace with NaN's.
    expectedP(expectedP(:,1) < .002,2) = nan;
    
    dataout = [1./finalfreq(:,1) finalfreq(:,1) 10.^finalfreq(:,2) 10.^LQu 10.^LQl 10.^expectedP(:,2)];
    dataout = sortrows(dataout,1);
    
    pp = plotpos(datain(datain(:,2)>0,:),H);
    
    pplot(pp(:,2:4),K,dataout(:,2:end),GD,imgfile,gaugeName,plotref,plottype);
    
    fprintf('\nFinished analyses.\n');
    
end

%% stationStats:  used to calculate Station Statistics Skew and Standard Deviation
% gw = generalized regional skew coefficient
% for eastern Puget Sound gw = 0.0
function [G N S Xmean] = stationStats(datain)
    % Used to calculate Station Statistics Skew and Standard Deviation
    %
    % gw = generalized regional skew coefficient
    % for eastern Puget Sound gw = 0.0
    
    % cialpha = round(1 - cii*100)/100;
    data = datain(:,2:end);
    %yr = datain(:,1);
    N = length(data);
    
    Xmean = mean(log10(data));
    X = log10(data);
    
    S = sqrt((sum(X.^2) - sum(X)^2/N)/(N-1));
    
    % for now check for outliers and notify user
    % this function will go away after B17.m is completed.
    %outliers = idoutliers(datain, Xmean, S);
    
    G = (N^2*sum(X.^3)- 3*N*sum(X)*sum(X.^2) + 2*sum(X)^3)/((N*(N-1)*(N-2))*S^3);
    
end

%% freqCurve:  Retrieve Frequency Curve Coordinates
% Uses ktable.mat to retrieve the skew for a set of probabilities.
function [K floodfreq Gzero] = freqCurve(Xmean, S, G, ktable)
    % Retrieve Frequency Curve Coordinates
    
    % Grab list of available probabilites from ktable
    P = unique(ktable(:,2));
    
    % the below loop uses the adopted Skew GD, not the station skew
    for i = 1:length(P)
        p = find(ktable(:,2) == P(i));
        g = ktable(p,1);
        k = ktable(p,3);
        % Replaced lagrange.m
        % (http://www.mathworks.com/matlabcentral/fileexchange/14398-a-para
        % bolic-lagrangian-interpolating-polynomial-function) for matlab
        % spline interpretor. Using interp1 this loop could be reduced to a
        % single sequence, but that is for another day.
        %
        % K(i) = lagrange([g k], G, 4);
        K(i) = interp1(g,k,G,'spline');
    end
    
    K = K';
    floodfreq = [P (Xmean + K.*S)];
    
    % add probability to K for looking up values
    K = [K P];
    
    % Compute confidence limits for estimate
    % retrieve zero skew probability
    Gzero = sortrows(ktable(ktable(:,1)==0.0,:),2);
end

%% plotpos:  Calculates plotting positions for peak annual flows
% Plotting positions currently calculated are: Gringorten and Weibull.
% Others can be added but the Weibull plotting position is the one used for
% plotting data on the figure.
function [gplot] = plotpos(datain, n)
    dsort = sortrows(datain,-2);
    [r c] = find(dsort(:,1));
    gp = (r - .44)./(n+.12);
    gw = (r./(n+1));
    gplot = [gp gw dsort(:,2) dsort(:,1)];
end

%% historical:  Adjusts the 17B statistics accounting for Historical Data
% High outliers are converted to Historical events-- per Appendix 6 in 17B.
% Also per the 17B method, one can manually supply historical events,
% however, this function does not provide a means for the user to provide
% them.  This lack of function generally will not be an issue for the Puget
% Sound region. 
function [Gbar Mbar Sbar hp] = historical(H, L, Z, X, Xz)
    % Appendix 6 in 17B
    
    % H = number of years in historic record
    % L = Number of low outliers and/or zero flood years
    % Z = Number of historic peaks including high outliers
    % X = Log10 of peaks not including outliers, zero floods, etc.
    % Xz = Log10 of historic peaks and high outliers (not low outliers)
    
    % Number of X events
    N = length(X);
    
    % Systematic record weight
    W = (H-Z)/(N+L);
    
    % Historically adjusted mean
    Mbar = (W*sum(X) + sum(Xz))/(H-W*L);
    
    % Historically adjusted standard deviation
    Sbar = sqrt((W*sum((X-Mbar).^2) + sum((Xz-Mbar).^2))/(H-W*L-1));
    
    % Historically adjusted Skew
    Gbar = ((H-W*L)/((H-W*L-1)*(H-W*L-2)))*((W*sum((X-Mbar).^3) + sum((Xz-Mbar).^3))/Sbar^3);
    
    % Number of events (Z + N)
    E = 1:(Z+N);
    
    % combining historical and systematic peaks
    Xh = [X; Xz];
    
    % sort from largest to smallest
    Xh = sort(Xh,'descend');
    
    % Define ranks 1 through Z+N
    m = E;
    
    % Historically adjusted ranks starting after historical peaks
    mh = W.*E-((W-1)*(Z+.50));
    m(Z+1:end) = mh(Z+1:end);
    
    wp = m./(H+1); % Weibul Plotting Position
    
    % Historical and systematic peaks combined with weibull and gringorten
    % plotting positions.
    hp = [wp' 10.^Xh];
end

%% pplot- will create a custom probability plot.  The probability spacing
% is based on the weighted skew- it is NOT a normal probability unless
% the weighted skew = 0.0.
%
% On the plot, the last year in the dataset will be plotted with a
% different symbol to highlight. So each year a new plot is created,
% the peak for that last year can be identified on the plot.
%
% datain = data with plotting position
% K = K values for final frequency
% curves = calculated regressions
% skew = weighted skew used for final frequency curve
% imgfile = full path and file name to export figure
%
% pscale.mat = a vector of user specified tick marks to plot. They do
%     not have to be sorted. One can append any value.  If a value
%     specified is beyond the limits of the probabilities calculated in
%     17B, then the limits will be reset.
%
% Requirements: none
%   Everything used to generate this probability plot can be done
%   without toolboxes (e.g. statistics, line, etc.).
%
% Written by
%  Jeff Burkey
%  King County- Department of Natural Resources and Parks
%  Seattle, WA
%  email: jeff.burkey@kingcounty.gov
%  January 8, 2009
function pplot(datain, K,curves,skew,imgfile,gaugeName,plotref,plottype)
    obs = sortrows(datain,2);
    
    yRnk= [obs interp1(K(:,2),K(:,1), obs(:,1),'pchip')];
    
    % build grid for figure
    load pscale.mat;
    
    % maybe overkill, but sort and filter out any duplicates. This does let
    % the user get lazy defining grid tick marks though.
    pscale = sort(unique(pscale),'descend');
    if max(pscale) > max(K(:,2))
        xmin=max(K(:,2));
        fprintf('Users specified an exceedance beyond available probabilities.\nLower limit was reset.\n');
        pscale = pscale(pscale<=xmin);
    end
    if min(pscale) < min(K(:,2))
        xmax=min(K(:,2));
        fprintf('Users specified an exceedance beyond available probabilities.\nUpper limit was reset.\n');
        pscale = pscale(pscale>=xmax);
    end
    
    gridMajor = sort(interp1(K(:,2),K(:,1),pscale,'pchip'));
    xcurve = sort(K(:,1));
    
    figure1 = figure;

    % Create axes
    if plottype == 1
        axes1 = axes('Parent',figure1,'YScale','log','YMinorTick','on',...
            'YMinorGrid','on',...
            'XTickLabel',num2str(pscale,'%0.3f'),'FontSize',10,'XTick',gridMajor);
    else
        axes('Position',[0 0 1 1],'Visible','off');
        
        axes1 = axes('Parent',figure1,'YScale','log','YMinorTick','on',...
            'YMinorGrid','on',...
            'XTickLabel',num2str(pscale,'%0.3f'),'FontSize',8,...
            'XTick',gridMajor,...
            'Position',[.1 .1 .67 .8]);
    end
    xlim([min(gridMajor) max(gridMajor)]);
    ymin = interp1(curves(:,1),curves(:,4),max(pscale),'pchip');
    ymax = interp1(curves(:,1),curves(:,3),min(pscale),'pchip');
    ylim([ymin*.9 ymax*1.1]);
    
    %   Written Oct 14, 2005 by Andy Bliss
    %   Copyright 2005 by Andy Bliss
    %   modified January 2009, Jeff Burkey
    h = gca;
    rot=90;
    %get current tick labels
    a=get(h,'XTickLabel');
    %erase current tick labels from figure
    set(h,'XTickLabel',[]);
    %get tick label positions
    b=get(h,'XTick');
    %c=get(h,'YTick');
    TyrA = [num2str(1./pscale(2:8),'%4.2f') repmat('-yr',length(pscale(2:8)),1)];
    TyrB = [num2str(1./pscale(9:end),'%4.0f') repmat('-yr',length(pscale(9:end)),1)];
    
    %make new tick labels
    if rot<180
        % modified y-location jjb
        text(b,repmat(ymin*.88,length(b),1),a,...
            'HorizontalAlignment','right',...
            'rotation',rot,...
            'FontSize',8);
        text(b(2:8),repmat(10^(log10(ymax)*.999),length(b(2:8)),1),TyrA,...
            'HorizontalAlignment','right',...
            'VerticalAlignment','bottom',...
            'rotation',rot,...
            'FontSize',8);
        text(b(9:end),repmat(10^(log10(ymax)*.999),length(b(9:end)),1),TyrB,...
            'HorizontalAlignment','right',...
            'VerticalAlignment','bottom',...
            'rotation',rot,...
            'FontSize',8);
    else
        % modified y-location jjb
        text(b,repmat(10^(log10(ymin)*.979),length(b),1),a,...
            'HorizontalAlignment','left',...
            'rotation',rot,...
            'FontSize',8);
        text(b(2:8),repmat(10^(log10(ymax)*.999),length(b(2:8)),1),TyrA,...
            'HorizontalAlignment','left',...
            'VerticalAlignment','top',...
            'rotation',rot,...
            'FontSize',8);
        text(b(9:end),repmat(10^(log10(ymax)*.999),length(b(9:end)),1),TyrB,...
            'HorizontalAlignment','left',...
            'VerticalAlignment','top',...
            'rotation',rot,...
            'FontSize',8);
    end    % end of Andy Blis script
    
    box('on');
    grid('on');
    
    %% Plot reference lines
    %
    % Currently hard coded to create reference lines and display the
    % Flow rate for the Upper/Lower 100-yr CI, 100-yr, 25-yr, 10-yr,
    % 5-yr, and 2-yr. If you pick a probability not in the output
    % frequency table, you'll have to use an interpolation function to
    % extract the value.
    if plotref == 1
        
        xrefmin = min(gridMajor);
        
        x100 = [xrefmin; xcurve(curves(:,1)==.01)];
        x025 = [xrefmin; xcurve(curves(:,1)==.04)];
        x010 = [xrefmin; xcurve(curves(:,1)==.10)];
        x005 = [xrefmin; xcurve(curves(:,1)==.20)];
        x002 = [xrefmin; xcurve(curves(:,1)==.50)];
        
        y100 = curves(curves(:,1)==.01,2)*ones(2,1);
        if plottype == 1
            yciu = curves(curves(:,1)==.01,3)*ones(2,1);
            ycil = curves(curves(:,1)==.01,4)*ones(2,1); % use of this is commented out below
        end
        y025 = curves(curves(:,1)==.04,2)*ones(2,1);
        y010 = curves(curves(:,1)==.10,2)*ones(2,1);
        y005 = curves(curves(:,1)==.20,2)*ones(2,1);
        y002 = curves(curves(:,1)==.50,2)*ones(2,1);
        
        % Removed the lower CI from the reference lines
        %        yrefs = [yciu(1) y100(1) ycil(1) y025(1) y010(1) y005(1) y002(1)];
        if plottype == 1
            yrefs = [yciu(1) y100(1) y025(1) y010(1) y005(1) y002(1)];
        else
            yrefs = [y100(1) y025(1) y010(1) y005(1) y002(1)];
        end
        
        h100 = line(x100,y100,'Parent',axes1,'LineWidth',1,'LineStyle','--','Color',[0 0 0]);
        hAnnotation = get(h100,'Annotation');
        hLegendEntry = get(hAnnotation','LegendInformation');
        set(hLegendEntry,'IconDisplayStyle','off');
        
        if plottype ==1
            h1u = line(x100,yciu,'Parent',axes1,'LineWidth',1,'LineStyle','--','Color',[0 0 0]);
            hAnnotation = get(h1u,'Annotation');
            hLegendEntry = get(hAnnotation','LegendInformation');
            set(hLegendEntry,'IconDisplayStyle','off');
        end
        
        %         h1l = line(x100,ycil,'Parent',axes1,'LineWidth',1,'LineStyle','--','Color',[0 0 0]);
        %         hAnnotation = get(h1l,'Annotation');
        %         hLegendEntry = get(hAnnotation','LegendInformation');
        %         set(hLegendEntry,'IconDisplayStyle','off');
        
        h25 = line(x025,y025,'Parent',axes1,'LineWidth',1,'LineStyle','--','Color',[0 0 0]);
        hAnnotation = get(h25,'Annotation');
        hLegendEntry = get(hAnnotation','LegendInformation');
        set(hLegendEntry,'IconDisplayStyle','off');
        
        h10 = line(x010,y010,'Parent',axes1,'LineWidth',1,'LineStyle','--','Color',[0 0 0]);
        hAnnotation = get(h10,'Annotation');
        hLegendEntry = get(hAnnotation','LegendInformation');
        set(hLegendEntry,'IconDisplayStyle','off');
        
        h05 = line(x005,y005,'Parent',axes1,'LineWidth',1,'LineStyle','--','Color',[0 0 0]);
        hAnnotation = get(h05,'Annotation');
        hLegendEntry = get(hAnnotation','LegendInformation');
        set(hLegendEntry,'IconDisplayStyle','off');
        
        h02 = line(x002,y002,'Parent',axes1,'LineWidth',1,'LineStyle','--','Color',[0 0 0]);
        hAnnotation = get(h02,'Annotation');
        hLegendEntry = get(hAnnotation','LegendInformation');
        set(hLegendEntry,'IconDisplayStyle','off');
        
        Tref = [num2str(yrefs','%4.1f') repmat('-cfs',length(yrefs),1)];
        text(b(2)*ones(length(yrefs),1),yrefs',Tref,'FontSize',8,'HorizontalAlignment','left','VerticalAlignment','bottom','rotation',0);
    end
    
    % Create frequency curves
    line(xcurve,curves(:,2),'Parent',axes1,'LineWidth',3,'Color',[1 0 0],...
        'DisplayName','17B');
    line(xcurve,curves(:,3),'Parent',axes1,'LineWidth',3,'LineStyle',':',...
        'Color',[1 0 0],...
        'DisplayName','95% CI');
    hci = line(xcurve,curves(:,4),'Parent',axes1,'LineWidth',3,'LineStyle',':',...
        'Color',[1 0 0],...
        'DisplayName','95% CI');
    hAnnotation = get(hci,'Annotation');
    hLegendEntry = get(hAnnotation','LegendInformation');
    set(hLegendEntry,'IconDisplayStyle','off');
    
    line(xcurve,curves(:,5),'Parent',axes1,'LineWidth',2,'Color',[0 0 1],...
        'DisplayName','Expected');
    
    % Plot observations
    line(yRnk(:,4),yRnk(:,2),'Parent',axes1,'MarkerEdgeColor',[0 0 1],'MarkerSize',10,...
        'Marker','*',...
        'LineStyle','none',...
        'Color',[0 0 1],...
        'DisplayName','Weibull');
    
    % place a square symbol on top of the most recent year to view
    [c,i] = max(yRnk(:,3));
    line(yRnk(i,4),yRnk(i,2),'Parent',axes1,'MarkerEdgeColor',[1 0 1],...
        'MarkerFaceColor',[1 0 1],...
        'MarkerSize',10,...
        'Marker','s',...
        'LineStyle','none',...
        'Color',[0 0 1],...
        'DisplayName',num2str(yRnk(i,3)));
    
    line(yRnk(end,4),yRnk(end,2),'Parent',axes1,'MarkerEdgeColor',[1 0 1],...
        'MarkerFaceColor',[.8 0 .1],...
        'MarkerSize',8,...
        'Marker','d',...
        'LineStyle','none',...
        'Color',[0 0 1],...
        'DisplayName',num2str(yRnk(end,3)));
    line(yRnk(end-1,4),yRnk(end-1,2),'Parent',axes1,'MarkerEdgeColor',[1 0 1],...
        'MarkerFaceColor',[.5 0 .3],...
        'MarkerSize',8,...
        'Marker','d',...
        'LineStyle','none',...
        'Color',[0 0 1],...
        'DisplayName',num2str(yRnk(end-1,3)));
    line(yRnk(end-2,4),yRnk(end-2,2),'Parent',axes1,'MarkerEdgeColor',[1 0 1],...
        'MarkerFaceColor',[.3 0 .5],...
        'MarkerSize',8,...
        'Marker','d',...
        'LineStyle','none',...
        'Color',[0 0 1],...
        'DisplayName',num2str(yRnk(end-2,3)));
    line(yRnk(end-3,4),yRnk(end-3,2),'Parent',axes1,'MarkerEdgeColor',[1 0 1],...
        'MarkerFaceColor',[.1 0 .8],...
        'MarkerSize',8,...
        'Marker','d',...
        'LineStyle','none',...
        'Color',[0 0 1],...
        'DisplayName',num2str(yRnk(end-3,3)));
    line(yRnk(end-4,4),yRnk(end-4,2),'Parent',axes1,'MarkerEdgeColor',[1 0 1],...
        'MarkerFaceColor',[.3 .5 .1],...
        'MarkerSize',8,...
        'Marker','d',...
        'LineStyle','none',...
        'Color',[0 0 1],...
        'DisplayName',num2str(yRnk(end-4,3)));
    
    % In addition to plotting the last water year with a square symbol to
    % highlight...
    % Draw drop down reference line from Final curve representing return
    % period of most recent year in data (i.e. square symbol data point)
    xlast = interp1(curves(:,2),curves(:,1),yRnk(i,2),'pchip');
    xLscale = interp1(K(:,2),K(:,1),xlast,'pchip');
    
    hlast = line([xLscale xLscale],[ymin*0.88 yRnk(i,2)],'Parent',axes1,'LineWidth',1,'LineStyle','--','Color',[0 0 0]);
    hAnnotation = get(hlast,'Annotation');
    hLegendEntry = get(hAnnotation','LegendInformation');
    set(hLegendEntry,'IconDisplayStyle','off');
    
    TyrL = [num2str(1./xlast,'%4.2f') repmat('-yr',length(xlast),1)];
    text(xLscale,repmat(yRnk(i,2)*0.5,length(xLscale),1),TyrL,'HorizontalAlignment','left','VerticalAlignment','bottom','rotation',rot);
    % end of drawing drop down reference line
    
    % Create xlabel
    text(3,-.5,'Exceedance Probability','HorizontalAlignment','center','Units','inches');
    %text((min(gridMajor)+max(gridMajor))/2,ymin*.65,'Exceedance Probability','HorizontalAlignment','center');
    
    % Create ylabel
    ylabel('Annual Flow Rate (cfs)');
    %ylabel('Stage (feet)');
    
    % Create title
    str(1) = {gaugeName};
    str(2) = {[' Weighted Skew (G= ' num2str(skew) ') Probability Plot']};
    title(str,'FontSize',12,'HorizontalAlignment','center');
    
    % Create legend
    legend1 = legend(axes1,'show');
    if plottype ==1
        set(legend1,'Location','SouthEast');
    else
        set(legend1,'Orientation','vertical',...
            'Orientation','vertical',...
            'Position',[0.83 0.20 0.10 0.10],...
            'FontSize',8);
        
        frqtxt = procFreqData;
        
        text('Parent',axes1,'VerticalAlignment','bottom','Units','normalized',...
            'String',frqtxt,...
            'Position',[1.29 0.60 0],...
            'Margin',5,...
            'HorizontalAlignment','right',...
            'EdgeColor',[0 0 0],...
            'FontSize',7,...
            'FontName','fixedwidth',...
            'BackgroundColor',[1 1 1]);
    end

    if ~isempty(imgfile)
        fprintf('\nCreating plot. Give a few tics.\n');
        print('-dpng','-r600', imgfile);
        fprintf('\nFinished...\n');
        close(figure1);
    end
    
    %% Create Text String for populating Frequency Table in Figure
    function frqlabel = procFreqData
        % User can edit this to adjust which Return periods are displayed
        frqDisp = [200 100 50 40 25 20 10 5 2 1.5 1.25 1.01]';
        % Return periods need to be in terms of probabilities for
        % interpolating using the 'curves' variable.
        invfrqDisp = 1./frqDisp;
        % remove any NaN's
        curves(any(isnan(curves),2),:) = [];
        yFinal = interp1(curves(:,1),curves(:,2),invfrqDisp,'pchip');
        yExpect = interp1(curves(:,1),curves(:,5),invfrqDisp,'pchip');
        mm = num2str([frqDisp yFinal yExpect],'%5.2f %7.0f %7.0f');
        % below is very specific to mm format above
        frqlabel = [...
            'Return   17B   Expectd';...
            '(year)  (cfs)   (cfs) ';...
            '----------------------';...
            mm;];
    end
    
    
end

