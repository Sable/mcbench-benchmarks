function pidimpl(pid_typ,pid_opr)
%
% Utility Function: PIDIMPL
%
% The purpose of this function is to implement the edit or iterate
% operations for the PID controller gains

% Author: Craig Borghesani
% Date: 9/13/94
% Revised:
% Copyright (c) 1999, Prentice-Hall

% obtain handle information
f = gcf;
ui_data = get(f,'userdata');
ui_han = ui_data{1};
ui_obj = ui_data{2};
%popup      = ui_han(1);
%txt_btm    = ui_han(3);
%edt_top    = ui_han(4);
%sld_top    = ui_han(6);
popup = ui_obj.SysUI(5);
txt_btm = ui_obj.SysUI(9);
edt_top = ui_obj.SysUI(7);
sld_top = ui_obj.SysUI(8);
num_den    = ui_han(36);
pid1       = ui_han(37);
pid2       = ui_han(38);
pid3       = ui_han(39);
type_all   = ui_han(36:39);

% file modification
set(ui_han(47),'userdata',1);

cur_sys = get(ui_han(30),'userdata');
sys_state = get(ui_han(33),'userdata');

% determine the current controller
if sys_state(2,cur_sys), % forward
 cur_cont = cur_sys;
elseif sys_state(3,cur_sys), % feedback
 cur_cont = cur_sys+3;
end

form1 = strcmp(get(pid1,'checked'),'on');
form2 = strcmp(get(pid2,'checked'),'on');

% get data from UPDATE and ITERATE uicontrols
if pid_opr == 1, % Update operation
 val1 = str2num(get(edt_top,'string'));

 if ~length(val1),
  katcherr(3,pid_typ); return;
 end

% update top and bottom sliders
 set(sld_top,'min',0.5*val1,'max',1.5*val1,'value',val1);

elseif pid_opr == 2, % Iterate operation
 val1 = get(sld_top,'value');
 set(edt_top,'string',num2str(val1));
 min1 = get(sld_top,'min'); max1 = get(sld_top,'max');
 if abs(val1) <= abs(min1) | abs(val1) >= abs(max1),
  set(sld_top,'min',0.5*val1,'max',1.5*val1,'value',val1);
 end

elseif pid_opr == 3, % switching to num-den controller

 set(type_all,'checked','off');
 set(num_den,'checked','on');
   popup_str = ['Gain|Integrator|Differentiator|Real Pole|Real Zero|',...
      'Complex Pole|Complex Zero|Lead/Lag|Num/Den|Delay Time|Design Point'];
 set(popup,'string',popup_str,'callback','termmang(0,1,1)');
 new_term = get(ui_han(18+cur_cont),'userdata');
 old_term = get(ui_han(6+cur_cont),'userdata');
 set(ui_han(18+cur_cont),'userdata',old_term);
 set(ui_han(6+cur_cont),'userdata',new_term);
 termmang(1,2,1);

 sys_state(6+((cur_cont>3)*3),cur_sys) = 1;
 sys_state([[7:8]+((cur_cont>3)*3)],cur_sys) = [0;0];

elseif pid_opr == 4, % switching to PID format #1

 set(type_all,'checked','off');
 set(pid1,'checked','on');

 if ~form2,
  popup_str = ['Proportional Gain|Integral Gain|Derivative Gain|Design Point'];
  set(popup,'string',popup_str,'callback','pidmang(0,1)');
  new_term = get(ui_han(18+cur_cont),'userdata');
  if new_term(4) == 40, new_term = pid2pid(new_term,1); end
  old_term = get(ui_han(6+cur_cont),'userdata');
  set(ui_han(18+cur_cont),'userdata',old_term);
  set(ui_han(6+cur_cont),'userdata',new_term);
 else
  pres_term = get(ui_han(6+cur_cont),'userdata');
  set(ui_han(6+cur_cont),'userdata',pid2pid(pres_term,1));
 end
 pidmang(1,2)

 sys_state(7+((cur_cont>3)*3),cur_sys) = 1;
 sys_state([[6,8]+((cur_cont>3)*3)],cur_sys) = [0;0];

elseif pid_opr == 5, % switching to PID format 2

 set(type_all,'checked','off');
 set(pid2,'checked','on');

 if ~form1,
  popup_str = ['Proportional Gain|Integral Gain|Derivative Gain|Design Point'];
  set(popup,'string',popup_str,'callback','pidmang(0,1)');
  new_term = get(ui_han(18+cur_cont),'userdata');
  if new_term(4) == 20, new_term = pid2pid(new_term,2); end
  old_term = get(ui_han(6+cur_cont),'userdata');
  set(ui_han(18+cur_cont),'userdata',old_term);
  set(ui_han(6+cur_cont),'userdata',new_term);
 else
  pres_term = get(ui_han(6+cur_cont),'userdata');
  set(ui_han(6+cur_cont),'userdata',pid2pid(pres_term,2));
 end
 pidmang(1,2)

 sys_state(8+((cur_cont>3)*3),cur_sys) = 1;
 sys_state([[6:7]+((cur_cont>3)*3)],cur_sys) = [0;0];

end

set(ui_han(33),'userdata',sys_state);

if any(pid_opr==[1,2]),

 old_term = get(ui_han(6+cur_cont),'userdata');
 new_term = old_term;
 new_term(pid_typ) = val1;
 set(ui_han(6+cur_cont),'userdata',new_term);

end

if (form2 & pid_opr == 4) | (form1 & pid_opr == 5),

 dispfrac

else

% reset root locus storage
 if (pid_typ ~= 1) | (pid_typ == 1 & sign(val1) ~= sign(old_term(1,1))),
  set(ui_han(37),'userdata',[]);
 end

 term_res = get(ui_han(cur_sys),'userdata');
 w = term_res(1,:);

 old_res = termcplx(old_term,w);
 new_res = termcplx(new_term,w);

 term_res(2,:) = term_res(2,:).*(new_res./old_res);
 set(ui_han(cur_sys),'userdata',term_res);

 pageplot(0,[]);

% display laplacian transfer function
 dispfrac
end