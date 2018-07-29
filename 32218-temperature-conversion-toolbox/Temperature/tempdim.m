function temp = tempdim(temp,from,to)
%TEMPDIM  Convert temperature units
%
%   tempOut = TEMPDIM(tempIn, FROM, TO) converts tempIn from the units
%   specified by the string FROM to the units specified by the string
%   TO.  FROM and TO are case-insensitive, and may equal any of the
%   following:
%
%        'farenheit', 'far', or 'f'
%        'rankine', 'rank', or 'r'
%        'celsius', 'cel' or 'c'
%        'kelvin', 'kel', or 'k'
%
%   See also  FAR2CEL,  FAR2KEL,  FAR2RANK,
%             CEL2FAR,  CEL2KEL,  CEL2RANK,
%             KEL2FAR,  KEL2CEL,  KEL2RANK,
%             RANK2FAR, RANK2CEL, RANK2KEL

error(nargchk(3, 4, nargin, 'struct'))

% Warn and convert to real if TEMP is complex.
temp = ignoreComplex(temp, mfilename, 'TEMP');

% Convert units only if there's something to change.
if ~strcmp(from, to)
    temp = applyconversion(temp, from, to);
end

function temp = applyconversion(temp, from, to)

from = lower(from);
to = lower(to);

toIsSupported   = true;
fromIsSupported = true;

switch from
    case {'farenheit','far','f'}
        switch to
            case {'rankine','rank','r'}
                temp = far2rank(temp);
            case {'celsius','cel','c'}
                temp = far2cel(temp);
            case {'kelvin', 'kel','k'}
                temp = far2kel(temp);
            otherwise
                toIsSupported = false;
        end
    case {'rankine','rank','r'}
        switch to
            case {'farenheit','far','f'}
                temp = rank2far(temp);
            case {'celsius','cel','c'}
                temp = rank2cel(temp);
            case {'kelvin', 'kel','k'}
                temp = rank2kel(temp);
            otherwise
                toIsSupported = false;
        end
    case {'celsius','cel','c'}
        switch to
            case {'rankine','rank','r'}
                temp = cel2rank(temp);
            case {'farenheit','far','f'}
                temp = cel2far(temp);
            case {'kelvin', 'kel','k'}
                temp = cel2kel(temp);
            otherwise
                toIsSupported = false;
        end
    case {'kelvin', 'kel','k'}
        switch to
            case {'farenheit','far','f'}
                temp = kel2far(temp);
            case {'celsius','cel','c'}
                temp = kel2cel(temp);
            case {'rankine','rank','r'}
                temp = kel2rank(temp);
            otherwise
                toIsSupported = false;
        end
    otherwise
        fromIsSupported = false;
end

assert(toIsSupported, 'map:distdim:UnsupportedToUnits', ...
    'Unsupported ''TO'' units: %s.', to)

assert(fromIsSupported, 'map:distdim:UnsupportedFromUnits', ...
    'Unsupported ''FROM'' units: %s.', from)