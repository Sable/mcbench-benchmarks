function G = EDFASinglePassGain_Analytical(wl,L,Pp,loss,plotFlag)
% Analytical solution to small-signal single-pass gain in rare-earth 
% doped fiber amplifier
% 
% For saturated (i.e. large-signal) gain, run numerical solution in
% EDFASinglePassGain_Numerical
% 
% Following Payne et al, "Ytterbium-Doped Silica Fiber Lasers: Versatile
%   Sources for the 1-1.2 um Region", IEEE J. S. T. in Quantum Electronics, 
%   Vol 1. No 1.  1995
% 
% Also see:
%   (for validation)
%      Barnard et al, "Rare Earth Doped Fiber Amplifiers and
%       Lasers", IEEE J. Q. Electronics 1994,vol 30, no8, pp 1817-1830
%   (for parameter calculation, Erbium spectroscopy)
%      RP-Photonics.com articles: "Saturation Power", "Doping
%       Concentration", "Erbium-Doped Gain Media"
%   (for Ytterbium spectroscopy)
%      Marciante and Zuegel, "High-gain, polarization-preserving, 
%       Yb-doped fiber amplifier for low-duty-cycle pulse amplification." 
%       Applied optics 45.26 (2006): 6798-6804.
%
% Release date 17 May 2013, Luke Rumbaugh, Clarkson University
% 
% Inputs:
%   wl -    wavelength of input signal in nm (default 1550 nm)
%           (can be single wavelength, or multiple wavelengths in vector)
%   L -     length of active fiber in m (default 5 m)
%           (can be multiple lengths in vector)
%   Pp -    power of amplifier pump in mW (default 1:1:200 mW)
%           (expected to be multiple powers in vector)
%   loss -  losses in amplifier chain in dB (default 2 dB)
%   plotFlag - "true" if plots should be generated
%           (differente plots generated for single wavelength or
%           multiple-wavelength cases)
%
% Outputs: 
%   G -     single pass gain in dB 
%           (nW x nP x nL) where nW is number of wavelengths, nP is number
%           of pump powers, and nL is number of fiber lengths to calculate

% User-adjustable parameters
wlp = 976;      % pump wavelength in nm

% Verify number of wavelengths (this affects calculation and display mode)
if nargin<1, 
    nW = 1;                 % if no input, default to single-wavelength
    re = 'e';               % default to erbium
else
    nW = length(wl);        % if user specifies multiple wavelengths, 
                            %  calculate them all (but fewer pump powers
                            %  will be used)
    if mean(wl)>1, wl = wl*1e-9; end % convert wavelengths to m from nm
    if mean(wl)>1300e-9, % infer the rare earth being used from the wavelength
        re = 'e'; % above 1300 nm must be erbium
    else
        re = 'y'; % below 1300 nm will be ytterbium
    end
end

% Resolve default inputs
if nargin<5, plotFlag = 1;  end;    % [bool]generate plots?
if nargin<4, loss = 2;      end;    % [dB]  losses in amplifier (splice, isolator, etc)
if nargin<3,
    if nW>1, % if multiple wavelengths are desired, show several discrete pump powers
        Pp = 50:50:200;    % [mW]  estimated pump power AT THE FIBER
    else % if only one wavelength of interest, show closely spaced pump powers
        Pp = 1:1:200;    % [mW]  estimated pump power AT THE FIBER
    end
end
if nargin<2, L = [0.5 1.0 2 5];         end;    % [m]   length of fiber
% if nargin<2, L = 2;         end;    % [m]   length of fiber

% Modify values for calculation
Pp = Pp * 1e-3;         % pump power: convert mW to W
wlp = wlp*1e-9;         % wavelength of pump: convert nm to m

% System parameters (user usually won't have to adjust)
d = 6e-6;               % [m] doped core diameter of active fiber
Gamma = 0.722;          % overlap factor of pump with doped core; estimating 
                        % that the core doping radius is 80% of the field radius
A = pi*((d/2)^2)/Gamma; % m^2, effective area of active fiber relative to pump
h = 6.626068e-034;      % planck's number
c = 3e8;                % speed of light in vaccuum (not modified by index 
                        % of refraction for photon frequency)
nup = c/wlp;            % Hz, frequency of pump photons
doping = 500;          % ppm (feel free to specify N directly if known -- see lines 102 or 115)
                        % this is by molecule fraction, not by weight
                        % fraction. for weight fraction, see
                        % RP-Photonics.com article on doping concentration

% Dopant-specific parameters
switch lower(re(1))
    case 'y'
        % ** if using ytterbium **
        if nargin<1, wl = 1064*1e-9;     end;    % [m]  wavelength of input signal        
        [sal,sel] = GetYbSpectrum(wl);
        [sap,sep] = GetYbSpectrum(wlp);
        NglassSiO2 = 1e6*2.648/(60*1.6726e-24); % m^-3, number of glass molecules per volume in SiO2 glass (Ytterbium Yb1200)
        N = (doping/1e6)*NglassSiO2; % m^-3, number of doped ions per volume
        %N = 97e24; % specify directly if known         
        doping = 1e6*N/NglassSiO2; % recalculate in case N was specified directly
        qe = 1; % 1, quantum efficiency of pump (1 for ytterbium, somewhat lower for erbium)
        tau = 0.77e-3; % s, spontaneous decay rate of excited ions
        fiberStr = 'Yb-Doped';
    case 'e'
        % ** if using erbium **
        if nargin<1, wl = 1550*1e-9;     end;    % [m]  wavelength of input signal      
        sap = 1.7e-25; % m^2, absorption cross section of pump (Erbium)
        sep = 0; % m^2, emission cross section of pump
        [sel,sal] = GetErSpectrum(wl);
        NglassAl2O3 = 1e6*4/(102*1.6726e-24); % m^-3, number of glass molecules per volume in SiO2 glass (Erbium HP980)
        N = (doping/1e6)*NglassAl2O3; % m^-3, number of doped ions per volume
        % N = 20e24; % specify directly if known 
        doping = 1e6*N/NglassAl2O3; % recalculate in case N was specified directly
        tau = 8e-3; % s, spontaneous decay rate of excited ions
        qe = 0.85; % 1, quantum efficiency of pump (1 for ytterbium, somewhat lower for erbium)
        fiberStr = 'Er-Doped';
end

% Compute saturation power
PpSat = (h*nup*A)/((sap+sep)*tau*qe); % saturation power for pump

% Calculate single-pass gain at each wavelength
%   For each fiber length
for ll = 1:numel(L)
    % For each pump power
    for pp = 1:numel(Pp)        
        % 1. Calculate power absorbed
        [Ppl(pp),err] = SolveForPpz(Pp(pp),PpSat,-N*sap*L(ll));
        Pa(pp) = Pp(pp)-Ppl(pp);
        % 2. Calculate gain for each wavelength (in dB)
        for ww = 1:numel(wl)
            G(ww,pp,ll) = 4.34*((qe*(sal(ww)+sel(ww))*tau*Pa(pp))./(A*h*nup) - Gamma*N*sal(ww)*L(ll)) - loss; % dB, gain at each wavelength, at each pump power
        end
        % 3. Define legend entry
        legStr{pp} = sprintf('P_p = %d mW',round(1000*Pp(pp)));
    end
end

% Generate plots
if plotFlag
    
    % Plot for a multiple-wavelength scenario
    %   Each fiber length is a different subplot
    %   Each pump power is a different trace vs wavelength on each subplot
    if length(wl)>1
        % Format figures and axes
        figure('windowstyle','docked');
        nAxX = 1+floor(length(L)/2);      % number of rows of subplots 
        nAxY = ceil(length(L)/nAxX);    % number of columns of subplots
        % Generate plots (one trace per pump power)
        for ll = 1:length(L)
            subplot(nAxX,nAxY,ll);
            plot(wl*1e9,G(:,:,ll),'linewidth',2);
            hT = title(sprintf('Active Fiber Length = %.2f m',L(ll))); set(hT,'fontsize',16);
            set(gca,'fontsize',14,'linewidth',2); grid on;
            xlabel ('Wavelength (nm)'); ylabel('Gain (dB)');
            hold on;
        end
        legend(legStr,'Location','EastOutside');
        
    % Plot for a single-wavelength scenario
    %   Generates a single plot: Each length will be a different trace vs
    %   pump power
    else
        cmap = hsv(length(L));
        figure('windowstyle','docked');
        for ll = 1:length(L);
            plot(1000*Pp,G(1,:,ll),'linewidth',2,'color',cmap(ll,:)); hold on;
            legStr{ll} = sprintf('%.2f m',L(ll));
        end
        hT = title(sprintf('Single-Pass Gain at %d nm\nUsing %s Fiber (%d ppm)',round(wl*1e9),fiberStr,10*round(doping/10))); set(hT,'fontsize',16);
        set(gca,'fontsize',14,'linewidth',2); grid on;
        xlabel(sprintf('Pump power (mW) at %d nm',round(wlp*1e9))); ylabel('Single-Pass Gain (dB)');
        legend(legStr,'Location','Best');        
    end
end

end
%%% END OF MAIN FUNCTION %%%

% GetErSpectrum
% Define erbium absorption and emission cross sections
function [emint,abint] = GetErSpectrum(wlint)
% taking the very scientific approach of visual inspection from a plot from
% RP-Photonics.com

wlint = wlint*1e9;

wl = [1460:10:1520, 1525:5:1550, 1560:10:1640];
ab = 1E-24*[0.025, 0.05, 0.15, 0.27, 0.24, 0.20, 0.21... % 1460 to 1520
    0.25, 0.4, 0.6, 0.39, 0.29, 0.24, ... % 1525 to 1550
    0.14, 0.06, 0.04, 0.03, 0.02, 0.015, 0.01, 0.002, 0.001]; % 1560 to 1640
em = 1E-24*[0.001, 0.02, 0.04, 0.1, 0.12, 0.14, 0.17... % 1460 to 1520
    0.2, 0.4, 0.6, 0.42, 0.35, 0.3, ... % 1525 to 1550
    0.24, 0.13, 0.09, 0.1, 0.09, 0.08, 0.07, 0.04, 0.02]; % 1560 to 1640
if nargin<1,
    wlint = 1460:0.5:1640; 
end
abint = interp1(wl,ab,wlint,'cubic');
emint = interp1(wl,em,wlint,'cubic');
% plot(wlint,abint,':b',wlint,emint,'-b'); grid on; legend('absorption','emission');

end

% GetYbSpectrum
% Define erbium absorption and emission cross sections
function [sigA,sigE,alpha] = GetYbSpectrum(lam)
% from Marciante & Zuengel

if nargin<1, lam = 1e-9 * (800:1200); end

lam = lam*1e9;

% Generate Gaussians describing emission / absorption cross sections
sigA = 1e-27* (180*exp(-(((lam-950)/70).^2)) + ...
                360*exp(-(((lam-895)/24).^2)) + ...
                510*exp(-(((lam-918)/22).^2)) + ...
                160*exp(-(((lam-971)/12).^2)) + ...
                2325*exp(-(((lam-975)/4).^2)));
sigE = 1e-27* (2325*exp(-(((lam-975)/4).^2)) + ...
                160*exp(-(((lam-978)/12).^2)) + ...
                340*exp(-(((lam-1025)/20).^2)) + ...
                175*exp(-(((lam-1050)/60).^2)) + ...
                150*exp(-(((lam-1030)/90).^2)));
alpha = sigA./sigE;
            
end

% SolveForPpz
% Solve for power at position L on fiber
function [solution,residual] = SolveForPpz(Pp0,Ps,k)
% based on equation: log(Pp(z) / Pp(0)) + (Pp(z) - Pp(0))/Ps = -N*sig_ap*a
% where k is the right hand side (should be negative)

if nargin<1
    Pp0 = 0.01;
    Ps = 0.002; % about right for 915 nm
    N = 1.5e25; % 550 ppm doping
    sap = 8e-25; % about right for 915 nm
    z = 1;
    k = -N*sap*z;
end

% initial guess is that between 0.01 and 0.99 of the power is absorbed
Ppz = Pp0*exp(k);
res = log(Ppz/Pp0) + (Ppz-Pp0)/Ps - k;
% solution = Ppz;
% residual = res;

% solving numerically, we can incorporate the saturation term as well
absDb = [0:0.001:30];
txLin = 10.^(-absDb./10);
Ppz = txLin*Pp0; 

% calculate residual for each Ppz guess
res = log(Ppz./Pp0) + (Ppz-Pp0)./Ps - k;

% output value with lowest residual
[minres,iimin] = min(abs(res));
solution = Ppz(iimin);
residual = minres;

% debugging
%   plot(1000*(Pp0-Ppz),res); xlabel('Power absorbed in fiber (mW)'); ylabel('Residual error in calc'); title(sprintf('Absorbed power in fiber launching %d mW pump',1000*Pp0));
%   fprintf('Pump power %f mW \t Term 1 %f \t Term 2 %f \t Term 3 %f \t Residual %f \t Pump at z %f mW \t Absorbed power %f mW\n',Pp0,log(Ppz(iimin)./Pp0),(Ppz(iimin)-Pp0)./Ps,-k,residual,solution,Pp0-solution);

end
