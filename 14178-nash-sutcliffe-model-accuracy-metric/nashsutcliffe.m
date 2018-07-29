% Nash-Sutcliffe model accuracy statistic. Nash-Sutcliffe 
% efficiency is an indicator of the model’s ability to predict about the 
% 1:1 line. 
%
% The Nash-Sutcliffe coefficient is calculated as:
% 
% 	              ?(Qobs - Qsim)^2
% =    1 -   ----------------------------
% 	              ?(Qobs - Qmean)^2
% 
% With the Nash-Sutcliffe measure, an r-square coefficient is calculated using 
% Coefficient values equal to 1 indicate a perfect fit between observed
% and predicted data, and r-square values equal to or less than 0 indicate that 
% the model is predicting no better than using the average of the observed 
% data.  Thus Ockham's razor should be applied. 
%
% Dimensions of Observed data array does not have to equal simulated data.
% An intersection is used to pair up observed data to simulated. This
% function is setup to pair up the first column in the observed data matrix
% and the first column in the simulated data matrix. Data values are
% located in column 2 of both matricies. 
%
% One critical assumption to this measurement is the data are normal.
%
% Syntax:
%     [NSout metric_id] = nashsutcliffe(obsDATA, simDATA)
%
% where:
%     obsData = N x 2
%     simData = N x 2
%
%     obsData(:,1) = time observed
%     obsData(:,2) = Observed Data
%     simData(:,1) = time simulated
%     simData(:,2) = Simulated data
%
%  NSout = double scalar
%  metric_id = 1001
%
% Requirements: none
%
% Written by Jeff Burkey
% King County, Department of Natural Resources and Parks
% 3/7/2007
% email: jeff.burkey@metrokc.gov
%
function [NSout metric_id] = nashsutcliffe(obsData, simData)
    % Set metric id for optional use.  This is arbitrarily set to 1001
    % for this metric and used in other applications not associated to this 
    % function. The user can either ignore or remove from the function. 
    metric_id = 1001;

    % find matching time values
    [v loc_obs loc_sim] = intersect(obsData(:,1), simData(:,1));

    % and create subset of data with elements= Time, Observed, Simulated
    MatchedData = [v obsData(loc_obs,2) simData(loc_sim,2)];

    % I'm not familiar with how MATLAB is optimized to clear it's memory,
    % this next call may or may not speed things up.
    clear v loc_obs loc_sim
    
    [r c] = size(MatchedData); %#ok<NASGU>

    if r >= 2 
        E = MatchedData(:,2) - MatchedData(:,3);
        SSE = sum(E.^2);
        u = mean(MatchedData(:,2));
        SSU = sum((MatchedData(:,2) - u).^2);

        NSout = 1 - SSE/SSU;
    
        if NSout < 0
            % model predictions are poor
            warning('MATLAB:ScoreLTZero','model predictions are poor. Using the mean \n of observed data would be better.')
        end
    else % cannot compute statistics
        error('MATLAB:divideByZero','Intesecting data resulted in too few elements to compute. \n Function has been terminated. If this is unexpected, \n check your index vectors of the two arrays.');
    end
end
