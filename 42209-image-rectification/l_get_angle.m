function theta = l_get_angle(l)

%% polar coordinates angle for line l

n = l_get_n(l);
theta = atan2(n(2),n(1));

% returns the smaller angle of l with x-axis
if theta<0
    theta = theta+pi;
end

if theta<pi/2
    theta = theta + pi/2;
else
    theta = theta - pi/2;
end
