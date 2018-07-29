function pageplot(mode,option)
% PAGEPLOT Update all graphs on current page.
%          PAGEPLOT manages the updating of all the currently viewed
%          axes objects.

% Author: Craig Borghesani
% Date: 10/18/94
% Revised: 11/13/94
% Copyright (c) 1999, Prentice-Hall

% obtain handle information
f = gcf;
ui_data = get(f,'userdata');
ui_han = ui_data{1};
sys_axes = ui_han(12);
cur_sys = get(ui_han(30),'userdata');
cur_page = get(ui_han(31),'userdata');
cur_axs = get(ui_han(32),'userdata');
font_size = get(ui_han(42),'userdata');
page_setup = get(ui_han(34),'userdata');
page_layout = get(ui_han(35),'userdata');

plant_mat = get(ui_han(3+cur_sys),'userdata');
for_mat = get(ui_han(6+cur_sys),'userdata');
bac_mat = get(ui_han(9+cur_sys),'userdata');
sys_res = get(ui_han(cur_sys),'userdata');

plot_type = page_setup(:,cur_page); plot_type(find(plot_type==0)) = [];
plot_hand = page_layout(:,cur_page); plot_hand(find(plot_hand==0)) = [];

if mode == 0, % update all visible plots
 freqplot(plot_hand(find(plot_type>0 & plot_type<5)),option);
 rootplot(plot_hand(find(plot_type==5)),option);
 gainplot(plot_hand(find(plot_type>5 & plot_type<8)),option)
 timeplot(plot_hand(find(plot_type==8)),option);

elseif mode == 1, % only frequency response plots
 freqplot(plot_hand(find(plot_type>0 & plot_type<5)),option);

elseif mode == 2, % only root locus plots
 rootplot(plot_hand(find(plot_type==5)),option);
 gainplot(plot_hand(find(plot_type>5 & plot_type<8)),option)

elseif mode == 3, % only time response plots
 timeplot(plot_hand(find(plot_type==8)),option);

elseif mode == 4, % only gain plots
 gainplot(plot_hand(find(plot_type>5 & plot_type<8)),option)

end

% display system information
% option == 13 - switching systems
% option == 14 - changing pages
% option == 15 - changing page layouts
% option == [] - changing transfer function

if ~length(option) | any(option == [13:15]),

 data = get(cur_axs,'userdata');
 environ = data(1);
 if all(environ~=[5:7]),
  systemin(environ, sys_axes, font_size, sys_res, plant_mat, for_mat, bac_mat);
 end

end
