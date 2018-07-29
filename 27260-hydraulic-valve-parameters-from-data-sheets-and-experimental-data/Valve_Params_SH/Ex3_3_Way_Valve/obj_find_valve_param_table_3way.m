function F  = obj_find_valve_param_table_3way(x,Q_r)
% Objective function to find out the required area vs. spool displacement
% relationship for 3-way valve.
% Copyright 2010 MathWorks, Inc.

% x - vector of variable parameters. It is constructed of ten area values
% a_1 ... a_max - cross-sectional area of the valve at 10 successive 
% spool position s_1 ... s_10. The positions are set by shifting the spool
% from zero to its maximum opening at constant speed.

% Q_r - required flow rate expressed in percentage with respect to its
% maximum flow and maximum displacement

% Q_max - maximum flow rate

assignin('base','a_1', x(1));
assignin('base','a_2', x(2));
assignin('base','a_3', x(3));
assignin('base','a_4', x(4));
assignin('base','a_5', x(5));
assignin('base','a_6', x(6));
assignin('base','a_7', x(7));
assignin('base','a_8', x(8));
assignin('base','a_9', x(9));
assignin('base','a_10', x(10));

model = 'valve_testrig_flow_char_3way';
load_system(model);
sim(model);

k = [1 1 1 0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2]; % Weight multipliers

% Computing objective function
F = 0;
for j = 1:11
    F = F + k(j) * (yout(j) - Q_r(j))^2;
end
end

% EOF