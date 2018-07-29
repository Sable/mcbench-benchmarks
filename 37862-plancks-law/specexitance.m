function M = specexitance(lamda, T, varargin)
%SPECEXITANCE Calculates the spectral radiant exitance for a black body
%based on Max Planck's law (W/m^2·µm)
%     M = specexitance(LAMBDA, T) computes the spectral radiant exitance
%     based on Max Planck's law based on a given temperature (T, in Kelvin) 
%     and wavelength (lamda in micro meter [10^-6 m]) 
%  
%     M = specexitance(LAMBDA, T, n) computes the spectral radiant exitance
%     based on Max Planck's law based on a given temperature (T, in Kelvin) 
%     and wavelength (lamda in micro meter [10^-6 m]) calculated in a medium 
%     for which the refractive index is something other than 1.
%  
%     The function does not exist for lamda == 0.  
%  
%     Created by Jaap de Vries, 8/20/2012
%     jpdvrs@yahoo.com
% 
% %-----------------------------------------------------------------------%

% Speed of light in a vacuum
c0 = 2.99792458*10.^8; % (±1.2) m/s 
%
% Planck's constant
h = 6.626176*10.^-34; % (±0.000036·10^-34) W·s^2 
%
% Boltzman constant
k = 1.380662*10.^-23; % (±0.000044·10^-23) W·s/K
%
% Refravtive index of the medium.
n = 1;
%
% Defining two new constants
%
% c1 = 2·pi·h·c0^2 (first radiant constant)
c1 = 3.741832*10^-16; % (±0.000020·10^-16) W·m^2 
%
% c2 = h·c0/k (second radiant constant)
c2 = 1.438786*10^-2; % (±0.000045^-2) m·K  
%
%   References
%   [1] W. Minkina and S. Dudzik, "Infrared Thermography," John Wiley & Sons
%   2009
%
%-------------------------------------------------------------------------%

% Check the number of input arguments
narginchk(2,3)

% Convert the wavelength in micrometers (µm, 10^-6 m)
lamda = lamda * 10^-6;

if isempty(varargin) % Check if the refractive index is specified 
 n = 1; % default refractive index is 1   
elseif length(varargin) == 1
 n = varargin{1};
end

% Calculate the spectral radiant exitance in(W/m^2·µm)
M = (10^-6 .* c1) ./ ((n.^2) .* lamda.^5 .* (exp(c2./(lamda * T))-1));
