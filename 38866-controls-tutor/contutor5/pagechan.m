function pagechan(page_num,mode)
% PAGECHAN Change pages within environment.
%          PAGECHAN handles the transition between pages within the
%          Page Setup... environment.

% Author: Craig Borghesani
% Date: 10/16/94
% Revised:
% Copyright (c) 1999, Prentice-Hall

% obtain handle information
f2 = gcf;
f = get(f2,'userdata');
ui_data = get(f,'userdata');
ui_han = ui_data{1};
ui_han2 = get(ui_han(49),'userdata');

% variables internal to Page Setup... interface
page_setup = get(ui_han2(1),'userdata');
ptch = get(ui_han2(2),'userdata');
txt = get(ui_han2(3),'userdata');

set(txt,'string',['Page ',int2str(page_num),' Layout']);

% first, how many plots on this page
plots = page_setup(:,page_num);
plots(find(plots==0)) = [];
set(ui_han2(4),'userdata',length(plots));

color_mat = [1,0,0;0,1,0;0,0,1;1,1,0;0,1,1;0.5,0,0;0,0.5,0;0,0,0.5];
if ~mode,
 set(ui_han2(1),'value',page_num);
 set(ui_han2(2:9),'back','w','value',0);
 for k = 1:length(plots),
  set(ui_han2(plots(k)+1),'back',color_mat(plots(k),:),'value',1);
 end
end

% locations of patchs
fig_wdt = 780;
frm_wdt = 190;

%axs1_l = (frm_wdt+2+60)/fig_wdt;
axs1_l = 0.07;
axs1_b = 0.15;
%axs1_w = 0.97 - axs1_l;
axs1_w = 0.97 - (frm_wdt+2+60)/fig_wdt;
axs1_h = 0.68;

axs2_b = 0.58;
axs2_w = axs1_w/2 - 0.05;
axs2_l = axs1_l + axs2_w + 0.1;
%axs2_h = axs2_w;
axs2_h = 0.26;

%axs1_l = (frm_wdt+2+60)/fig_wdt;
%axs1_b = 0.15;
%axs1_w = 0.97 - axs1_l;
%axs1_h = 0.68;

%axs2_b = 0.58;
%axs2_w = axs1_w/2 - 0.05;
%axs2_l = axs1_l + axs2_w + 0.1;
%axs2_h = axs2_w;

set(ptch,'vis','off');
if length(plots)==1,
 xpos1 = [axs1_l, axs1_l+axs1_w, axs1_l+axs1_w, axs1_l];
 ypos1 = [axs1_b, axs1_b, axs1_b+axs1_h, axs1_b+axs1_h];
 set(ptch(1),'vis','on','facecolor',get(ui_han2(plots(1)+1),'back'),...
             'xdata',xpos1,'ydata',ypos1);

elseif length(plots)==2,
 xpos1 = [axs1_l, axs1_l+axs1_w, axs1_l+axs1_w, axs1_l];
 ypos1 = [axs2_b, axs2_b, axs2_b+axs2_h, axs2_b+axs2_h];
 ypos2 = [axs1_b, axs1_b, axs1_b+axs2_h, axs1_b+axs2_h];
 set(ptch(1),'vis','on','facecolor',get(ui_han2(plots(1)+1),'back'),...
             'xdata',xpos1,'userdata',plots(1),'ydata',ypos1);
 set(ptch(2),'vis','on','facecolor',get(ui_han2(plots(2)+1),'back'),...
             'xdata',xpos1,'userdata',plots(2),'ydata',ypos2);

elseif length(plots)==3,
 xpos1 = [axs1_l, axs1_l+axs1_w, axs1_l+axs1_w, axs1_l];
 ypos1 = [axs2_b, axs2_b, axs2_b+axs2_h, axs2_b+axs2_h];
 xpos2 = [axs1_l, axs1_l+axs2_w, axs1_l+axs2_w, axs1_l];
 ypos2 = [axs1_b, axs1_b, axs1_b+axs2_h, axs1_b+axs2_h];
 xpos3 = [axs2_l, axs2_l+axs2_w, axs2_l+axs2_w, axs2_l];
 ypos3 = [axs1_b, axs1_b, axs1_b+axs2_h, axs1_b+axs2_h];
 set(ptch(1),'vis','on','facecolor',get(ui_han2(plots(1)+1),'back'),...
             'xdata',xpos1,'userdata',plots(1),'ydata',ypos1);
 set(ptch(2),'vis','on','facecolor',get(ui_han2(plots(2)+1),'back'),...
             'xdata',xpos2,'userdata',plots(2),'ydata',ypos2);
 set(ptch(3),'vis','on','facecolor',get(ui_han2(plots(3)+1),'back'),...
             'xdata',xpos3,'userdata',plots(3),'ydata',ypos3);

elseif length(plots)==4,
 xpos1 = [axs1_l, axs1_l+axs2_w, axs1_l+axs2_w, axs1_l];
 ypos1 = [axs2_b, axs2_b, axs2_b+axs2_h, axs2_b+axs2_h];
 xpos2 = [axs2_l, axs2_l+axs2_w, axs2_l+axs2_w, axs2_l];
 ypos2 = [axs2_b, axs2_b, axs2_b+axs2_h, axs2_b+axs2_h];
 xpos3 = [axs1_l, axs1_l+axs2_w, axs1_l+axs2_w, axs1_l];
 ypos3 = [axs1_b, axs1_b, axs1_b+axs2_h, axs1_b+axs2_h];
 xpos4 = [axs2_l, axs2_l+axs2_w, axs2_l+axs2_w, axs2_l];
 ypos4 = [axs1_b, axs1_b, axs1_b+axs2_h, axs1_b+axs2_h];
 set(ptch(1),'vis','on','facecolor',get(ui_han2(plots(1)+1),'back'),...
             'xdata',xpos1,'userdata',plots(1),'ydata',ypos1);
 set(ptch(2),'vis','on','facecolor',get(ui_han2(plots(2)+1),'back'),...
             'xdata',xpos2,'userdata',plots(2),'ydata',ypos2);
 set(ptch(3),'vis','on','facecolor',get(ui_han2(plots(3)+1),'back'),...
             'xdata',xpos3,'userdata',plots(3),'ydata',ypos3);
 set(ptch(4),'vis','on','facecolor',get(ui_han2(plots(4)+1),'back'),...
             'xdata',xpos4,'userdata',plots(4),'ydata',ypos4);
end