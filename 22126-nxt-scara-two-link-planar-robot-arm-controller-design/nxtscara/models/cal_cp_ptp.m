function cp_ptp = cal_cp_ptp(cp_name, ts, l1, l2)
% CP + PTP Trajectory Calculation
%
% [Inputs]
%	cp_name     : CP trajectory name ('circle', 'spiral', 'smile', 'ml_logo')
%   ts          : sample rate [msec]
%	l1          : link1 length [m]
%	l2          : link2 length [m]
% [Outputs] 
%	cp_ptp		: CP + PTP trajectory


% CP trajectory
switch cp_name
	case 'Circle'
		cp = cp_circle(ts);
	case 'Spiral'
		cp = cp_spiral(ts);
	case 'Smile Mark'
		cp = cp_smile(ts);
	case 'MATLAB Logo'
		cp = cp_ml_logo;
	otherwise
		error('Unexpected CP Trajectory Name.')
end

% start & finish position
pos_s = [l1 + l2; 0];
pos_f = pos_s;

% PTP trajectory
ptp = cal_ptp(cp, pos_s, pos_f, ts, l1, l2);

% concatenate CP and PTP trajectory
cp_ptp = cat_cp_ptp(cp, ptp);
