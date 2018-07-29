function ptp = cal_ptp(cp, pos_s, pos_f, ts, l1, l2)
% PTP Trajectory Calculation
%
% [Inputs]
%	cp          : CP trajectory
%	pos_s       : start position [m]
%	pos_f       : finish position [m]
%   ts          : sample rate [msec]
%	l1          : link1 length [m]
%	l2          : link2 length [m]
% [Outputs] 
%	ptp         : PTP trajectory

% acceleration/deceleration time
dt = ts * 20;

% PTP start & finish position
num_cp = length(cp);
ptp_s = cell(1, num_cp + 1);
ptp_f = cell(1, num_cp + 1);
ptp_s{1} = pos_s;
for n = 1:num_cp
	ptp_s{n + 1} = cp{n}(:, end);
	ptp_f{n} = cp{n}(:, 1);
end
ptp_f{end} = pos_f;

% PTP trajectory
num_ptp = length(ptp_s);
ptp = cell(1, num_ptp);
for n = 1:num_ptp
	ptp{n} = cal_each_ptp(ptp_s{n}, ptp_f{n}, dt, ts, l1, l2);	
end


function ptp = cal_each_ptp(ptp_s, ptp_f, dt, ts, l1, l2)
% Each PTP trajectory Calculation

% angular velocity limitation
omega1_max = 6e-3;
omega2_max = 6e-3;
omega1_min = 6e-4;
omega2_min = 6e-4;

% angle variation
[theta1_s, theta2_s] = xy2theta(ptp_s(1), ptp_s(2), l1, l2);
[theta1_f, theta2_f] = xy2theta(ptp_f(1), ptp_f(2), l1, l2);
theta1_diff = abs(theta1_f - theta1_s);
theta2_diff = abs(theta2_f - theta2_s);

if theta1_diff < 1e-5 && theta2_diff < 1e-5
	ptp = [];
else
	% PTP time
	ptp_time = max(ceil(theta1_diff / omega1_max), ...
	ceil(theta2_diff / omega2_max));

	% angular velocity
	omega1 = theta1_diff / ptp_time;
	omega2 = theta2_diff / ptp_time;
	if 0 < omega1 && omega1 < omega1_min
		omega1 = omega1_min;
	end
	if 0 < omega2 && omega2 < omega2_min
		omega2 = omega2_min;
	end
	
	% PTP calculation of theta1 and theta2
	ptp_th1 = cal_eta(theta1_s, theta1_f, omega1, dt, ts);
	ptp_th2 = cal_eta(theta2_s, theta2_f, omega2, dt, ts);
	ptp_th1_len = length(ptp_th1);
	ptp_th2_len = length(ptp_th2);
	
	% adjustment of number of elements
	if ptp_th2_len > ptp_th1_len
		ptp_th1 = [ptp_th1, repmat(ptp_th1(end), 1, ptp_th2_len - ptp_th1_len)];
	elseif ptp_th1_len > ptp_th2_len
		ptp_th2 = [ptp_th2, repmat(ptp_th2(end), 1, ptp_th1_len - ptp_th2_len)];
	end
	
	% angle to position conversion
	[ptp_x, ptp_y] = theta2xy(ptp_th1, ptp_th2, l1, l2);
	ptp = [ptp_x; ptp_y];
end
