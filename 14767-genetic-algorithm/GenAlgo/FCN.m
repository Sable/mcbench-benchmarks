function z =fcn(input)
%PEAKSFCN The PEAKS function.
%	PEAKSFCN(INPUT) returns the value of the PEAKS function at the INPUT.
%	
%	See also PEAKS.

%	Roger Jang, 12-24-94.

global OPT_METHOD	% optimization method
global PREV_PT		% previous data point, used by simplex

x = input(1); y = input(2);
% The following function should be the same as the one in PEAKS.M.
z =  exp(-(x-0.5)^2)+exp(-(y-0.7)^2)+(1/25)*exp(-(x+0.2)^2)+(1/25)*exp(-(x-0.2)^2)+(1/25)*exp(-(y+1)^2)+(1/25)*exp(-(y-1)^2);

% if matlabv==4,
% 	property='linestyle';
% elseif matlabv==5,
% 	property='marker';
% else
% 	error('Unknown MATLAB version!');
% end

	property='marker';

% Plotting ... 
if strcmp(OPT_METHOD, 'ga'), % plot each member; for GA
	line(x, y, property, 'o', 'markersize', 15, ...
		'clipping', 'off', 'erase', 'xor', 'color', 'w', ...
		'tag', 'member', 'linewidth', 2);
else	% plot input point for simplex method
	line(x, y, property, '.', 'markersize', 10, ...
		'clipping', 'off', 'erase', 'none', 'color', 'k', ...
		'tag', 'member');
	if ~isempty(PREV_PT),	% plotting traj
		line([PREV_PT(1) x], [PREV_PT(2) y], 'linewidth', 1, ...
			'clipping', 'off', 'erase', 'none', ...
			'color', 'k', 'tag', 'traj');
	else	% plotting starting point
%		line(x, y, property, 'o', 'markersize', 10, ...
%			'clipping', 'off', 'erase', 'none', ...
%			'color', 'w', 'tag', 'member', 'linewidth', 3);
	end
	PREV_PT = [x y];
end

drawnow;
