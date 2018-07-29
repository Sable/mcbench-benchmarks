function EQtime = EquationOfTime(UTCjd)
% Programmed by Darin C. Koblick (09/05/2011)

% External Function Call Sequence:
%>> EQtime = EquationOfTime('2000/01/01 00:00:00');
%>> EQtime = EquationOfTime(2451544.5);

% Input Description:                                         Format:
% UTCjd (Coordinated Universal Time YYYY/MM/DD hh:mm:ss)    [N x M]  (char)
%       or 
%       Julian Date`  (Fractional Days)                     [N x 1]  (double)

% Output Description:
% EQtime Equation of Time Solution for a specified date (minutes)[N x 1]

% Source References:
% Solar Equations Referenced Directly From SolarAzEl.m (Darin C. Koblick)
% Vallado pg.183 eq. 3-37
% Astronomical Information Sheet No. 58
% (http://astro.ukho.gov.uk/nao/services/ais58.pdf)
% Kennewell J, McDonald A. The Equation of Time, Australian Government.
% IPS Radio and Space Services.
% Algorithmic Inspiration from Mike Bevis @ Ohio State University

% Begin Code Sequence

if ~exist('UTCjd','var')
    yr = (100:100:5100)';
    numDays = 365;
    figure('color',[1 1 1]); 
    plot(1:numDays,EquationOfTimeComparisonRoutine(1:numDays),'.r'); hold on;
    for i=1:size(yr,1)
        val = datestr([repmat([sprintf('%04d',yr(i,1)),'/01/'],[numDays,1]), ...
            char(cellfun(@num2str,num2cell(1:numDays)','UniformOutput',false))], ...
            'yyyy/mm/dd HH:MM:SS');
        EQtime = EquationOfTime(val);
        plot(1:numDays,EQtime,'-k');
    end
    plot(1:numDays,EquationOfTimeComparisonRoutine(1:numDays),'.r');
    xlabel('Day of Year'); ylabel('Equation of Time (Minutes)');
    title('Equation of Time Over 50 Centuries (0100 - 5100 AD)'); grid on; 
    xlim([1,numDays]);
    legend('EoT Approximation (1900-2100 AD)','EquationOfTime.m','location','se');
else
    %compute JD if input is in the form of a string
    if ischar(UTCjd); jd = juliandate(UTCjd,'yyyy/mm/dd HH:MM:SS'); else jd = UTCjd; end
    clear UTCjd;
    d = jd-2451543.5;
    % Keplerian Elements for the Sun         (geocentric)
    w = 282.9404+4.70935e-5*d; %             (longitude of perihelion degrees)
    e = 0.016709-1.151e-9*d;%                (eccentricity)
    M = mod(356.0470+0.9856002585*d,360);%   (mean anomaly degrees)
    %auxiliary angle
    E = M+(180/pi).*e.*sin(M.*(pi/180)).*(1+e.*cos(M.*(pi/180)));
    %rectangular coordinates in the plane of the ecliptic (x axis toward
    %perhilion)
    x = cos(E.*(pi/180))-e;
    y = sin(E.*(pi/180)).*sqrt(1-e.^2);
    %find the distance and true anomaly (degrees)
    v = atan2(y,x).*(180/pi);
    %find the ecliptic longitude of the sun
    eclLon = v + w;
    %Calculate the equation of time
    EQtime = -1.91466647.*sind(M) - 0.019994643.*sind(2.*M) + ...
        2.466.*sind(2.*eclLon) - 0.0053.*sind(4.*eclLon);
    %Convert from degrees to minutes (1 deg = 4 minutes)
    EQtime = EQtime.*4;
end
end
function jd = juliandate(varargin)
% This sub function is provided in case juliandate does not come with your 
% distribution of Matlab
[year month day hour min sec] = datevec(datenum(varargin{:}));
for k = length(month):-1:1
    if ( month(k) <= 2 ) % january & february
        year(k)  = year(k) - 1.0;
        month(k) = month(k) + 12.0;
    end
end
jd = floor( 365.25*(year + 4716.0)) + floor( 30.6001*( month + 1.0)) + 2.0 - ...
    floor( year/100.0 ) + floor( floor( year/100.0 )/4.0 ) + day - 1524.5 + ...
    (hour + min/60 + sec/3600)/24;
end
function E = EquationOfTimeComparisonRoutine(DOY)
B = 360.*(DOY-81)./365;
E = 9.87.*sind(2.*B) - 7.67.*sind(B+78.7);
end