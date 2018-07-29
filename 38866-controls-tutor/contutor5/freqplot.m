function freqplot(axs_hand,mode)
% FREQPLOT Frequency response plotting.
%          FREQPLOT handles the plotting of all graphs involved with
%          frequency.

% Author: Craig Borghesani
% Date: 8/8/94
% Revised: 10/18/94, 11/16/94, 12/10/94
% Copyright (c) 1999, Prentice-Hall

% mode represents all the options for frequency response.
% mode = 13, switching systems
% mode = 14, switching pages
% mode = 15, changing layouts

% if no frequency plots on current page, dont do anything
if ~length(axs_hand), return; end

% obtain handle information
f = gcf;
ui_data = get(f,'userdata');
ui_han = ui_data{1};

% current plant response
cur_sys   = get(ui_han(30),'userdata');
oth_sys   = [1:(cur_sys-1),(cur_sys+1):3];
plant_mat = get(ui_han(3+cur_sys),'userdata');
for_mat   = get(ui_han(6+cur_sys),'userdata');
bac_mat   = get(ui_han(9+cur_sys),'userdata');
sys_res   = get(ui_han(cur_sys),'userdata');
font_size = get(ui_han(42),'userdata');
stat_bar  = get(ui_han(43),'userdata');
cur_axs   = get(ui_han(32),'userdata');
w         = sys_res(1,:);
sys_cplx  = sys_res(2,:);

sys_axes  = ui_han(12);
show_all  = ui_han(25);
open_loop = ui_han(60);
clos_loop = ui_han(61);
exact     = ui_han(62);
straight  = ui_han(63);
margins   = ui_han(64);
range1    = 60:61;
range2    = 62:64;
fontname = 'times';

% extract data stored in axis handles
axs_data = [];
for k = 1:length(axs_hand),
 axs_data = [axs_data;get(axs_hand(k),'userdata')];
end
nyq = find(axs_data(:,1)==1);
bodm = find(axs_data(:,1)==2);
bodp = find(axs_data(:,1)==3);
nic = find(axs_data(:,1)==4);

if length(mode) & any(mode == [1,2]),

 if mode == 1, % open loop
  if strcmp(get(open_loop,'checked'),'on'),
   set(open_loop,'checked','off');
  else
   set(open_loop,'checked','on');
  end
 end

 if mode == 2, % closed loop
  if strcmp(get(clos_loop,'checked'),'on'),
   set(clos_loop,'checked','off');
  else
   set(clos_loop,'checked','on');
  end
 end

 ct = 2;
 for k = range2,
  if strcmp(get(ui_han(k),'checked'),'on') & ...
     strcmp(get(ui_han(k),'enable'),'on'),
   mode(ct) = k-(range1(1)-1);
  else
   mode(ct) = 0;
  end
  ct = ct + 1;
 end

elseif length(mode) & any(mode == [3,4,5]),

 ct = 2;
 for k = range1,
  if strcmp(get(ui_han(k),'checked'),'on') & ...
     strcmp(get(ui_han(k),'enable'),'on'),
   mode(ct) = k-(range1(1)-1);
  else
   mode(ct) = 0;
  end
  ct = ct + 1;
 end

end

if length(mode) < 2,
 if ~length(mode) | any(mode == [12:15]),

% determine various states of frequency response environments
  if ~length(mode), mode = 0; end
  ct = 2;
  for k = [range1,range2],
   if strcmp(get(ui_han(k),'checked'),'on') & ...
      strcmp(get(ui_han(k),'enable'),'on'),
    mode(ct) = k-(range1(1)-1);
   else
    mode(ct) = 0;
   end
   ct = ct + 1;
  end

 end
end

open_flag = strcmp(get(open_loop,'checked'),'on');
clos_flag = strcmp(get(clos_loop,'checked'),'on');
show_flag = strcmp(get(show_all,'label'),'Show All Systems');
hide_flag = strcmp(get(show_all,'label'),'Hide Other Systems');

if clos_flag,
 bac_cplx = termcplx(bac_mat,w);
 tmp_cplx = sys_cplx./bac_cplx;
 clos_cplx = tmp_cplx./(1+sys_cplx);
end

mode_len = 3;
if length(mode) == 3 & hide_flag,
 mode = [mode,14];
 mode_len = 4;
end

if any(mode==3), % exact plot

 if strcmp(get(exact,'checked'),'off') | length(mode)>mode_len,
  set(exact,'checked','on');

  if length(nyq), % nyquist plot

% update current system frequency response
   if all(mode ~= 12),

% switching systems
    if any(mode == 13) & show_flag,
     set(axs_data(nyq,1+oth_sys),'vis','off');
     set(axs_data(nyq,4+oth_sys),'vis','off');
    elseif any(mode == 13),
     if open_flag,
      set(axs_data(nyq,1+oth_sys),'color','r');
      set(axs_data(nyq,4+oth_sys),'color','b');
     end
%     if clos_flag,
%      set(axs_data(nyq,4+oth_sys),'color','b');
%     end
    end

    if open_flag & any(mode == 1),
     set(stat_bar,'string','Computing exact open-loop frequency response');
     rl = real(sys_cplx);  im = imag(sys_cplx);
     set(axs_data(nyq,1+cur_sys),'xdata',rl,'ydata',im,...
           'color','g','vis','on');
     set(axs_data(nyq,4+cur_sys),'xdata',rl,'ydata',-im,...
           'color','m','vis','on');
    elseif any(mode == 1),
     set(stat_bar,'string','Removing exact open-loop frequency response');
     set(axs_data(nyq,1+cur_sys),'vis','off');
     set(axs_data(nyq,4+cur_sys),'vis','off');
    end

%    if clos_flag,
%     ers = 'norm';
%     if ~open_flag, ers = 'xor'; end
%     rl = real(clos_cplx);  im = imag(clos_cplx);
%     set(axs_data(nyq,4+cur_sys),'xdata',rl,'ydata',im,...
%           'color','m','vis','on');
%    elseif any(mode == 2),
%     set(axs_data(nyq,4+cur_sys),'vis','off');
%    end

   end

% switching pages or requesting to veiw all systems
   if (any(mode == 12) & show_flag) | (any(mode == 14) & hide_flag) | ...
      (any(mode == 15) & hide_flag),

    for k = 1:2,
     oth_res = get(ui_han(oth_sys(k)),'userdata');
     oth_cplx = oth_res(2,:);

%     if clos_flag,
%      oth_bac = get(ui_han(9+oth_sys(k)),'userdata');
%      bac_cplx = termcplx(oth_bac,w);
%      tmp_cplx = oth_cplx./bac_cplx;
%      oth_clos = tmp_cplx./(1+oth_cplx);
%     end

     if open_flag,
      rl=real(oth_cplx); im=imag(oth_cplx);
      set(axs_data(nyq,1+oth_sys(k)),'xdata',rl,'ydata',im,...
                'color','r','vis','on','erase','norm');
      set(axs_data(nyq,4+oth_sys(k)),'xdata',rl,'ydata',-im,...
            'color','b','vis','on');
     end

%     if clos_flag,
%      rl=real(oth_clos); im=imag(oth_clos);
%      set(axs_data(nyq,4+oth_sys(k)),'xdata',rl,'ydata',im,...
%                'color','b','vis','on','erase','norm');
%     end
    end

   elseif any(mode == 12) | any(mode == 14) | any(mode == 15),

    set(axs_data(nyq,1+oth_sys),'vis','off');
    set(axs_data(nyq,4+oth_sys),'vis','off');

   end

   if any(mode == 15), % setting axis limits to full after page layout
    pageview(1,axs_hand(nyq));
   end

  end

  if length(bodm), % bode (magnitude) plot

% update current system frequency response
   if all(mode~=12),

% switching systems
    if any(mode == 13) & show_flag,
     set(axs_data(bodm,1+oth_sys),'vis','off');
     set(axs_data(bodm,4+oth_sys),'vis','off');
    elseif any(mode == 13),
     if open_flag,
      set(axs_data(bodm,1+oth_sys),'color','r');
     end
     if clos_flag,
      set(axs_data(bodm,4+oth_sys),'color','b');
     end
    end

    if open_flag & any(mode == 1),
     set(stat_bar,'string','Computing exact open-loop frequency response');
     wdb = w;
     db = 20*log10(abs(sys_cplx));
     set(axs_data(bodm,1+cur_sys),'xdata',wdb,'ydata',db,...
           'color','g','vis','on');
    elseif any(mode == 1),
     set(stat_bar,'string','Removing exact open-loop frequency response');
     set(axs_data(bodm,1+cur_sys),'vis','off');
    end

    if clos_flag & any(mode == 2),
     set(stat_bar,'string','Computing exact closed-loop frequency response');
     ers = 'norm';
     if ~open_flag, ers = 'norm'; end
     wdb = w;
     db = 20*log10(abs(clos_cplx));
     set(axs_data(bodm,4+cur_sys),'xdata',wdb,'ydata',db,...
           'color','m','vis','on');
    elseif any(mode == 2),
     set(stat_bar,'string','Removing exact closed-loop frequency response');
     set(axs_data(bodm,4+cur_sys),'vis','off');
    end

   end

% switching pages or requesting to veiw all systems
   if (any(mode == 12) & show_flag) | (any(mode == 14) & hide_flag) | ...
      (any(mode == 15) & hide_flag),

    for k = 1:2,
     oth_res = get(ui_han(oth_sys(k)),'userdata');
     oth_w = oth_res(1,:);
     oth_cplx = oth_res(2,:);

     if clos_flag,
      oth_bac = get(ui_han(9+oth_sys(k)),'userdata');
      bac_cplx = termcplx(oth_bac,w);
      tmp_cplx = oth_cplx./bac_cplx;
      oth_clos = tmp_cplx./(1+oth_cplx);
     end

     if open_flag,
      wdb = oth_w;
      db = 20*log10(abs(oth_cplx));
      set(axs_data(bodm,1+oth_sys(k)),'xdata',wdb,'ydata',db,'color','r',...
                                    'vis','on','erase','norm');
     end

     if clos_flag,
      wdb = oth_w;
      db = 20*log10(abs(oth_clos));
      set(axs_data(bodm,1+oth_sys(k)),'xdata',wdb,'ydata',db,'color','b',...
                                    'vis','on','erase','norm');
     end
    end

   elseif any(mode == 12) | any(mode == 14) | any(mode == 15),

    set(axs_data(bodm,1+oth_sys),'vis','off');
    set(axs_data(bodm,4+oth_sys),'vis','off');

   end

   if any(mode == 15), % setting axis limits to full after page change
    pageview(1,axs_hand(bodm));
   end

  end

  if length(bodp), % bode (phase) plot

   axsp=[get(axs_hand(bodp),'xlim'),get(axs_hand(bodp),'ylim')];

% update current system frequency response
   if all(mode~=12),

% switching systems
    if any(mode == 13) & show_flag,
     set(axs_data(bodp,1+oth_sys),'vis','off');
     set(axs_data(bodp,4+oth_sys),'vis','off');
    elseif any(mode == 13),
     if open_flag,
      set(axs_data(bodp,1+oth_sys),'color','r');
     end
     if clos_flag,
      set(axs_data(bodp,4+oth_sys),'color','b');
     end
    end

    wph = w;
    if open_flag & any(mode == 1),
     set(stat_bar,'string','Computing exact open-loop frequency response');
     ph = phasecor(sys_cplx,[-360,0]);

     brk=find(abs(diff(ph))>170);
     t=1; pht=[]; wpht=[];
     for k=brk,
      pht=[pht,ph(t:k),NaN];
      wpht=[wpht,wph(t:k),NaN];
      t=k+1;
     end
     pht=[pht,ph(t:length(ph))];
     wpht=[wpht,wph(t:length(wph))];

% update current system frequency response
     set(axs_data(bodp,1+cur_sys),'xdata',wpht,'ydata',pht,...
          'color','g','vis','on');
    elseif any(mode == 1),
     set(stat_bar,'string','Removing exact open-loop frequency response');
     set(axs_data(bodp,1+cur_sys),'vis','off');
    end

    if clos_flag & any(mode == 2),
     set(stat_bar,'string','Computing exact closed-loop frequency response');
     ers = 'norm';
     if ~open_flag, ers = 'norm'; end

     ph = phasecor(clos_cplx,[-360,0]);

     brk=find(abs(diff(ph))>170);
     t=1; pht=[]; wpht=[];
     for k=brk,
      pht=[pht,ph(t:k),NaN];
      wpht=[wpht,wph(t:k),NaN];
      t=k+1;
     end
     pht=[pht,ph(t:length(ph))];
     wpht=[wpht,wph(t:length(wph))];

% update current system frequency response
     set(axs_data(bodp,4+cur_sys),'xdata',wpht,'ydata',pht,...
          'color','m','vis','on');
    elseif any(mode == 2),
     set(stat_bar,'string','Removing exact closed-loop frequency response');
     set(axs_data(bodp,4+cur_sys),'vis','off');
    end

   end

% switching pages or requesting to veiw all systems
   if (any(mode == 12) & show_flag) | (any(mode == 14) & hide_flag) | ...
      (any(mode == 15) & hide_flag),

    for k = 1:2,
     oth_res = get(ui_han(oth_sys(k)),'userdata');
     oth_w = oth_res(1,:);
     oth_cplx = oth_res(2,:);

     if clos_flag,
      oth_bac = get(ui_han(9+oth_sys(k)),'userdata');
      bac_cplx = termcplx(oth_bac,w);
      tmp_cplx = oth_cplx./bac_cplx;
      oth_clos = tmp_cplx./(1+oth_cplx);
     end

     wph = oth_w;
     if open_flag,
      ph = phasecor(oth_cplx,[-360,0]);

      brk=find(abs(diff(ph))>170);
      t=1; pht=[]; wpht=[];
      for k2=brk,
       pht=[pht,ph(t:k2),NaN];
       wpht=[wpht,wph(t:k2),NaN];
       t=k2+1;
      end
      pht=[pht,ph(t:length(ph))];
      wpht=[wpht,wph(t:length(wph))];

      set(axs_data(bodp,1+oth_sys(k)),'xdata',wpht,'ydata',pht,'color','r',...
                                    'vis','on','erase','norm');
     end

     if clos_flag,
      ph = phasecor(oth_clos,[-360,0]);

      brk=find(abs(diff(ph))>170);
      t=1; pht=[]; wpht=[];
      for k2=brk,
       pht=[pht,ph(t:k2),NaN];
       wpht=[wpht,wph(t:k2),NaN];
       t=k2+1;
      end
      pht=[pht,ph(t:length(ph))];
      wpht=[wpht,wph(t:length(wph))];

      set(axs_data(bodp,4+oth_sys(k)),'xdata',wpht,'ydata',pht,'color','b',...
                                    'vis','on','erase','norm');
     end

    end
   elseif any(mode == 12) | any(mode == 14) | any(mode == 15),

    set(axs_data(bodp,1+oth_sys),'vis','off');
    set(axs_data(bodp,4+oth_sys),'vis','off');

   end

   if any(mode == 15), % setting axis limits to full after page change
    pageview(1,axs_hand(bodp));
   end

  end

  if length(nic), % nichols plot

   axs = [get(axs_hand(nic),'xlim'),get(axs_hand(nic),'ylim')];

% update current system frequency response
   if all(mode~=12),

% switching systems
    if any(mode == 13) & show_flag,
     set(axs_data(nic,1+oth_sys),'vis','off');
%     set(axs_data(nic,4+oth_sys),'vis','off');
    elseif any(mode == 13),
     if open_flag,
      set(axs_data(nic,1+oth_sys),'color','r');
     end
%     if clos_flag,
%      set(axs_data(nic,4+oth_sys),'color','b');
%     end
    end

    if open_flag & any(mode == 1),
     set(stat_bar,'string','Computing exact open-loop frequency response');
     db = 20*log10(abs(sys_cplx));
     ph = phasecor(sys_cplx,[-360,0]);
     brk=find(abs(diff(ph))>170);
     t=1; pht=[]; dbt=[];
     for k=brk,
      pht=[pht,ph(t:k),NaN];
      dbt=[dbt,db(t:k),NaN];
      t=k+1;
     end
     pht=[pht,ph(t:length(ph))];
     dbt=[dbt,db(t:length(db))];

% update current system frequency response
     set(axs_data(nic,1+cur_sys),'xdata',pht,'ydata',dbt,...
           'color','g','vis','on');

    elseif any(mode == 1),
     set(stat_bar,'string','Removing exact open-loop frequency response');
     set(axs_data(nic,1+cur_sys),'vis','off');
    end

%    if clos_flag,
%     ers = 'norm';
%     if ~open_flag, ers = 'norm'; end
%
%     db = 20*log10(abs(clos_cplx));
%     ph = phasecor(clos_cplx,[-360,0]);
%
%     brk=find(abs(diff(ph))>170);
%     t=1; pht=[]; dbt=[];
%     for k=brk,
%      pht=[pht,ph(t:k),NaN];
%      dbt=[dbt,db(t:k),NaN];
%      t=k+1;
%     end
%     pht=[pht,ph(t:length(ph))];
%     dbt=[dbt,db(t:length(db))];

% update current system frequency response
%     set(axs_data(nic,4+cur_sys),'xdata',pht,'ydata',dbt,...
%           'color','m','vis','on');
%    elseif any(mode == 2),
%     set(axs_data(nic,4+cur_sys),'vis','off');
%    end

   end

% switching pages or requesting to veiw all systems
   if (any(mode == 12) & show_flag) | (any(mode == 14) & hide_flag) | ...
      (any(mode == 15) & hide_flag),

    for k = 1:2,
     oth_res = get(ui_han(oth_sys(k)),'userdata');
     oth_w = oth_res(1,:);
     oth_cplx = oth_res(2,:);

%     if clos_flag,
%      oth_bac = get(ui_han(9+oth_sys(k)),'userdata');
%      bac_cplx = termcplx(oth_bac,w);
%      tmp_cplx = oth_cplx./bac_cplx;
%      oth_clos = tmp_cplx./(1+oth_cplx);
%     end

     if open_flag,
      db = 20*log10(abs(oth_cplx));
      ph = phasecor(oth_cplx,[-360,0]);

      brk=find(abs(diff(ph))>170);
      t=1; pht=[]; dbt=[];
      for k2=brk,
       pht=[pht,ph(t:k2),NaN];
       dbt=[dbt,db(t:k2),NaN];
       t=k2+1;
      end
      pht=[pht,ph(t:length(ph))];
      dbt=[dbt,db(t:length(db))];

      set(axs_data(nic,1+oth_sys(k)),'xdata',pht,'ydata',dbt,'color','r',...
                                    'vis','on','erase','norm');
     end

%     if clos_flag,
%      db = 20*log10(abs(oth_clos));
%      ph = phasecor(oth_clos,[-360,0]);
%
%      brk=find(abs(diff(ph))>170);
%      t=1; pht=[]; dbt=[];
%      for k2=brk,
%       pht=[pht,ph(t:k2),NaN];
%       dbt=[dbt,db(t:k2),NaN];
%       t=k2+1;
%      end
%      pht=[pht,ph(t:length(ph))];
%      dbt=[dbt,db(t:length(db))];
%
%      set(axs_data(nic,4+oth_sys(k)),'xdata',pht,'ydata',dbt,'color','b',...
%                                    'vis','on','erase','norm');
%     end

    end
   elseif any(mode == 12) | any(mode == 14) | any(mode == 15),

    set(axs_data(nic,1+oth_sys),'vis','off');
%    set(axs_data(nic,4+oth_sys),'vis','off');

   end

   if any(mode == 15), % setting axis limits to full after page change
    pageview(1,axs_hand(nic));
   end

  end
 else

  set(stat_bar,'string','Removing exact frequency response');
  set(axs_data(:,2:7),'vis','off');
  set(exact,'checked','off');

 end
end

if any(mode == 4), % straight line approximation of bode

 if strcmp(get(straight,'checked'),'off') | length(mode)>mode_len,

  if length(bodm) | length(bodp),
   set(straight,'checked','on');
   if clos_flag,
    [nump,denp] = termextr(plant_mat);
    [numg,deng] = termextr(for_mat);
    [numh,denh] = termextr(bac_mat);
    numcl = conv(conv(nump,numg),denh);
    num = conv(conv(nump,numg),numh);
    den = conv(conv(denp,deng),denh);
    ln = length(num); ld = length(den);
    num = [zeros(1,ld-ln),num];
    den = [zeros(1,ln-ld),den];
    dencl = den + num;
    clos_mat = termpars(numcl,dencl);
   end
  end
  term_mat = termjoin(plant_mat,for_mat,bac_mat);

  if length(bodm), % bode (magnitude)

   if all(mode~=12),

% switching systems
    if any(mode == 13) & show_flag,
     set(axs_data(bodm,7+oth_sys),'vis','off');
     set(axs_data(bodm,10+oth_sys),'vis','off');
    elseif any(mode == 13),
     if open_flag,
      set(axs_data(bodm,7+oth_sys),'color','c');
     end
     if clos_flag,
      set(axs_data(bodm,10+oth_sys),'color','c');
     end
    end

    if open_flag & any(mode == 1),
     set(stat_bar,'string','Computing open-loop straight-line approximation');
     [frq_mag,st_mag]=straitln(term_mat,w,1);
     set(axs_data(bodm,7+cur_sys),'xdata',frq_mag,'ydata',st_mag,...
            'color','r','vis','on');
    elseif any(mode==1),
     set(stat_bar,'string','Removing open-loop straight-line approximation');
     set(axs_data(bodm,7+cur_sys),'vis','off');
    end

    if clos_flag & any(mode == 2),
     set(stat_bar,'string','Computing closed-loop straight-line approximation');
     [frq_mag,st_mag]=straitln(clos_mat,w,1);
     set(axs_data(bodm,10+cur_sys),'xdata',frq_mag,'ydata',st_mag,...
            'color','r','vis','on');
    elseif any(mode==2),
     set(stat_bar,'string','Removing closed-loop straight-line approximation');
     set(axs_data(bodm,10+cur_sys),'vis','off');
    end

   end

% switching pages or requesting to veiw all systems
   if (any(mode == 12) & show_flag) | (any(mode == 14) & hide_flag),

    for k = 1:2,
     oth_res = get(ui_han(oth_sys(k)),'userdata');
     oth_w = oth_res(1,:);

     if open_flag,
      oth_plant = get(ui_han(3+oth_sys(k)),'userdata');
      oth_for = get(ui_han(6+oth_sys(k)),'userdata');
      oth_bac = get(ui_han(9+oth_sys(k)),'userdata');
      oth_open = termjoin(oth_plant,oth_for,oth_bac);

      [frq_mag,st_mag]=straitln(oth_open,oth_w,1);

      set(axs_data(bodm,7+oth_sys(k)),'xdata',frq_mag,'ydata',st_mag,...
              'color','c','vis','on');
     end

     if clos_flag,
      [nump,denp] = termextr(oth_plant);
      [numg,deng] = termextr(oth_for);
      [numh,denh] = termextr(oth_bac);
      numcl = conv(conv(nump,numg),denh);
      num = conv(conv(nump,numg),numh);
      den = conv(conv(denp,deng),denh);
      ln = length(num); ld = length(den);
      num = [zeros(1,ld-ln),num];
      den = [zeros(1,ln-ld),den];
      dencl = den + num;
      oth_clos = termpars(numcl,dencl);

      [frq_mag,st_mag]=straitln(oth_clos,oth_w,1);

      set(axs_data(bodm,7+oth_sys(k)),'xdata',frq_mag,'ydata',st_mag,...
              'color','c','vis','on');
     end
    end

   elseif any(mode == 12) | any(mode == 14),

    set(axs_data(bodm,7+oth_sys),'vis','off');
    set(axs_data(bodm,10+oth_sys),'vis','off');

   end

  end

  if length(bodp), % bode (phase)

   if all(mode~=12),

% switching systems
    if any(mode == 13) & show_flag,
     set(axs_data(bodp,7+oth_sys),'vis','off');
     set(axs_data(bodp,10+oth_sys),'vis','off');
    elseif any(mode == 13),
     if open_flag,
      set(axs_data(bodp,7+oth_sys),'color','c');
     end
     if clos_flag,
      set(axs_data(bodp,10+oth_sys),'color','c');
     end
    end

    if open_flag & any(mode == 1),
     set(stat_bar,'string','Computing open-loop straight-line phase approximation');
     [frq_mag,st_mag]=straitln(term_mat,w,2);
     set(axs_data(bodp,7+cur_sys),'xdata',frq_mag,'ydata',st_mag,...
            'color','r','vis','on');
    elseif any(mode==1),
     set(stat_bar,'string','Removing open-loop straight-line phase approximation');
     set(axs_data(bodp,7+cur_sys),'vis','off');
    end

    if clos_flag & any(mode == 2),
     set(stat_bar,'string','Computing closed-loop straight-line phase approximation');
     [frq_mag,st_mag]=straitln(clos_mat,w,2);
     set(axs_data(bodp,10+cur_sys),'xdata',frq_mag,'ydata',st_mag,...
            'color','r','vis','on');
    elseif any(mode==2),
     set(stat_bar,'string','Removing closed-loop straight-line phase approximation');
     set(axs_data(bodp,10+cur_sys),'vis','off');
    end

   end

% switching pages or requesting to veiw all systems
   if (any(mode == 12) & show_flag) | (any(mode == 14) & hide_flag),

    for k = 1:2,
     oth_res = get(ui_han(oth_sys(k)),'userdata');
     oth_w = oth_res(1,:);

     if open_flag,
      oth_plant = get(ui_han(3+oth_sys(k)),'userdata');
      oth_for = get(ui_han(6+oth_sys(k)),'userdata');
      oth_bac = get(ui_han(9+oth_sys(k)),'userdata');
      oth_open = termjoin(oth_plant,oth_for,oth_bac);

      [frq_mag,st_mag]=straitln(oth_open,oth_w,2);

      set(axs_data(bodp,7+oth_sys(k)),'xdata',frq_mag,'ydata',st_mag,...
              'color','c','vis','on');
     end

     if clos_flag,
      [nump,denp] = termextr(oth_plant);
      [numg,deng] = termextr(oth_for);
      [numh,denh] = termextr(oth_bac);
      numcl = conv(conv(nump,numg),denh);
      num = conv(conv(nump,numg),numh);
      den = conv(conv(denp,deng),denh);
      ln = length(num); ld = length(den);
      num = [zeros(1,ld-ln),num];
      den = [zeros(1,ln-ld),den];
      dencl = den + num;
      oth_clos = termpars(numcl,dencl);

      [frq_mag,st_mag]=straitln(oth_clos,oth_w,2);

      set(axs_data(bodp,7+oth_sys(k)),'xdata',frq_mag,'ydata',st_mag,...
              'color','c','vis','on');
     end
    end

   elseif any(mode == 12) | any(mode == 14),

    set(axs_data(bodp,7+oth_sys),'vis','off');
    set(axs_data(bodp,10+oth_sys),'vis','off');

   end

  end

 else

  set(stat_bar,'string','Removing straight-line approximation');
  set(axs_data([bodm,bodp],8:13),'vis','off');
  set(straight,'checked','off');

 end

end

if any(mode == 5), % margins

 if (strcmp(get(margins,'checked'),'off') | length(mode)>mode_len) & open_flag,
  set(margins,'checked','on');

  set(stat_bar,'string','Displaying margins');

  if all(mode ~= 12),
   db = 20*log10(abs(sys_cplx));
   deg = phase4(sys_cplx)*180/pi;
   [Gm,Wcg,Pm,Wcp] = termmarg(db,deg,w);
  end

% switching pages or requesting to veiw all systems
  if (any(mode == 12) & show_flag) | ...
     (any(mode == 14) & hide_flag),

   for k = 1:2,
    oth_res = get(ui_han(oth_sys(k)),'userdata');
    oth_w = oth_res(1,:);
    oth_cplx = oth_res(2,:);
    db = 20*log10(abs(oth_cplx));
    deg = phase4(oth_cplx)*180/pi;
    [oGm,oWcg,oPm,oWcp] = termmarg(db,deg,oth_w);
    oth_Gm(k) = oGm; oth_Wcg(k) = oWcg;
    oth_Pm(k) = oPm; oth_Wcp(k) = oWcp;
   end
  end

  if length(nyq), % nyquist gain and phase margins

   if all(mode ~= 12),

% switching systems
    if any(mode == 13) & show_flag,
     set(axs_data(nyq,7+oth_sys),'vis','off');
     set(axs_data(nyq,10+oth_sys),'vis','off');
    elseif any(mode == 13),
     set(axs_data(nyq,7+oth_sys),'color','c');
     set(axs_data(nyq,10+oth_sys),'color','c');
    end

    if ~isnan(Wcg),
     set(axs_data(nyq,7+cur_sys),'xdata',[-1,-1/Gm],'ydata',[0,0],...
            'color','k','vis','on');
    else
     set(axs_data(nyq,7+cur_sys),'xdata',0,'ydata',0,'vis','off');
    end

    if ~isnan(Wcp),
     set(axs_data(nyq,10+cur_sys),...
               'xdata',[0,real(exp(i*(-180+Pm)*pi/180))],...
               'ydata',[0,imag(exp(i*(-180+Pm)*pi/180))],...
               'color','k','vis','on');
    else
     set(axs_data(nyq,10+cur_sys),'xdata',0,'ydata',0,'vis','off');
    end

   end

   if (any(mode == 12) & show_flag) | ...
      (any(mode == 14) & hide_flag),

    for k = 1:2,
     if ~isnan(oth_Wcg(k)),
      set(axs_data(nyq,7+oth_sys(k)),'xdata',[-1,-1/oth_Gm(k)],'ydata',[0,0],...
            'color','c','vis','on');
     else
      set(axs_data(nyq,7+oth_sys(k)),'xdata',0,'ydata',0,'vis','off');
     end

     if ~isnan(oth_Wcp(k)),
      set(axs_data(nyq,10+oth_sys(k)),...
                'xdata',[0,real(exp(i*(-180+oth_Pm(k))*pi/180))],...
                'ydata',[0,imag(exp(i*(-180+oth_Pm(k))*pi/180))],...
                'color','c','vis','on');
     else
      set(axs_data(nyq,10+oth_sys(k)),'xdata',0,'ydata',0,'vis','off');
     end

    end

   elseif any(mode == 12) | any(mode == 14),

    set(axs_data(nyq,7+oth_sys),'vis','off');
    set(axs_data(nyq,10+oth_sys),'vis','off');

   end
  end

  if length(bodm), % bode (magnitude)

   if all(mode ~= 12),

% switching systems
    if any(mode == 13) & show_flag,
     set(axs_data(bodm,13+oth_sys),'vis','off');
    elseif any(mode == 13),
     set(axs_data(bodm,13+oth_sys),'color','c');
    end

    if ~isnan(Wcg),
     set(axs_data(bodm,13+cur_sys),'xdata',[Wcg,Wcg],'ydata',[0,-20*log10(Gm)],...
      'color','k','vis','on');
    else
     set(axs_data(bodm,13+cur_sys),'xdata',0,'ydata',0,'vis','off');
    end

   end

   if (any(mode == 12) & show_flag) | ...
      (any(mode == 14) & hide_flag),

    for k = 1:2,
     if ~isnan(oth_Wcg),
      set(axs_data(bodm,13+oth_sys(k)),'xdata',[oth_Wcg(k),oth_Wcg(k)],...
                  'ydata',[0,-20*log10(oth_Gm(k))],...
                  'color','c','vis','on');
     else
      set(axs_data(bodm,13+oth_sys(k)),'xdata',0,'ydata',0,'vis','off');
     end

    end

   elseif any(mode == 12) | any(mode == 14),

    set(axs_data(bodm,13+oth_sys),'vis','off');

   end

  end

  if length(bodp), % bode (phase)

   if all(mode ~= 12),

% switching systems
    if any(mode == 13) & show_flag,
     set(axs_data(bodp,13+oth_sys),'vis','off');
    elseif any(mode == 13),
     set(axs_data(bodp,13+oth_sys),'color','c');
    end

    if ~isnan(Wcp),
     set(axs_data(bodp,13+cur_sys),'xdata',[Wcp,Wcp],'ydata',[-180,-180+Pm],...
            'color','k','vis','on');
    else
     set(axs_data(bodp,13+cur_sys),'xdata',0,'ydata',0,'vis','off');
    end

   end

   if (any(mode == 12) & show_flag) | ...
      (any(mode == 14) & hide_flag),

    for k = 1:2,
     if ~isnan(oth_Wcp(k)),
      set(axs_data(bodp,13+oth_sys(k)),...
          'xdata',[oth_Wcp(k),oth_Wcp(k)],'ydata',[-180,-180+oth_Pm(k)],...
          'color','c','vis','on');
     else
      set(axs_data(bodp,13+oth_sys(k)),'xdata',0,'ydata',0,'vis','off');
     end
    end

   elseif any(mode == 12) | any(mode == 14),

    set(axs_data(bodp,13+oth_sys),'vis','off');

   end

  end

  if length(nic), % nichols gain and phase margins

   if all(mode~=12),

% switching systems
    if any(mode == 13) & show_flag,
     set(axs_data(nic,7+oth_sys),'vis','off');
     set(axs_data(nic,10+oth_sys),'vis','off');
    elseif any(mode == 13),
     set(axs_data(nic,7+oth_sys),'color','c');
     set(axs_data(nic,10+oth_sys),'color','c');
    end

    if ~isnan(Wcg),
     set(axs_data(nic,7+cur_sys),'xdata',[-180,-180],...
            'ydata',[0,-20*log10(Gm)],'color','k','vis','on');
    else
     set(axs_data(nic,7+cur_sys),'xdata',0,'ydata',0,'vis','off');
    end

    if ~isnan(Wcp),
     set(axs_data(nic,10+cur_sys),'xdata',[-180,-180+Pm],...
            'ydata',[0,0],'color','k','vis','on');
    else
     set(axs_data(nic,10+cur_sys),'vis','off');
    end

   end

   if (any(mode == 12) & show_flag) | ...
      (any(mode == 14) & hide_flag),

    for k = 1:2,
     if ~isnan(oth_Wcg(k)),
      set(axs_data(nic,7+oth_sys(k)),'xdata',[-180,-180],...
            'ydata',[0,-20*log10(oth_Gm(k))],'color','c','vis','on');
     else
      set(axs_data(nic,7+oth_sys(k)),'xdata',0,'ydata',0,'vis','off');
     end

     if ~isnan(oth_Wcp(k)),
      set(axs_data(nic,10+oth_sys(k)),'xdata',[-180,-180+oth_Pm(k)],...
             'ydata',[0,0],'color','c','vis','on');
     else
      set(axs_data(nic,10+oth_sys(k)),'xdata',0,'ydata',0','vis','off');
     end
    end

   elseif any(mode == 12) | any(mode == 14),

    set(axs_data(nic,7+oth_sys),'vis','off');
    set(axs_data(nic,10+oth_sys),'vis','off');

   end

  end

 else

  if open_flag,
   set(stat_bar,'string','Removing margins');
   set(margins,'checked','off');
  end
  set(axs_data(nyq,8:13),'vis','off');
  set(axs_data(bodm,14:16),'vis','off');
  set(axs_data(bodp,14:16),'vis','off');
  set(axs_data(nic,8:13),'vis','off');

 end
end

if any(mode == 12) & show_flag,
 set(show_all,'label','Hide Other Systems');
elseif any(mode == 12),
 set(show_all,'label','Show All Systems');
end