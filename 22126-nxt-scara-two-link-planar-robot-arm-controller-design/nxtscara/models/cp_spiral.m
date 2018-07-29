function cp = cp_spiral(ts)
% CP Trajectory (Spiral)

% CP trajectory
radius = 0.11 / 2;
center = [0.14; 0.08];
gain = 2 * radius / (13 * pi);
omega_s = 2 * pi / (ts * 200);
omega_f = 2 * pi / (ts * 800);
phi_s = 0;
phi_f = 6 * pi;
t_f = 2 * (phi_f - phi_s) / (omega_s + omega_f);
t = 0:ts:t_f;
phi = omega_s * t + (omega_f - omega_s) * t.^2 / (2 * t_f);
sprl = repmat(center, 1, length(phi)) + [gain * phi .* cos(phi); gain * phi .* sin(phi)];
cp = {sprl};
