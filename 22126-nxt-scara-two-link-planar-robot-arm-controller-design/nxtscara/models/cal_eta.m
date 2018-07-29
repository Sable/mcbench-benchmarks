function eta = cal_eta(eta_s, eta_f, vec_max, dt, ts)
% Basic Trajectory Calculation using 5-1-5 Polynomial
%
% [Inputs]
%	eta_s   : start value
%	eta_f   : finish value
%	vec_max : velocity maximum [***/msec]
%	dt      : acceleration/deceleration time [msec]
%   ts      : sample rate [msec]
% [Outputs] 
%	eta     : basic trajectory

if eta_s == eta_f || vec_max == 0 
	eta = eta_s;
else
	dst = eta_f - eta_s;
	vec_max = abs(vec_max);
	dt2 = abs(dst) / vec_max - dt;
	
	if dt2 <= 0				% Small Motion
		vec = dst / dt;
	elseif 0 < dst          % Large Motion
		vec = vec_max;
	else
		vec = -vec_max;
	end

	% t = t0 to t1
	t0 = 0;
	t1 = dt;
	e0 = [eta_s, 0, 0];
	e1 = [eta_s + vec * dt / 2, vec, 0];
	eta1 = cal_eta_515(t0, t1, e0, e1, ts);

	if dt2 <= 0				% Small Motion
		t2 = t1;
		eta2 = eta1(end);
	else					% Large Motion
		% t = t1 to t2
		t2 = t1 + dt2;
		t = t1:ts:t2;
		eta2 = vec * (t - t1) + e1(1);
	end

	% t = t2 to t3
	t3 = t2 + dt;
	e2 = [eta2(end), vec, 0];
	e3 = [eta_f, 0, 0];
	eta3 = cal_eta_515(t2, t3, e2, e3, ts);

	eta = [eta1, eta2(2:end), eta3(2:end)];
end

function eta_515 = cal_eta_515(t0, t1, e0, e1, ts)
% 5-1-5 Polynomial Calculation

t01 = [
	t0^5,      t0^4,     t0^3,   t0^2, t0, 1
	5 * t0^4,  4 * t0^3, 3 * t0^2, 2 * t0,  1, 0
	20 * t0^3, 12 * t0^2, 6 * t0  ,      2,  0, 0
	t1^5,      t1^4,     t1^3,   t1^2, t1, 1
	5 * t1^4,  4 * t1^3, 3 * t1^2, 2 * t1,  1, 0
	20 * t1^3, 12 * t1^2, 6 * t1  ,      2,  0, 0
	];
e01 = [
	e0(1)
	e0(2)
	e0(3)
	e1(1)
	e1(2)
	e1(3)
	];

% disable warning message about singular matrix
warning('off', 'MATLAB:nearlySingularMatrix')
a = t01 \ e01;
warning('on', 'MATLAB:nearlySingularMatrix')

t = t0:ts:t1;
eta_515 = a(1) * t.^5 + a(2) * t.^4 + a(3) * t.^3 + a(4) * t.^2 + a(5) * t + a(6);
