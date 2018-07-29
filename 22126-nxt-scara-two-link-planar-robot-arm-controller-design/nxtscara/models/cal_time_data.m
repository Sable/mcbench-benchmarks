function [time_finish, time_table_pen] = cal_time_data(cp_ptp, ts, time_wait)
% Finish Time and Pen Time Table Calculation
%
% [Inputs]
%	cp_ptp			 : CP + PTP trajectory
%   ts				 : sample rate [msec]
%	time_wait		 : time to wait [msec]
% [Outputs] 
%	time_finish		 : time to finish tracking trajectory [msec]
%	time_table_pen	 : time table to manipulate pen [msec]

% time_table_pen
num_pen = length(cp_ptp) - 1;
time_table_pen = zeros(1, num_pen);
noe = 0;
for n = 1:num_pen
	noe = noe + max(size(cp_ptp{n}));
	time_table_pen(n) = noe * ts;
end

% time_finish
noe = noe + max(size(cp_ptp{end}));
time_finish = noe * ts + time_wait;
