function axisset(mode)
% AXISSET User axis setting.

% Author: Craig Borghesani <cborg@terasoft.com>
% Date: 1/19/98 10:36PM

% obtain handle information
if mode == 1,
 f = gcf;

else
 f2 = gcf;
 f = get(f2,'userdata');

end

ui_data = get(f,'userdata');
ui_han = ui_data{1};
last_lims = ui_han(36);
ui_han2 = get(ui_han(54),'userdata');

cur_axs = get(ui_han(32),'userdata');

axs_data = get(cur_axs,'userdata');
axs_typ = axs_data(1);

if mode == 1, % axis limit entering

 win_str = get(ui_han(48),'userdata');

% define various shades of grey
 grey = get(0,'defaultuicontrolbackground');
 ltgrey = [0.5,0.5,0.5]*1.5;
 dkgrey = [0.5,0.5,0.5]*0.5;

 f2 = findobj(0,'type','figure','tag','AxisLimits');

 if isempty(f2),
  scrn_size = get(0,'screensize');
  fig_h = 80;
  fig_w = 360;
  fig_lft = (scrn_size(3) - fig_w)/2;
  fig_btm = (scrn_size(4) - (fig_h+20))/2;
  f2 = figure('pos',[fig_lft,fig_btm,fig_w,fig_h],'menubar','none','numbertitle','off',...
              'color',grey,'name',['Axis Limits',win_str],...
              'userdata',f,'defaultuicontrolbackgroundcolor',grey,...
              'tag','AxisLimits');


  lft = 10; btm = fig_h - 25;
  ui_han2(1) = uicontrol('style','text',...
                        'pos',[lft,btm,80,17],...
                        'string','Current Axis:',...
                        'horiz','left');
  ui_han2(2) = uicontrol('style','text',...
                        'pos',[lft+85,btm,150,17],...
                        'string','',...
                        'horiz','left');

  btm = btm - 22;
  ui_han2(3) = uicontrol('style','text',...
                        'pos',[lft,btm,50,17],...
                        'string','X Min',...
                        'horiz','left');
  ui_han2(4) = uicontrol('style','edit',...
                        'pos',[lft+55,btm,60,20],...
                        'string','',...
                        'horiz','right',...
                        'back','w');
  ui_han2(5) = uicontrol('style','text',...
                        'pos',[lft+130,btm,50,17],...
                        'string','X Max',...
                        'horiz','left');
  ui_han2(6) = uicontrol('style','edit',...
                        'pos',[lft+185,btm,60,20],...
                        'string','',...
                        'horiz','right',...
                        'back','w');
  btm = btm - 22;
  ui_han2(7) = uicontrol('style','text',...
                        'pos',[lft,btm,50,17],...
                        'string','Y Min',...
                        'horiz','left');
  ui_han2(8) = uicontrol('style','edit',...
                        'pos',[lft+55,btm,60,20],...
                        'string','',...
                        'horiz','right',...
                        'back','w');
  ui_han2(9) = uicontrol('style','text',...
                        'pos',[lft+130,btm,50,17],...
                        'string','Y Max',...
                        'horiz','left');
  ui_han2(10) = uicontrol('style','edit',...
                        'pos',[lft+185,btm,60,20],...
                        'string','',...
                        'horiz','right',...
                        'back','w');

  btm = fig_h - 25;
  lft = fig_w - 70;
  ui_han2(11) = uicontrol('style','push',...
                         'pos',[lft,btm,60,20],...
                         'string','OK',...
                         'callback','axisset(2)');

  btm = btm - 25;
  ui_han2(12) = uicontrol('style','push',...
                         'pos',[lft,btm,60,20],...
                         'string','Cancel',...
                         'callback','axisset(3)');

  set(ui_han(54),'userdata',ui_han2);
  set(f2,'vis','on');

 end

 figure(f2);

 if axs_data(1) == 1, set(ui_han2(2),'string','Nyquist');
 elseif axs_data(1) == 2, set(ui_han2(2),'string','Bode (Magnitude)');
 elseif axs_data(1) == 3, set(ui_han2(2),'string','Bode (Phase)');
 elseif axs_data(1) == 4, set(ui_han2(2),'string','Nichols');
 elseif axs_data(1) == 5, set(ui_han2(2),'string','Root Locus');
 elseif axs_data(1) == 6, set(ui_han2(2),'string','Gain (Magnitude)');
 elseif axs_data(1) == 7, set(ui_han2(2),'string','Gain (Phase)');
 elseif axs_data(1) == 8, set(ui_han2(2),'string','Time Response'); end

 Xlimits = get(cur_axs,'xlim');
 Ylimits = get(cur_axs,'ylim');
 set(ui_han2(4),'string',Xlimits(1));
 set(ui_han2(6),'string',Xlimits(2));
 set(ui_han2(8),'string',Ylimits(1));
 set(ui_han2(10),'string',Ylimits(2));

elseif mode == 2, % axis limits acceptance

 Xlimits = get(cur_axs,'xlim');
 Ylimits = get(cur_axs,'ylim');
 set(last_lims,'userdata',[cur_axs,Xlimits,Ylimits]);

 Xmin = str2num(get(ui_han2(4),'string'));
 Xmax = str2num(get(ui_han2(6),'string'));
 Ymin = str2num(get(ui_han2(8),'string'));
 Ymax = str2num(get(ui_han2(10),'string'));

 if any(axs_typ == [1, 5]),
  set(cur_axs,{'xlim','ylim'},ctsqaxes(cur_axs,[Xmin,Xmax],[Ymin,Ymax]));
 else
  set(cur_axs,'xlim',[Xmin,Xmax],'ylim',[Ymin,Ymax]);
 end

 set(f2,'vis','off');

elseif mode == 3, % Cancel

  set(f2,'vis','off');

end