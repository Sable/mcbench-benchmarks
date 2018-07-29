function filename = fileoptn(mode)
% FILEOPTN File pulldown menu.
%          FILEOPTN handles New, Open, Save, Save As.., Print, and Exit
%          options under the File pulldown menu.

% Author: Craig Borghesani
% Date: 9/4/94
% Revised: 10/18/94
% Copyright (c) 1999, Prentice-Hall

% obtain handle information
f = gcf;
ui_data = get(f,'userdata');
ui_han = ui_data{1};
cur_sys = get(ui_han(30),'userdata');

% path to current file (for Save)
save_opt = ui_han(45);
stat_bar = get(ui_han(43),'userdata');
win_str = get(ui_han(48),'userdata');

if any(mode == [1,10]), % New

 if mode == 10,
  filename = fileoptn(3);
 else
  filename = 1;
 end

 if ~filename, return; end

 set(stat_bar,'string','Re-setting Controls Tutor');

 page_setup = [1,  2,  4,  5,  6,  8,  0,  0;
               0,  3,  0,  0,  7,  0,  0,  0;
               0,  0,  0,  0,  0,  0,  0,  0;
               0,  0,  0,  0,  0,  0,  0,  0];

 sys_state = [1,  1,  1;
              0,  0,  0;
              0,  0,  0;
              0,  0,  0;
              0,  0,  0;
              1,  1,  1;
              0,  0,  0;
              0,  0,  0;
              1,  1,  1;
              0,  0,  0;
              0,  0,  0];

 plant1_mat = [1,0,NaN,1;0,NaN,NaN,2];
 pid1_mat = [1,0,0,20];

% reset frequency response
 w = logspace(-2,3,100);
 plant1_res = [w;ones(2,length(w))];

% plant and controller initial matrices
 set(ui_han(1:3),'userdata',plant1_res);
 set(ui_han(4:18),'userdata',plant1_mat);
 set(ui_han(19:24),'userdata',pid1_mat);

% reset design point data
 set(ui_han(25:26),'userdata',[]);

% current page
 set(ui_han(31),'userdata',[]);

% page setup
 set(ui_han(34),'userdata',page_setup);
 set(ui_han(33),'userdata',sys_state);
 drawnow;
 set(f,'name','Controls Tutor - [Untitled]');

 set(stat_bar,'string','Setting up page layout...');
 pagelayo
 pagesele(1)

% reset display menu and tools menu
 set(ui_han([26:28,44:49,60:64,67:75,78:88]),'checked','off');
 set(ui_han([44,47,60,62,67,78,81]),'checked','on');

 dispfrac(-1)

 set(save_opt,'userdata','Untitled');

elseif any(mode == [2,11]), % Open

 if mode == 11,
  filename = fileoptn(3);
 else
  filename = 1;
 end

 if ~filename, return; end

 set(stat_bar,'string','Select a *.tut file to Open');
 [filename,pathname] = uigetfile('*.tut',['Open',win_str]);

 if filename,

  set(stat_bar,'string','Loading...');
  eval(['load ',pathname,filename,' -mat']);
  set(ui_han(47),'userdata',0);

  for k = 1:3,
   kstr = int2str(k);
   eval(['set(ui_han(3+k),''userdata'',plant',kstr,'_mat);']);
   eval(['set(ui_han(6+k),''userdata'',for',kstr,'_mat);']);
   eval(['set(ui_han(9+k),''userdata'',bac',kstr,'_mat);']);
  end

  for k = 13:24,
   kstr = int2str(k);
   eval(['set(ui_han(k),''userdata'',mat',kstr,');']);
  end

  set(ui_han(25:26),'userdata',[]);
  set(ui_han(30),'userdata',cur_sys);
  set(ui_han(31),'userdata',cur_page);
  set(ui_han(33),'userdata',sys_state);
  set(ui_han(34),'userdata',page_setup);

  for k = 1:3,
   kstr = int2str(k);
   sys_res = get(ui_han(k),'userdata');
   w = sys_res(1,:);
   eval(['term_mat = termjoin(plant',kstr,'_mat,for',kstr,'_mat,bac',kstr,'_mat);']);
   new_res = termcplx(term_mat,w);
   sys_res(2,:) = new_res;
   set(ui_han(k),'userdata',sys_res);
  end

  lfile = length(filename);
  if strcmp(filename(lfile-2:lfile),'tux') | ...
     strcmp(filename(lfile-2:lfile),'TUX'),

   set(f,'name',['Controls Tutor - [',pathname,filename,']']);
   drawnow;
   set(ui_han(34),'userdata',page_setup);
   pagelayo
   set(ui_han(31),'userdata',[]);

% reset display menu and tools menu
   set(ui_han([44:49,60:64,67:75,78:88]),'checked','off');
   set(ui_han([44,47,60,62,67,78,81]),'checked','on');

   pagesele(cur_page);
   dispfrac(-cur_sys)
   eval(filename(1:lfile-4));

  else

   set(f,'name',['Controls Tutor - [',pathname,filename,']']);
   drawnow;

   set(stat_bar,'string','Setting up page layout...');
   set(ui_han(26:28),'checked','off');
   pagelayo
   pagesele(cur_page)

   pageplot(0,[]);

   dispfrac(-cur_sys)

  end

  set(save_opt,'userdata',[pathname,filename]);

 end

elseif mode == 3, % Save

 pathfile = get(save_opt,'userdata');
 if ~strcmp(pathfile,'Untitled'),
  set(ui_han(47),'userdata',0);
  for k = 1:3,
   kstr = int2str(k);
   eval(['plant',kstr,'_mat = get(ui_han(3+k),''userdata'');']);
   eval(['for',kstr,'_mat = get(ui_han(6+k),''userdata'');']);
   eval(['bac',kstr,'_mat = get(ui_han(9+k),''userdata'');']);
  end
  cur_sys = get(ui_han(30),'userdata');
  cur_page = get(ui_han(31),'userdata');
  sys_state = get(ui_han(33),'userdata');
  page_setup = get(ui_han(34),'userdata');

  for k = 13:24,
   kstr = int2str(k);
   eval(['mat',kstr,' = get(ui_han(k),''userdata'');']);
  end

  set(stat_bar,'string',['Saving to ',pathfile]);
  eval(['save ',pathname,filename,' plant1_mat for1_mat bac1_mat plant2_mat ',...
              'for2_mat bac2_mat plant3_mat for3_mat bac3_mat cur_sys ',...
              'mat13 mat14 mat15 mat16 mat17 mat18 mat19 mat20 mat21 mat22 ',...
              'mat23 mat24 cur_page sys_state page_setup -mat']);
 else

  filename = fileoptn(4);

 end

elseif mode == 4, % Save As...

 set(stat_bar,'string','Specify a *.tut file to Save to');
 [filename,pathname] = uiputfile('*.tut',['Save As...',win_str]);

 if filename,
  set(ui_han(47),'userdata',0);
  for k = 1:3,
   kstr = int2str(k);
   eval(['plant',kstr,'_mat = get(ui_han(3+k),''userdata'');']);
   eval(['for',kstr,'_mat = get(ui_han(6+k),''userdata'');']);
   eval(['bac',kstr,'_mat = get(ui_han(9+k),''userdata'');']);
  end

  for k = 13:24,
   kstr = int2str(k);
   eval(['mat',kstr,' = get(ui_han(k),''userdata'');']);
  end

  cur_sys = get(ui_han(30),'userdata');
  cur_page = get(ui_han(31),'userdata');
  sys_state = get(ui_han(33),'userdata');
  page_setup = get(ui_han(34),'userdata');

  set(stat_bar,'string',['Saving to ',pathname,filename]);
  eval(['save ',pathname,filename,' plant1_mat for1_mat bac1_mat plant2_mat ',...
              'for2_mat bac2_mat plant3_mat for3_mat bac3_mat cur_sys ',...
              'mat13 mat14 mat15 mat16 mat17 mat18 mat19 mat20 mat21 mat22 ',...
              'mat23 mat24 cur_page sys_state page_setup -mat']);
  set(save_opt,'userdata',[pathname,filename]);
  set(f,'name',['Controls Tutor - [',pathname,filename,']']);

 end

elseif mode == 5, % Print

 set(stat_bar,'string','Printing...');
 mtitl = get(ui_han(11),'title');
 stitl = get(ui_han(12),'title');
 lab_txt = get(ui_han(44),'userdata');

 set(mtitl,'string',get(lab_txt(2),'string'),'erase','xor','vis','on');
 set(stitl,'string',get(lab_txt(3),'string'),'erase','xor','vis','on');

 print -noui

 set([mtitl,stitl],'vis','off');

 set(stat_bar,'string','Printing completed');

elseif any(mode == [6,12]), % Exit

 if mode == 12,
  filename = fileoptn(3);
 else
  filename = 1;
 end

 if ~filename, return; end

 set(stat_bar,'string','Exiting Controls Tutor...Y''all come back now');
 pause(1);

 [flag,fig] = figflag(['Frequency...',win_str],1);
 if flag, close(fig); end

 [flag,fig] = figflag(['Gain...',win_str],1);
 if flag, close(fig); end

 [flag,fig] = figflag(['Time...',win_str],1);
 if flag, close(fig); end

 [flag,fig] = figflag(['Out to Workspace...',win_str],1);
 if flag, close(fig); end

 [flag,fig] = figflag(['In From Workspace...',win_str],1);
 if flag, close(fig); end

 [flag,fig] = figflag(['Page Layout...',win_str],1);
 if flag, close(fig); end

 [flag,fig] = figflag(['Axis Limits',win_str],1);
 if flag, close(fig); end

 [flag,fig] = figflag(['Controls Tutor Help',win_str],1);
 if flag, close(fig); end

 close(f);

elseif any(mode == [7,8,9]),

 file_mod = get(ui_han(47),'userdata');

 if file_mod,
  scrn_size = get(0,'screensize');
  center = scrn_size(3:4)/2;
  figure('pos',[center(1)-175,center(2)-55,350,110],'menubar','none',...
         'color',[0.8,0.8,0.8],'numbertitle','off','name',['Controls Tutor',win_str],...
         'resize','off');
  r = exp(i*[0:0.1:2*pi]);
  x = real(r); y = imag(r);
  axes('pos',[-0.13,0.4,0.5,0.5],'vis','off','xlim',[-1,1],'ylim',[-1,1],...
       'nextplot','add');
  axis square;
  fill(x,y,'y');
  text(0,0.1,'?','fontname','times','fontweight','bold','fontsize',56,...
       'horiz','center','color','k');
  han(1) = uicontrol('style','text','pos',[75,50,265,40],'backgroundcolor',[0.8,0.8,0.8],...
            'horiz','left');
  han(2) = uicontrol('style','push','pos',[79,10,60,20],'string','Yes');
  han(3) = uicontrol('style','push','pos',[145,10,60,20],'string','No');
  uicontrol('style','push','pos',[211,10,60,20],'string','Cancel',...
            'callback','close');

  file_path = get(save_opt,'userdata');
  if mode == 7, % New
   set(han(1),'string',[file_path,' has changed.  Save before closing?']);
   set(han(2),'callback','close;fileoptn(10);');
   set(han(3),'callback','close;fileoptn(1);');
  elseif mode == 8, % Open
   set(han(1),'string',[file_path,' has changed.  Save before closing?']);
   set(han(2),'callback','close;fileoptn(11);');
   set(han(3),'callback','close;fileoptn(2);');
  elseif mode == 9, % Exit
   set(han(1),'string',[file_path,' has changed.  Save before exiting?']);
   set(han(2),'callback','close;fileoptn(12);');
   set(han(3),'callback','close;fileoptn(6);');
  end
 elseif mode == 7, % New
  fileoptn(1);
 elseif mode == 8, % Open
  fileoptn(2);
 elseif mode == 9, % Exit
  fileoptn(6);
 end

elseif mode == 23,

   msgbox({'Controls Tutor',...
           'Version 1.0',...
           '01-Jan-1999',...
           'Copyright (c) 1999, Prentice-Hall',...
           ' ',...
           'If you encounter any problems or have',...
           'comments, please contact Terasoft, Inc.',...
           'at the appropriate E-mail:',...
           ' ',...
           'info@terasoft.com',...
           'suggest@terasoft.com',...
           'support@terasoft.com',...
           'bugs@terasoft.com'},...
           'About');

end