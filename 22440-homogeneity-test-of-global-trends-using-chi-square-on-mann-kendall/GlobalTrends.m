function [ChiOutput K M sig] = GlobalTrends( datain, alpha )
%     GlobalTrends- Homogeneity tests for multiple seasons and stations.
%       This function will test for trends when seasonality is present and
%       over multiple observation stations, all of which are Chi-square
%       statistics.  There are so many statistical tests being done, this
%       function is more like a script or program than a function, but I
%       prefer operating with functions.
%     
%       This function relies heavily on Matlab's Statistical Toolbox for
%       obtaining Chi-square values and ktaub.m function.
%     
%       These tests will allow for ties, missing data, and multiple
%       observations per time index, since it uses the enhanced ktaub.m
%       function that was recently updated.
%     
%     This function is based on Chapter 17.5 in Gilbert.
%     
%     Syntax:
%       [ChiOutput K M sig] = GlobalTrends( datain, alpha )
%     
%     Inputs:
%       To stay consistent with the previous trend statistics posted (ktaub,
%       sktt, and SenT), data are expected to be linear with the following
%       structure:
%     
%        datain(:,1) = Year
%        datain(:,2) = season
%        datain(:,3) = value
%        datain(:,4) = station
%        alpha = scaler (e.g. 0.05)
%     
%     Outputs:
%       ChiOutput structure is like the following (labels are not included)
%         Total:           Chi-square    df   p-value
%         Homogeneity:     Chi-square    df   p-value
%         Season:          Chi-square    df   p-value
%         Station:         Chi-square    df   p-value
%         Station-Season:  Chi-square    df   p-value
%         Trend:           Chi-square    df   p-value
%     
%       And depending on significances of Stations, Seasons, and
%       StationSeasons, one of three other outpus may occur:
%         K: significance of Seasons per station
%         M: significance of Stations for seasons
%       And when seasonal trend tests should not be done
%         sig: individual station-season p-values are given by row
%     
%     There is a lot of output to the screen as well, but using fprintf,
%     one could easily redirect output to a file.
%     
%     Requirements
%        - Matlab Statistical Toolbox
%        - ktaub.m
%     
%     Reference:
%       Richard O. Gilbert, Pacific Northwest National Laboratories,
%       "Statistical methods for Environmental Pollution Monitoring", 1987,
%       Van Nostrand Reinhold, New York Publishing, ISBN 0-442-23050-8.
%     
%     Written by:
%       Jeff Burkey
%       King County- Department of Natural Resources and Parks
%       email: Jeff.Burkey@kingcounty.gov
%       12/13/2008
    
    %% Load in data and initialize
    [m,n] = size(datain);
    
    if n <= 4 % any columns of data right of column 4 will be ignored
        % sort by station, then time then season
        sorteds = sortrows(datain, [4,1,2]);
        Seasons = unique(sorteds(:,2));
        Stations = unique(sorteds(:,4));
    else
        error('ErrorTrend:globalTrends', 'There is an error in the structure of the data input.\n');
    end
    
    clear datain
    
    nSeasons = length(Seasons);
    nStations = length(Stations);
    
    % initialize variables
    S = zeros(nStations,nSeasons);
    sigma = zeros(nStations,nSeasons);
    
    
    
    %% Calculate trend statistics Z for each station-season (Zim) using
    %    taub function recently updated in Mathworks
    for jj = 1:nStations
        data = sorteds(sorteds(:,4)== jj,:);
        
        for ii = 1:nSeasons
            data2 = data(data(:,2)==ii,:);
            [taub tau h sig Z S(jj,ii) sigma(jj,ii) sen(jj,ii) n(jj,ii)] = ktaub([data2(:,1) data2(:,3)], alpha);
        end
    end
    clear taub tau h sig Z data data2 sorteds
    
    K = [];
    M = [];
    sig = [];
    
    % S is NOT adjusted like in Taub or Seasonal Kendall
    Zim = S./sigma;
    Zi = mean(Zim,1);
    Zm = mean(Zim,2);
    Z = sum(sum(Zim))/(nStations*nSeasons);
    
    %% Calculate Chi-square statistics
    ChiTotal = sum(sum(Zim.^2));
    ChiTrend = (nSeasons*nStations*Z.^2);
    ChiHomog = ChiTotal - ChiTrend;
    ChiSeason = nStations*sum(Zi.^2) - ChiTrend;
    ChiStation = nSeasons*sum(Zm.^2) - ChiTrend;
    ChiStationSeason = ChiHomog - ChiStation - ChiSeason;
    
    % Using Statistical Toolbox, calculate p-values for the various
    % chi-square statistics.
    TotalPvalue = 1-chi2cdf(ChiTotal,nStations*nSeasons);
    HomogPvalue = 1-chi2cdf(ChiHomog,nStations*nSeasons-1);
    StationPvalue = 1-chi2cdf(ChiStation,nStations-1);
    SeasonPvalue = 1-chi2cdf(ChiSeason,nSeasons-1);
    StationSeasonPvalue = 1-chi2cdf(ChiStationSeason,(nStations-1)*(nSeasons-1));
    TrendPvalue = 1-chi2cdf(ChiTrend,1);
    
    %% Load data into output variable.
    ChiOutput = [
        ChiTotal nStations*nSeasons TotalPvalue;
        ChiHomog nStations*nSeasons-1 HomogPvalue;
        ChiSeason nSeasons-1 SeasonPvalue;
        ChiStation nStations-1 StationPvalue;
        ChiStationSeason (nStations-1)*(nSeasons-1) StationSeasonPvalue;
        ChiTrend 1 TrendPvalue;
        ];
    
    fprintf('\n  Chi-Square Statistics\t\t  df\tp-value\t\tComment\n');
    fprintf('Total\t\t\t%7.6f\t%4.0f\t%6.4f\n',ChiOutput(1,:)); % no comment for Chi-Total
    fprintf('Homogeneity\t\t%7.6f\t%4.0f\t%6.4f\t\t%s\n',ChiOutput(2,:),HowSigIsIt(ChiOutput(2,3)));
    fprintf('Season\t\t\t%7.6f\t%4.0f\t%6.4f\t\t%s\n',ChiOutput(3,:),HowSigIsIt(ChiOutput(3,3)));
    fprintf('Station\t\t\t%7.6f\t%4.0f\t%6.4f\t\t%s\n',ChiOutput(4,:),HowSigIsIt(ChiOutput(4,3)));
    fprintf('Station-Season\t%7.6f\t%4.0f\t%6.4f\t\t%s\n',ChiOutput(5,:),HowSigIsIt(ChiOutput(5,3)));
    % note Global trend is fprintf from one of the if-end proc depending on
    % the conditionals.
    
    %% Some significance tests and narration to help interpretations.
    %   Hard to believe but in Switch-Case, you cannot use expressions
    %   other than equal-to...? Thus mutliple if-end procedures.
    if StationPvalue > alpha && SeasonPvalue > alpha && StationSeasonPvalue > alpha
        % Then test for global trend
        fprintf('Global Trend\t%7.6f\t%4.0f\t%6.4f\t\t%s\n',ChiOutput(6,:),HowSigIsIt(ChiOutput(6,3)));
        if TrendPvalue < alpha
            % There is a significant global trend
            fprintf('\nThere is a significant global trend in the data. \nTrend P-value = %5f\n',TrendPvalue);
        end
    end
    if SeasonPvalue < alpha && StationPvalue > alpha
        % Global Trend is not meaningful. Still print out but note comment
         fprintf('Global Trend\t%7.6f\t%4.0f\t%6.4f\t\t%s\n',ChiOutput(6,:),HowSigIsIt(1.1));
       % Trends have significantly different directions in different
        % seasons, but not stations, then
        % test for a different trend direction in each season
        K = nStations*(Zi.^2);
        
        % output format is by row: season chi-square, df, and p-value
        K = [K; ones(size(K)); 1-chi2cdf(K,1)];
        
        fprintf('\nTrends have significantly different directions in different seasons.\n');
        fprintf('\nThere IS significance in season p-value     = %5f and,\n',SeasonPvalue);
        fprintf('there is no significance in station p-value = %5f\n',StationPvalue);
        fprintf('\nSeason\tChi-Square\t  df\tp-value\t\tComment\n');
        fprintf('--------------------------------------------------------------------------------\n');
        K = K';
        for kk = 1:size(K,1)
            msg = HowSigIsIt(K(kk,3));
            fprintf(' %2.0f\t\t %7.5f\t%4.0f\t%6.5f\t\t%s\n',kk,K(kk,1),K(kk,2),K(kk,3),msg);
        end
    end
    if StationPvalue < alpha && SeasonPvalue > alpha
        % Global Trend is not meaningful. Still print out but note comment
         fprintf('Global Trend\t%7.6f\t%4.0f\t%6.4f\t\t%s\n',ChiOutput(6,:),HowSigIsIt(1.1));
        % Trends have significantly different directions in different
        % stations, but not in seasons, then
        % test for different trend directions for each station.
        M = nSeasons*(Zm.^2);
        
        % output format is by column: station chi-square, df, and p-value
        M = [M ones(size(M)) 1-chi2cdf(M,1)];
        
        fprintf('\nTrends have significantly different directions at different stations.\n');
        fprintf('\nThere is no significance in season p-value   = %5f and,\n',SeasonPvalue);
        fprintf('there IS significance in station p-value     = %5f\n',StationPvalue);
        fprintf('\nStation\tChi-Square\t  df\tp-value\t\tComment\n');
        fprintf('--------------------------------------------------------------------------------\n');
        for kk = 1:size(M,1)
            msg = HowSigIsIt(M(kk,3));
            fprintf(' %2.0f\t\t%6.4f\t\t%4.0f\t%6.5f\t\t%s\n',kk,M(kk,1),M(kk,2),M(kk,3),msg);
        end
    end
    if StationPvalue < alpha && SeasonPvalue < alpha || StationSeasonPvalue < alpha
        % Global Trend is not meaningful. Still print out but note comment
         fprintf('Global Trend\t%7.6f\t%4.0f\t%6.4f\t\t%s\n',ChiOutput(6,:),HowSigIsIt(1.1));
        % Chi trend tests should not be done and only the individual
        % station-seasons Z statistics tested.
        % S needs to be adjusted for individual station-seasons.
        s = S - sign(S);
        % pre-allocate
        sig = zeros(size(s));
        for ii = 1:numel(s)
            % Lame but you cant feed ztest vectors for sigmas, hence the
            % loop. Each row of p-values in the output is for a station
            % with seasons as columns.
            [h, sig(ii)] = ztest(s(ii),0,sigma(ii),alpha);
        end
        
        warning('WarningTrends:globalTrends','None of the Chi-square statistics are meaningful.');
        fprintf('\nThere is significance in season p-value         = %5f and,\n',SeasonPvalue);
        fprintf('there is significance in station p-value        = %5f\n',StationPvalue);
        fprintf('               OR\n');
        fprintf('There is significance in station-season p-value = %5f\n',StationSeasonPvalue);

        fprintf('\nStation\t Season\t\t  Z\t\t  n\t  S\t\tp-value\t\tSen Slope\n');
        fprintf('---------------------------------------------------------------\n');
        for ii = 1:size(sig,1)
            for jj = 1:size(sig,2)
                fprintf(' %3.0f\t  %3.0f\t\t%6.4f\t%3.0f\t%4.0f\t%7.5f\t\t%+6.5f\n',ii,jj,s(ii,jj)/sigma(ii,jj),n(ii,jj),S(ii,jj),sig(ii,jj),sen(ii,jj));
            end
        end
    end
end

function [answer] = HowSigIsIt(pvalue)
    % Some strings used in narrative interpretations of the estimated
    % significance of the homogeneity test results.  These are obviously
    % subjective, use, don't use, or change to your liking.
    p01 = 'All but absolute there is a trend.';
    p05 = 'High confidence there is a trend.';
    p10 = 'Likely there is a trend.';
    p20 = 'Some evidence there is a trend.';
    p21 = 'No significance.';
    p00 = 'Not meaningful. Do not use.';
    
    if pvalue > 1.0
        answer = p00;
    elseif  pvalue > 0.20
        answer = p21;
        return;
    elseif pvalue > 0.10
        answer = p20;
        return;
    elseif pvalue > 0.05
        answer = p10;
        return;
    elseif pvalue > 0.01
        answer = p05;
        return;
    elseif pvalue <= 0.01
        answer = p01;
        return;
    end
end

