function lim_cell = ctsqaxes(axes_han, desired_xlim, desired_ylim)
% CTSQAXES Create equal axes proportions.

% Author: Craig Borghesani <cborg@terasoft.com>
% Date: 7/29/96 9:56AM
% Revision:
% Copyright (c) 1996, V.C.T., Inc.

axes_pos = get(axes_han,'position');
fig_pos = get(get(axes_han,'parent'),'position');

axes_width = axes_pos(3);
axes_height = axes_pos(4);
fig_width = fig_pos(3);
fig_height = fig_pos(4);

if isnan(desired_xlim),
   desired_xlim = get(axes_han,'xlim');
   center_xlim = diff(desired_xlim)/2 + desired_xlim(1);
   desired_xlim = center_xlim + [-eps,eps];

else
   center_xlim = diff(desired_xlim)/2 + desired_xlim(1);

end

if isnan(desired_ylim),
   desired_ylim = get(axes_han,'ylim');
end

diff_ylim = diff(desired_ylim);
axes_ratio = axes_width/axes_height;
fig_ratio = fig_width/fig_height;
true_ratio = axes_ratio*fig_ratio;
diff_xlim = diff_ylim*(true_ratio);

new_xlim = center_xlim + [-0.5,0.5]*diff_xlim;

% recompute if new_xlim is smaller than desired_xlim
while diff(new_xlim) < diff(desired_xlim),

% increase ylim by 5%
   desired_ylim = desired_ylim + [-0.05,0.05]*diff_ylim;
   diff_ylim2 = diff(desired_ylim);
   diff_xlim = diff_ylim2*(true_ratio);

   new_xlim = center_xlim + [-0.5,0.5]*diff_xlim;

end

lim_cell = {new_xlim, desired_ylim};