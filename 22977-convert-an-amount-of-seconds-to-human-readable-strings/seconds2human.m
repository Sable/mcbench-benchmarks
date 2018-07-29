function out = seconds2human(secs, varargin)
%SECONDS2HUMAN( seconds )   Converts the given number of seconds into a 
%                           human-readable string.
%
%   str = SECONDS2HUMAN(seconds) returns a human-readable string from a
%   given (usually large) amount of seconds. For example, 
%
%       str = seconds2human(1463456.3)
%
%       str = 
%       'About 2 weeks and 2 days.'
%
%   You may also call the function with a second input argument; either
%   'short' (the default) or 'full'. This determines the level of detail
%   returned in the string:
%
%       str = seconds2human(1463456.3, 'full')
%   
%       str =
%       '2 weeks, 2 days, 22 hours, 30 minutes, 56 seconds.'
%
%   The 'short' format returns only the two largest units of time.
%
%   [secs] may be an NxM-matrix, in which case the output is an NxM cell 
%   array of the corresponding strings. 
%
%   NOTE: SECONDS2HUMAN() defines one month as an "average" month, which 
%   means that the string 'month' indicates 30.471 days. 
%
%   See also datestr, datenum, etime. 


%   Author: Rody P.S. Oldenhuis
%   Delft University of Technology
%   E-mail: oldnhuis@dds.nl
%   Last edited 11/Feb/2010.

    % default error
    error(nargchk(1,2,nargin));%#ok

    % define some intuitive variables
    Seconds   = round(1                 );
    Minutes   = round(60     * Seconds  ); 
    Hours     = round(60     * Minutes  );
    Days      = round(24     * Hours    ); 
    Weeks     = round(7      * Days     ); 
    Months    = round(30.471 * Days     );
    Years     = round(365.26 * Days     );
    Centuries = round(100    * Years    );
    Millennia = round(10     * Centuries);

    % put these into an array, and define associated strings
    units   = [Millennia, Centuries, Years, Months, Weeks, ...
               Days, Hours, Minutes, Seconds];
    singles = {'millennium'; 'century'; 'year'; 'month'; ...
               'week'; 'day'; 'hour'; 'minute'; 'second'};
    plurals = {'millennia' ; 'centuries'; 'years'; 'months'; ...
               'weeks'; 'days'; 'hours'; 'minutes'; 'seconds'};

    % cut off all decimals from the given number of seconds
    assert(isnumeric(secs), 'seconds2human:seconds_mustbe_numeric', ...
        'The argument ''secs'' must be a scalar or matrix.');
    secs = round(secs);   
    
    % parse second argument
    short = true; 
    if (nargin > 1)
        % extract argument
        short = varargin{1};
        % check its type
        assert(ischar(short), 'seconds2human:argument_type_incorrect', ...
            'The second argument must be either ''short'' or ''full''.');
        % check its contents
        switch lower(short)
            case 'full' , short = false;
            case 'short', short = true;
            otherwise
                error('seconds2human:short_format_incorrect',...
                    'The second argument must be either ''short'' or ''full''.');
        end
    end
    
    % pre-allocate appropriate output-type
    numstrings = numel(secs);    
    if (numstrings > 1), out = cell(size(secs)); end
    
    % build (all) output string(s)    
    for j = 1:numstrings
                
        % initialize nested loop
        secsj   = secs(j);
        counter = 0;       
        if short, string = 'About ';
        else      string = '';
        end
        
        % possibly quick exit
        if (secsj < 1), string = 'Less than one second.'; end
        
        % build string for j-th amount of seconds
        for i = 1:length(units)
            
            % amount of this unit
            amount = fix(secsj/units(i));
            
            % include this unit in the output string
            if amount > 0
                
                % increase counter
                counter = counter + 1;
                                
                % append (single or plural) unit of time to string
                if (amount > 1)
                    string = [string, num2str(amount), ' ', plurals{i}];%#ok
                else
                    string = [string, num2str(amount), ' ', singles{i}];%#ok
                end
                                
                % Finish the string after two units if short format is requested
                if (counter > 1 && short), string = [string, '.']; break, end%#ok
                
                % determine whether the ending should be a period (.) or a comma (,)
                if (rem(secsj, units(i)) > 0)
                    if short, ending = ' and ';
                    else ending = ', ';
                    end
                else ending = '.';
                end
                string = [string, ending];%#ok
                
            end
            
            % subtract this step from given amount of seconds
            secsj = secsj - amount*units(i);
        end
        
        % insert in output cell, or set output string
        if (numstrings > 1)
            out{j} = string;
        else
            out = string;
        end        
    end % for
    
end % seconds2human
