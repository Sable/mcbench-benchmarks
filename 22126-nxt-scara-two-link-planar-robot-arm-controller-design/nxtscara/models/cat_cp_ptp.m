function cp_ptp = cat_cp_ptp(cp, ptp)
% Concatenate CP and PTP trajectory
%
% [Inputs]
%	cp			: CP trajectory
%	ptp			: PTP trajectory
% [Outputs] 
%	cp_ptp		: CP + PTP trajectory


num_cp = length(cp);
num_ptp = length(ptp);
cp_ptp = cell(1, num_cp + num_ptp);
for n = 1:num_cp
	cp_ptp{2 * n} = cp{n};
	cp_ptp{2 * n - 1} = ptp{n};	
end
cp_ptp{end} = ptp{end};
