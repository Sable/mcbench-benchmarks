function pagesetu(mode)
% PAGESETU Graphical user interface for page setup.
%          PAGESETU creates the interface for the user to setup what plots
%          appear on what pages in The Controls Tutor environment.

% Author: Craig Borghesani
% Date: 10/16/94
% Revised:
% Copyright (c) 1999, Prentice-Hall

% obtain handle information
if nargin ~= 0,
 f2 = gcf;
 f = get(f2,'userdata');
else
 f = gcf;
end
ui_data = get(f,'userdata');
ui_han = ui_data{1};
cur_page = get(ui_han(31),'userdata');
win_str = get(ui_han(48),'userdata');
ui_han2 = get(ui_han(49),'userdata');
if length(ui_han2) & figflag(['Page Layout...',win_str]),
   stat_bar = get(ui_han2(8),'userdata');
end
del = 22;

% setup gui
if nargin == 0,

% define various shades of grey
 grey = get(0,'defaultuicontrolbackground');
 ltgrey = [0.5,0.5,0.5]*1.5;
 dkgrey = [0.5,0.5,0.5]*0.5;

 if ~figflag(['Page Layout...',win_str],0),
  scrn_size = get(0,'screensize');
  fig_h = 235;
  fig_w = 420;
  fig_lft = (scrn_size(3) - fig_w)/2;
  fig_btm = (scrn_size(4) - (fig_h+20))/2;
  f2 = figure('pos',[fig_lft,fig_btm,420,235],'menubar','none','numbertitle','off',...
              'color',[0.8,0.8,0.8],'name',['Page Layout...',win_str],...
              'windowbuttondownfcn','pagesetu(2)','userdata',f,...
              'defaultuicontrolbackgroundcolor',[0.8,0.8,0.8]);
% status bar
  stat_bar = uicontrol('style','edit',...
                  'pos',[0,0,420,20],...
                  'foregroundcolor','k',...
                  'backgroundcolor',grey,...
                  'horizontalalignment','left');

  txt(1) = uicontrol('style','text','pos',[10,186+del,40,17],'string','Page');
  ui_han2(1) = uicontrol('style','popup','pos',[10,164+del,40,17],...
                    'string','1|2|3|4|5|6|7|8','callback','pagesetu(1)');

  txt(2) = uicontrol('style','text','pos',[70,186+del,120,17],...
                   'string','Plot');
  ui_han2(2) = uicontrol('style','check','pos',[70,164+del,120,17],...
                   'string','Nyquist','callback','pagesetu(2)');
  ui_han2(3) = uicontrol('style','check','pos',[70,142+del,120,17],...
                   'string','Bode (Magnitude)','callback','pagesetu(2)');
  ui_han2(4) = uicontrol('style','check','pos',[70,120+del,120,17],...
                   'string','Bode (Phase)','callback','pagesetu(2)');
  ui_han2(5) = uicontrol('style','check','pos',[70,98+del,120,17],...
                   'string','Nichols','callback','pagesetu(2)');
  ui_han2(6) = uicontrol('style','check','pos',[70,76+del,120,17],...
                   'string','Root Locus','callback','pagesetu(2)');
  ui_han2(7) = uicontrol('style','check','pos',[70,54+del,120,17],...
                   'string','Gain (Magnitude)','callback','pagesetu(2)');
  ui_han2(8) = uicontrol('style','check','pos',[70,32+del,120,17],...
                   'string','Gain (Phase)','callback','pagesetu(2)');
  ui_han2(9) = uicontrol('style','check','pos',[70,10+del,120,17],...
                   'string','Time Response','callback','pagesetu(2)');

  set(ui_han2,'horizontalalignment','left','backgroundcolor','w');

  txt(3) = uicontrol('style','text','pos',[210,186+del,120,17]);
  axs = axes('pos',[210/420,(61+del)/(213+del),120/420,120/(213+del)],...
             'color','k','xtick',[],'ytick',[],'box','on');

  ptch(1) = patch('xdata',[0,0,0,0],'ydata',[0,0,0,0],...
                  'erase','norm','vis','off');
  ptch(2) = patch('xdata',[0,0,0,0],'ydata',[0,0,0,0],...
                  'erase','norm','vis','off');
  ptch(3) = patch('xdata',[0,0,0,0],'ydata',[0,0,0,0],...
                  'erase','norm','vis','off');
  ptch(4) = patch('xdata',[0,0,0,0],'ydata',[0,0,0,0],...
                  'erase','norm','vis','off');

  set(txt,'horizontalalignment','left');

  psh(1) = uicontrol('style','push','pos',[350,183+del,60,20],...
                     'string','OK','callback','pagesetu(5)');
  psh(2) = uicontrol('style','push','pos',[350,160+del,60,20],...
                     'string','Cancel','callback','pagesetu(6)');
  psh(3) = uicontrol('style','push','pos',[350,134+del,60,20],...
                     'string','Clear','callback','pagesetu(7)');
  psh(4) = uicontrol('style','push','pos',[350,111+del,60,20],...
                     'string','Default','callback','pagesetu(8)');
  psh(5) = uicontrol('style','push','pos',[350,88+del,60,20],...
                     'string','Help','callback','userhelp(8,2)');

  set(psh,'back',grey);

  page_setup = get(ui_han(34),'userdata');
  set(ui_han2(1),'userdata',page_setup);
  set(ui_han2(2),'userdata',ptch);
  set(ui_han2(3),'userdata',txt(3));
  set(ui_han2(8),'userdata',stat_bar);
  set(ui_han(49),'userdata',ui_han2);

 else

  page_setup = get(ui_han(34),'userdata');
  set(ui_han2(1),'userdata',page_setup);

 end

 pagechan(cur_page,0);

 set(stat_bar,'string','Use the mouse to select plots and change layouts');

elseif mode == 1, % changing pages

 page_num = get(ui_han2(1),'value');
 pagechan(page_num,0);

 num_plots = get(ui_han2(4),'userdata');
 if num_plots > 1,
  set(stat_bar,'string','Remember, you can use the mouse to drag and drop axes');
 end

elseif mode == 2, % choosing plots or changing layout with mouse

 cur_obj = get(f2,'currentobject');
 loc_obj = find(cur_obj==ui_han2(2:9));
 page_setup = get(ui_han2(1),'userdata');
 page_num = get(ui_han2(1),'value');
 color_mat = [1,0,0;0,1,0;0,0,1;1,1,0;0,1,1;0.5,0,0;0,0.5,0;0,0,0.5];
 if strcmp(get(cur_obj,'type'),'uicontrol') & length(loc_obj),
  cur_clr = get(cur_obj,'backgroundcolor');
  loc = find(page_setup(:,page_num)==0);
  if length(loc) | (~all(cur_clr)),
   if all(cur_clr),
    set(cur_obj,'backgroundcolor',color_mat(loc_obj,:));
    page_setup(loc(1),page_num) = loc_obj;
    set(stat_bar,'string',[int2str(length(loc)-1),' more plot(s) allowed']);
   else
    set(cur_obj,'backgroundcolor','w');
    page_setup(find(loc_obj==page_setup(:,page_num)),page_num) = 0;
    set(stat_bar,'string',[int2str(length(loc)+1),' more plot(s) allowed']);
   end
   set(ui_han2(1),'userdata',page_setup);
   pagechan(page_num,1);
  else
   set(stat_bar,'string','Maximum 4 plots per page');
   set(cur_obj,'backgroundcolor','w','value',0);
  end
 elseif strcmp(get(cur_obj,'type'),'patch'),

  num_plots = get(ui_han2(4),'userdata');
  if num_plots > 1,
   set(cur_obj,'erase','xor');
   set(f2,'windowbuttonmotionfcn','pagesetu(3)',...
          'windowbuttonupfcn','pagesetu(4)');
   init_pt = get(gca,'currentpoint');
   set(ui_han2(5),'userdata',init_pt);
   set(ui_han2(6),'userdata',cur_obj);
   init_xdata = get(cur_obj,'xdata'); init_ydata = get(cur_obj,'ydata');
   set(ui_han2(7),'userdata',[init_xdata(:)';init_ydata(:)']);
  end

 end

elseif mode == 3, % moving a patch

 init_pt = get(ui_han2(5),'userdata');
 cur_obj = get(ui_han2(6),'userdata');
 init_data = get(ui_han2(7),'userdata');
 cur_pt = get(gca,'currentpoint');
 delx = cur_pt(1,1) - init_pt(1,1);
 dely = cur_pt(1,2) - init_pt(1,2);
 set(cur_obj,'xdata',[init_data(1,:)']+delx,'ydata',[init_data(2,:)']+dely);
 set(stat_bar,'string','Axes object grabbed...');

elseif mode == 4, % dropping a patch onto another

 page_setup = get(ui_han2(1),'userdata');
 page_num = get(ui_han2(1),'value');
 ptch = get(ui_han2(2),'userdata');
 num_plots = get(ui_han2(4),'userdata');
 cur_obj = get(ui_han2(6),'userdata');
 cur_pt = get(gca,'currentpoint');
 first_plot = get(cur_obj,'userdata');
 set(cur_obj,'erase','norm');

 if num_plots == 2,
  if cur_pt(1,2) >= 0.5,
   second_plot = get(ptch(1),'userdata');
  else
   second_plot = get(ptch(2),'userdata');
  end
 elseif num_plots == 3,
  if cur_pt(1,2) >= 0.5,
   second_plot = get(ptch(1),'userdata');
  elseif cur_pt(1,1) < 0.6,
   second_plot = get(ptch(2),'userdata');
  elseif cur_pt(1,1) >= 0.6,
   second_plot = get(ptch(3),'userdata');
  end
 elseif num_plots == 4,
  if cur_pt(1,2) >= 0.5,
   if cur_pt(1,1) < 0.6,
    second_plot = get(ptch(1),'userdata');
   elseif cur_pt(1,1) >= 0.6,
    second_plot = get(ptch(2),'userdata');
   end
  elseif cur_pt(1,1) < 0.6,
   second_plot = get(ptch(3),'userdata');
  elseif cur_pt(1,1) >= 0.6,
   second_plot = get(ptch(4),'userdata');
  end
 end

 if first_plot ~= second_plot,
  loc_first = find(first_plot == page_setup(:,page_num));
  loc_second = find(second_plot == page_setup(:,page_num));
  page_setup(loc_first,page_num) = second_plot;
  page_setup(loc_second,page_num) = first_plot;
  set(ui_han2(1),'userdata',page_setup);
  set(stat_bar,'string','Layout changed');
 else
  set(stat_bar,'string','To change the layout, place an axes object over another');
 end
 pagechan(page_num,1);
 set(f2,'windowbuttonupfcn','','windowbuttonmotionfcn','');

elseif mode == 5, % OK

 set(f2,'vis','off');

% file modification flag
 set(ui_han(47),'userdata',1);

 drawnow;
 page_setup = get(ui_han2(1),'userdata');
 cur_page = get(ui_han(31),'userdata');

% remove blank pages
 page_setup(:,all(~page_setup)) = [];
 [r,c]=size(page_setup);
 page_setup = [page_setup,zeros(4,8-c)];

 if cur_page > c, cur_page = c; end

 set(ui_han(34),'userdata',page_setup);
 figure(f);                             % added because of UNIX platform
 pagelayo
 set(ui_han(31),'userdata',[]);
 pagesele(cur_page,15);

elseif mode == 6, % Cancel

 set(f2,'vis','off');

elseif mode == 7, % Clear

 page_setup = [0,  0,  0,  0,  0,  0,  0,  0;
               0,  0,  0,  0,  0,  0,  0,  0;
               0,  0,  0,  0,  0,  0,  0,  0;
               0,  0,  0,  0,  0,  0,  0,  0];

 set(ui_han2(1),'userdata',page_setup,'value',1);
 pagechan(1,0);
 set(stat_bar,'string','Clearing page layout');

elseif mode == 8, % Default

 page_setup = [1,  2,  4,  5,  6,  8,  0,  0;
               0,  3,  0,  0,  7,  0,  0,  0;
               0,  0,  0,  0,  0,  0,  0,  0;
               0,  0,  0,  0,  0,  0,  0,  0];

 set(ui_han2(1),'userdata',page_setup);
 page_num = get(ui_han2(1),'value');
 pagechan(page_num,0);
 set(stat_bar,'string','Returning to default page layout');

end

