% Returns the epanet code for a given string (char array)
% The values have been copied directly from the EPANET source code
%
% Arguments:
%   - en_constant (char)
%       Character array for which the EPANET code is required
%       E.g. 'EN_PRESSURE'
% Returns:
%   - value (int)
%       EPANET code. E.g. 11 for 'EN_PRESSURE'.
%       Returns -1 if the input string was not found.
%
% Author: Philip Jonkergouw
% Email:  pjonkergouw@gmail.com
% Date:   July 2007

function value = getenconstant(en_constant)

value = -1;

switch en_constant
    case 'EN_ELEVATION'
        value = 0;
    case 'EN_BASEDEMAND'
        value = 1;
    case 'EN_PATTERN'
        value = 2;
    case 'EN_EMITTER'
        value = 3;
    case 'EN_INITQUAL'
        value = 4;
    case 'EN_SOURCEQUAL'
        value = 5;
    case 'EN_SOURCEPAT'
        value = 6;
    case 'EN_SOURCETYPE'
        value = 7;
    case 'EN_TANKLEVEL'
        value = 8;
    case 'EN_DEMAND'
        value = 9;
    case 'EN_HEAD'
        value = 10;
    case 'EN_PRESSURE'
        value = 11;
    case 'EN_QUALITY'
        value = 12;
    case 'EN_SOURCEMASS'
        value = 13;

    case 'EN_DIAMETER'
        value = 0;
    case 'EN_LENGTH'
        value = 1;
    case 'EN_ROUGHNESS'
        value = 2;
    case 'EN_MINORLOSS'
        value = 3;
    case 'EN_INITSTATUS'
        value = 4;
    case 'EN_INITSETTING'
        value = 5;
    case 'EN_KBULK'
        value = 6;
    case 'EN_KWALL'
        value = 7;
    case 'EN_FLOW'
        value = 8;
    case 'EN_VELOCITY'
        value = 9;
    case 'EN_HEADLOSS'
        value = 10;
    case 'EN_STATUS'
        value = 11;
    case 'EN_SETTING'
        value = 12;
    case 'EN_ENERGY'
        value = 13;

    case 'EN_DURATION'
        value = 0;
    case 'EN_HYDSTEP'
        value = 1;
    case 'EN_QUALSTEP'
        value = 2;
    case 'EN_PATTERNSTEP'
        value = 3;
    case 'EN_PATTERNSTART'
        value = 4;
    case 'EN_REPORTSTEP'
        value = 5;
    case 'EN_REPORTSTART'
        value = 6;
    case 'EN_RULESTEP'
        value = 7;
    case 'EN_STATISTIC'
        value = 8;
    case 'EN_PERIODS'
        value = 9;

    case 'EN_NODECOUNT'
        value = 0;
    case 'EN_TANKCOUNT'
        value = 1;
    case 'EN_LINKCOUNT'
        value = 2;
    case 'EN_PATCOUNT'
        value = 3;
    case 'EN_CURVECOUNT'
        value = 4;
    case 'EN_CONTROLCOUNT'
        value = 5;

    case 'EN_JUNCTION'
        value = 0;
    case 'EN_RESERVOIR'
        value = 1;
    case 'EN_TANK'
        value = 2;

    case 'EN_CVPIPE'
        value = 0;
    case 'EN_PIPE'
        value = 1;
    case 'EN_PUMP'
        value = 2;
    case 'EN_PRV'
        value = 3;
    case 'EN_PSV'
        value = 4;
    case 'EN_PBV'
        value = 5;
    case 'EN_FCV'
        value = 6;
    case 'EN_TCV'
        value = 7;
    case 'EN_GPV'
        value = 8;
    %Quality analysis types
    case 'EN_NONE'
        value = 0;
    case 'EN_CHEM'
        value = 1;
    case 'EN_AGE'
        value = 2;
    case 'EN_TRACE'
        value = 3;

    %Source quality types
    case 'EN_CONCEN'
        value = 0;
    case 'EN_MASS'
        value = 1;
    case 'EN_SETPOINT'
        value = 2;
    case 'EN_FLOWPACED'
        value = 3;

    %Flow units types
    case 'EN_CFS'
        value = 0;
    case 'EN_GPM'
        value = 1;
    case 'EN_MGD'
        value = 2;
    case 'EN_IMGD'
        value = 3;
    case 'EN_AFD'
        value = 4;
    case 'EN_LPS'
        value = 5;
    case 'EN_LPM'
        value = 6;
    case 'EN_MLD'
        value = 7;
    case 'EN_CMH'
        value = 8;
    case 'EN_CMD'
        value = 9;
    % Misc. options
    case 'EN_TRIALS'
        value = 0;
    case 'EN_ACCURACY'
        value = 1;
    case 'EN_TOLERANCE'
        value = 2;
    case 'EN_EMITEXPON'
        value = 3;
    case 'EN_DEMANDMULT'
        value = 4;
    % Control types
    case 'EN_LOWLEVEL'
        value = 0;
    case 'EN_HILEVEL'
        value = 1;
    case 'EN_TIMER'
        value = 2;
    case 'EN_TIMEOFDAY'
        value = 3;
    % Time statistic types
    case 'EN_AVERAGE'
        value = 1;
    case 'EN_MINIMUM'
        value = 2;
    case 'EN_MAXIMUM'
        value = 3;
    case 'EN_RANGE'
        value = 4;
    % Save-results-to-file flag
    case 'EN_NOSAVE'
        value = 0;
    case 'EN_SAVE'
        value = 1;
    % Re-initialize flow flag 
    case 'EN_INITFLOW'
        value = 10;
                  
end

if ~(value + 1)
    fprintf('Could not retrieve EPANET code for ''%s''.\n', en_constant);
end
