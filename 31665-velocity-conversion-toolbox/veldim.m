function vel = veldim(vel,from,to)
%VELDIM  Convert velocity units
%
%   velOut = VELDIM(velIn, FROM, TO) converts velIn from the units
%   specified by the string FROM to the units specified by the string
%   TO.  FROM and TO are case-insensitive, and may equal any of the
%   following:
%
%        'meters per second', 'mps' or 'm/s'
%        'feet per second', 'ftps' or 'ft/s'   <== U.S. survey feet
%        'kilometers per hour', 'kmph', 'km/hr', or 'km/h'
%        'knots', 'kts', 'nm/hr' or 'nm/h'
%        'miles per hour', 'mph', 'mi/hr', 'mi/h', sm/hr' or 'sm/h' <== statute miles
%
%   Exercise caution with 'feet' and 'miles'
%   ----------------------------------------
%   VELDIM interprets 'feet per second', 'ftps', and 'ft/s' as U.S. survey
%   feet per second, and does not support international feet at all.
%
%   By definition, one international foot is exactly 0.3048 meters and
%   one U.S. survey foot is exactly 1200/3937 meters.  For many
%   applications, the difference is significant.
%
%   Likewise, VELDIM interprets 'miles per hour', 'mph', 'mi/h', and 'sm/h'
%   as statute miles per hour (also known as U.S. survey miles), and does
%   not support international miles per hour at all.  By definition, one
%   international mile is 5280 international feet and one statute mile is
%   5280 survey feet.
%
%   See also  MPS2FTPS, MPS2KMPH,  MPS2KTS,  MPS2MPH,
%             FTPS2MPS, FTPS2KMPH, FTPS2KTS, FTPS2MPH,
%             KMPH2MPS, KMPH2FTPS, KMPH2KTS, KMPH2MPH,
%             KTS2MPS,  KTS2FTPS,  KTS2KMPH, KTS2MPH, 
%             MPH2MPS,  MPH2FTPS,  MPH2KMPH, MPH2KTS

error(nargchk(3, 4, nargin, 'struct'))

% Warn and convert to real if VEL is complex.
vel = ignoreComplex(vel, mfilename, 'VEL');

% Convert units only if there's something to change.
if ~strcmp(from, to)
    vel = applyconversion(vel, from, to);
end

function vel = applyconversion(vel, from, to)

from = lower(from);
to = lower(to);

toIsSupported   = true;
fromIsSupported = true;

switch from
    case {'meters per second','mps','m/s'}
        switch to
            case {'feet per second','ftps','ft/s'}
                vel = mps2ftps(vel);
            case {'kilometers per hour','kmph','km/h','km/hr'}
                vel = mps2kmph(vel);
            case {'knots','kts','nm/h','nm/hr'}
                vel = mps2kts(vel);
            case {'miles per hour','mph','mi/hr','mi/h','sm/hr','sm/h'}
                vel = mps2mph(vel);
            otherwise
                toIsSupported = false;
        end
    case {'feet per second','ftps','ft/s'}
        switch to
            case {'meters per second','mps','m/s'}
                vel = ftps2mps(vel);
            case {'kilometers per hour','kmph','km/h','km/hr'}
                vel = ftps2kmph(vel);
            case {'knots','kts','nm/h','nm/hr'}
                vel = ftps2kts(vel);
            case {'miles per hour','mph','mi/hr','mi/h','sm/hr','sm/h'}
                vel = ftps2mph(vel);
            otherwise
                toIsSupported = false;
        end
    case {'kilometers per hour','kmph','km/h','km/hr'}
        switch to
            case {'feet per second','ftps','ft/s'}
                vel = kmph2ftps(vel);
            case {'meters per second','mps','m/s'}
                vel = kmph2mps(vel);
            case {'knots','kts','nm/h','nm/hr'}
                vel = kmph2kts(vel);
            case {'miles per hour','mph','mi/hr','mi/h','sm/hr','sm/h'}
                vel = kmph2mph(vel);
            otherwise
                toIsSupported = false;
        end
    case {'knots','kts','nm/h','nm/hr'}
        switch to
            case {'feet per second','ftps','ft/s'}
                vel = kts2ftps(vel);
            case {'kilometers per hour','kmph','km/h','km/hr'}
                vel = kts2kmph(vel);
            case {'meters per second','mps','m/s'}
                vel = kts2mps(vel);
            case {'miles per hour','mph','mi/hr','mi/h','sm/hr','sm/h'}
                vel = kts2mph(vel);
            otherwise
                toIsSupported = false;
        end
    case {'miles per hour','mph','mi/hr','mi/h','sm/hr','sm/h'}
        switch to
            case {'feet per second','ftps','ft/s'}
                vel = mph2ftps(vel);
            case {'kilometers per hour','kmph','km/h','km/hr'}
                vel = mph2kmph(vel);
            case {'knots','kts','nm/h','nm/hr'}
                vel = mph2kts(vel);
            case {'meters per second','mps','m/s'}
                vel = mph2mps(vel);
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