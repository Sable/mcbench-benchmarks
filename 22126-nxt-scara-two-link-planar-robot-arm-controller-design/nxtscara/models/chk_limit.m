function chk_limit(thetas, thetas_max, omegas_max, ts)
% Theta and Omega Limitation Check
%
% [Inputs]
%	thetas      : theta vector [deg]          ([theta1; theta2])
%   thetas_max  : max theta vector [deg]      ([theta1_max; theta2_max])
%	omegas_max  : max omega vector [deg/msec] ([omega1_max; omega2_max])
%   ts          : sample rate [msec]

theta1 = thetas(1, :);
theta2 = thetas(2, :);
omega1 = diff(theta1) / ts;
omega2 = diff(theta2) / ts;

theta1_max = thetas_max(1);
theta2_max = thetas_max(2);
omega1_max = omegas_max(1);
omega2_max = omegas_max(2);

if abs(theta1) > theta1_max
	error('Theta1 does not satisfy the angle limitaion.')
elseif abs(theta2) > theta2_max
	error('Theta2 does not satisfy the angle limitaion.')
elseif abs(omega1) > omega1_max
	error('Omega1 does not satisfy the angular velocity limitaion.')
elseif abs(omega2) > omega2_max
	error('Omega2 does not satisfy the angular velocity limitaion.')
end
