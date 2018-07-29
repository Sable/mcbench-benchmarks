function varargout = LD(lambda,material,model)

% LD : Drude-Lorentz model for the dielectric constant of metals and
%      Debye-Lorentz model for the dielectric constant of pure water
%***********************************************************************
% 
%   Program author:    Bora Ung
%                      Ecole Polytechnique de Montreal
%                      Dept. Engineering physics
%                      2500 Chemin de Polytechnique
%                      Montreal, Canada
%                      H3T 1J4
%                      boraung@gmail.com
%
%             Date:    January 31, 2012
%***********************************************************************
%   DESCRIPTION:
%   This function computes the complex dielectric constant (i.e. relative
%   permittivity) of various metals using either the Lorentz-Drude (LD) or
%   the Drude model (D). The LD model is the default choice since it 
%   provides a better fit with the exact values. The dielectric function of
%   pure water is calculated with a 2-pole Debye model valid for microwave 
%   frequencies and a 5-pole Lorentz model valid for higher frequencies. 
%   
%   Reference [1] should be used to cite this Matlab code. 
%
%   The Drude-Lorentz parameters for metals are taken from [2] while the 
%   Debye-Lorentz parameters for pure water are from [3].
%   
%***********************************************************************
%   
%   USAGE: epsilon = LD(lambda,material,model)
%
%      OR: [epsilon_Re epsilon_Im] = LD(lambda,material,model)
%
%      OR: [epsilon_Re epsilon_Im N] = LD(lambda,material,model)
%
%
%   WHERE: "epsilon_Re" and "epsilon_Im" are respectively the real and
%          imaginary parts of the dielectric constant "epsilon", and "N"
%          is the complex refractive index.
% 
%
%   INPUT PARAMETERS:
% 
%       lambda   ==> wavelength (meters) of light excitation on material.
%                    Accepts either vector or matrix inputs.
% 
%       material ==>    'Ag'  = silver
%                       'Al'  = aluminum
%                       'Au'  = gold
%                       'Cu'  = copper
%                       'Cr'  = chromium
%                       'Ni'  = nickel
%                       'W'   = tungsten
%                       'Ti'  = titanium
%                       'Be'  = beryllium
%                       'Pd'  = palladium
%                       'Pt'  = platinum
%                       'H2O' = pure water (triply distilled)
%
%       model    ==> Choose 'LD' or 'D' for Lorentz-Drude or Drude model. 
%   
%   REFERENCES:
%
%   [1] B. Ung and Y. Sheng, Interference of surface waves in a metallic
%       nanoslit, Optics Express (2007)
%   [2] Rakic et al., Optical properties of metallic films for vertical-
%       cavity optoelectronic devices, Applied Optics (1998)
%   [3] J. E. K. Laurens and K. E. Oughstun, Electromagnetic impulse,
%       response of triply distilled water, Ultra-Wideband /
%       Short-Pulse Electromagnetics (1999)
%
%***********************************************************************

if nargin < 3, model = 'LD'; end  % Lorentz contributions used by default
if nargin < 2, return; end

%***********************************************************************
% Physical constants
%***********************************************************************
twopic = 1.883651567308853e+09; % twopic=2*pi*c where c is speed of light
omegalight = twopic*(lambda.^(-1)); % angular frequency of light (rad/s)
invsqrt2 = 0.707106781186547;  % 1/sqrt(2)
ehbar = 1.51926751447914e+015; % e/hbar where hbar=h/(2*pi) and e=1.6e-19

%***********************************************************************
% Drude-Lorentz and Debye-Lorentz parameters for dispersive medium [2,3]
%***********************************************************************
% N.B. Gamma and omega values are in eV, while f is adimensional.

switch material
    case 'Ag'
        % Plasma frequency
        omegap = 9.01*ehbar;
        % Oscillators' strenght
        f =     [0.845 0.065 0.124 0.011 0.840 5.646];
        % Damping frequency of each oscillator
        Gamma = [0.048 3.886 0.452 0.065 0.916 2.419]*ehbar;
        % Resonant frequency of each oscillator
        omega = [0.000 0.816 4.481 8.185 9.083 20.29]*ehbar;
        % Number of resonances
        order = length(omega);

    case 'Al'
        omegap = 14.98*ehbar;
        f =     [0.523 0.227 0.050 0.166 0.030];
        Gamma = [0.047 0.333 0.312 1.351 3.382]*ehbar;
        omega = [0.000 0.162 1.544 1.808 3.473]*ehbar;
        order = length(omega);                         

    case 'Au'
        omegap = 9.03*ehbar;
        f =     [0.760 0.024 0.010 0.071 0.601 4.384];
        Gamma = [0.053 0.241 0.345 0.870 2.494 2.214]*ehbar;
        omega = [0.000 0.415 0.830 2.969 4.304 13.32]*ehbar;
        order = length(omega); 

    case 'Cu'
        omegap = 10.83*ehbar;
        f =     [0.575 0.061 0.104 0.723 0.638];
        Gamma = [0.030 0.378 1.056 3.213 4.305]*ehbar;
        omega = [0.000 0.291 2.957 5.300 11.18]*ehbar;
        order = length(omega); 

    case 'Cr'
        omegap = 10.75*ehbar; 
        f =     [0.168 0.151 0.150 1.149 0.825];
        Gamma = [0.047 3.175 1.305 2.676 1.335]*ehbar;
        omega = [0.000 0.121 0.543 1.970 8.775]*ehbar;
        order = length(omega);

    case 'Ni'
        omegap = 15.92*ehbar;
        f =     [0.096 0.100 0.135 0.106 0.729];
        Gamma = [0.048 4.511 1.334 2.178 6.292]*ehbar;
        omega = [0.000 0.174 0.582 1.597 6.089]*ehbar;
        order = length(omega);

    case 'W'
        omegap = 13.22*ehbar;
        f =     [0.206 0.054 0.166 0.706 2.590];
        Gamma = [0.064 0.530 1.281 3.332 5.836]*ehbar;
        omega = [0.000 1.004 1.917 3.580 7.498]*ehbar;
        order = length(omega);

    case 'Ti'
        omegap = 7.29*ehbar;
        f =     [0.148 0.899 0.393 0.187 0.001];
        Gamma = [0.082 2.276 2.518 1.663 1.762]*ehbar;
        omega = [0.000 0.777 1.545 2.509 1.943]*ehbar;
        order = length(omega);

    case 'Be'
        omegap = 18.51*ehbar;
        f =     [0.084 0.031 0.140 0.530 0.130];
        Gamma = [0.035 1.664 3.395 4.454 1.802]*ehbar;
        omega = [0.000 0.100 1.032 3.183 4.604]*ehbar;
        order = length(omega);

    case 'Pd'
        omegap = 9.72*ehbar;
        f =     [0.330 0.649 0.121 0.638 0.453];
        Gamma = [0.008 2.950 0.555 4.621 3.236]*ehbar;
        omega = [0.000 0.336 0.501 1.659 5.715]*ehbar;
        order = length(omega);

    case 'Pt'
        omegap = 9.59*ehbar;
        f =     [0.333 0.191 0.659 0.547 3.576];
        Gamma = [0.080 0.517 1.838 3.668 8.517]*ehbar;
        omega = [0.000 0.780 1.314 3.141 9.249]*ehbar;
        order = length(omega);
        
    case 'H2O'
        % Debye parameters (microwave frequencies)
        a = [74.65 2.988];
        tauj = [8.30e-12 5.91e-14]; % [sec]
        tauf = [1.09e-13 8.34e-15]; % [sec]
        nu = [0 -0.5];
        debye_order = length(a);
        
        % Lorentz parameters (infrared and optical frequencies)
        omegap = ehbar; % "virtual" plasma frequency
        f =     [0 1.0745e-05 3.1155e-03 1.6985e-04 1.1795e-02 1.7504e+02];
        Gamma = [0 0.0046865 0.059371 0.0040546 0.037650 7.66167]*ehbar;
        omega = [0 0.013691 0.069113 0.21523 0.40743 15.1390]*ehbar;
        order = length(omega);

    otherwise
       error('ERROR! Not a valid choice of material in input argument.')
end

%***********************************************************************
% Debye model (pure water only)
%***********************************************************************
switch material
    case 'H2O'
    epsilon_D = ones(size(lambda));

    for kk = 1:debye_order
        epsilon_D = epsilon_D + a(kk)*...
         (((ones(size(lambda)) - i*tauj(kk)*omegalight).^(1-nu(kk))) .*...
           (ones(size(lambda)) - i*tauf(kk)*omegalight) ).^(-1);
    end
    otherwise

%***********************************************************************
% Drude model (intraband effects in metals)
%***********************************************************************
    epsilon_D = ones(size(lambda)) - ((f(1)*omegap^2) *...
        (omegalight.^2 + i*Gamma(1)*omegalight).^(-1));
end

%***********************************************************************
% Lorentz model (interband effects)
%***********************************************************************

switch model
    case 'D'   % Drude model
        epsilon = epsilon_D;
    
    case 'LD'  % Lorentz-Drude model
        epsilon_L = zeros(size(lambda));
        % Lorentzian contributions
        for k = 2:order
            epsilon_L = epsilon_L + (f(k)*omegap^2)*...
                (((omega(k)^2)*ones(size(lambda)) - omegalight.^2) -...
                i*Gamma(k)*omegalight).^(-1);
        end
        
        % Drude and Lorentz contributions combined
        epsilon = epsilon_D + epsilon_L;
        
    otherwise
        error('ERROR! Invalid option. Choose ''LD'' or ''D''')
end

%***********************************************************************
% Output variables
%***********************************************************************

switch nargout
    case 1 % one output variable assigned
        varargout{1} = epsilon;
        
    case 2 % two output variables assigned
        
        % Real part of dielectric constant
        varargout{1} = real(epsilon);
        
        % Imaginary part of dielectric constant
        varargout{2} = imag(epsilon);
        
    case 3 % three output variables assigned
        
        % Real part of dielectric constant
        varargout{1} = real(epsilon);
        
        % Imaginary part of dielectric constant
        varargout{2} = imag(epsilon);
        
        % Complex refractive index [2]: N = n + i*k
        varargout{3} = invsqrt2*(sqrt(sqrt((varargout{1}).^2 +...
            (varargout{2}).^2) + varargout{1}) +...
            i*sqrt(sqrt((varargout{1}).^2 +...
            (varargout{2}).^2) - varargout{1}));
        
    otherwise
    error('Invalid number of output variables; 1,2 or 3 output variables.')
end
