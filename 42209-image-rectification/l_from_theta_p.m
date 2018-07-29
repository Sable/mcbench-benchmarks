function l = l_from_theta_p(theta,p)

%% l is a line s.t. its angle with positive x-axis is theta and l'p=0
%
n = [-sin(theta);cos(theta)];
l = [n(1);n(2);-(p(1)*n(1)+p(2)*n(2))];