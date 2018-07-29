function m = meltpdd(dem,T,minalt,params)
% PURPOSE: calculate melt for a DEM based on a simple temperature index model
%          using positive degree days (PDD).
% -------------------------------------------------------------------
% USAGE: m = meltpdd(dem,T,minalt,params)
% where: [dem] is the input topography grid
%        [T] is the mean annual air temperature MAAT at sealevel in degC
%        [minalt] (optional) is the minimum altitude to calculate melt for
%                 (default min(dem(:)) )
%        [params] (optional) is a vector containing the 4 parameters:
%               ddf_ice: degree day factor for ice [m/d degC]
%               lrate:   temperature lapse rate in deg/100m
%               a_seas:  annual temp fluctuation in degrees.
%               tau_a:   length of the year in days to calculate annual fluctuation
%                        for, should be 365
%        [params] default to [8.0,0.6,5.0,365];
%        Values and model taken from
%        SJ Marshall and GKC Clarke 1999: Ice sheet inception: subgrid
%        hypsometric parameterisation of mass balance in an ice sheet
%        model. Climate Dynamics 15:533-550
%
%% -------------------------------------------------------------------------
% OUTPUTS:
%        m is an array with melt values for evey grid cell in dem above
%        minalt
% -------------------------------------------------------------------
% NOTE:  Seasonal variation is calculated using cos(2*pi*d/tau_a)
%        for d 1:tau_a.
%        Melt for areas lower than [minalt] is set to 0.
%
% EXAMPLE: m=meltpdd(randn(100,100)*1000,13,500,[8.0,0.6,5.0,365])
%
%% Felix Hebeler, Geography Dept., University Zurich, Jan 2007.

if nargin < 2
    error('This function needs 2 input parameters (DEM,T)');
end

% default parameter values
ddf_ice  = 8.0; % DDF f2or ice in m/d degC
%ddf_snow = 0.003;
lrate = 0.6;  % temperatur lapse rate in deg/100m
a_seas   = 5.0;   % annual amplitude of temperature fluctuations in degrees
tau_a    = 365;   %length of the year in days used in PDD

if ~exist('minalt','var')
    minalt=min(dem(:));
end

if ~exist('params','var')
    params=[ddf_ice,lrate,a_seas,tau_a];
end
params(1)=params(1)/1000;
% initialise
T = T - (dem*params(2)/100); % adjust T to be surface temperature for the DEM
%tempm=zeros(size(dem,1),size(dem,2)); % allocate matrix to hold daily melt
m = zeros(size(dem,1),size(dem,2)); % matrix for meltsum
% calc melt
for d=1:params(4)  % seasonal variation in melt
        % tempm = (T - (a_seas * cos(2*pi*d/tau_a)))*ddf_ice;
        tempm = (T - (params(3)*cos(2*pi*d/params(4))))*params(1);
        tempm(tempm<0)=0;
        m = m + tempm;
end
clear tempm;
m(dem<minalt)=0;
clear dem;