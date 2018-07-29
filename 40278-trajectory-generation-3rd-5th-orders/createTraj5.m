function [a5,a4,a3,a2,a1,a0] = createTraj5(theta0,thetaf,thetad0,thetadf,thetadd0,thetaddf,tstart,tfinal)
	% inputs : initial position, velocity, and acceleration + final position, velocity, and acceleration, + initial and final times
	% output : a vector specifying the polynomial and can be used with poly functions such as : polyder, polyval, etc.
	% create a 5th order trajectory
	% example:
	% createTraj5(10,30,0,0,0,0,0,1)
	%
	%
	% By: Reza Ahmadzadeh - Matlab/Octave - 2013
	T = tfinal - tstart;
	a0 = theta0;
	a1 = thetad0;
	a2 = 0.5 * thetadd0;
	a3 =(1/(2*T^3)) * (20 * (thetaf - theta0) - (8 * thetadf+ 12*thetad0 )*T - (3 * thetaddf - thetadd0 )*T^2 );
	a4 =(1/(2*T^4)) * (30 * (theta0 - thetaf) + (14 * thetadf+ 16*thetad0 )*T + (3 * thetaddf - 2*thetadd0 )*T^2 );
	a5 =(1/(2*T^5)) * (12 * (thetaf - theta0) - 6*(thetadf+ thetad0 )*T - (thetaddf - thetadd0 )*T^2 );		

end	




