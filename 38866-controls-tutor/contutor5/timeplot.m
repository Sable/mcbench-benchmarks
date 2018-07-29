function timeplot(axs_hand,mode)
%
% Utility Function: TIMEPLOT
%
% The purpose of this function is to handle the plotting of all the time
% response options

% Author: Craig Borghesani
% Date: 8/8/94
% Revised: 11/15/94
% Copyright (c) 1999, Prentice-Hall

% if no time response axis present, get out
if ~length(axs_hand), return; end

% obtain handle information
f = gcf;
ui_data = get(f,'userdata');
ui_han = ui_data{1};
open_loop = ui_han(78);
clos_loop = ui_han(79);
unit_imp  = ui_han(80);
unit_step = ui_han(81);
unit_ramp = ui_han(82);
rise_time = ui_han(83);
dlay_time = ui_han(84);
peak_time = ui_han(85);
over_shot = ui_han(86);
setl_2per = ui_han(87);
setl_5per = ui_han(88);
cur_sys = get(ui_han(30),'userdata');
stat_bar = get(ui_han(43),'userdata');
range1 = 78:82;
range2 = 83:88;

% distribute handles
axs_data = get(axs_hand,'userdata');

if ~length(mode) | any(mode == [13,14,15]),

% determine various states of time response environment

 if ~length(mode), mode = 0; end
 ct = 2;
 for k = range1,
  if strcmp(get(ui_han(k),'checked'),'on'),
   mode(ct) = k-(range1(1)-1);
  else
   mode(ct) = 0;
  end
  ct = ct + 1;
 end

end

if length(mode) > 1,
 set(axs_data(2:length(axs_data)),'vis','off');
end

open_imp = axs_data(2);
clos_imp = axs_data(5);
open_step = axs_data(3);
clos_step = axs_data(6);
open_ramp = axs_data(4);
clos_ramp = axs_data(7);
tim_txt = axs_data(8:length(axs_data));

plant_mat = get(ui_han(3+cur_sys),'userdata');
for_mat  = get(ui_han(6+cur_sys),'userdata');
bac_mat  = get(ui_han(9+cur_sys),'userdata');

term_mat  = termjoin(plant_mat,for_mat,bac_mat);
[num,den] = termextr(term_mat);

if length(num)==1 & length(den) == 1,
 set(stat_bar,'string','No Time Response computed');
 return;
end

ln = length(num); ld = length(den);
if ln > ld,
 set(stat_bar,'string','You have more Zeros than Poles.  Time response not plotted.');
 return
end

if polyval(den,0) ~= 0,
 final = polyval(num,0)/polyval(den,0);
else
 final = inf;
end

[nump,denp] = termextr(plant_mat);
[numg,deng] = termextr(for_mat);
[numh,denh] = termextr(bac_mat);
numt = conv(conv(nump,numg),numh);
dent = conv(conv(denp,deng),denh);
lnt = length(numt); ldt = length(dent);
numt = [zeros(1,ldt-lnt),numt];
dent = [zeros(1,lnt-ldt),dent];
numcl = conv(conv(nump,numg),denh);
dencl = dent + numt;

finalcl = polyval(numcl,0)/polyval(dencl,0);

tvec = get(ui_han(40),'userdata');
imp_input = [1/(tvec(2)-tvec(1));zeros(length(tvec)-1,1)];
stp_input = ones(length(tvec),1);
rmp_input = tvec';

if term_mat(1,2)~=0, % pure delay time
 loc_t = find(tvec <= term_mat(1,2));
 len = length(loc_t);
 if len > 1,
  imp_input = [zeros(len,1);imp_input(1:(length(imp_input)-len))];
  stp_input = [zeros(len,1);stp_input(1:(length(stp_input)-len))];
  rmp_input = [zeros(len,1);rmp_input(1:(length(rmp_input)-len))];
 end
end

if any(mode==1), % Open-Loop

 if strcmp(get(open_loop,'checked'),'off') | length(mode)>1,
  set(open_loop,'checked','on');

  if strcmp(get(unit_imp,'checked'),'on'),

   set(stat_bar,'string','Computing open-loop impulse response');
   imp_ol = lsim(num,den,imp_input,tvec);
   set(open_imp,'xdata',tvec,'ydata',imp_ol,'vis','on');
   if length(mode) > 1, mode(4) = 0; end

  end

  if strcmp(get(unit_step,'checked'),'on'),

   set(stat_bar,'string','Computing open-loop step response');
   step_ol = lsim(num,den,stp_input,tvec);
   set(open_step,'xdata',tvec,'ydata',step_ol,'vis','on');
   if length(mode) > 1, mode(5) = 0; end

  end

  if strcmp(get(unit_ramp,'checked'),'on'),

   set(stat_bar,'string','Computing open-loop ramp response');
   ramp_ol = lsim(num,den,rmp_input,tvec);
   set(open_ramp,'xdata',tvec,'ydata',ramp_ol,'vis','on');
   if length(mode) > 1, mode(6) = 0; end

  end

 else

  set(stat_bar,'string','Removing Open-Loop');
  set(open_loop,'checked','off');
  set([open_imp,open_step,open_ramp,tim_txt([1:2:9])],'vis','off');

 end

end

if any(mode==2), % Closed-Loop

 if strcmp(get(clos_loop,'checked'),'off') | length(mode)>1,
  set(clos_loop,'checked','on');

  if strcmp(get(unit_imp,'checked'),'on'),

   set(stat_bar,'string','Computing closed-loop impulse response');
   imp_cl = lsim(numcl,dencl,imp_input,tvec);
   set(clos_imp,'xdata',tvec,'ydata',imp_cl,'vis','on');
   if length(mode) > 1, mode(4) = 0; end

  end

  if strcmp(get(unit_step,'checked'),'on'),

   set(stat_bar,'string','Computing closed-loop step response');
   step_cl = lsim(numcl,dencl,stp_input,tvec);
   set(clos_step,'xdata',tvec,'ydata',step_cl,'vis','on');
   if length(mode) > 1, mode(5) = 0; end

  end

  if strcmp(get(unit_ramp,'checked'),'on'),

   set(stat_bar,'string','Computing closed-loop ramp response');
   ramp_cl = lsim(numcl,dencl,rmp_input,tvec);
   set(clos_ramp,'xdata',tvec,'ydata',ramp_cl,'vis','on');
   if length(mode) > 1, mode(6) = 0; end

  end

 else

  set(stat_bar,'string','Removing Closed-Loop');
  set(clos_loop,'checked','off');
  set([clos_imp,clos_step,clos_ramp,tim_txt([2:2:10])],'vis','off');

 end

end

if any(mode==3), % unit impulse

 if strcmp(get(unit_imp,'checked'),'off') | length(mode)>1,
  set(unit_imp,'checked','on');

  if strcmp(get(open_loop,'checked'),'on'),

   set(stat_bar,'string','Computing open-loop impulse response');
   imp_ol = lsim(num,den,imp_input,tvec);
   set(open_imp,'xdata',tvec,'ydata',imp_ol,'vis','on');

  end

  if strcmp(get(clos_loop,'checked'),'on'),

   set(stat_bar,'string','Computing closed-loop impulse response');
   imp_cl = lsim(numcl,dencl,imp_input,tvec);
   set(clos_imp,'xdata',tvec,'ydata',imp_cl,'vis','on');

  end

 else

  set(stat_bar,'string','Removing impulse response');
  set(unit_imp,'checked','off');
  set([open_imp,clos_imp],'vis','off');

 end

end

if any(mode==4), % unit step

 if strcmp(get(unit_step,'checked'),'off') | length(mode)>1,
  set(unit_step,'checked','on');

  if strcmp(get(open_loop,'checked'),'on'),

   set(stat_bar,'string','Computing open-loop step response');
   step_ol = lsim(num,den,stp_input,tvec);
   set(open_step,'xdata',tvec,'ydata',step_ol,'vis','on');

  end

  if strcmp(get(clos_loop,'checked'),'on'),

   set(stat_bar,'string','Computing closed-loop step response');
   step_cl = lsim(numcl,dencl,stp_input,tvec);
   set(clos_step,'xdata',tvec,'ydata',step_cl,'vis','on');

  end

  set(ui_han(range2),'enable','on');

 else

  set(stat_bar,'string','Removing step response');
  set(unit_step,'checked','off');
  set([open_step,clos_step,tim_txt],'vis','off');
  set(ui_han(range2),'enable','off');

 end

end

if any(mode==5), % unit ramp

 if strcmp(get(unit_ramp,'checked'),'off') | length(mode)>1,
  set(unit_ramp,'checked','on');

  if strcmp(get(open_loop,'checked'),'on'),

   set(stat_bar,'string','Computing open-loop ramp response');
   ramp_ol = lsim(num,den,rmp_input,tvec);
   set(open_ramp,'xdata',tvec,'ydata',ramp_ol,'vis','on');

  end

  if strcmp(get(clos_loop,'checked'),'on'),

   set(stat_bar,'string','Computing closed-loop ramp response');
   ramp_cl = lsim(numcl,dencl,rmp_input,tvec);
   set(clos_ramp,'xdata',tvec,'ydata',ramp_cl,'vis','on');

  end

 else

  set(stat_bar,'string','Removing ramp response');
  set(unit_ramp,'checked','off');
  set([open_ramp,clos_ramp],'vis','off');

 end

end

if any(mode < 6),

 pageview(1,axs_hand);
 ct = 1;
 mode = 0;
 for k = range2,
  if strcmp(get(ui_han(k),'checked'),'on'),
   mode(ct) = k-(range1(1)-1);
  else
   mode(ct) = 0;
  end
  ct = ct + 1;
 end

end

if any(mode==6) & strcmp(get(rise_time,'enable'),'on'), % rise time

 if strcmp(get(rise_time,'checked'),'off') | length(mode)>1,

  if strcmp(get(open_loop,'checked'),'on'),
   set(stat_bar,'string','Computing open-loop rise time');
   set(rise_time,'checked','on');
   amp = get(open_step,'ydata');
   diff_amp = diff(amp);
   loc_neg = find(diff_amp < 0);
   if ~length(loc_neg), % overdamped system
    less10 = find(amp>=0.1*final);
    less90 = find(amp>=0.9*final);
    riset = tvec(less90(1)) - tvec(less10(1));
    risea = amp(less90(1));
    set(tim_txt(1),'pos',[riset,risea,0],...
            'string',['Rise time (10-90%) = ',num2str(riset)],'vis','on');
   else  % underdamped system
    less0 = 1;
    less100 = find(amp>=final);
    riset = tvec(less100(1)) - tvec(less0);
    risea = amp(less100(1));
    set(tim_txt(1),'pos',[riset,risea,0],...
            'string',['Rise time (0-100%) = ',num2str(riset)],'vis','on');
   end
  end

  if strcmp(get(clos_loop,'checked'),'on'),
   set(stat_bar,'string','Computing closed-loop rise time');
   set(rise_time,'checked','on');
   amp = get(clos_step,'ydata');
   diff_amp = diff(amp);
   loc_neg = find(diff_amp < 0);
   if ~length(loc_neg), % overdamped system
    less10 = find(amp>=0.1*finalcl);
    less90 = find(amp>=0.9*finalcl);
    riset = tvec(less90(1)) - tvec(less10(1));
    risea = amp(less90(1));
    set(tim_txt(2),'pos',[riset,risea,0],...
          'string',['Rise time (10-90%) = ',num2str(riset)],'vis','on');
   else % underdamped system
    less0 = 1;
    less100 = find(amp>=finalcl);
    riset = tvec(less100(1)) - tvec(less0);
    risea = amp(less100(1));
    set(tim_txt(1),'pos',[riset,risea,0],...
            'string',['Rise time (0-100%) = ',num2str(riset)],'vis','on');
   end
  end

 else

  set(stat_bar,'string','Removing rise time');
  set(rise_time,'checked','off');
  set(tim_txt(1:2),'vis','off');
 end

end

if any(mode==7) & strcmp(get(dlay_time,'enable'),'on'), % delay time

 if strcmp(get(dlay_time,'checked'),'off') | length(mode)>1,

  if strcmp(get(open_loop,'checked'),'on'),
   set(stat_bar,'string','Computing open-loop delay time');
   set(dlay_time,'checked','on');
   amp = get(open_step,'ydata');
   less50 = find(amp>=0.5*final);
   dlayt = tvec(less50(1));
   dlaya = amp(less50(1));
   set(tim_txt(3),'pos',[dlayt,dlaya,0],...
         'string',['Delay time = ',num2str(dlayt)],'vis','on');
  end

  if strcmp(get(clos_loop,'checked'),'on'),
   set(stat_bar,'string','Computing closed-loop delay time');
   set(dlay_time,'checked','on');
   amp = get(clos_step,'ydata');
   less50 = find(amp>=0.5*finalcl);
   dlayt = tvec(less50(1));
   dlaya = amp(less50(1));
   set(tim_txt(4),'pos',[dlayt,dlaya,0],...
         'string',['Delay time = ',num2str(dlayt)],'vis','on');
  end

 else

  set(stat_bar,'string','Removing delay time');
  set(dlay_time,'checked','off');
  set(tim_txt(3:4),'vis','off');
 end

end

if any(mode==8) & strcmp(get(peak_time,'enable'),'on'), % peak time

 if strcmp(get(peak_time,'checked'),'off') | length(mode)>1,

  if strcmp(get(open_loop,'checked'),'on'),
   amp = get(open_step,'ydata');
   diff_amp = diff(amp);
   loc_neg = find(diff_amp < 0);
   if length(loc_neg),
    set(stat_bar,'string','Computing open-loop peak time');
    set(peak_time,'checked','on');
    peakt = tvec(loc_neg(1)-1);
    peaka = amp(loc_neg(1)-1);
    set(tim_txt(5),'pos',[peakt,peaka,0],...
         'string',['Peak time = ',num2str(peakt)],'vis','on');
   else
    set(stat_bar,'string','Unable to determine open-loop peak time');
   end
  end

  if strcmp(get(clos_loop,'checked'),'on'),
   amp = get(clos_step,'ydata');
   diff_amp = diff(amp);
   loc_neg = find(diff_amp < 0);
   if length(loc_neg),
    set(stat_bar,'string','Computing closed-loop peak time');
    set(peak_time,'checked','on');
    peakt = tvec(loc_neg(1)-1);
    peaka = amp(loc_neg(1)-1);
    set(tim_txt(6),'pos',[peakt,peaka,0],...
         'string',['Peak time = ',num2str(peakt)],'vis','on');
   else
    set(stat_bar,'string','Unable to determine closed-loop peak time');
   end
  end

 else

  set(stat_bar,'string','Removing peak time');
  set(peak_time,'checked','off');
  set(tim_txt(5:6),'vis','off');
 end

end

if any(mode==9) & strcmp(get(over_shot,'enable'),'on'), % percent overshoot

 if strcmp(get(over_shot,'checked'),'off') | length(mode)>1,

  if strcmp(get(open_loop,'checked'),'on'),
   set(stat_bar,'string','Computing open-loop % overshoot');
   set(over_shot,'checked','on');
   amp = get(open_step,'ydata');
   [max_amp,k] = max(amp);
   perover = 100*(max_amp-final)/final;
   set(tim_txt(7),'pos',[tvec(k),max_amp,0],...
       'string',[sprintf('%0.2f',perover),'% overshoot'],'vis','on');
  end

  if strcmp(get(clos_loop,'checked'),'on'),
   set(stat_bar,'string','Computing closed-loop % Overshoot');
   set(over_shot,'checked','on');
   amp = get(clos_step,'ydata');
   [max_amp,k] = max(amp);
   perover = 100*(max_amp-finalcl)/finalcl;
   set(tim_txt(8),'pos',[tvec(k),max_amp,0],...
       'string',[sprintf('%0.2f',perover),'% overshoot'],'vis','on');
  end

 else

  set(stat_bar,'string','Removing % overshoot');
  set(over_shot,'checked','off');
  set(tim_txt(7:8),'vis','off');
 end

end

if any(mode==10) & strcmp(get(setl_2per,'enable'),'on'), % 2% settling time

 if strcmp(get(setl_2per,'checked'),'off') | length(mode)>1,

  if strcmp(get(open_loop,'checked'),'on'),
   set(stat_bar,'string','Computing open-loop 2% settling time');
   set(setl_2per,'checked','on');
   amp = get(open_step,'ydata');
   per2 = length(amp);
   while (amp(per2)>0.98*final & amp(per2)<1.02*final), per2=per2-1; end
   per2t = tvec(per2);
   per2a = amp(per2);
   set(tim_txt(9),'pos',[per2t,per2a,0],...
         'string',['2%=',sprintf('%0.2f',per2t)],'vis','on');
  end

  if strcmp(get(clos_loop,'checked'),'on'),
   set(stat_bar,'string','Computing closed-loop 2% settling time');
   set(setl_2per,'checked','on');
   amp = get(clos_step,'ydata');
   per2 = length(amp);
   while (amp(per2)>0.98*finalcl & amp(per2)<1.02*finalcl), per2=per2-1; end
   per2t = tvec(per2);
   per2a = amp(per2);
   set(tim_txt(10),'pos',[per2t,per2a,0],...
         'string',['2%=',sprintf('%0.2f',per2t)],'vis','on');
  end

 else

  set(stat_bar,'string','Removing 2% settling time');
  set(setl_2per,'checked','off');
  set(tim_txt(9:10),'vis','off');
 end

end

if any(mode==11) & strcmp(get(setl_5per,'enable'),'on'), % 5% settling time

 if strcmp(get(setl_5per,'checked'),'off') | length(mode)>1,

  if strcmp(get(open_loop,'checked'),'on'),
   set(stat_bar,'string','Computing open-loop 5% settling time');
   set(setl_5per,'checked','on');
   amp = get(open_step,'ydata');
   per5 = length(amp);
   while (amp(per5)>0.95*final & amp(per5)<1.05*final), per5=per5-1; end
   per5t = tvec(per5);
   per5a = amp(per5);
   set(tim_txt(11),'pos',[per5t,per5a,0],...
         'string',['5%=',sprintf('%0.2f',per5t)],'vis','on');
  end

  if strcmp(get(clos_loop,'checked'),'on'),
   set(stat_bar,'string','Computing closed-loop 5% settling time');
   set(setl_5per,'checked','on');
   amp = get(clos_step,'ydata');
   per5 = length(amp);
   while (amp(per5)>0.95*finalcl & amp(per5)<1.05*finalcl), per5=per5-1; end
   per5t = tvec(per5);
   per5a = amp(per5);
   set(tim_txt(12),'pos',[per5t,per5a,0],...
         'string',['5%=',sprintf('%0.2f',per5t)],'vis','on');
  end

 else

  set(stat_bar,'string','Removing 5% settling time');
  set(setl_5per,'checked','off');
  set(tim_txt(11:12),'vis','off');
 end

end

