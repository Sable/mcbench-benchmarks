clear all
close all
 
% this file contains several examples of using the mie scattering scripts
% in this archive

nTheta = 721;
theta = linspace(0, pi, nTheta); % bistatic scattering angles
nMax = 40; % maximum mode number

% Example 1: Bistatic scattering of a 1 meter PEC sphere at 1 GHz.

frequency = 1e9;
radius = 1.0;

for k = 1:nTheta
    [eTheta(k,:) a] = mie(radius, frequency, theta(k), 0.0, nMax);
    [a ePhi(k,:)] = mie(radius, frequency, theta(k), pi/2, nMax);
end


figure(1)
 
plot(theta*180/pi, 20.0*log10(abs(eTheta)), 'r', theta*180/pi, 20.0*log10(abs(ePhi)), 'b');
 
axis([0 180 -20 40]);
set(gca, 'fontsize', 14);
set(gca, 'xtick', linspace(0,180,7));
set(gca, 'ytick', linspace(-20,40,7));
xlabel('Bistatic Angle (degrees)')
ylabel('RCS (dBSm)')
grid on
legend('VV', 'HH');

 
% Example 2: Bistatic scattering of a 1 meter lossless dielectric sphere
% (epsilon = 2.56) at 300 MHz.

frequency = 300e6;

radius = [1.0];
mu = [1.0 1.0]; % free space is the first entry
epsilon = [1.0 (2.56)]; % free space is the first entry
isPEC = 0; % core is not conducting
 
[An Bn] = mieLayeredTerms(mu, epsilon, radius, isPEC, frequency, nMax);
clear etheta_mie
clear ephi_mie
for k = 1:nTheta
    [eTheta(k,:) a] = mieScatteredField(An, Bn, theta(k), 0.0, frequency);
    [a ePhi(k,:)] = mieScatteredField(An, Bn, theta(k), pi/2, frequency);
end
 
 
figure(2)
 
plot(theta*180/pi, 20.0*log10(abs(eTheta)), 'r', theta*180/pi, 20.0*log10(abs(ePhi)), 'b');
 
axis([0 180 -30 40]);
set(gca, 'fontsize', 14);
set(gca, 'xtick', linspace(0,180,7));
set(gca, 'ytick', linspace(-30,40,8));
xlabel('Bistatic Angle (degrees)')
ylabel('RCS (dBSm)')
grid on
legend('VV', 'HH');


% Example 3: Bistatic scattering of a 1 meter lossy dielectric sphere
% (epsilon = 2.56 - j0.5) at 300 MHz.

frequency = 300e6;

radius = [1.0];
mu = [1.0 1.0]; % free space is the first entry
epsilon = [1.0 (2.56 - j*0.5)]; % free space is the first entry
isPEC = 0; % core is not conducting
 
[An Bn] = mieLayeredTerms(mu, epsilon, radius, isPEC, frequency, nMax);
clear etheta_mie
clear ephi_mie
for k = 1:nTheta
    [eTheta(k,:) a] = mieScatteredField(An, Bn, theta(k), 0.0, frequency);
    [a ePhi(k,:)] = mieScatteredField(An, Bn, theta(k), pi/2, frequency);
end
 
 
figure(3)
 
plot(theta*180/pi, 20.0*log10(abs(eTheta)), 'r', theta*180/pi, 20.0*log10(abs(ePhi)), 'b');
 
axis([0 180 -30 40]);
set(gca, 'fontsize', 14);
set(gca, 'xtick', linspace(0,180,7));
set(gca, 'ytick', linspace(-30,40,8));
xlabel('Bistatic Angle (degrees)')
ylabel('RCS (dBSm)')
grid on
legend('VV', 'HH');

 
 
% Example 4: Bistatic scattering of a PEC sphere with a lossless dielectric
% coating (epsilon = 4.0) at 47.7 MHz.

frequency = 4.7713e+07;
radius = [3.0 0.75]; % radius of each interface, outermost first
mu = [1.0 1.0 1.0]; % 3rd entry is a dummy value for the PEC region
epsilon = [1.0 4.0 1.0]; % 3rd entry is a dummy value for the PEC region
isPEC = 1; % innermost region is conducting
 
[An Bn] = mieLayeredTerms(mu, epsilon, radius, isPEC, frequency, nMax);

for k = 1:nTheta
    [eTheta(k,:) a] = mieScatteredField(An, Bn, theta(k), 0.0, frequency);
    [a ePhi(k,:)] = mieScatteredField(An, Bn, theta(k), pi/2, frequency);
end


figure(4)
 
plot(theta*180/pi, 20.0*log10(abs(eTheta)), 'r', theta*180/pi, 20.0*log10(abs(ePhi)), 'b');
 
axis([0 180 -10 40]);
set(gca, 'fontsize', 14);
set(gca, 'xtick', linspace(0,180,7));
set(gca, 'ytick', linspace(-10,40,6));
xlabel('Bistatic Angle (degrees)')
ylabel('RCS (dBSm)')
grid on
legend('VV', 'HH');



% Example 5: Bistatic scattering of a PEC sphere with a lossy dielectric
% coating (epsilon = 4.0 - j1.5) at 47.7 MHz.

frequency = 4.7713e+07;
radius = [3.0 0.75]; % radius of each interface, outermost first
mu = [1.0 1.0 1.0]; % 3rd entry is a dummy value for the PEC region
epsilon = [1.0 (4.0- j*1.5) 1.0]; % 3rd entry is a dummy value for the PEC region
isPEC = 1; % innermost region is conducting
 
[An Bn] = mieLayeredTerms(mu, epsilon, radius, isPEC, frequency, nMax);

for k = 1:nTheta
    [eTheta(k,:) a] = mieScatteredField(An, Bn, theta(k), 0.0, frequency);
    [a ePhi(k,:)] = mieScatteredField(An, Bn, theta(k), pi/2, frequency);
end


figure(5)
 
plot(theta*180/pi, 20.0*log10(abs(eTheta)), 'r', theta*180/pi, 20.0*log10(abs(ePhi)), 'b');
 
axis([0 180 -10 40]);
set(gca, 'fontsize', 14);
set(gca, 'xtick', linspace(0,180,7));
set(gca, 'ytick', linspace(-10,40,6));
xlabel('Bistatic Angle (degrees)')
ylabel('RCS (dBSm)')
grid on
legend('VV', 'HH');
 