function [] = set_equal_ylims(fig_handle);
% Function which sets the y limits of all axes in the figure whose
% handle is 'fig_handle' to those of the axes set which has been tagged
% 'Main'.
%
% Matt Allen

Hax = findall(fig_handle,'type','axes');

% Find the set of axes Tagged 'Main'
k = 1; Main_found = 0;
while k <= length(Hax) & Main_found  < 1;
    if strcmp('main',lower(get(Hax(k),'Tag')))
        Main_found = 10;
        H_main_ax = Hax(k);
    end
    k = k+1;
end

y_lims_des = get(H_main_ax, 'YLim');

set(Hax,'Ylim',y_lims_des);
