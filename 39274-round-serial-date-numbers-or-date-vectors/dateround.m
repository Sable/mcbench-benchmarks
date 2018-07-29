function DtN = dateround(DVN,Uni,RFC)
% Round date vectors/numbers to the nearest chosen unit. (round/floor/ceiling)
%
% (c) 2013 Stephen Cobeldick
%
% ### Function ###
%
% Round Serial Date Numbers or Date Vectors to the nearest chosen unit, i.e.
% to the nearest year, month, day, hour, minute, or second. Accepts multiple
% date values, returns Serial Date Numbers. Choice of rounding, floor or ceiling.
%
% Syntax:
%  DtN = dateround              % Round current time to the second.
%  DtN = dateround(DVN)         % Round <DVN> to the second.
%  DtN = dateround(DVN,Uni)     % Round <DVN> to the chosen unit.
%  DtN = dateround(DVN,Uni,RFC) % Round/floor/ceiling <DVN> to the chosen unit.
%
% See also ROUND PREFNUM CLOCK NOW DATENUM8601 DATESTR8601 DATENUM DATEVEC DATESTR
%
% Note 1: Calls undocumented MATLAB functions "datevecmx" and "datenummx".
% Note 2: Provides a precision of ca. 0.0001 seconds, from year 0000 to 5741.
%
% ### Examples ###
%
% Examples use the date+time described by the vector [1999,1,3,15,6,48.0568].
%
% datevec(dateround(730123.62972287962))
%             ans = [1999,1,3,15,6,48]
%
% datevec(dateround([1999,1,3,15,6,48.0568]))
%             ans = [1999,1,3,15,6,48]
%
% datevec(dateround([1999,1,3,15,6,48.0568],'minute'))
%             ans = [1999,1,3,15,7,0]
%
% datevec(dateround([1999,1,3,15,6,48.0568],5)) % 5=='minute'
%             ans = [1999,1,3,15,7,0]
%
% datevec(dateround([1999,1,3,15,6,48.0568],5,'floor'))
%             ans = [1999,1,3,15,6,0]
%
% datevec(dateround([1999,12,31,23,59,59.5000;1999,12,31,23,59,59.4999]))
%             ans = [2000, 1, 1, 0, 0, 0;     1999,12,31,23,59,59]
%
% ### Input & Output Arguments ###
%
% Inputs (*=default):
%  DVN = Date Vector, one single date vector (OR matrix of Date Vectors).
%      = Serial Date Number, scalar numeric (OR column vector of Serial Date Numbers).
%      = []*, use the current time.
%  Uni = Numeric scalar, 1/2/3/4/5/6* -> round to the year/month/day/hour/min/sec.
%      = String, 'year'/'month'/'day'/'hour'/'minute'/'second' (plural also),
%        or as per "datestr8601"/"datenum8601" tokens: 'y'/'m'/'d'/'H'/'M'/'S',
%        or as per MATLAB symbolic identifiers: 'yyyy'/'mm'/'dd'/'HH'/'MM'/'SS'.
%  RFC = String token *'round'/'floor'/'ceiling' to select the rounding method.
%
% Output:
%  DtN = Serial Date Number, column vec, <DVN> rounded at the units given by <Uni>.
%
% Inputs = (DVN,Uni*,RFC*)
% Output = DtN

% ### Date Vector & Number ###
%
% Calculate date-vector:
if nargin==0||isempty(DVN) % Default = now
    DtV = clock;
elseif iscolumn(DVN)       % Serial Date Number
    DtV = datevecmx(DVN);
elseif ismatrix(DVN)       % Date Vector
    DtV = datevecmx(datenummx(DVN));
else
    error('First argument: invalid Date Vector or Date Number. Check array dimensions.')
end
% Calculate serial date-number:
DtN = datenummx(DtV);
%
% ### Unit Index ###
%
% Determine unit's index (1/2/3/4/5/6* = year/month/day/hour/min/sec):
if nargin<2||isempty(Uni)
    Uni = 6; % *default = seconds.
elseif isnumeric(Uni)&&isscalar(Uni)
    Uni = real(double(Uni));
    assert(0<Uni&&Uni<7,'Second argument <Uni>: permitted range 1-6 inclusive')
elseif ischar(Uni)
    Uni = DtRndStr(Uni);
else
    error('Second argument <Uni>: must be string or numeric scalar.')
end
%
% ### Check Trailing Values ###
%
% Separate milliseconds from seconds:
DtV(:,7) = rem(DtV(:,6),1);
DtV(:,6) = floor(DtV(:,6));
% Check if any trailing values are > default:
DtW = [0,1,1,0,0,0,0];
DtI = any(bsxfun(@gt,DtV(:,Uni+1:7),DtW(Uni+1:7)),2);
% Remove milliseconds:
DtV(:,7) = [];
%
% ### Floor & Ceiling ###
%
% floor:
DtV(:,Uni+1:6) = DtW(ones(1,numel(DtN)),Uni+1:6);
DtC(1,:) = datenummx(DtV);
% ceiling:
DtV(:,Uni) = DtV(:,Uni)+DtI;
DtC(2,:) = datenummx(DtV);
% DtC must be columnwise so that logical indexing gives correct output order.
%
% ### Select Output ###
%
if nargin<3||isempty(RFC)||strcmp(RFC,'round')
    DtL = 2*DtN.'<sum(DtC,1)-0.0000000002; % - Conversion precision
    DtN(:) = DtC([DtL;~DtL]);
elseif strcmp(RFC,'floor')
    DtN(:) = DtC(1,:);
elseif strcmp(RFC,'ceiling')
    DtN(:) = DtC(2,:);
else
    error('Third argument <RFC> must be one of ''round''/''floor''/''ceiling''.')
end
%
end
%--------------------------------------------------------------------------
function Uni = DtRndStr(Str)
%
% Switch seems to be the fastest and clearest way to select the index:
switch Str
    case {'S','SS','sec','secs','second','seconds'}
        Uni = 6;
    case {'M','MM','min','mins','minute','minutes'}
        Uni = 5;
    case {'H','HH','hour','hours'}
        Uni = 4;
    case {'d','dd','day','days'}
        Uni = 3;
    case {'m','mm','month','months'}
        Uni = 2;
    case {'y','yyyy','year','years'}
        Uni = 1;
    otherwise
        error('Second argument <Uni>: unrecognized string token.')
end
%
end
%----------------------------------------------------------------------End!