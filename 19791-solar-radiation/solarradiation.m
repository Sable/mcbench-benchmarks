function srad = solarradiation(dem,lat,cs,r)
% PUPROSE: Calculate solar radiation for a digital elevation model (DEM)
%          over one year for clear sky conditions in W/m2
% -------------------------------------------------------------------
% USAGE: srad = solarradiation(dem,lat,cs)
% where: dem is the DEM to calculate hillshade for
%        lat is the latitude vector for the DEM - same size as size(dem,2)
%        cs is the cellsize in meters
%        r is the ground reflectance (global value or map, default is 0.2)
%
%       srad is the solar radiation in W/m2 over one year per grid cell
%
% EXAMPLE:
%       srad = solarradiation(peaks(50)*100,54.9:-0.1:50,1000,0.2);
%       - calculates the solar radiation for an example 50x50 peak surface.
%
% See also: GRADIENT, CART2POL
%
% Note: Follows the approach of Kumar et al 1997. Calculates clear sky
%       radiation corrected for the incident angle (selfshading) plus
%       diffuse and reflected radiation. Insolation is depending on time of year (and day), 
%       latitude, elevation, slope and aspect. 
%       Relief shading is not considered.
%       Script uses simple unweighed gradient of 4 nearest neighbours for slope
%       calculation.
%
% Reference: Kumar, L, Skidmore AK and Knowles E 1997: Modelling topographic variation in solar radiation in 
%            a GIS environment. Int.J.Geogr.Info.Sys. 11(5), 475-497
%
%
% Felix Hebeler, Dept. of Geography, University Zurich, May 2008.


%% parameters
%It ;               % total hours of daily sunshine (calculated inline)
%M ;                % air mass ratio parameter (calculated inline)
%r = 0.20;          % ground reflectance coefficient (more sensible to give as input)
%L=lat;             %latitude
n = 1;              % timestep of calculation over sunshine hours: 1=hourly, 0.5=30min, 2=2hours etc
tau_a    = 365;     %length of the year in days
S0 = 1367;          % solar constant W m^-2   default 1367

dr= 0.0174532925;   % degree to radians conversion factor

%%  convert factors
[slop,asp]=get_ders(dem,cs);   % calculate slope and aspect in radians using given cellsize cs
[dummy,L]=meshgrid(1:size(dem,2),lat);   % grid latitude
clear dummy;
L=L*dr;                     % convert to radians
fcirc = 360*dr; % 360 degrees in radians

%% some setup calculations
srad=0;
sinL=sin(L);
cosL=cos(L);
tanL=tan(L);
sinSlop=sin(slop);
cosSlop=cos(slop);
cosSlop2=cosSlop.*cosSlop;
sinSlop2=sinSlop.*sinSlop;
sinAsp=sin(asp);
cosAsp=cos(asp);
term1 = ( sinL.*cosSlop - cosL.*sinSlop.*cosAsp);
term2 = ( cosL.*cosSlop + sinL.*sinSlop.*cosAsp);
term3 = sinSlop.*sinAsp;
%% loop over year
for d = 1:tau_a; 
    %display(['Calculating melt for day ',num2str(d)])  
    % clear sky solar radiation
    I0 = S0 * (1 + 0.0344*cos(fcirc*d/tau_a)); % extraterr rad per day     
    % sun declination dS
    dS = 23.45 * dr* sin(fcirc * ( (284+d)/tau_a ) ); %in radians, correct/verified
    % angle at sunrise/sunset
    % t = 1:It; % sun hour    
    hsr = real(acos(-tanL*tan(dS)));  % angle at sunrise
    % this only works for latitudes up to 66.5 deg N! Workaround:
    % hsr(hsr<-1)=acos(-1);
    % hsr(hsr>1)=acos(1);
    It=round(12*(1+mean(hsr(:))/pi)-12*(1-mean(hsr(:))/pi)); % calc daylength
%%  daily loop
    I=0;
    for t=1:n:It % loop over sunshine hours
        % if accounting for shading should be included, calc hillshade here
        % hourangle of sun hs  
        hs=hsr-(pi*t/It);               % hs(t)
        %solar angle and azimuth
        %alpha = asin(sinL*sin(dS)+cosL*cos(dS)*cos(hs));% solar altitude angle
        sinAlpha = sinL.*sin(dS)+cosL.*cos(dS).*cos(hs);
        %alpha_s = asin(cos(dS)*sin(hs)/cos(alpha)); % solar azimuth angle
        % correction  using atmospheric transmissivity taub_b
        M=sqrt(1229+((614.*sinAlpha)).^2)-614.*sinAlpha; % Air mass ratio
        tau_b = 0.56 * (exp(-0.65*M) + exp(-0.095*M));
        tau_d = 0.271-0.294*tau_b; % radiation diffusion coefficient for diffuse insolation
        tau_r = 0.271+0.706*tau_b; % reflectance transmitivity
        % correct for local incident angle
        cos_i = (sin(dS).*term1) + (cos(dS).*cos(hs).*term2) + (cos(dS).*term3.*sin(hs));
        Is = I0 * tau_b; % potential incoming shortwave radiation at surface normal (equator)
        % R = potential clear sky solar radiation W m2
        R = Is .* cos_i;
        R(R<0)=0;  % kick out negative values
        Id = I0 .* tau_d .* cosSlop2./ 2.*sinAlpha; %diffuse radiation;
        Ir = I0 .* r .* tau_r .* sinSlop2./ 2.* sinAlpha; % reflectance
        R= R + Id + Ir;
        R(R<0)=0; 
        I=I+R;% solar radiation per day (sunshine hours)  
     end % end of sun hours in day loop
%%  add up radiation part melt for every day
    srad = srad + I;
end   % end of days in year loop


%%
function [grad,asp] = get_ders(dem,cs)
% calculate slope and aspect (deg) using GRADIENT function
[fx,fy] = gradient(dem,cs,cs); % uses simple, unweighted gradient of immediate neighbours
[asp,grad]=cart2pol(fy,fx); % convert to carthesian coordinates
grad=atan(grad); %steepest slope
asp=asp.*-1+pi; % convert asp 0 facing south
