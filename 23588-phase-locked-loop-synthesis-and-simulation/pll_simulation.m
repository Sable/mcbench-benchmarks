function [bandwidth pm] = pll_simulation(cap, res, ipump, vco_sensitivity, fout, fcomp )

% Simulates 2nd, 3rd and 4th order PLL loops for the topologies shown
% below using basic control systems theory.  This is useful for design
% verification.  
%
% Input 
%       - cap is the capacitors of the loop in Farads [C1, C2, C3, C4].  If
%           these components are not present in the loop, set their value
%           to zero.
%       - res is the resistors of the  loop in Ohms [ R2, R3, R4].  If
%           these components are not present in the loop, set their value to zero.  
%       - order of the loop, either 2,3, or 4.
%       - ipump is the charge pump current in Amperes
%       - vco_sensitivity is the VCO sensitivity in Hertz/Volt
%       - fout is the output frequency in Hertz
%       - fcomp is the comparison frequency in Hertz
%      
% Output  
%       - bandwidth is the open loop bandwidth in Hertz
%       - pm is the phase margin in degrees
%
% The methods used here are derived from those presented in Dean Banerjee's
% Book "PLL Performance, Simulation, and Design" 4th Ed available at
% National Semiconductors site www.national.com.  Most of the work is
% derived from Chapter 8 pp.43-47 and Chapter 9 pp. 48-53.
%
% 
% Loop Topologies
% 2nd Order
%        +  _____                                   ______
% fcomp -->|Phase|----------------------------------| VCO |---->fout
%          |Det. |     |      |                     |     |  |
%           -----      |      |                      -----   |
%            ^ -      C1     R2                              |
%            |         |      |                              |
%            |        GND    C2                              |
%            |                |                              |
%            |               GND         _______             |
%            ----------------------------| 1/N |--------------
%                                        -------    
%
% 3rd Order 
%        +  _____                                   ______
% fcomp -->|Phase|-----------------R3---------------| VCO |---->fout
%          |Det. |     |      |         |           |     |  |
%           -----      |      |         |            -----   |
%            ^ -      C1     R2        C3                    |
%            |         |      |         |                    |
%            |        GND    C2        GND                   |
%            |                |                              |
%            |               GND         _______             |
%            ----------------------------| 1/N |--------------
%                                        -------    
%
%
% 4th Order
%        +  _____                                   ______
% fcomp -->|Phase|-----------------R3------R4-------| VCO |---->fout
%          |Det. |     |      |         |     |     |     |  |
%           -----      |      |         |     |      -----   |
%            ^ -      C1     R2        C3     C4             |
%            |         |      |         |     |              |
%            |        GND    C2        GND   GND             |
%            |                |                              |
%            |               GND         _______             |
%            ----------------------------| 1/N |--------------
%                                        -------    
%
% 
%   Author: Ben Gilbert 
%   Homepage: http://nicta.com.au/people/gilbertb
%   Email: ben.gilbert (wibble) nicta.com.au
%   (c) 2009 by National ICT Australia (NICTA)
%   

%% Setup Parameters
C1 = cap(1);
C2 = cap(2);
C3 = cap(3);
C4 = cap(4);

R2 = res(1);
R3 = res(2);
R4 = res(3);

% Conversion of parameters to more convenient units
Kpd = ipump/2/pi; % phase detector gain
Kvco = vco_sensitivity*2*pi; % vco gain

%% Plot Setup
% Generates logarithmic spaced points for the calculations
fplotstart = 10; % Hz
fplotstop = 10E6; % Hz
plotpoints = 100;
pltfreqs = [];
for ppts=0:plotpoints
    pltfreqs = [ pltfreqs fplotstart * 10 ^ (ppts/plotpoints* log10(fplotstop/fplotstart)) ]; 
end

%% Loop Poll's Polynomial Coefficients

A0 = C1 + C2 + C3 + C4;
A1 = C2*R2*(C1+C3+C4) + R3*(C1+C2)*(C3+C4) + C4*R4*(C1+C2+C3);
A2 = C1*C2*R2*R3*(C3+C4) + C4*R4*(C2*C3*R3+C1*C3*R3+C1*C2*R2+C2*C3*R2);
A3 = C1*C2*C3*C4*R2*R3*R4;

T2 = R2*C2;

%% Filter Transfer Function
Zfilt = @(s)  (1 + s.*T2)./s./(A3.*s.^3 + A2.*s.^2 + A1.*s + A0); % filter transfer function
zfilt = @(f) Zfilt(2*pi*1i*f); % filter transfer function as a function of frequency

%% VCO Transfer Function
Gvco = @(s) Kvco./s; % vco transfer function
gvco = @(f) Gvco(2*pi*1i*f); % vco transfer function expressed as a function of frequency

%% Forward Path Transfer Function
G = @(s)  Kpd * Gvco(s) .* Zfilt(s); % forward path transfer function
%% Reverse (Feedback) Transfer Function
H = fcomp/fout; % feedback path transfer function
%% Open Loop Transfer Function
GH = @(s) G(s)*H; % open loop transfer function
gh = @(f) GH(2*pi*1i*f); % open loop transfer function expressed as a function of frequency

%% Gain Plots
% Plots of transfer function magnitudes
% figure; 
% loglog( ...
%     pltfreqs, (abs(gh(pltfreqs))), ...
%     pltfreqs, (abs(zfilt(pltfreqs))), ...
%     pltfreqs, (abs(gvco(pltfreqs))) ... 
% ); 
% grid on; title('Open Loop Gain and Contributing Factors'); 
% xlabel('Frequency [Hz]');
% legend('Open Loop Gain','Loop Filter','VCO', 'Location', 'SouthWest'); 

%% Bode Plot
figure; 
    subplot(2,1,1); 
        semilogx(pltfreqs, 20*log10(abs(gh(pltfreqs)))); 
        grid on; 
        title('Open Loop Magnitude'); 
    subplot(2,1,2); 
        semilogx(pltfreqs, angle(gh(pltfreqs)).*180/pi); 
        grid on; 
        title('Open Loop Phase'); 
        ylim([-180 180]);

%% Find open loop bandwidth and phase margin
ghdB = @(f) 20*log10(abs(gh(f)));
bandwidth = fzero(ghdB, [fplotstart fplotstop]); % find bandwidth numerically
pm = 180 + angle(gh(bandwidth)).*180/pi;

%% Closed Loop Transfer Function
Gcl = @(s) GH(s)./(1 + GH(s)); % closed loop transfer function
gcl = @(f) Gcl(2*pi*1i*f); 
%% Closed Loop Plot (Magnitude)
% figure; 
%     subplot(2,1,1); 
%         semilogx(pltfreqs, 20*log10(abs(gcl(pltfreqs)))); 
%         grid on; 
%         title('Closed Loop Magnitude'); 
%     subplot(2,1,2); 
%         semilogx(pltfreqs, angle(gcl(pltfreqs)).*180/pi); 
%         grid on; 
%         title('Closed Loop Phase'); 
%         ylim([-180 180]);

