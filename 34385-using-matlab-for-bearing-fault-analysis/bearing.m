%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function bearing:	 									   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function  generates  the bearing response function. %
% For that, it uses the known first 3 resonance frequencies%
% 120rad/s, 500rad/s & 1500rad/s. 						   %
% It  does  so  by getting the response to each frequency, %
% using the function lsim, and then it adds up each response
% to get the overall response.							   %
% It  also  calculates the  Gain  response  of the overall %
% system, using the Bode representation.				   %
% It returns the overall response, Y, and the time vector-t,
% and  the 	Frequency 	and Gain 	vectors of  the  Bode  %
% representation. 										   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Y, t, W, M] = bearing(P, t)
W1 = 120;                       % \
W2 = 500;                       %  => The resonance frequencies of
W3 = 1500;                      % /   the bearing.

[num, den] = ord2(W1,0.05);     % Create second order system.
den = den/max(den);             % Normalize to get zero gain at w=0.
sys1 = tf(num, den);
y1 = lsim(num, den, P, t);		% Get response to current system.
y1 = y1(:);
[num, den] = ord2(W2, 0.05);	% Create second order system.
den = den/max(den);     		% Normalize to get zero gain at w=0.
sys2 = tf(num, den);
y2 = lsim(num, den, P, t);		% Get response to current system.
y2 = y2(:);
[num, den] = ord2(W3, 0.05);	% Create second order system.
den = den/max(den);         	% Normalize to get zero gain at w=0.
sys3 = tf(num, den);
y3 = lsim(num, den, P, t);		% Get response to current system.
y3 = y3(:);
Y = y1+y2+y3;					% Final response is sum of all responses.
SYS = parallel(sys1, sys2);     % Parallel combine all systems to get one
SYS = parallel(SYS, sys3);		% system, with 3 resonance frequencies.
SYS = SYS/3;					% Normalize to get gain=1 at w=0.
[M, ~, W] = bode(SYS);			% Get Bode Description of the system.
M = squeeze(M);
W = W(:);