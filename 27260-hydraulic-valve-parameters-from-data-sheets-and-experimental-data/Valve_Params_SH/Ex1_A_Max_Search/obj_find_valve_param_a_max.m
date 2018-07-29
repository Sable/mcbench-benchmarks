function F  = obj_find_valve_param_a_max(x,Q_r)
% Objective function to find the maximum valve area parameter value
% Copyright 2010 MathWorks, Inc.

assignin('base','a_max', x);

% If necessary, reset parameterizaton to second option (table)
model = 'valve_testrig_flow_char_4way';
load_system(model);
blkpth = find_system(bdroot,'ClassName','valve_dir_4_way');
set_param(char(blkpth),'mdl_type','1');
sim(model);

k = [1 1 1 0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2];    % Weight multipliers
% Computing objective function
F = 0;
for j = 1:11
    F = F + k(j) * (yout(j) - Q_r(j))^2;
end
end

% EOF