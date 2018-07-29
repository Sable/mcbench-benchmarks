function termmang(term_typ,term_opr,term_loc)
%
% Utility function: TERMMANG
%
% The purpose of this function is to be the manager of all possible terms
% that can be added, edited, and iterated.

% Author: Craig Borghesani
% Date: 8/7/94
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
plant   = ui_han(30);
for_cont= ui_han(31);
bac_cont= ui_han(32);
cur_sys = get(ui_han(30),'userdata');
cur_page = get(ui_han(31),'userdata');
page_setup = get(ui_han(34),'userdata');
cur_plots = page_setup(:,cur_page);
stat_bar = get(ui_han(43),'userdata');

% if plant checked, get the plant matrix; otherwise, get the controller
if strcmp(get(plant,'checked'),'on'),
 term_mat = get(ui_han(3+cur_sys),'userdata');
elseif strcmp(get(for_cont,'checked'),'on'),
 term_mat = get(ui_han(6+cur_sys),'userdata');
else
 term_mat = get(ui_han(9+cur_sys),'userdata');
end

if term_opr == 1,
 term_typ = get(popup,'value');
 if any(term_typ == [1,10,11]),
  term_opr = 2;
  term_loc = 1;
  set(stat_bar,'string','Update Mode: use Update button and sliders to change your values');
 elseif any(term_typ == [2:8,11]),
  set(rht_btn,'enable','off');
  set(stat_bar,'string','Add Mode: Enter values into edit boxes; Press Add to accept');
 end
else
 if term_typ == 2 & term_mat(2,1)<0, term_typ = 3; end
 set(popup,'value',term_typ);
 if term_typ == 1,
  set(rht_btn,'enable','off');
 else
  set(rht_btn,'enable','on');
 end
 set(stat_bar,'string','Update Mode: Change your values; Press Update to accept');
end

if term_typ==1, % Gain
 set(txt_top,'string','gain=');
 set([txt_btm,edt_btm],'string','');

 set([edt_btm,sld_btm,rht_btn],'enable','off');
 set(sld_top,'enable','on');

 set(edt_top,'string',num2str(term_mat(1,1)));
 set(sld_top,'callback',['termimpl(1,3,',int2str(term_loc),')']);
 if term_mat(1,1)>0,
  set(sld_top,'min',10^((20*log10(term_mat(1,1))-5)/20),...
                'max',10^((20*log10(term_mat(1,1))+5)/20));
 else
  set(sld_top,'max',sign(term_mat(1,1))*10^((20*log10(abs(term_mat(1,1)))-5)/20),...
           'min',sign(term_mat(1,1))*10^((20*log10(abs(term_mat(1,1)))+5)/20));
 end
 set(sld_top,'value',term_mat(1,1));
 set(lft_btn,'string','Update');

elseif term_typ==2, % Integrator
 set(txt_top,'string','n=');
 set([txt_btm,edt_btm],'string','');
 set([edt_btm,sld_top,sld_btm],'enable','off','string','');

 if term_opr == 1,
  if term_loc,
   set(edt_top,'string','');
  end
  set(lft_btn,'string','Add');
 elseif term_opr == 2,
  set(edt_top,'string',num2str(term_mat(term_loc,1)));
  set(lft_btn,'string','Update');
 end

elseif term_typ==3, % Differentiator
 set(txt_top,'string','n=');
 set([txt_btm,edt_btm],'string','');
 set([edt_btm,sld_top,sld_btm],'enable','off','string','');

 if term_opr == 1,
  if term_loc,
   set(edt_top,'string','');
  end
  set(lft_btn,'string','Add');
 elseif term_opr == 2,
  set(edt_top,'string',num2str(abs(term_mat(term_loc,1))));
  set(lft_btn,'string','Update');
 end

elseif any(term_typ==[4,5]), % First Order Pole/Zero

 if term_typ==4,
  set(txt_top,'string','pole=');
 else
  set(txt_top,'string','zero=');
 end

 set([txt_btm,edt_btm],'string','');

 if term_opr == 1,
  if term_loc,
   set(edt_top,'string','');
  end
  set([edt_btm,sld_top,sld_btm],'enable','off');
  set(lft_btn,'string','Add');
 elseif term_opr == 2,
  set(edt_top,'string',num2str(term_mat(term_loc,1)));
  set(sld_top,'enable','on',....
      'callback',['termimpl(',int2str(term_typ),',3,',int2str(term_loc),')']);
  set(sld_top,'min',term_mat(term_loc,1)*0.5,...
                'max',term_mat(term_loc,1)*1.5,...
                'value',term_mat(term_loc,1));
  set([edt_btm,sld_btm],'enable','off');
  set(lft_btn,'string','Update');
 end

elseif any(term_typ==[6,7]), % Second Order Pole/Zero
 set(txt_top,'string','zeta=');
 set(txt_btm,'string','wn=');
 set([edt_top,edt_btm],'enable','on');

 if term_opr == 1,
  if term_loc,
   set([edt_top,edt_btm],'string','');
  end
  set([sld_top,sld_btm],'enable','off');
  set(lft_btn,'string','Add');
 elseif term_opr == 2,
  set(edt_top,'string',num2str(term_mat(term_loc,1)));
  set(edt_btm,'string',num2str(term_mat(term_loc,2)));
  set(sld_top,'enable','on',...
    'callback',['termimpl(',int2str(term_typ),',3,',int2str(term_loc),')']);
  set(sld_top,'min',term_mat(term_loc,1)*0.5,...
                'max',term_mat(term_loc,1)*1.5,...
                'value',term_mat(term_loc,1));
  set(sld_btm,'enable','on',...
    'callback',['termimpl(',int2str(term_typ),',3,',int2str(term_loc),')']);
  set(sld_btm,'min',term_mat(term_loc,2)*0.5,...
                'max',term_mat(term_loc,2)*1.5,...
                'value',term_mat(term_loc,2));
  set(lft_btn,'string','Update');
 end

elseif term_typ==8, % Lead/Lag
 set(txt_top,'string','phase=');
 set(txt_btm,'string','w=');
 set([edt_top,edt_btm],'enable','on');

 if term_opr == 1,
  if term_loc,
   set([edt_top,edt_btm],'string','');
  end
  set([sld_top,sld_btm],'enable','off');
  set(lft_btn,'string','Add');
 elseif term_opr == 2,
  set(edt_top,'string',num2str(term_mat(term_loc,1)));
  set(edt_btm,'string',num2str(term_mat(term_loc,2)));
  set(sld_top,'enable','on',...
    'callback',['termimpl(',int2str(term_typ),',3,',int2str(term_loc),')']);
  set(sld_top,'min',-87,...
                'max',87,...
                'value',term_mat(term_loc,1));
  set(sld_btm,'enable','on',...
    'callback',['termimpl(',int2str(term_typ),',3,',int2str(term_loc),')']);
  set(sld_btm,'min',term_mat(term_loc,2)*0.5,...
                 'max',term_mat(term_loc,2)*1.5,...
                 'value',term_mat(term_loc,2));
  set(lft_btn,'string','Update');
 end

elseif term_typ==9, % numerator/denominator
 set(txt_top,'string','num=');
 set(txt_btm,'string','den=');
 set([edt_top,edt_btm],'enable','on','string','');
 set([sld_top,sld_btm,rht_btn],'enable','off');
 set(lft_btn,'string','Add');

elseif term_typ == 10, % Time delay

 if strcmp(get(plant,'checked'),'on'),

  set(txt_top,'string','delay=');
  set([txt_btm,edt_btm],'string','');

  set([edt_btm,sld_btm,rht_btn],'enable','off');
  set(sld_top,'enable','on');

  set(edt_top,'string',num2str(term_mat(1,2)));
  set(sld_top,'callback','termimpl(10,3,1)');
  if term_mat(1,2)==0,
   set(sld_top,'min',term_mat(1,2)*0.5,'max',0.01);
  else
   set(sld_top,'min',term_mat(1,2)*0.5,'max',term_mat(1,2)*1.5);
  end
  set(sld_top,'value',term_mat(1,2));
  set(lft_btn,'string','Update');

 else
  set(stat_bar,'string','Delay Time only allowed for Plant');
  pause(2);
  termmang(1,2,1);
 end

elseif term_typ==11, % design point

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
  termmang(1,2,1);
 end
end

if term_typ < 11,
 if any(term_opr==[1,2]), % add/update
  t_typ = int2str(term_typ);
  t_opr = int2str(term_opr);
  t_loc = int2str(term_loc);
  set(lft_btn,'enable','on',...
   'callback',['eval(''termimpl(',t_typ,',',t_opr,',',t_loc,')'',''katcherr(1)'')']);
%   'callback',['termimpl(',t_typ,',',t_opr,',',t_loc,')']);
 end
end
