function vectedit(mode1,mode2)
% VECTEDIT Vector editing.
%          VECTEDIT provides the GUI for altering the current frequency,
%          gain, or time vectors.

% Author: Craig Borghesani
% Date: 9/4/94
% Revised:
% Copyright (c) 1999, Prentice-Hall

if mode1 == 0,
 f = gcf;
else
 f2 = gcf;
 f = get(f2,'userdata');
end
ui_data = get(f,'userdata');
ui_han = ui_data{1};
ui_obj = ui_data{2};
cur_sys = get(ui_han(30),'userdata');

stat_bar = get(ui_han(43),'userdata');
win_str = get(ui_han(48),'userdata');
ui_han2 = get(ui_han(52),'userdata');
if length(ui_han2),
 stat_bar2 = ui_han2(9);
end

% define various shades of grey
grey = get(0,'defaultuicontrolbackground');
ltgrey = [0.5,0.5,0.5]*1.5;
dkgrey = [0.5,0.5,0.5]*0.5;

if mode1 == 0,

 if mode2 == 1, fig_title = ['Frequency...',win_str];
 elseif mode2 == 2, fig_title = ['Gain...',win_str];
 elseif mode2 == 3, fig_title = ['Time...',win_str]; end

 if all([figflag(['Frequency...',win_str],0),...
         figflag(['Gain...',win_str],0),....
         figflag(['Time...',win_str],0)]==0),

  f2 = figure('numbertitle','off','menubar','none','color',[0.5,0.5,0.5],...
              'pos',[50,50,340,105],'name','','resize','off',...
              'userdata',f,...
              'color',[0.8,0.8,0.8]);

  del=5;
  ui_han2(1) = uicontrol('style','text','string','',...
            'pos',[10,58+del,70,17],'backgroundcolor',[0.8,0.8,0.8],...
            'horizontalalignment','right');
  ui_han2(2) = uicontrol('style','edit','pos',[80,58+del,50,20],...
               'backgroundcolor','w','horiz','right');
  uicontrol('style','text','string',',','pos',[130,58+del,10,17],...
            'backgroundcolor',[0.8,0.8,0.8]);
  ui_han2(3) = uicontrol('style','edit','pos',[140,58+del,50,20],...
               'backgroundcolor','w','horiz','right');
  uicontrol('style','text','string',',','pos',[190,58+del,10,17],...
            'backgroundcolor',[0.8,0.8,0.8]);
  ui_han2(4) = uicontrol('style','edit','pos',[200,58+del,50,20],...
               'backgroundcolor','w','horiz','right');
  uicontrol('style','text','string',')','pos',[250,58+del,10,17],...
            'backgroundcolor',[0.8,0.8,0.8],'horizontalalignment','left');
  ui_han2(5) = uicontrol('style','check','pos',[80,20+del,110,20],...
            'string','Auto-Select','value',1,'backgroundcolor',[0.8,0.8,0.8],...
            'callback','vectedit(2)');

  ui_han2(6) = uicontrol('style','push','string','OK','pos',[270,70+del,60,20]);
  ui_han2(7) = uicontrol('style','push','string','Cancel','pos',[270,47+del,60,20],...
               'callback','vectedit(3)');
  ui_han2(8) = uicontrol('style','push','string','Help','pos',[270,21+del,60,20]);

  ui_han2(9) = uicontrol('style','edit','pos',[0,0,340,20],...
             'foregroundcolor','k',...
             'horizontalalignment','left');
  stat_bar2 = ui_han2(9);

  set(ui_han(52),'userdata',ui_han2);

 end

 f2 = gcf;
 figure(f2);

 set(f2,'name',fig_title);
 set(ui_han2(6),'callback',['vectedit(1,',int2str(mode2),')']);

 if any(mode2 == [1,2]), set(ui_han2(1),'string','logspace(');
 else set(ui_han2(1),'string','linspace('); end

 auto_sel = get(ui_han(41),'userdata');
 if mode2 == 2 & auto_sel, set(ui_han2(5),'enable','on');
 elseif mode2 == 2, set(ui_han2(5),'enable','off','value',0);
 else set(ui_han2(5),'enable','off'); end

 if mode2 == 1,

  sys_res = get(ui_han(cur_sys),'userdata');
  w = sys_res(1,:);
  first = log10(w(1));
  last = log10(w(length(w)));
  len = length(w);
  set(ui_han2(2:4),'enable','on');
  set(ui_han2(2),'string',num2str(first));
  set(ui_han2(3),'string',num2str(last));
  set(ui_han2(4),'string',num2str(len));
  set(stat_bar2,'string','Enter new values for your frequency vector');
  set(ui_han2(8),'callback','userhelp(9,2)');

 elseif mode2 == 2,

  if ~get(ui_han2(5),'value'),
   kvec = get(ui_han(38),'userdata');
   kvec2 = get(ui_han(39),'userdata');
   if length(kvec2),
    if kvec2(1) == 0,
     first = log10(kvec2(2));
    else
     first = log10(kvec2(1));
    end
    last = log10(kvec2(length(kvec2)));
    len = length(kvec2);
    set(ui_han2(2),'string',num2str(first));
    set(ui_han2(3),'string',num2str(last));
    set(ui_han2(4),'string',num2str(len));
   elseif length(kvec),
    if kvec(1) == 0,
     first = log10(kvec(2));
    else
     first = log10(kvec(1));
    end
    last = log10(kvec(length(kvec)));
    len = length(kvec);
    set(ui_han2(2),'string',num2str(first));
    set(ui_han2(3),'string',num2str(last));
    set(ui_han2(4),'string',num2str(len));
   else
    set(ui_han2(2:4),'string','');
   end
   stat_str = 'Enter new values for your gain vector';
   if get(ui_han(41),'userdata'),
    stat_str = [stat_str,'; Auto-Select OFF'];
   else
    stat_str = [stat_str,'; Auto-Select N/A'];
   end
  else
   set(ui_han2(2:4),'string','');
   stat_str = 'Auto-Select ON';
  end
  set(stat_bar2,'string',stat_str);
  set(ui_han2(8),'callback','userhelp(10,3)');

 elseif mode2 == 3,

  tvec = get(ui_han(40),'userdata');
  first = tvec(1);
  last = tvec(length(tvec));
  len = length(tvec);
  set(ui_han2(2:4),'enable','on');
  set(ui_han2(2),'string',num2str(first));
  set(ui_han2(3),'string',num2str(last));
  set(ui_han2(4),'string',num2str(len));
  set(stat_bar2,'string','Enter new values for your time vector');
  set(ui_han2(8),'callback','userhelp(12,3)');

 end

elseif mode1 == 1,

 first = str2num(get(ui_han2(2),'string'));
 last = str2num(get(ui_han2(3),'string'));
 len = str2num(get(ui_han2(4),'string'));

 if mode2 == 1,
  if length([first,last,len]) == 3,
   if last <= first,
    set(stat_bar2,'string','First value must be less than Last value');
   elseif len <= 3,
    set(stat_bar2,'string','Length must be greater than 3');
   else
    wnew = logspace(first,last,len);
    for k = 1:3,
     plant_mat = get(ui_han(3+k),'userdata');
     for_mat = get(ui_han(6+k),'userdata');
     bac_mat = get(ui_han(9+k),'userdata');
     term_mat = termjoin(plant_mat,for_mat,bac_mat);
     new_res = termcplx(term_mat,wnew);
     term_res = [wnew;new_res;ones(1,len)];
     set(ui_han(k),'userdata',term_res);
    end
    set(f2,'vis','off');
    figure(f);
    pageplot(1,[]);
   end
  else
   set(stat_bar2,'string','You must fill all edit boxes');
  end

 elseif mode2 == 2,

  if ~get(ui_han2(5),'value'),
   if length([first,last,len]) == 3,
    if last <= first,
     set(stat_bar2,'string','First value must be less than Last value');
    elseif len <= 3,
     set(stat_bar2,'string','Length must be greater than 3');
    else
     knew = logspace(first,last,len);
     set(ui_han(39),'userdata',knew);
     set(ui_han(37),'userdata',[]);
     set(f2,'vis','off');
     figure(f);

     pageplot(2,[]);
     pageplot(4,[]);
    end
   else
    set(stat_bar2,'string','You must fill all edit boxes');
   end
  else
   set(ui_han([37:39]),'userdata',[]);
   set(f2,'vis','off');
   figure(f);

   pageplot(2,[]);
   pageplot(4,[]);
  end

 elseif mode2 == 3,

  if length([first,last,len]) == 3,
   if last <= first,
    set(stat_bar2,'string','First value must be less than Last value');
   elseif len <= 3,
    set(stat_bar2,'string','Length must be greater than 3');
   else
    tnew = linspace(first,last,len);
    set(ui_han(40),'userdata',tnew);
    set(f2,'vis','off');
    figure(f);

    pageplot(3,[]);
   end
  else
   set(stat_bar2,'string','You must fill all edit boxes');
  end

 end

elseif mode1 == 2,

 stat_str = 'Enter new values for your gain vector';
 if get(ui_han2(5),'value'),
  stat_str = 'Auto-Select ON';
  set(ui_han2(2:4),'string','','enable','off');
 else
  kvec = get(ui_han(38),'userdata');
  kvec2 = get(ui_han(39),'userdata');
  if length(kvec2),
   if kvec2(1) == 0,
    first = log10(kvec2(2));
   else
    first = log10(kvec2(1));
   end
   last = log10(kvec2(length(kvec2)));
   len = length(kvec2);
   set(ui_han2(2),'string',num2str(first));
   set(ui_han2(3),'string',num2str(last));
   set(ui_han2(4),'string',num2str(len));
  elseif length(kvec),
   if kvec(1) == 0,
    first = log10(kvec(2));
   else
    first = log10(kvec(1));
   end
   last = log10(kvec(length(kvec)));
   len = length(kvec);
   set(ui_han2(2),'string',num2str(first));
   set(ui_han2(3),'string',num2str(last));
   set(ui_han2(4),'string',num2str(len));
  else
   set(ui_han2(2:4),'string','');
  end
  set(ui_han2(2:4),'enable','on');
  stat_str = [stat_str,'; Auto-Select OFF'];
 end
 set(stat_bar2,'string',stat_str);

elseif mode1 == 3,

 set(f2,'vis','off');

end