function dispfrac(mode)
% DISPFRAC Display terms in laplacian format.
%          DISPFRAC displays the current terms in fraction format.

% Author: Craig Borghesani
% Date: 8/23/94
% Revised: 10/18/94
% Copyright (c) 1999, Prentice-Hall

% obtain handle information
f=gcf;
ui_data     = get(f,'userdata');
ui_han      = ui_data{1};
ui_obj      = ui_data{2};
%popup       = ui_han(1);
popup       = ui_obj.SysUI(5);
term_axis   = ui_han(10);
plant       = ui_han(30);
for_cont    = ui_han(31);
bac_cont    = ui_han(32);
set_to_one1 = ui_han(33);
set_to_one2 = ui_han(34);
cont_type   = ui_han(35);
num_den     = ui_han(36);
pid_1       = ui_han(37);
pid_2       = ui_han(38);
component   = ui_han(44);
open_loop   = ui_han(45);
closed_loop = ui_han(46);
factored    = ui_han(47);
coefficient = ui_han(48);
inverse     = ui_han(49);
neg_loc     = ui_han(68);
cur_sys     = get(ui_han(30),'userdata');
cur_page    = get(ui_han(31),'userdata');
sys_state   = get(ui_han(33),'userdata');
page_setup  = get(ui_han(34),'userdata');
stat_bar    = get(ui_han(43),'userdata');
lab_txt     = get(ui_han(44),'userdata');
ers = 'norm';
fontname = 'times';

% define various shades of grey
grey = get(0,'defaultuicontrolbackground');
ltgrey = [0.5,0.5,0.5]*1.5;
dkgrey = [0.5,0.5,0.5]*0.5;

if nargin == 0, mode = 0; end

% update checked properties of menu items
if mode,
 if any(abs(mode) == [1,2,3]), % switching systems

  if cur_sys == mode, return; end

  eraser1 = ui_obj.eraser1;
  tab_uis = ui_obj.SysTabs;

   %sel_dims = [-3,0,+6,+2];
   %unsel_dims = [3,0,-6,-2];

  sel_dims = [0,0,0,+2];
  unsel_dims = [0,0,0,-2];

  sel_tab = findobj(f,'tag','selected_tab1');
  cur_obj = tab_uis(abs(mode));
  if mode > 0 & sel_tab == cur_obj, return; end

  if length(sel_tab),
     tab_pos = get(sel_tab,'pos');
     set(sel_tab,'pos',tab_pos+unsel_dims,'tag','',...
                 'back',ltgrey);
  end

  cur_pos = get(cur_obj,'pos');
  set(cur_obj,'pos',cur_pos+sel_dims,'tag','selected_tab1',...
              'back',grey);
  eraser_pos = cur_pos+sel_dims;
  set(eraser1,'pos',[eraser_pos(1:3)+[2,0,-4],2]);

  set(ui_han(25+cur_sys),'checked','off');
  set(ui_han(25+abs(mode)),'checked','on');
  cur_sys = abs(mode);
  set(ui_han(30),'userdata',cur_sys);
  set(lab_txt(3),'callback',['dispfrac(',int2str(rem(cur_sys,3)+1),')'],...
                 'string',['System ',int2str(cur_sys),' Info']);

% restore settings for system
% Plant option
  if sys_state(1,cur_sys),
   popup_str = ['Gain|Integrator|Differentiator|Real Pole|Real Zero|',...
      'Complex Pole|Complex Zero|Lead/Lag|Num/Den|Delay Time|Design Point'];
   set(popup,'string',popup_str,'callback','termmang(0,1,1)');
   set(plant,'checked','on','enable','on');
   set(cont_type,'enable','off');
   set([for_cont,bac_cont],'checked','off');
   set(ui_obj.SysUI(1),'value',1);
   set(ui_obj.SysUI(2:3),'value',0);
   set(lab_txt(1),'callback','dispfrac(5)');
   loc_type = 1;

% set to one option
   set(set_to_one1,'label',['Set G(s) = 1']);
   set(set_to_one2,'label',['Set H(s) = 1']);
   if sys_state(4,cur_sys),
    set(set_to_one1,'checked','on');
    set(for_cont,'enable','off');
   else
    set(set_to_one1,'checked','off');
    set(for_cont,'enable','on');
   end
   if sys_state(5,cur_sys),
    set(set_to_one2,'checked','on');
    set(bac_cont,'enable','off');
   else
    set(set_to_one2,'checked','off');
    set(bac_cont,'enable','on');
   end
  end

% Forward Controller option
  if sys_state(2,cur_sys),
   set(for_cont,'checked','on','enable','on');
   set([plant,bac_cont],'checked','off');
   set(ui_obj.SysUI(2),'value',1);
   set(ui_obj.SysUI([1,3]),'value',0);
   set(cont_type,'enable','on');
   set(lab_txt(1),'callback','dispfrac(6)');

% set to one option
   set(set_to_one1,'label',['Set P(s) = 1']);
   set(set_to_one2,'label',['Set H(s) = 1']);
   if sys_state(4,cur_sys),
    set(set_to_one1,'checked','on');
    set(plant,'enable','off');
   else
    set(set_to_one1,'checked','off');
    set(plant,'enable','on');
   end
   if sys_state(5,cur_sys),
    set(set_to_one2,'checked','on');
    set(bac_cont,'enable','off');
   else
    set(set_to_one2,'checked','off');
    set(bac_cont,'enable','on');
   end

% what type of forward controller
   loc_type = find(sys_state(6:8,cur_sys)==1);
   set(ui_han(36:38),'checked','off');
   set(ui_han(35+loc_type),'checked','on');

   if loc_type == 1,
    popup_str = ['Gain|Integrator|Differentiator|Real Pole|Real Zero|',...
      'Complex Pole|Complex Zero|Lead/Lag|Num/Den|Delay Time|Design Point'];
    set(popup,'string',popup_str,'callback','termmang(0,1,1)');
   else
    popup_str = ['Proportional Gain|Integral Gain|Derivative Gain|Design Poin'];
    set(popup,'string',popup_str,'callback','pidmang(0,1)');
   end

  end

% Feedback Controller option
  if sys_state(3,cur_sys),
   set(bac_cont,'checked','on','enable','on');
   set([plant,for_cont],'checked','off');
   set(cont_type,'enable','on');
   set(ui_obj.SysUI(3),'value',1);
   set(ui_obj.SysUI(1:2),'value',0);
   set(lab_txt(1),'callback','dispfrac(6)');

% set to one option
   set(set_to_one1,'label',['Set P(s) = 1']);
   set(set_to_one2,'label',['Set G(s) = 1']);
   if sys_state(4,cur_sys),
    set(set_to_one1,'checked','on');
    set(plant,'enable','off');
   else
    set(set_to_one1,'checked','off');
    set(plant,'enable','on');
   end
   if sys_state(5,cur_sys),
    set(set_to_one2,'checked','on');
    set(for_cont,'enable','off');
   else
    set(set_to_one2,'checked','off');
    set(for_cont,'enable','on');
   end

% what type of feedback controller
   loc_type = find(sys_state(9:11,cur_sys)==1);
   set(ui_han(36:38),'checked','off');
   set(ui_han(35+loc_type),'checked','on');

   if loc_type == 1,
    popup_str = ['Gain|Integrator|Differentiator|Real Pole|Real Zero|',...
      'Complex Pole|Complex Zero|Lead/Lag|Num/Den|Delay Time|Design Point'];
    set(popup,'string',popup_str,'callback','termmang(0,1,1)');
   else
    popup_str = ['Proportional Gain|Integral Gain|Derivative Gain|Design Poin'];
    set(popup,'string',popup_str,'callback','pidmang(0,1)');
   end

  end

  if loc_type == 1,
   termmang(1,2,1);
  else
   pidmang(1,2)
  end

% clear root locus storage
  set(ui_han([37,69:75]),'userdata',[]);

  pageplot(0,13);

 elseif mode == 4, % switching to plant
  if strcmp(get(plant,'enable'),'off'),
   dispfrac(5);
   return
  end
  set(stat_bar,'string',['Switching to Plant ',int2str(cur_sys),' transfer function']);
  set(lab_txt(1),'callback','dispfrac(5)');
  set(plant,'checked','on');
  set([for_cont,bac_cont],'checked','off');
  set(ui_obj.SysUI(1),'value',1);
  set(ui_obj.SysUI(2:3),'value',0);

  set(set_to_one1,'label',['Set G(s) = 1']);
  set(set_to_one2,'label',['Set H(s) = 1']);

  if strcmp(get(for_cont,'enable'),'off'),
   set(set_to_one1,'checked','on');
   temp1 = get(ui_han(12+cur_sys*2-1),'userdata');
   temp2 = get(ui_han(12+cur_sys*2),'userdata');
   set(ui_han(12+cur_sys*2-1),'userdata',temp2);
   set(ui_han(12+cur_sys*2),'userdata',temp1);
  end

  if strcmp(get(bac_cont,'enable'),'off'),
   set(set_to_one2,'checked','on');
  end

  set(cont_type,'enable','off');
  popup_str = ['Gain|Integrator|Differentiator|Real Pole|Real Zero|',...
            'Complex Pole|Complex Zero|Lead/Lag|Num/Den|Delay Time|Design Point'];
  set(popup,'string',popup_str,'callback','termmang(0,1,1)');
  termmang(1,2,1)

% update sys_state matrix
  sys_state(2:3,cur_sys) = [0;0];
  sys_state(1,cur_sys) = 1;

% need to update gain plots because of transfer function change
  pageplot(4,[]);

 elseif mode == 5, % switching to forward controller
  if strcmp(get(for_cont,'enable'),'off'),
   dispfrac(6);
   return
  end
  set(stat_bar,'string',['Switching to Forward Controller ',int2str(cur_sys),' transfer function']);
  set(lab_txt(1),'callback','dispfrac(6)');
  set(for_cont,'checked','on');
  set([plant,bac_cont],'checked','off');
  set(ui_obj.SysUI(2),'value',1);
  set(ui_obj.SysUI([1,3]),'value',0);

  set(set_to_one1,'label',['Set P(s) = 1']);
  set(set_to_one2,'label',['Set H(s) = 1']);

  if strcmp(get(plant,'enable'),'off'),
   set(set_to_one1,'checked','on');
  end
  if strcmp(get(bac_cont,'enable'),'off'),
   set(set_to_one2,'checked','on');
  end

  set(cont_type,'enable','on');

% what type of forward controller
  loc_type = find(sys_state(6:8,cur_sys)==1);
  set(ui_han(36:38),'checked','off');
  set(ui_han(35+loc_type),'checked','on');

  if strcmp(get(num_den,'checked'),'on'),
   popup_str = ['Gain|Integrator|Differentiator|Real Pole|Real Zero|',...
     'Complex Pole|Complex Zero|Lead/Lag|Num/Den|Delay Time|Design Point'];
   set(popup,'string',popup_str,'callback','termmang(0,1,1)');
   termmang(1,2,1)
  else
   popup_str = ['Proportional Gain|Integral Gain|Derivative Gain|Design Point'];
   set(popup,'string',popup_str,'callback','pidmang(0,1)');
   pidmang(1,2)
  end

% update sys_state matrix
  sys_state([1,3],cur_sys) = [0;0];
  sys_state(2,cur_sys) = 1;

% need to update gain plots because of transfer function change
  pageplot(4,[]);

 elseif mode == 6, % switching to feedback controller
  if strcmp(get(bac_cont,'enable'),'off'),
   dispfrac(4);
   return
  end
  set(stat_bar,'string',['Switching to Feedback Controller ',int2str(cur_sys),' transfer function']);
  set(lab_txt(1),'callback','dispfrac(4)');
  set(bac_cont,'checked','on');
  set([plant,for_cont],'checked','off');
  set(ui_obj.SysUI(3),'value',1);
  set(ui_obj.SysUI(1:2),'value',0);

  set(set_to_one1,'label',['Set P(s) = 1']);
  set(set_to_one2,'label',['Set G(s) = 1']);

  if strcmp(get(plant,'enable'),'off'),
   set(set_to_one1,'checked','on');
  end
  if strcmp(get(for_cont,'enable'),'off'),
   set(set_to_one2,'checked','on');
   temp1 = get(ui_han(12+cur_sys*2-1),'userdata');
   temp2 = get(ui_han(12+cur_sys*2),'userdata');
   set(ui_han(12+cur_sys*2-1),'userdata',temp2);
   set(ui_han(12+cur_sys*2),'userdata',temp1);
  end

  set(cont_type,'enable','on');

% what type of feedback controller
  loc_type = find(sys_state(9:11,cur_sys)==1);
  set(ui_han(36:38),'checked','off');
  set(ui_han(35+loc_type),'checked','on');

  if strcmp(get(num_den,'checked'),'on'),
   popup_str = ['Gain|Integrator|Differentiator|Real Pole|Real Zero|',...
     'Complex Pole|Complex Zero|Lead/Lag|Num/Den|Delay Time|Design Point'];
   set(popup,'string',popup_str,'callback','termmang(0,1,1)');
   termmang(1,2,1)
  else
   popup_str = ['Proportional Gain|Integral Gain|Derivative Gain|Design Point'];
   set(popup,'string',popup_str,'callback','pidmang(0,1)');
   pidmang(1,2)
  end

% update sys_state matrix
  sys_state(1:2,cur_sys) = [0;0];
  sys_state(3,cur_sys) = 1;

% need to update gain plots because of transfer function change
  pageplot(4,[]);

 elseif mode == 7, % component
  set(stat_bar,'string','Displaying individual transfer function');
  set(ui_han([45:46]),'checked','off')
  set(component,'checked','on');

 elseif mode == 8, % open-loop
  set(stat_bar,'string','Displaying open-loop transfer function');
  set(ui_han([44,46]),'checked','off')
  set(open_loop,'checked','on');

 elseif mode == 9, % closed-loop
  set(stat_bar,'string','Displaying closed-loop transfer function');
  set(ui_han([44:45]),'checked','off');
  set(closed_loop,'checked','on');

 elseif mode == 10, % factored
  set(stat_bar,'string','Displaying pole-zero factored form');
  set(ui_han([48:49]),'checked','off');
  set(factored,'checked','on');

 elseif mode == 11, % coefficient
  set(stat_bar,'string','Displaying polynomial form');
  set(ui_han([47,49]),'checked','off');
  set(coefficient,'checked','on');

 elseif mode == 12, % inverse laplace transform
  set(stat_bar,'string','Displaying inverse Laplace form');
  set(ui_han([47:48]),'checked','off');
  set(inverse,'checked','on');

 end
 set(ui_han(33),'userdata',sys_state);

end

% determine states of display

% which component is displayed
if strcmp(get(plant,'checked'),'on'), mode1 = 1;
elseif strcmp(get(for_cont,'checked'),'on'), mode1 = 2;
else mode1 = 3; end

% what type of controller is displayed
if strcmp(get(num_den,'checked'),'on'), mode2 = 1;
elseif strcmp(get(pid_1,'checked'),'on'), mode2 = 2;
else mode2 = 3; end

% what configuration is desired
if strcmp(get(component,'checked'),'on'), mode3 = 1;
elseif strcmp(get(open_loop,'checked'),'on'), mode3 = 2;
else mode3 = 3; end

% what form is desired
if strcmp(get(factored,'checked'),'on'), mode4 = 1;
elseif strcmp(get(coefficient,'checked'),'on'), mode4 = 2;
else mode4 = 3; end

if mode1 == 1,
 set(lab_txt(1),'string',['Plant ',int2str(cur_sys),' Entry']);
elseif mode1 == 2,
 set(lab_txt(1),'string',['Forward ',int2str(cur_sys),' Entry']);
else
 set(lab_txt(1),'string',['Feedback ',int2str(cur_sys),' Entry']);
end

plant_mat = get(ui_han(3+cur_sys),'userdata');
for_mat = get(ui_han(6+cur_sys),'userdata');
bac_mat = get(ui_han(9+cur_sys),'userdata');

if mode3 == 1,

 if mode1 == 1,
  tf_str = ['P',int2str(cur_sys)];
  term_mat = plant_mat;
 elseif mode1 == 2,
  tf_str = ['G',int2str(cur_sys)];
  term_mat = for_mat;
 else
  tf_str = ['H',int2str(cur_sys)];
  term_mat = bac_mat;
 end

elseif mode3 == 2,

 tf_str = ['GPH',int2str(cur_sys)];
 term_mat = termjoin(plant_mat,for_mat,bac_mat);

else

 if any(mode == [4:6]), return; end
 tf_str = ['CL',int2str(cur_sys)];
 [nump,denp] = termextr(plant_mat);
 [numg,deng] = termextr(for_mat);
 [numh,denh] = termextr(bac_mat);
 neg_locus = strcmp(get(neg_loc,'checked'),'on');
 numcl = conv(conv(nump,numg),denh);
 num = conv(conv(nump,numg),numh);
 den = conv(conv(denp,deng),denh);
 ln = length(num); ld = length(den);
 num = [zeros(1,ld-ln),num];
 den = [zeros(1,ln-ld),den];
 dencl = den + num;
 term_mat = termpars(numcl,dencl);

end

if mode4 < 3 , tf_str = [tf_str,'(s)='];
else tf_str = [tf_str,'(t)=']; end

if mode1 > 1 & mode2 > 1 & mode3 == 1, % pid controller
 if mode4 > 1,
  if term_mat(4) == 40, term_mat = pid2pid(term_mat,1); end
  term_mat = termpars(term_mat([3,1,2]),[1,0]);
 end
end

% destroy present transfer function
axes(term_axis);
cla;

line_yloc = 0.5;
T = [];
txt = text(0,0.5,tf_str,'erase',ers,'horizontalalignment','left',...
        'verticalalignment','middle','fontname',fontname,'color','k');
tf_ext = get(txt,'extent');

% initial locations of text for the numerator and denominator
num_btm = line_yloc+0.01;
den_btm = line_yloc-tf_ext(4)-0.01;
txt_lft = sum(tf_ext([1,3]))+0.01;
term_val = [1:8];

% mode1 - transfer function
% mode2 - controller type
% mode3 - component, open-loop, closed-loop
% mode4 - factored, coefficient, inverse laplace

if mode4 == 1,
 if mode1 > 1 & mode2 == 2 & mode3 == 1, % pid form #1
  p_gain = num2str(term_mat(1));
  i_gain = num2str(term_mat(2));
  d_gain = num2str(term_mat(3));
  txt = text(txt_lft,0.5,[p_gain,' + '],'erase',ers,...
            'horizontalalignment','left','verticalalignment','middle',...
            'userdata',[1,0],'fontname',fontname,...
            'tag','0','color','k');
%            'buttondownfcn','pagemous(0)');
  txt_ext = get(txt,'extent');
  txt_lft = txt_lft+txt_ext(3);
  txt = text(txt_lft,num_btm,i_gain,'erase',ers,...
            'horizontalalignment','left','verticalalignment','bottom',...
            'userdata',[2,0],'fontname',fontname,...
            'tag','0','color','k');
%            'buttondownfcn','pagemous(0)');
  txt_ext = get(txt,'extent');
  new_lft = txt_lft+txt_ext(3);
  lin_lft = txt_lft; lin_rht = new_lft;
  lin = line([lin_lft,lin_rht],[line_yloc,line_yloc],'erase',ers,'color','k');
  txt_mid = txt_lft + (lin_rht-lin_lft)/2;
  txt = text(txt_mid,den_btm,'s','erase',ers,...
           'horizontalalignment','center','verticalalignment','bottom',...
           'userdata',[2,0],'fontname',fontname,...
           'tag','0','color','k');
%           'buttondownfcn','pagemous(0)');
  text(new_lft,0.5,[' + ',d_gain,'s'],'erase',ers,...
            'horizontalalignment','left','verticalalignment','middle',...
            'userdata',[3,0],'fontname',fontname,...
            'tag','0','color','k');
%            'buttondownfcn','pagemous(0)');

 elseif mode1 > 1 & mode2 == 3 & mode3 == 1, % pid form #2

  p_gain = num2str(term_mat(1));
  i_gain = num2str(abs(term_mat(2)));
  d_gain = num2str(abs(term_mat(3)));

  if term_mat(2) >= 0, p_gain = [p_gain,' + '];
  else p_gain = [p_gain,' - ']; end

  if term_mat(3) >= 0, d_gain = [' + ',d_gain];
  else d_gain = [' - ',d_gain]; end

  txt = text(txt_lft,0.5,['(1',d_gain,'s)'],'erase',ers,...
            'horizontalalignment','left','verticalalignment','middle',...
            'userdata',[3,0],'fontname',fontname,...
            'tag','0','color','k');
%            'buttondownfcn','pagemous(0)');
  txt_ext = get(txt,'extent');
  txt_lft = txt_lft+txt_ext(3);

  txt = text(txt_lft,0.5,['(',p_gain],'erase',ers,...
            'horizontalalignment','left','verticalalignment','middle',...
            'userdata',[1,0],'fontname',fontname,...
            'tag','0','color','k');
%            'buttondownfcn','pagemous(0)');
  txt_ext = get(txt,'extent');
  txt_lft = txt_lft+txt_ext(3);

  txt = text(txt_lft,num_btm,i_gain,'erase',ers,...
            'horizontalalignment','left','verticalalignment','bottom',...
            'userdata',[2,0],'fontname',fontname,...
            'tag','0','color','k');
%            'buttondownfcn','pagemous(0)');
  txt_ext = get(txt,'extent');
  new_lft = txt_lft+txt_ext(3);
  lin_lft = txt_lft; lin_rht = new_lft;
  lin = line([lin_lft,lin_rht],[line_yloc,line_yloc],'erase',ers,'color','k');
  txt_mid = txt_lft + (lin_rht-lin_lft)/2;
  txt = text(txt_mid,den_btm,'s','erase',ers,...
           'horizontalalignment','center','verticalalignment','bottom',...
           'userdata',[2,0],'fontname',fontname,...
           'tag','0','color','k');
%           'buttondownfcn','pagemous(0)');
  text(new_lft,0.5,')','erase',ers,...
            'horizontalalignment','left','verticalalignment','middle',...
            'userdata',[2,0],'fontname',fontname,...
            'tag','0','color','k');

 else
  for k = term_val,
   term_loc=find(k==term_mat(:,4));
   if length(term_loc),
    for h=1:length(term_loc),

     if k==1, % Gain

      gain = num2str(term_mat(1,1));
      txt = text(txt_lft,0.5,gain,'erase',ers,...
                 'horizontalalignment','left','verticalalignment','middle',...
                 'fontname',fontname,'color','k');
      txt_ext = get(txt,'extent');

      if mode3 == 1 & mode4 == 1,
       set(txt,'userdata',term_loc(h),'tag','0');
%       set(txt,'userdata',term_loc(h),'buttondownfcn','pagemous(0)');
      else
       set(txt,'tag','9');
      end

      txt_lft = txt_lft + txt_ext(3)+0.01;

     elseif k==2,

      integ = term_mat(term_loc(h),1);
      if integ~=0,
       if integ > 0,
        txt1_btm = den_btm; txt2_btm = num_btm;
       else
        txt1_btm = num_btm; txt2_btm = den_btm;
       end

       coeffs = [1,zeros(1,abs(integ))];
       [txt_han,new_lft] = coefdisp(txt_lft,txt1_btm,coeffs,0,term_loc(h));

       lin_lft = txt_lft; lin_rht = new_lft;
       lin = line([lin_lft,lin_rht],[line_yloc,line_yloc],'erase',ers,'color','k');
       txt_mid = txt_lft + (lin_rht-lin_lft)/2;
       txt = text(txt_mid,txt2_btm,'1','erase',ers,...
            'horizontalalignment','center','verticalalignment','bottom',...
            'fontname',fontname,'color','k');
       set(txt,'userdata',term_loc(h));
       set(lin,'userdata',[txt_han,txt]);

       if mode3 == 1 & mode4 == 1,
        set([txt,txt_han],'tag','0');
%        set([txt,txt_han],'buttondownfcn','pagemous(0)');
       else
        set([txt,txt_han],'tag','9');
       end

       txt_lft = new_lft + 0.01;
      end

     elseif any(k==[4,5]), % real pole/zero

      if k==4,
       txt1_btm = den_btm; txt2_btm = num_btm;
      else
       txt1_btm = num_btm; txt2_btm = den_btm;
      end

      coeffs = [1,term_mat(term_loc(h),1)];
      [txt_han,new_lft] = coefdisp(txt_lft,txt1_btm,coeffs,1,term_loc(h));

      lin_lft = txt_lft; lin_rht = new_lft;
      lin = line([lin_lft,lin_rht],[line_yloc,line_yloc],'erase',ers,'color','k');
      txt_mid = txt_lft + (lin_rht-lin_lft)/2;
      txt = text(txt_mid,txt2_btm,'1','erase',ers,...
              'horizontalalignment','center','verticalalignment','bottom',...
              'fontname',fontname,'color','k');
      set(txt,'userdata',term_loc(h));

      if mode3 == 1 & mode4 == 1,
       set([txt,txt_han],'tag','0');
%       set([txt,txt_han],'buttondownfcn','pagemous(0)');
      else
       set([txt,txt_han],'tag','9');
      end

      set(lin,'userdata',[txt_han,txt]);
      txt_lft = new_lft + 0.01;

     elseif any(k==[6,7]), % complex pole/zero

      if k==6,
       txt1_btm = den_btm; txt2_btm = num_btm;
      else
       txt1_btm = num_btm; txt2_btm = den_btm;
      end

      zeta = term_mat(term_loc(h),1);
      wn = term_mat(term_loc(h),2);
      coeffs = [1,2*zeta*wn,wn^2];
      [txt_han,new_lft] = coefdisp(txt_lft,txt1_btm,coeffs,1,term_loc(h));

      lin_lft = txt_lft; lin_rht = new_lft;
      lin = line([lin_lft,lin_rht],[line_yloc,line_yloc],'erase',ers,'color','k');
      txt_mid = txt_lft + (lin_rht-lin_lft)/2;
      txt = text(txt_mid,txt2_btm,'1','erase',ers,...
             'horizontalalignment','center','verticalalignment','bottom',...
             'fontname',fontname,'color','k');
      set(txt,'userdata',term_loc(h));

      if mode3 == 1 & mode4 == 1,
       set([txt,txt_han],'tag','0');
%       set([txt,txt_han],'buttondownfcn','pagemous(0)');
      else
       set([txt,txt_han],'tag','9');
      end

      set(lin,'userdata',[txt_han,txt]);
      txt_lft = new_lft + 0.01;

     elseif k==8, % lead/lag

      phase = term_mat(term_loc(h),1);
      freq = term_mat(term_loc(h),2);
      [jk,zero,pole]=leadlag(phase,freq,[],T);

      zero_str = num2str(zero);
      pole_str = num2str(pole);

      if zero > 0,
       lead = ['(s+',zero_str,')'];
      else
       lead = ['(s',zero_str,')'];
      end

      if pole > 0,
       lag = ['(s+',pole_str,')'];
      else
       lag = ['(s',pole_str,')'];
      end

      txt1 = text(txt_lft,num_btm,lead,'erase',ers,...
            'horizontalalignment','left','verticalalignment','bottom',...
            'fontname',fontname,'color','k');
      set(txt1,'userdata',term_loc(h));

      txt_ext = get(txt1,'extent');
      lin_lft = txt_lft; lin_rht = txt_lft+txt_ext(3);
      lin = line([lin_lft,lin_rht],[line_yloc,line_yloc],'erase',ers,'color','k');

      txt2 = text(txt_lft,den_btm,lag,'erase',ers,...
            'horizontalalignment','left','verticalalignment','bottom',...
            'fontname',fontname,'color','k');
      set(txt2,'userdata',term_loc(h));
      set(lin,'userdata',[txt1,txt2]);

      if mode3 == 1 & mode4 == 1,
       set([txt1,txt2],'tag','0');
%       set([txt1,txt2],'buttondownfcn','pagemous(0)');
      else
       set([txt1,txt2],'tag','9');
      end

      txt_lft = txt_lft + txt_ext(3) + 0.01;

     end % end else-ifs
    end % end for h = loop
   end % end of if length(term_loc)
  end % end of for k = loop

  if term_mat(1,2)~=0,
   e_str = 'e';
   txt1=text(txt_lft,line_yloc,e_str,'erase',ers,...
             'horizontalalignment','left','verticalalignment','middle',...
             'fontname',fontname,'color','k');
   ext_txt = get(txt1,'extent');
   txt_lft = txt_lft + ext_txt(3);
   if term_mat(1,2) > 0,
    delay_str = ['-',num2str(term_mat(1,2)),'s'];
   else
    delay_str = [num2str(-term_mat(1,2)),'s'];
   end
   txt2=text(txt_lft,line_yloc,delay_str,'erase',ers,...
             'horizontalalignment','left','verticalalignment','bottom',...
             'fontname',fontname,'color','k');
   if mode3 == 1 & mode4 == 1,
    set([txt1,txt2],'userdata',[0,1],'tag','0');
%       set([txt1,txt2],'buttondownfcn','pagemous(0)');
   else
    set([txt1,txt2],'tag','9');
   end
  end
 end

elseif mode4 == 2, % coefficient

 [num,den] = termextr(term_mat);
 num = num/term_mat(1,1);

 gain = num2str(term_mat(1,1));
 txt = text(txt_lft,0.5,gain,'erase',ers,...
            'horizontalalignment','left','verticalalignment','middle',...
            'fontname',fontname,'color','k');
 txt_ext = get(txt,'extent');
 set(txt,'userdata',1);
 txt_lft = txt_lft + txt_ext(3)+0.01;

 [txt_han1,new_lft1] = coefdisp(txt_lft,num_btm,num,0,[0,0]);
 [txt_han2,new_lft2] = coefdisp(txt_lft,den_btm,den,0,[0,0]);
 min_lft = min(new_lft1,new_lft2); max_lft = max(new_lft1,new_lft2);
 shft = (max_lft - min_lft)/2;
 if new_lft1 < new_lft2,
  for k = length(txt_han1):-1:1,
   txt_pos = get(txt_han1(k),'pos');
   set(txt_han1(k),'pos',txt_pos+[shft,0,0]);
  end
 elseif new_lft2 < new_lft1,
  for k = length(txt_han2):-1:1,
   txt_pos = get(txt_han2(k),'pos');
   set(txt_han2(k),'pos',txt_pos+[shft,0,0]);
  end
 end
 lin_lft = txt_lft; lin_rht = max_lft;
 lin = line([lin_lft,lin_rht],[line_yloc,line_yloc],'erase',ers,'color','k');
 set(lin,'userdata',[txt_han1,txt_han2]);
 set([txt_han1,txt_han2],'tag','9');

elseif mode4 == 3, % Inverse Laplace Transform

 residisp(term_mat,tf_ext);

end