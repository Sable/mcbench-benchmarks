function [Bx, By, Bz] = igrf(time, latitude, longitude, altitude, coord)

% IGRF Earth's magnetic field from IGRF model.
% 
% Usage: [BX, BY, BZ] = IGRF(TIME, LATITUDE, LONGITUDE, ALTITUDE, COORD)
%     or [BX, BY, BZ] = IGRF(COEFS, LATITUDE, LONGITUDE, ALTITUDE, COORD)
%     or B = IGRF(TIME, LATITUDE, LONGITUDE, ALTITUDE, COORD)
%     or B = IGRF(COEFS, LATITUDE, LONGITUDE, ALTITUDE, COORD)
% 
% Calculates the components of the Earth's magnetic field using the
% International Geomagnetic Reference Field (IGRF) model. The inputs for
% the position can be scalars or vectors (in the latter case each should
% have the same number of elements or be a scalar), but TIME must be a
% scalar.
% 
% When all the coordinate inputs are scalars, the function can be run more
% efficiently by providing the proper IGRF coefficient vector for a given
% time rather than the time itself. This mode is useful when making
% multiple calls to the function while keeping the time the same (meaning
% the coefficients will be the same for each run) as loading the
% coefficients can be the most time-consuming part of the function. The
% coefficient vector can be easily loaded using the function LOADIGRFCOEFS.
% This mode is assumed when all the coordinate inputs are scalars and the
% first input is a vector. In this case, the coefficient vector should be
% formatted as (LOADIGRFCOEFS provides this):
% 
%   [g(n=1,m=0) g(n=1,m=1) h(n=1,m=1) g(n=2,m=0) g(n=2,m=1) h(n=2,m=1) ...]
% 
% Regardless of the size of the inputs, the outputs will be column vectors.
% If only one output is requested, B = [BX(:), BY(:), BZ(:)] is output.
% Note that the other parameters the IGRF gives can be computed from BX,
% BY, and BZ as:
% 
%   Horizonal intensity: hypot(BX, BY) (i.e., sqrt(BX.^2 + BY.^2) )
%   Total intensity: hypot(BX, hypot(BY, BZ))
%   Declination: atan2(BY, BX)
%   Inclination: atan(BZ./hypot(BX, BY))
% 
% This function relies on having the file igrfcoefs.mat in the MATLAB
% path to function properly when a time is input. If this file cannot be
% found, this function will try to create it by calling GETIGRFCOEFS.
% 
% The IGRF is a spherical harmonic expansion of the Earth's internal
% magnetic field. Currently, the IGRF model is valid between the years 1900
% and 2015. See the health warning for the IGRF model here:
% http://www.ngdc.noaa.gov/IAGA/vmod/igrfhw.html
% 
% Reference:
% International Association of Geomagnetism and Aeronomy, Working Group 
% V-MOD (2010), International Geomagnetic Reference Field: the eleventh
% generation, _Geophys. J. Int._, _183_(3), 1216-1230, 
% doi:10.1111/j.1365-246X.2010.04804.x.
% 
% Inputs:
%   -TIME: Time to get the magnetic field values either in MATLAB serial
%   date number format or a string that can be converted into MATLAB serial
%   date number format using DATENUM with no format specified (see
%   documentation of DATENUM for more information).
%   -COEFS: Instead of inputting a time, you can simply specify the proper
%   coefficients for the time you want by inputting in the first argument
%   the proper coefficient vector from igrfcoefs.mat.
%   -LATITUDE: Geocentric or geodetic latitude in degrees.
%   -LONGITUDE: Geocentric or geodetic longitude in degrees.
%   -ALTITUDE: For geodetic coordiates, the height in km above the Earth's
%   surface. For geocentric coordiates, the radius in km from the center of
%   the Earth.
%   -COORD: String specifying the coordinate system to use. Either
%   'geocentric' or 'geodetic' (optional, default is geodetic). Note that
%   only geodetic coordinates have been verified.
% 
% Outputs:
%   -BX: Northward component of the magnetic field in nanoteslas (nT).
%   -BY: Eastward component of the magnetic field in nT.
%   -BZ: Downward component of the magnetic field in nT.
%   -B: [BX(:), BY(:), BZ(:)].
% 
% See also: LOADIGRFCOEFS, GETIGRFCOEFS, IGRFLINE, DATENUM, IGRF11MAGM.

% Run IGRFS if all position inputs are scalars.
if isscalar(latitude) && isscalar(longitude) && isscalar(altitude)
    if nargin < 5
        [Bx, By, Bz] = igrfs(time, latitude, longitude, altitude);
    else
        [Bx, By, Bz] = igrfs(time, latitude, longitude, altitude, coord);
    end
% Otherwise run IGRFV.
else
    if nargin < 5
        [Bx, By, Bz] = igrfv(time, latitude, longitude, altitude);
    else
        [Bx, By, Bz] = igrfv(time, latitude, longitude, altitude, coord);
    end
end

if nargout <= 1
    Bx = [Bx(:), By(:), Bz(:)];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%        IGRF vector function.        %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Bx, By, Bz] = igrfv(time, latitude, longitude, altitude, coord)

% Fundamental constant.
Rearth_km = 6371.2;

%%% CHECK INPUT VALIDITY %%%
% Convert time to a datenumber if it is a string.
if ischar(time)
    time = datenum(time);
end

% Make sure time has only one element.
if numel(time) > 1
    error('igrf:timeInputInvalid', ['The input TIME can only have one ' ...
        'element.']);
end

% Check that the inputs all have either one or the same number of elements.
numlat = numel(latitude);
numlon = numel(longitude);
numalt = numel(altitude);
if numlat > 1
    if numlon == 1
        longitude = repmat(longitude, size(latitude));
    end
    if numalt == 1
        altitude = repmat(altitude, size(latitude));
    end
elseif numlon > 1
    latitude = repmat(latitude, size(longitude));
    if numalt == 1
        altitude = repmat(altitude, size(latitude));
    end
elseif numalt > 1
    latitude = repmat(latitude, size(altitude));
    longitude = repmat(longitude, size(altitude));
end
numlat = numel(latitude);
numlon = numel(longitude);
numalt = numel(altitude);
if numlat ~= numlon || numlat ~= numalt || numlon ~= numalt
    error('igrf:inputNotSameSize', ['The input coordinates must have ' ...
        'the same number of elements.']);
end

%%% SPHERICAL COORDINATE CONVERSION %%%
% Convert the latitude, longitude, and altitude coordinates input into
% spherical coordinates r (radius), theta (inclination angle from +z axis),
% and phi (azimuth angle from +x axis). Also, make the coordinates go down
% the rows.
% We want cos(theta) and sin(theta) rather than theta itself.
costheta = cos((90 - latitude(:))*pi/180);
sintheta = sin((90 - latitude(:))*pi/180);

% Convert from geodetic coordinates to geocentric coordinates if necessary.
% This method was adapted from igrf11syn, which was a conversion of the
% IGRF subroutine written in FORTRAN.
if nargin < 5 || isempty(coord) || strcmpi(coord, 'geodetic') || ...
        strcmpi(coord, 'geod') || strcmpi(coord, 'gd')
    a = 6378.137; f = 1/298.257223563; b = a*(1 - f);
    rho = hypot(a*sintheta, b*costheta);
    r = sqrt( altitude(:).^2 + 2*altitude(:).*rho + ...
        (a^4*sintheta.^2 + b^4*costheta.^2) ./ rho.^2 );
    cd = (altitude(:) + rho) ./ r;
    sd = (a^2 - b^2) ./ rho .* costheta.*sintheta./r;
    oldcos = costheta;
    costheta = costheta.*cd - sintheta.*sd;
    sintheta = sintheta.*cd + oldcos.*sd;
elseif strcmpi(coord, 'geocentric') || strcmpi(coord, 'geoc') || ...
        strcmpi(coord, 'gc')
    r = altitude(:);
    cd = 1;
    sd = 0;
else
    error('igrf:coordInputInvalid', ['Unrecognized command ' coord ...
        ' for COORD input.']);
end

% Special case when sin(theta) = 0.
sintheta0 = sintheta == 0;
anysintheta0 = any(sintheta0);
anysinthetanot0 = any(~sintheta0);

% Convert longitude to radians.
phi = longitude(:)*pi/180;

%%% GET PROPER IGRF COEFFICIENTS %%%
[g, h] = loadigrfcoefs(time);
nmax = size(g, 1);

% We need cos(m*phi) and sin(m*phi) multiple times, so precalculate into a
% matrix here:
cosphi = cos(bsxfun(@times, 0:nmax, phi));
sinphi = sin(bsxfun(@times, 0:nmax, phi));

%%% BEGIN MAGNETIC FIELD CALCULATION %%%
% Initialize variables used in for loop below.
Br = zeros(size(r));
Bt = zeros(size(r));
Bp = zeros(size(r));
lastP = 1;
lastdP_1 = 0;
lastdP_2 = 0;

% Sum for each n value.
for n = 1 : nmax
    
    m = 0 : n;
    
    % Calculate legendre values. The output of the function has each m
    % value going down the rows, but since m goes along the columns
    % (coordinates go down the rows, remember?), permute it.
    P = legendre(n, costheta, 'sch').';
    
    % We also need the derivative of the legendre with respect to theta. It
    % is given by a recursive function of both the previous legendre values
    % as well as the previous derivatives. Functionally, it is:
    % dP(0, 0) = 0, dP(1, 1) = cos(theta)
    % dP(n, n) = sqrt(1 - 1/(2n))*(sin(theta)*dP(n-1, n-1) +
    %     cos(theta)*P(n-1, n-1))
    % dP(n, m) = (2n - 1)/sqrt(n^2 - m^2)*(cos(theta)*dP(n-1, m) -
    %     sin(theta)*P(n-1, m)) - sqrt(((n-1)^2 - m^2)/(n^2 - m^2))*
    %     dP(n-2, m)
    dP = [bsxfun(@minus, bsxfun(@times, ...
        (2*n - 1)./sqrt(n^2 - m(1:end-1).^2), ...
        bsxfun(@times, costheta, lastdP_1) - bsxfun(@times, sintheta, ...
        lastP)), bsxfun(@times, sqrt(((n - 1)^2 - m(1:end-1).^2)./...
        (n^2 - m(1:end-1).^2)), lastdP_2)), zeros(size(costheta))];
    if n > 1
        dP(:, end) = sqrt(1 - 1/(2*n))*...
            (sintheta*lastdP_1(end) + costheta*lastP(end));
        lastdP_2 = [lastdP_1 zeros(size(costheta))];
    else
        dP(:, end) = costheta;
        lastdP_2 = lastdP_1;
    end
    lastP = P;
    lastdP_1 = dP;
    
    % Multiply coefficients by proper longitude trigonemetric term.
    gcos = bsxfun(@times, g(n, m + 1), cosphi(:, m + 1));
    gsin = bsxfun(@times, g(n, m + 1), sinphi(:, m + 1));
    hcos = bsxfun(@times, h(n, m + 1), cosphi(:, m + 1));
    hsin = bsxfun(@times, h(n, m + 1), sinphi(:, m + 1));
    
    % Calculate the magnetic field components as a running sum. Find
    % explicit expressions for these in Global Earth Physics: a Handbook of
    % Physical Constants by Thomas J. Aherns (1995), pg. 49. Link:
    % http://books.google.com/books?id=aqjU_NHyre4C&lpg=PP1&dq=Global%20
    % earth%20physics%3A%20a%20handbook%20of%20physical%20constants&pg=PA49
    % #v=onepage&q&f=false
    % (except equation 6 is missing a required 1/sin(theta) and m; correct
    % equations on page 5 (equations 3a-3c) of:
    % http://hanspeterschaub.info/Papers/UnderGradStudents/
    % MagneticField.pdf)
    a_r = (Rearth_km./r).^(n + 2);
    Br = Br + a_r.*(n+1).*sum((gcos + hsin).*P, 2);
    Bt = Bt - a_r.*sum((gcos + hsin).*dP, 2);
    % Different case when sin(theta) == 0 for phi component.
    if anysinthetanot0
        Bp(~sintheta0) = Bp(~sintheta0) - 1./sintheta(~sintheta0).*...
            a_r(~sintheta0).*sum(bsxfun(@times, m, ...
            (-gsin(~sintheta0, :) + hcos(~sintheta0, :)).*...
            P(~sintheta0, :)), 2);
    end
    if anysintheta0
        Bp(sintheta0) = Bp(sintheta0) - costheta(sintheta0).*...
            a_r(sintheta0).*sum((-gsin(sintheta0, :) ...
            + hcos(sintheta0, :)).*dP(sintheta0, :), 2);
    end
    
end

% Convert from spherical to (x,y,z) = (North,East,Down).
Bx = -Bt;
By = Bp;
Bz = -Br;

% Convert back to geodetic coordinates if necessary.
Bx_old = Bx;
Bx = Bx.*cd + Bz.*sd;
Bz = Bz.*cd - Bx_old.*sd;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%        IGRF scalar function.        %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Bx, By, Bz] = igrfs(time, latitude, longitude, altitude, coord)

% Fundamental constant.
Rearth_km = 6371.2;

%%% CHECK INPUT VALIDITY %%%
% Convert time to a datenumber if it is a string.
if ischar(time)
    time = datenum(time);
end

% Check that the input coordinates are scalars.
if ~isscalar(latitude) || ~isscalar(longitude) || ~isscalar(altitude)
    error('igrf1:inputNotScalar', ...
        'The input coordinates must be scalars.');
end

%%% SPHERICAL COORDINATE CONVERSION %%%
% Convert the latitude, longitude, and altitude coordinates input into
% spherical coordinates r (radius), theta (inclination angle from +z axis),
% and phi (azimuth angle from +x axis).
% We want cos(theta) and sin(theta) rather than theta itself.
costheta = cos((90 - latitude)*pi/180);
sintheta = sin((90 - latitude)*pi/180);

% Convert from geodetic coordinates to geocentric coordinates if necessary.
% This method was adapted from igrf11syn, which was a conversion of the
% IGRF subroutine written in FORTRAN.
if nargin < 5 || isempty(coord) || strcmpi(coord, 'geodetic') || ...
        strcmpi(coord, 'geod') || strcmpi(coord, 'gd')
    a = 6378.137; f = 1/298.257223563; b = a*(1 - f);
    rho = hypot(a*sintheta, b*costheta);
    r = sqrt( altitude.^2 + 2*altitude.*rho + ...
        (a^4*sintheta.^2 + b^4*costheta.^2) ./ rho.^2 );
    cd = (altitude + rho) ./ r;
    sd = (a^2 - b^2) ./ rho .* costheta.*sintheta./r;
    oldcos = costheta;
    costheta = costheta.*cd - sintheta.*sd;
    sintheta = sintheta.*cd + oldcos.*sd;
elseif strcmpi(coord, 'geocentric') || strcmpi(coord, 'geoc') || ...
        strcmpi(coord, 'gc')
    r = altitude;
    cd = 1;
    sd = 0;
else
    error('igrf:coordInputInvalid', ['Unrecognized command ' coord ...
        ' for COORD input.']);
end

% Convert longitude to radians.
phi = longitude*pi/180;

%%% GET PROPER IGRF COEFFICIENTS %%%
if isscalar(time)
    gh = loadigrfcoefs(time);
    nmax = sqrt(numel(gh) + 1) - 1;
% Assume a vector input means the coefficients are the input.
else
    gh = time;
    nmax = sqrt(numel(gh) + 1) - 1;
    % nmax should be an integer.
    if nmax - round(nmax) ~= 0
        error('igrf:timeInputInvalid', ['TIME input should either be ' ...
            'a single date or a valid coefficient vector.']);
    end
end

% We need cos(m*phi) and sin(m*phi) multiple times, so precalculate into a
% vector here:
cosphi = cos((1:nmax)*phi);
sinphi = sin((1:nmax)*phi);

Pmax = (nmax+1)*(nmax+2)/2;

%%% BEGIN MAGNETIC FIELD CALCULATION %%%
% Initialize variables used in for loop below.
Br = 0; Bt = 0; Bp = 0;
 P = zeros(1, Pmax);  P(1) = 1;  P(3) = sintheta;
dP = zeros(1, Pmax); dP(1) = 0; dP(3) = costheta;

% For this initial condition, the first if will result in n = 1, m = 0.
m = 1; n = 0; coefindex = 1;

a_r = (Rearth_km/r)^2;

% Increment through all the n's and m's. gh will be a vector with g
% followed by h for incrementing through n and m except when h would be
% redundant (i.e., when m = 0).
for Pindex = 2:Pmax
    
    % Increment to the next n when m becomes larger than n.
    if n < m
        m = 0;
        n = n + 1;
        a_r = a_r*(Rearth_km/r); % We need (Rearth_km./r)^(n+2)
    end
    
    % Calculate P and dP. They are given recursively according to:
    % 
    % P(0, 0) = 1, P(1, 1) = sin(theta) <- Specified above
    % P(n, n) = sqrt(1 - 1/(2n))*sin(theta)*P(n-1, n-1)
    % P(n, m) = (2n - 1)/sqrt(n^2 - m^2)*cos(theta)*P(n-1, m) -
    %     sqrt(((n-1)^2 - m^2) / (n^2 - m^2)) * P(n-2, m)
    % 
    % dP(0, 0) = 0, dP(1, 1) = cos(theta) <- Specified above
    % dP(n, n) = sqrt(1 - 1/(2n))*(sin(theta)*dP(n-1, n-1) +
    %     cos(theta)*P(n-1, n-1))
    % dP(n, m) = (2n - 1)/sqrt(n^2 - m^2)*(cos(theta)*dP(n-1, m) -
    %     sin(theta)*P(n-1, m)) - sqrt(((n-1)^2 - m^2)/(n^2 - m^2))*
    %     dP(n-2, m)
    if m < n && Pindex ~= 3 % (Pindex=3 is n=1, m=1, initial cond. above)
        last1n = Pindex - n;
        last2n = Pindex - 2*n + 1;
        P(Pindex) = (2*n - 1)/sqrt(n^2 - m^2)*costheta*P(last1n) - ...
            sqrt(((n-1)^2 - m^2) / (n^2 - m^2)) * P(last2n);
        dP(Pindex) = (2*n - 1)/sqrt(n^2 - m^2)*(costheta*dP(last1n) - ...
            sintheta*P(last1n)) - sqrt(((n-1)^2 - m^2) / (n^2 - m^2)) * ...
            dP(last2n);
    elseif Pindex ~= 3
        lastn = Pindex - n - 1;
        P(Pindex) = sqrt(1 - 1/(2*m))*sintheta*P(lastn);
        dP(Pindex) = sqrt(1 - 1/(2*m))*(sintheta*dP(lastn) + ...
            costheta*P(lastn));
    end
    
    % Calculate the magnetic field components as a running sum. Find
    % explicit expressions for these in Global Earth Physics: a Handbook of
    % Physical Constants by Thomas J. Aherns (1995), pg. 49. Link:
    % http://books.google.com/books?id=aqjU_NHyre4C&lpg=PP1&dq=Global%20
    % earth%20physics%3A%20a%20handbook%20of%20physical%20constants&pg=PA49
    % #v=onepage&q&f=false
    % (except equation 6 is missing a required 1/sin(theta) and m; correct
    % equations on page 5 (equations 3a-3c) of:
    % http://hanspeterschaub.info/Papers/UnderGradStudents/
    % MagneticField.pdf)
    if m == 0 % Implies h = 0, so only coefficient in gh is g
        coef = a_r*gh(coefindex); %*cos(0*phi) = 1
        Br = Br + (n+1)*coef*P(Pindex);
        Bt = Bt - coef*dP(Pindex);
        % Bp is 0 for m = 0.
        coefindex = coefindex + 1; % Only need to skip over g this time.
    else
        coef = a_r*(gh(coefindex)*cosphi(m) + gh(coefindex+1)*sinphi(m));
        Br = Br + (n+1)*coef*P(Pindex);
        Bt = Bt - coef*dP(Pindex);
        if sintheta == 0 % Use different formula when dividing by 0.
            Bp = Bp - costheta*a_r*(-gh(coefindex)*sinphi(m) + ...
                gh(coefindex+1)*cosphi(m))*dP(Pindex);
        else
            Bp = Bp - 1/sintheta*a_r*m*(-gh(coefindex)*sinphi(m) + ...
                gh(coefindex+1)*cosphi(m))*P(Pindex);
        end
        coefindex = coefindex + 2; % Skip over g and h this time.
    end
    
    % Increment m.
    m = m + 1;
    
end

% Convert from spherical to (x,y,z) = (North,East,Down).
Bx = -Bt;
By = Bp;
Bz = -Br;

% Convert back to geodetic coordinates if necessary.
Bx_old = Bx;
Bx = Bx.*cd + Bz.*sd;
Bz = Bz.*cd - Bx_old.*sd;