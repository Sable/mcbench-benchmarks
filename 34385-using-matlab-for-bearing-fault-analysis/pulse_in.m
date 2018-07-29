%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function pulse_in	 									   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function generates a signal which represents a fault%
% on the inner ring of the bearing. According to  what  we %
% know, it is composed of fast pulses which occur at times %
% which are  dependant  on  the  rotation velocity of  the %
% bearing, and has a surrounding envelope structure.	   %
% It also adds noise to the signal, which  represents  the %
% measurement noise.									   %
% It gets the rotation speed (in RPM), and returns the time%
% vector - t, along with the generated signal - P.		   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [P, t] = pulse_in(N)
NOC = 15;					% Number of cycles.
T = 60/N;					% Cycle of pulse.
dt = T/100;					% Time interval.
t = 0:dt:NOC*T-dt;			% Create time vector.
noise = abs(randn(size(t)));	    % Create noise.
noise = 0.05*noise/max(noise);	% Normalize noise: 0 < noise < 0.05
P = noise;                  % Init.
sinWav = sin(1:length(t));  % Sine Envelope
[~, ind] = find(mod(t,T)==0);   % Find all the cycles.
P(ind) = abs(sinWav(ind));  % Put envelope value at every cycle.