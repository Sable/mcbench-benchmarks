function y=physunits(flagString)
%PHYSUNITS  Enable/Disable the physunits toolkit.
%
% Syntax: physunits(state)
% where state is either 'on' or 'off'.
% physunits by itself returns the current state.

global useUnitsFlag

switch nargin
    case 0
        if isempty(useUnitsFlag)||(useUnitsFlag)
            fprintf('PHYSUNITS currently enabled.\n')
        else
            fprintf('PHYSUNITS currently disabled.\n')
        end
    case 1
        if ~ischar(flagString)
            error('Possible values for input: ''on'', ''off''.')
        end
        if strcmpi(flagString,'on')
            useUnitsFlag=true;
            fprintf('PHYSUNITS enabled.\n')
        elseif strcmpi(flagString,'off')
            useUnitsFlag=false;
            fprintf('PHYSUNITS disabled.\n')
        else
            error('Possible values for input: ''on'', ''off''.')
        end
    otherwise
        error('Too many input arguments.')
end