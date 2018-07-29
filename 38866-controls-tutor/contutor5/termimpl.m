function termimpl(term_typ,term_opr,term_loc)
%
% Utility Function: TERMIMPL
%
% The purpose of this function is to implement the add, edit, or iterate
% operations

% Author: Craig Borghesani
% Date: 8/8/94
% Revised:
% Copyright (c) 1999, Prentice-Hall

% obtain handle information
f = gcf;
ui_data = get(f,'userdata');
ui_han = ui_data{1};
ui_obj = ui_data{2};
%popup      = ui_han(1);
%txt_top    = ui_han(2);
%txt_btm    = ui_han(3);
%edt_top    = ui_han(4);
%edt_btm    = ui_han(5);
%sld_top    = ui_han(6);
%sld_btm    = ui_han(7);
%lft_btn    = ui_han(8);
%rht_btn    = ui_han(9);
popup = ui_obj.SysUI(5);
txt_top = ui_obj.SysUI(6);
txt_btm = ui_obj.SysUI(9);
edt_top = ui_obj.SysUI(7);
edt_btm = ui_obj.SysUI(10);
sld_top = ui_obj.SysUI(8);
sld_btm = ui_obj.SysUI(11);
lft_btn = ui_obj.SysUI(12);
rht_btn = ui_obj.SysUI(13);
plant      = ui_han(30);
for_cont   = ui_han(31);
bac_cont   = ui_han(32);
set_to_one1= ui_han(33);
set_to_one2= ui_han(34);

% file modification
set(ui_han(47),'userdata',1);

cur_sys = get(ui_han(30),'userdata');
cur_page = get(ui_han(31),'userdata');
sys_state = get(ui_han(33),'userdata');
page_setup = get(ui_han(34),'userdata');

temp1_mat = [1,0,NaN,1;0,NaN,NaN,2];

% variable term_mat alternates as either the current controller matrix or
% current plant matrix
if strcmp(get(plant,'checked'),'on'),
 term_mat = get(ui_han(3+cur_sys),'userdata');
elseif strcmp(get(for_cont,'checked'),'on'),
 term_mat = get(ui_han(6+cur_sys),'userdata');
else
 term_mat = get(ui_han(9+cur_sys),'userdata');
end

% get data from ADD/UPDATE and ITERATE uicontrols
if any(term_opr == [1,2]), % Add/Update operation
 val1 = str2num(get(edt_top,'string'));
 val2 = str2num(get(edt_btm,'string'));

 if ~length(val1) & any(term_typ==[1,2,4,5,9,10]),
  katcherr(2,term_typ); return;
 elseif (~length(val1) | (~length(val2))) & any(term_typ == [6,7,8,9,11]),
  katcherr(2,term_typ); return;
 elseif any(term_typ==[1:5,11]),
  if (length(val1) & val1==0 & any(term_typ==[1:3])) | (length(val2) & val2==0 & any(term_typ==[6,7,11])),
   katcherr(4,term_typ); return;
  end
 elseif term_typ == 8,
  if abs(val1) > 88,
   katcherr(5,8); return;
  elseif val2 == 0,
   katcherr(6,8); return;
  end
 end

 if ~length(val2), val2 = NaN; end

% update top and bottom sliders
 if term_opr == 2,
  if term_typ ~= 9,
   set(sld_top,'min',0.5*val1,'max',1.5*val1,'value',val1);
   if ~isnan(val2),
    set(sld_btm,'min',0.5*val2,'max',1.5*val2,'value',val2);
   end
  end
 end

elseif term_opr == 3, % Iterate operation

 val1 = get(sld_top,'value');
 set(edt_top,'string',num2str(val1));
 min1 = get(sld_top,'min'); max1 = get(sld_top,'max');
 if abs(val1) <= abs(min1) | abs(val1) >= abs(max1),
  set(sld_top,'min',0.5*val1,'max',1.5*val1,'value',val1);
 end

 val2 = get(sld_btm,'value');
 if strcmp(get(sld_btm,'enable'),'off'),
  val2 = NaN;
 else
  set(edt_btm,'string',num2str(val2));
  min2 = get(sld_btm,'min'); max2 = get(sld_btm,'max');
  if abs(val2) <= abs(min2) | abs(val2) >= abs(max2),
   set(sld_btm,'min',0.5*val2,'max',1.5*val2,'value',val2);
  end
 end

elseif term_opr == 4, % Delete operation
 val1 = term_mat(term_loc,1);
 val2 = term_mat(term_loc,2);

end

if any(term_typ == [1,4:8]), % standard elements
 if term_typ == 1,
  new_term = [val1,term_mat(1,2),NaN,1];
 else
  if imag(val1)~=0,
   zeta = -cos(atan2(imag(-val1),real(-val1)));
   wn = abs(val1);
   term_typ = term_typ + 2;
   val1 = zeta;
   val2 = wn;
  end
  new_term = [val1,val2,NaN,term_typ];
 end

elseif any(term_typ==[2,3]), % integrators/differentiators
 new_term = [val1*((term_typ==2)-(term_typ==3)),val2,NaN,2];

elseif term_typ == 9, % num/den
 new_term = termpars(val1,val2);

elseif term_typ == 10, % delay time
 new_term = [term_mat(1,1),val1,NaN,1];

elseif term_typ == 15, % setting = 1

 set_to_one = get(f,'currentmenu');
 if set_to_one == set_to_one1,
  loc1 = cur_sys*2 - 1;
  loc2 = 4;
 else
  loc1 = cur_sys*2;
  loc2 = 5;
 end

 set_label = get(set_to_one,'label');
 if length(find(set_label=='P')), sel = 3;
 elseif length(find(set_label=='G')), sel = 6;
 else sel = 9; end

 if strcmp(get(ui_han(29+sel/3),'enable'),'off'), % retrieving
  new_term = get(ui_han(12+loc1),'userdata');
  set(ui_han(12+loc1),'userdata',temp1_mat);
  set(ui_han(sel+cur_sys),'userdata',new_term);
  set(set_to_one,'checked','off');
  term_opr = 1;
  set(ui_han(29+sel/3),'enable','on');
  sys_state(loc2,cur_sys) = 0;
 else % storing
  new_term = get(ui_han(sel+cur_sys),'userdata');
  set(ui_han(12+loc1),'userdata',new_term);
  set(ui_han(sel+cur_sys),'userdata',temp1_mat);
  set(set_to_one,'checked','on');
  term_opr = 4;
  set(ui_han(29+sel/3),'enable','off');
  sys_state(loc2,cur_sys) = 1;
 end
end
set(ui_han(33),'userdata',sys_state);

% reset root locus storage
if (term_typ ~= 1) | (term_typ == 1 & sign(val1) ~= sign(term_mat(1,1))),
 set(ui_han(37),'userdata',[]);
end

if term_opr == 1, % Add

 if any(term_typ == [1,4:8]), % standard elements
  term_mat = [term_mat;new_term];
  term_loc = length(term_mat(:,1));

 elseif any(term_typ == [2,3]), % integrator/differentiator
  term_mat(2,:) = [term_mat(2,1)+new_term(1),new_term(2:4)];
  term_loc=2;

 elseif term_typ == 9, % num/den
  term_mat(1,1) = term_mat(1,1)*new_term(1,1);
  term_mat(2,1) = term_mat(2,1)+new_term(2,1);
  term_mat = [term_mat;new_term(3:length(new_term(:,1)),:)];

 elseif term_typ == 10, % delay time
  term_mat(1,2) = new_term(1,2);

 end

elseif any(term_opr == [2,3]), % Update/Iterate

 old_term = term_mat(term_loc,:);
 term_mat(term_loc,:) = new_term;

else % Delete

 if term_typ == 2,
  term_mat(2,1)=0;
 elseif any(term_typ == [1,4:8]),
  term_mat(term_loc,:)=[];
 end

end

if strcmp(get(plant,'checked'),'on'),
 set(ui_han(3+cur_sys),'userdata',term_mat);
elseif strcmp(get(for_cont,'checked'),'on'),
 set(ui_han(6+cur_sys),'userdata',term_mat);
else
 set(ui_han(9+cur_sys),'userdata',term_mat);
end

term_res = get(ui_han(cur_sys),'userdata');
w = term_res(1,:);

new_res = termcplx(new_term,w);

if term_opr == 1, % Add
 old_res = ones(1,length(w));
% if term_typ < 9,
%  set(lft_btn,'string','Update',...
%      'callback',['termimpl(',int2str(term_typ),',2,',int2str(term_loc),')']);
% end

elseif any(term_opr == [2,3]), % Edit/Iterate
 old_res = termcplx(old_term,w);

else % delete
 old_res = new_res;
 new_res = ones(1,length(w));

end

term_res(2,:) = term_res(2,:).*(new_res./old_res);
set(ui_han(cur_sys),'userdata',term_res);

% display laplacian transfer function
if term_loc >= 0,
 dispfrac
end

pageplot(0,[]);

if term_typ < 10,
 if term_opr == 1,
%  termmang(term_typ,2,term_loc);
  set(rht_btn,'callback',['termimpl(',int2str(term_typ),',4,',int2str(term_loc),')']);
 elseif term_opr == 4,
  termmang(term_typ,1,0);
 end
end
