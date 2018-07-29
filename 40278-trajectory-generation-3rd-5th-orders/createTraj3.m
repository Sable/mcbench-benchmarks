function [a3,a2,a1,a0] = createTraj3(theta0,thetaf,thetad0,thetadf,tstart,tfinal)
	% inputs : initial position, velocity + final position, velocity + initial and final times
	% output : a vector specifying the polynomial and can be used with poly functions such as : polyder, polyval, etc.
	% create a 3rd order trajectory
	% example:
	% createTraj3(10,30,0,0,0,1)
	%
	%
	% By: Reza Ahmadzadeh - Matlab/Octave - 2013
	T = tfinal - tstart;
	a0 = theta0;
	a1 = thetad0;
	a2 = (-3 * (theta0 - thetaf) - (2 * thetad0+thetadf )*T)/ T ^ 2;
	a3 = (2 * (theta0 - thetaf) + (thetad0+thetadf )*T)/ T ^ 3;
	
end	




