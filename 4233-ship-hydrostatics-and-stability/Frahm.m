%FRAHM Model of a Frahm vibration absorber. It implements the model
%   described in  Example 12.2. The theory is developed in Section 12.6 of
%   the book. This function file is called by Call_Frahm.
%   Companion file to Biran, A. {2003}, Ship Hydrostatics and Stability,
%   Oxford: Butterworth-Heinemann.
%   Syntax: Frahm(t, y, rm)
%   Input arguments:
%	    t	time
%	    y	variable
%	    rm	m2-to-m1 ratio


	function	yd = Frahm(t, y, rm)
	

% meaning of derivatives
%	yd(1)	speed of main mass m1
%	yd(2)	displacement of main mass m1
%	yd(3)	displacement of absorbing mass m2
% 	yd(4) 	displacement of absorbing mass m2

w0   = 2*pi/14.43;					% ship natural frequency, rad/s
w    = 2*pi/7;						% wave frequency, rad/s
c_m  = 0.1;							% damping coefficient, c-to-m1 ratio
F_m  = 1;							% exciting amplitude, F-to-m1 ratio

yd = zeros(size(y));

% derivatives
yd(1) = -c_m*y(1)- w0^2*y(2) - w^2*rm*(y(2) - y(4)) - F_m*sin(w*t);	
yd(2) = y(1);														
yd(3) = -w^2*(y(4) - y(2))	;										
yd(4) = y(3);														