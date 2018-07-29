function cp = cp_smile(ts)
% CP Trajectory (Smile Mark)

% acceleration/deceleration time
dt = ts * 4;

% CP trajectory
radius_face = 0.11 / 2;
radius_eye = radius_face * 0.15;
radius_mouth = radius_face * 0.67;
center_face = [0.254 - radius_face; 0];
center_eye1 = center_face + radius_face * [0.35; 0.35];
center_eye2 = center_face + radius_face * [0.35; -0.35];
center_mouth = center_face;

omega_face = 2 * pi / (ts * 600);
omega_eye = 2 * pi / (ts * 150);
omega_mouth = 2 * pi / (ts * 600);
phi_face = cal_eta(0, 2 * pi, omega_face, dt, ts);
phi_eye = cal_eta(0, 2 * pi, omega_eye, dt, ts);
phi_mouth = cal_eta(2 / 3 * pi, 4 / 3 * pi, omega_mouth, dt, ts);

face = repmat(center_face, 1, length(phi_face)) ...
	+ radius_face * [cos(phi_face); sin(phi_face)];
eye1 = repmat(center_eye1, 1, length(phi_eye)) ...
	+ radius_eye * [cos(phi_eye); sin(phi_eye)];
eye2 = repmat(center_eye2, 1, length(phi_eye)) ...
	+ radius_eye * [cos(phi_eye); sin(phi_eye)];
mouth = repmat(center_mouth, 1, length(phi_mouth)) ...
	+ radius_mouth * [cos(phi_mouth); sin(phi_mouth)];

cp = {face, eye1, eye2, mouth};
