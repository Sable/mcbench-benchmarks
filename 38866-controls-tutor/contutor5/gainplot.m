function gainplot(axs_hand,mode)
% GAINPLOT Plot Gain (phase) and Gain (magnitude) curves
%
%          GAINPLOT handles plotting the Gain plots.

% Author: Craig Borghesani
% Date: 10/25/94
% Revised:
% Copyright (c) 1999, Prentice-Hall

if ~length(axs_hand), return; end  % No axis, get out

% obtain handle information
f = gcf;
ui_data = get(f,'userdata');
ui_han = ui_data{1};
plant = ui_han(30);
for_cont = ui_han(31);
bac_cont = ui_han(32);
pos_loc = ui_han(67);
neg_loc = ui_han(68);
rt_locus = get(ui_han(37),'userdata');
stat_bar = get(ui_han(43),'userdata');

if length(mode) & any(mode==1), % positive root locus
 set(stat_bar,'string','Positive Root Locus settings');
 set(pos_loc,'checked','on');
 set(neg_loc,'checked','off');
 rt_locus = [];
 dispfrac
end

if length(mode) & any(mode==2), % negative root locus
 set(stat_bar,'string','Negative Root Locus settings');
 set(pos_loc,'checked','off');
 set(neg_loc,'checked','on');
 rt_locus = [];
 dispfrac
end

cur_sys = get(ui_han(30),'userdata');
plant_mat = get(ui_han(3+cur_sys),'userdata');
for_mat = get(ui_han(6+cur_sys),'userdata');
bac_mat = get(ui_han(9+cur_sys),'userdata');
kvec = get(ui_han(38),'userdata');
kvec2 = get(ui_han(39),'userdata');

[term_mat,for_mat,bac_mat] = termjoin(plant_mat,for_mat,bac_mat);
[num,den] = termextr(term_mat);

% determine whether it is a positive or negative root locus
neg_locus = strcmp(get(neg_loc,'checked'),'on');

if ~length(rt_locus),
 if length(kvec2),
  if length(num) > 1 | length(den) > 1,
   rt_locus = rlocus((~neg_locus - neg_locus)*num,den,kvec2);
  else
   rt_locus = [];
  end
 else
  if length(num) > 1 | length(den) > 1,
   [rt_locus,kvec] = rlocus((~neg_locus - neg_locus)*num,den);
  else
   rt_locus = []; kvec = [];
  end
  set(ui_han(38),'userdata',kvec);
 end
 set(ui_han(37),'userdata',rt_locus);
end

if length(kvec2), kvec = kvec2; end

if strcmp(get(plant,'checked'),'on'),
 kvec = kvec/abs(for_mat(1,1)*bac_mat(1,1));
 xlab_str = 'Plant Gain (K)';
elseif strcmp(get(for_cont,'checked'),'on'),
 kvec = kvec/abs(plant_mat(1,1)*bac_mat(1,1));
 xlab_str = 'Forward Controller Gain (K)';
elseif strcmp(get(bac_cont,'checked'),'on'),
 kvec = kvec/abs(plant_mat(1,1)*bac_mat(1,1));
 xlab_str = 'Feedback Controller Gain (K)';
end

% extract data stored in axis handles
axs_data = [];
for k = 1:length(axs_hand),
 axs_data = [axs_data;get(axs_hand(k),'userdata')];
end
gainm = find(axs_data(:,1)==6);
gainp = find(axs_data(:,1)==7);

if length(gainm),

 axes(axs_hand(gainm));
 cla;
 mag_rts = abs(rt_locus);
 plot(kvec,mag_rts,'tag','1620)','erase','xor');
 xlabel(xlab_str);

 pageview(1,axs_hand(gainm));

end

if length(gainp),

 axes(axs_hand(gainp));
 cla;
 phs_rts = phase4(rt_locus,1)*180/pi;
 plot(kvec,phs_rts,'tag','1720)','erase','xor');
 xlabel(xlab_str);

 pageview(1,axs_hand(gainp));

end

dispfrac