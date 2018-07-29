%CALL_FRAHM	Calls ODE23 with the  derivatives file Frahm. Integrates the model of the
%   Frahm damper described in  Example 12.2. The theory is developed in Section 12.6 
%   of the book. 
%   Companion file to Biran, A. {2003}, Ship Hydrostatics and Stability,
%   Oxford: Butterworth-Heinemann.

t0 = 0.0;							% initial time, s
tf = 100;							% final integration time
y0 = [ 0; 0; 0; 0 ];				% initial conditions

% call integration function for system without absorber
[ t, y ] = ode23(@Frahm, [ t0, tf ], y0, [], 0);

subplot(3, 1, 1)
	plot(t, y(:, 2))
	axis([ 0 100 -5 5 ])
	Ht = text(80, 3.5, 'r_m = 0');
	set(Ht, 'FontSize', 12)
	Ht = title('Displacement of main mass');
	set(Ht, 'FontSize', 14)

% call integration function with mass ratio 1/10
[ t, y ] = ode23(@Frahm, [ t0, tf ], y0, [], 1/10);
subplot(3, 1, 2)
	plot(t, y(:, 2))
	axis([ 0 100 -5 5 ])
	Ht = text(80, 3.5, 'r_m = 1/10');
	set(Ht, 'FontSize', 12)
	
% call integration function with mass ratio 1/5
[ t, y ] = ode23(@Frahm, [ t0, tf ], y0, [], 1/5);
subplot(3, 1, 3)
	plot(t, y(:, 2))	
	axis([ 0 100 -5 5 ])
	Ht = text(80, 3.5, 'r_m = 1/5');
	set(Ht, 'FontSize', 12)
	Ht = xlabel('Time scale, s');
	set(Ht, 'FontSize', 12)

