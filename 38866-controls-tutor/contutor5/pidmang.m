function pidmang(pid_typ,pid_opr)
%
% Utility function: PIDMANG
%
% The purpose of this function is to be the manager of the three gains
% associated with a PID controller.

% Author: Craig Borghesani
% Date: 9/13/94
% Revised:
% Copyright (c) 1999, Prentice-Hall

% obtain handle information
f = gcf;
ui_data = get(f,'userdata');
ui_han = ui_data{1};
ui_obj = ui_data{2};
%popup = ui_han(1);
%txt_top = ui_han(2);
%txt_btm = ui_han(3);
%edt_top = ui_han(4);
%edt_btm = ui_han(5);
%sld_top = ui_han(6);
%sld_btm = ui_han(7);
%lft_btn = ui_han(8);
%rht_btn = ui_han(9);
popup = ui_obj.SysUI(5);
txt_top = ui_obj.SysUI(6);
txt_btm = ui_obj.SysUI(9);
edt_top = ui_obj.SysUI(7);
edt_btm = ui_obj.SysUI(10);
sld_top = ui_obj.SysUI(8);
sld_btm = ui_obj.SysUI(11);
lft_btn = ui_obj.SysUI(12);
rht_btn = ui_obj.SysUI(13);
for_cont = ui_han(31);

cur_sys = get(ui_han(30),'userdata');
cur_page = get(ui_han(31),'userdata');
page_setup = get(ui_han(34),'userdata');
cur_plots = page_setup(:,cur_page);
stat_bar = get(ui_han(43),'userdata');

% determine the current controller
if strcmp(get(for_cont,'checked'),'on'), % forward
 cur_cont = cur_sys;
else                                     % feedback
 cur_cont = cur_sys+3;
end

gain_mat = get(ui_han(6+cur_cont),'userdata');

set(rht_btn,'enable','off');
set(stat_bar,'string','Update Mode: Change your values; Press Update to accept');
if pid_opr == 1,
 pid_typ = get(popup,'value');
else
 set(popup,'value',pid_typ);
end

if any(pid_typ==[1,2,3]),

 cur_gain = gain_mat(pid_typ);
 if pid_typ == 1, % Proportional Gain
  gain_str = 'Kp=';
 elseif pid_typ == 2, % Integral Gain
  gain_str = 'Ki=';
 elseif pid_typ == 3, % Derivative Gain
  gain_str = 'Kd=';
 end

 set([txt_btm,edt_btm],'string','');

 set([edt_btm,sld_btm,rht_btn],'enable','off');
 set(sld_top,'enable','on');
 set(txt_top,'string',gain_str);

 set(edt_top,'string',num2str(cur_gain));
 set(sld_top,'callback',['pidimpl(',int2str(pid_typ),',2)']);
 if cur_gain > 0,
  set(sld_top,'min',10^((20*log10(cur_gain)-5)/20),...
              'max',10^((20*log10(cur_gain)+5)/20));
 elseif cur_gain < 0,
  set(sld_top,'max',sign(cur_gain)*10^((20*log10(abs(cur_gain))-5)/20),...
            'min',sign(cur_gain)*10^((20*log10(abs(cur_gain))+5)/20));
 else
  set(sld_top,'min',0,'max',10);
 end
 set(sld_top,'value',cur_gain);
 set(lft_btn,'string','Update');

 if any(pid_opr==[1,2]), % update
  set(lft_btn,'enable','on',...
    'callback',['pidimpl(',int2str(pid_typ),',1)']);
 end

elseif pid_typ==4, % design point

 if any(cur_plots==5),
  set(txt_top,'string','zeta=');
  set(txt_btm,'string','wn=');
  set([edt_top,edt_btm],'enable','on');
  data = get(ui_han(25),'userdata');

  if ~length(data),
   set([edt_top,edt_btm],'string','');
   set([sld_top,sld_btm],'enable','off');
   set(lft_btn,'string','Add','callback','designpt(0)');
  else
   set(edt_top,'string',num2str(data(1)));
   set(edt_btm,'string',num2str(data(2)));
   set(sld_top,'enable','on','callback','designpt(2)',...
               'min',-1,'max',1,'value',data(1));
   set(sld_btm,'enable','on','callback','designpt(3)',...
               'min',data(2)*0.5,'max',data(2)*1.5,'value',data(2));
   set(lft_btn,'string','Update','callback','designpt(1)');
   set(rht_btn,'enable','on','callback','designpt(4)');
  end
 else
  set(stat_bar,'string','Root Locus plot must be present to use Design Point');
  pause(2);
  pidmang(1,2);
 end
end