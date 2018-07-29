function pagelayo
% PAGELAYO Set up graphical objects for Tutor environment.
%          PAGELAYO sets up all the axes, line, and text graphical objects
%          depending upon the desired arrangement.

% Author: Craig Borghesani
% Date: 10/17/94
% Revised: 11/13/94
% Copyright (c) 1999, Prentice-Hall

page_chil = [];

f = gcf;
ui_data = get(f,'userdata');
ui_han = ui_data{1};

page_setup = get(ui_han(34),'userdata');
page_layout = get(ui_han(35),'userdata');
if length(page_layout),
 delete(page_layout(find(page_layout~=0)));
 page_chil = get(ui_han(90),'userdata');
 set(page_chil,'vis','off');
end
page_layout = zeros(4,8);

% locations of axes
scrn_size = get(0,'screensize');
fig_size = get(gcf,'position');
%fig_wdt = scrn_size(3)-10*2;
fig_wdt = fig_size(3);
frm_wdt = 190;
ers = 'xor';

%axs1_l = (frm_wdt+2+60)/fig_wdt;
axs1_l = 0.07;
axs1_b = 0.15;
%axs1_w = 0.97 - axs1_l;
axs1_w = 0.97 - (frm_wdt+2+60)/fig_wdt;
axs1_h = 0.68;

axs2_b = 0.58;
axs2_w = axs1_w/2 - 0.05;
axs2_l = axs1_l + axs2_w + 0.1;
%axs2_h = axs2_w;
axs2_h = 0.26;

if ~length(page_chil),
 for k = 1:8,
  page_chil(k) = uimenu(ui_han(90),'vis','off');
 end
 set(ui_han(90),'userdata',page_chil);
end

page_ct = 0;
for page_num = 1:8,
 lab_tit = [];
 plots = page_setup(:,page_num); plots(find(plots==0)) = [];

 if length(plots)==1,
  axs_pos = [axs1_l,axs1_b,axs1_w,axs1_h];
 elseif length(plots)==2,
  axs_pos = [axs1_l,axs2_b,axs1_w,axs2_h;
             axs1_l,axs1_b,axs1_w,axs2_h];
 elseif length(plots)==3,
  axs_pos = [axs1_l,axs2_b,axs1_w,axs2_h;
             axs1_l,axs1_b,axs2_w,axs2_h;
             axs2_l,axs1_b,axs2_w,axs2_h];
 elseif length(plots)==4,
  axs_pos = [axs1_l,axs2_b,axs2_w,axs2_h;
             axs2_l,axs2_b,axs2_w,axs2_h;
             axs1_l,axs1_b,axs2_w,axs2_h;
             axs2_l,axs1_b,axs2_w,axs2_h];
 else
  break;
 end

 for k = 1:length(plots),
  if any(plots(k)==[2,3,6,7]),
   xscale = 'log';
  else
   xscale = 'linear';
  end
  if plots(k) == 1, % Nyquist
   xlab = 'Real';
   ylab = 'Imaginary';
   titl = 'Nyquist';
   xlim = [-1,1]; ylim = [-1,1];
  elseif plots(k) == 2, % Bode (Magnitude)
   xlab = 'Frequency (rad/sec)';
   ylab = 'Magnitude (dB)';
   titl = 'Bode (Magnitude)';
   xlim = [0.01,1000]; ylim = [-20,20];
  elseif plots(k) == 3, % Bode (Phase)
   xlab = 'Frequency (rad/sec)';
   ylab = 'Phase (degrees)';
   titl = 'Bode (Phase)';
   xlim = [0.01,1000]; ylim = [-360,0];
  elseif plots(k) == 4, % Nichols
   xlab = 'Phase (degrees)';
   ylab = 'Magnitude (dB)';
   titl = 'Nichols';
   xlim = [-360,0]; ylim = [-20,20];
  elseif plots(k) == 5, % Root Locus
   xlab = 'Real';
   ylab = 'Imaginary';
   titl = 'Root Locus';
   xlim = [-1,1]; ylim = [-1,1];
  elseif plots(k) == 6, % Gain (Magnitude)
   xlab = 'K';
   ylab = 'Magnitude';
   titl = 'Gain (Magnitude)';
   xlim = [0.01,1000]; ylim = [0.01,10];
  elseif plots(k) == 7, % Gain (Phase)
   xlab = 'K';
   ylab = 'Phase (degrees)';
   titl = 'Gain (Phase)';
   xlim = [0.01,1000]; ylim = [0,360];
  elseif plots(k) == 8, % Time Response
   xlab = 'Time (seconds)';
   ylab = 'Amplitude';
   titl = 'Time Response';
   xlim = [0,10]; ylim = [0,5];
  end

  axs = axes('vis','off','box','on','pos',axs_pos(k,:),...
             'xscale',xscale,'xgrid','on','ygrid','on',...
             'xlim',xlim,'ylim',ylim,...
             'drawmode','fast',...
             'tag',['1',int2str(plots(k)),'20']);
%             'buttondownfcn',['pagemous(1,',int2str(plots(k)),',10)']);
  XLabelHandle = get(axs,'xlabel');
  YLabelHandle = get(axs,'ylabel');
  TitleHandle  = get(axs,'title');
  set(XLabelHandle,'string',xlab);
  set(YLabelHandle,'string',ylab);
  set(TitleHandle,'string',titl);

  if any(plots(k)==[1,5]),
%   set(axs,'dataaspectratio',[1,1,1]);
   axis equal;
  end

  if any(plots(k)==[1,2,3,4]), % frequency response plots
   clr = 'g';
   lin = [];
   for k2 = 1:15,
    if k2 > 6, clr = 'r'; end
%    if k2 > 3, ers = 'norm'; end
    lin(k2) = line('xdata',0,'ydata',0,'color',clr,'erase',ers,...
                   'vis','off',...
                   'tag',['2',int2str(plots(k)),int2str(k2)]);
%     'buttondownfcn',['pagemous(2,',int2str(plots(k)),',',int2str(k2),')']);
   end
   set(axs,'userdata',[plots(k),lin]);

  elseif any(plots(k) == [5,6,7]), % root locus, gain plots

   set(axs,'userdata',plots(k),'nextplot','add');

   if plots(k) == 6,
    set(axs,'yscale','log');
   end

  else % time response
   clr = ['r';'g';'b';'y';'m';'c'];
   lin = [];
   for k2 = 1:6,
    lin(k2) = line('xdata',0,'ydata',0,'color',clr(k2),...
                   'vis','off',...
                   'erase',ers,...
                   'tag',['1',int2str(plots(k)),int2str(20+k2)]);
%     'buttondownfcn',['pagemous(1,',int2str(plots(k)),',10)']);
   end
   txt = [];
   for k2 = 1:12,
    txt(k2) = text('pos',[0,0,0],'vis','off',...
     'tag',['1',int2str(plots(k)),int2str(26+k2)],'color','k',...
     'erase',ers);
%     'buttondownfcn',['pagemous(1,',int2str(plots(k)),',10)']);
   end
   set(axs,'userdata',[plots(k),lin,txt]);

  end

  page_layout(k,page_num)=axs;
  lab_tit = [lab_tit,titl,', '];

 end

 if length(lab_tit),
  lab_tit((length(lab_tit)-1):length(lab_tit))=[];
  set(page_chil(page_num),'label',lab_tit,'vis','on',...
                   'callback',['pagesele(',int2str(page_num),',14)']);
 end
 page_ct = page_ct + 1;
end

if page_ct < 2,
 set(ui_han(90),'enable','off');
else
 set(ui_han(90),'enable','on');
end

set(ui_han(35),'userdata',page_layout);