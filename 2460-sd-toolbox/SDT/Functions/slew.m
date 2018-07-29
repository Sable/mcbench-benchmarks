function out = slew(in,alfa,sr,GBW,Ts)
% 
% Models the op-amp slew rate for a discrete time integrator
%
% in:   input signal amplitude
% alfa: effect of finite gain (ideal op-amp alfa=1)
% sr:   slew rate in V/s
% GBW:  gain-bandwidth product of the integrator in Hz
% Ts:   sample time
%
% out:  output signal amplitude

tau=1/(2*pi*GBW);  % Time constant of the integrator
Tmax = Ts/2;

slope=alfa*abs(in)/tau;

if slope > sr			% Op-amp in slewing
	
	tsl = abs(in)*alfa/sr - tau;  % Slewing time
	
	if tsl >= Tmax
		error = abs(in) - sr*Tmax;
	else
		texp = Tmax - tsl;
		error = abs(in)*(1-alfa) + (alfa*abs(in) - sr*tsl) * exp(-texp/tau);
	end
	
else					% Op-amp in linear region
	texp = Tmax;
	error = abs(in)*(1-alfa) + alfa*abs(in) * exp(-texp/tau);
end

out = in - sign(in)*error;
