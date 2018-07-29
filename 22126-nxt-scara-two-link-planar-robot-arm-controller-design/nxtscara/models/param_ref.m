% Reference Parameters

% Finish Time and Pen Time Table
[time_finish, time_table_pen] = cal_time_data(cp_ptp, ts1, time_wait);
max_pen_idx = length(time_table_pen) - 1;

% Position Reference
cp_ptp = cell2mat(cp_ptp);
x_ref = cp_ptp(1, :);
y_ref = cp_ptp(2, :);

% Angle Reference
[theta1_ref, theta2_ref] = xy2theta(x_ref, y_ref, l1, l2);

% Theta and Omega Limitation Check
thetas = [theta1_ref; theta2_ref];
thetas_max = [theta1_max; theta2_max];
omega1m_max = (100 - pwm1_offset) / pwm1_gain;
omega2m_max = (100 - pwm2_offset) / pwm2_gain;
omegas_max = [omega1m_max / g1; omega2m_max / g2];
chk_limit(thetas, thetas_max, omegas_max, ts1)

clear cp_ptp
clear thetas thetas_max omegas_max omega1m_max omega2m_max
