function x=eqnsol(varargin)
% EQNSOL computes the date of equinoxes and solstices for the input year.
% This is based upon the formulas given by Jean Meeus in his "Astronomical
% Algorithms". The date is computed in Julian Date. 
% This function take in JD2CAL function of "Geodetic Toolbox" by Mike
% Craymer (ID:15285) to convert Julian Date into gregorian calendar date.
%
% Syntax: 	Y=EQNSOL(YEAR,VERBOSE)
%      
%     Inputs:
%           YEAR (default=current Year). 
%           VERBOSE (default=0)
%     Outputs:
%           - Y=datenum formatted array.
%
%      Example: 
%
%      y=eqnsol(2007)
%
%      y =
% 
%      1.0e+005 *
% 
%      7.33122005889494
%      7.33214755008280
%      7.33308411171428
%      7.33398256147171
%
%      y=eqnsol(2007,1)
%
%         All dates and times are referred to GMT without DST
%         Spring Equinox    21-Mar-2007 00:08:28
%         Summer Solstice   21-Jun-2007 18:07:12
%         Autumn Equinox    23-Sep-2007 09:52:05
%         Winter Solstice   22-Dec-2007 06:08:51
%
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2007) Equinoxes and Solstices: compute the date and time of
% equinoxes and solstices. 
% http://www.mathworks.com/matlabcentral/fileexchange/17977

%Input Error handling
args=cell(varargin);
nu=numel(args);
if nu>2 
    error('stats:Eqnsol:TooMuchInputs','Max two inputs are required.');
end
default.values = {str2double(datestr(date,10)),0}; %set current year and 0 as default values for year and verbose
default.values(1:nu) = args;
[Year verbose] = deal(default.values{:});

if nu>1 %if year was an input
    if ~isscalar(Year) || ~isnumeric(Year) || ~isfinite(Year)
        error('Warning: Year value must be a numeric and finite scalar')
    end
    if ~isequal(Year,round(Year))
        error('Warning: Year values must be integer')
    end
end
if nu==2 %if verbose was an input
    if ~isscalar(verbose) || ~isnumeric(verbose) || ~isfinite(verbose) || isempty(verbose)
        error('Warning: Verbose values must be numeric and finite')
    else
        verbose=logical(verbose);
    end
end
clear args default nu

% Meeus ("Astronomical Algorithms", 1991) gives the following formulae for
% the instant of Vernal Equinox (in Dynamical time) as a function of the
% integral A.D. year-number Y (good from about 1000 to about 3000 AD)
if Year>=1000
    M=(Year-2000)/1000; %onvert AD year to millenia, from 2000 AD.
JDME=[polyval([-0.00057 -0.00411 0.05169 365242.37404 2451623.80984],M);...
    polyval([-0.0003 0.00888 0.00325 365241.62603 2451716.56767],M);...
    polyval([0.00078 0.00337 -0.11575 365242.01767 2451810.21715],M);...
    polyval([0.00032 -0.00823 -0.06223 365242.74049 2451900.05952],M)];
else
    M=Year/1000;
JDME=[polyval([- 0.00071 0.00111 0.06134 365242.13740 1721139.29189],M);...
    polyval([0.00025 0.00907 -0.05323 365241.72562 1721233.25401],M);...
    polyval([0.00074 -0.00297 -0.11677 365242.49558 1721325.70455],M);...
    polyval([-0.00006 -0.00933 -0.00769 365242.88257 1721414.39987],M)];
end

T=(JDME-2451545)./36525; %Julian centuries from 2000 (of equ/sol).

%compute perturbation
A=[485; 203; 199; 182; 156; 136; 77; 74; 70; 58; 52; 50; 45; 44; 29; 18; 17; 16; 14; 12; 12; 12; 9; 8];
B=[324.96; 337.23; 342.08; 27.85; 73.14; 171.52; 222.54; 296.72; 243.58; 119.81; 297.17; 21.02; 247.54; 325.15; 60.93; 155.12; 288.79; 198.04; 199.76; 95.39; 287.11; 320.81; 227.73; 15.45];
C=[1934.136; 32964.467; 20.186; 445267.112; 45036.886; 22518.443; 65928.934; 3034.906; 9037.513; 33718.147; 150.678; 2281.226; 29929.562; 31555.956; 4443.417; 67555.328; 4562.452; 62894.029; 31436.921; 14577.848; 31931.756; 34777.259; 1222.114; 16859.074];
S=(sum(repmat(A,1,4).*cosd(repmat(B,1,4)+kron(C,T'))))'; %perturbations

W=(35999.373.*T-2.7); %degrees

L=1+0.0334.*cosd(W)+0.00007.*cosd(2.*W); %Lambda

JD=JDME+0.00001.*(S./L); %The final result in Julian Dynamical Days.

%Convert JD in calendar (DD:MM:YYYY HH:MM:SS)
a=fix(JD+0.5);
if a<2299161
  c=a+1524;
else
  b=fix((a-1867216.25)./36524.25);
  c=a+b-fix(b./4)+1525;
end
d=fix((c-122.1)./365.25);
e=fix(365.25.*d);
f=fix((c-e)./30.6001);
days=c-e-fix(30.6001.*f)+rem((JD+0.5),a);
months=f-1-12.*fix(f./14);
x=datenum([repmat(Year,4,1) months fix(days) zeros(4,2) (days-fix(days)).*86400]);

if verbose
    event={'Spring Equinox    ';'Summer Solstice   ';'Autumn Equinox    ';'Winter Solstice   '};
    disp('All dates and times are referred to GMT without DST')
    y=cellstr(datestr(x,0));
    for I=1:4
        disp([event{I},y{I}])
    end
end