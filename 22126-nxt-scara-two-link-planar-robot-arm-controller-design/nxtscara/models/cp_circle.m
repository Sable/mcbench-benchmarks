function cp = cp_circle(ts)
% CP Trajectory (Circle)

% acceleration/deceleration time
dt = ts * 4;

% CP trajectory
radius = 0.11 / 2;
center = [0.254 - radius; 0];
omega = 2 * pi / (ts * 800);
phi = cal_eta(0, 2 * pi, omega, dt, ts);
crcl = repmat(center, 1, length(phi)) + radius * [cos(phi); sin(phi)];
cp = {crcl};
