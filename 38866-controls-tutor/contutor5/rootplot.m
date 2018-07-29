function rootplot(axs_hand,mode)
%
% Utility Function: ROOTPLOT
%
% The purpose of this function is to handle the different options for
% plotting of the root locus under the Tools menu

% Author: Craig Borghesani
% Date: 8/30/94
% Revised: 10/25/94, 11/15/94
% Copyright (c) 1999, Prentice-Hall

% if no root locus plot on current page, dont do anything
if ~length(axs_hand), return; end

% obtain handle information
f = gcf;
ui_data = get(f,'userdata');
ui_han = ui_data{1};
ui_obj = ui_data{2};
pos_loc    = ui_han(67);
pos_rad    = ui_obj.RootUI(1);
neg_loc    = ui_han(68);
neg_rad    = ui_obj.RootUI(2);
real_loc   = ui_han(69);
real_chk   = ui_obj.RootUI(3);
asymptotes = ui_han(70);
breakaway  = ui_han(71);
imag_cross = ui_han(72);
angles     = ui_han(73);
root_locus = ui_han(74);
closed_rts = ui_han(75);
cur_sys = get(ui_han(30),'userdata');
rt_locus = get(ui_han(37),'userdata');
kvec = get(ui_han(38),'userdata');
kvec2 = get(ui_han(39),'userdata');
range = 67:75;

% set current axis
axes(axs_hand);
xlim = [-1,1]; ylim = [-1,1];

ers = 'xor';
stat_bar = get(ui_han(43),'userdata');
plant_mat = get(ui_han(3+cur_sys),'userdata');
for_mat = get(ui_han(6+cur_sys),'userdata');
bac_mat = get(ui_han(9+cur_sys),'userdata');
term_mat = termjoin(plant_mat,for_mat,bac_mat);

replot_poles = 0;

if ~length(mode) | any(mode == [1,2,13:15]),

 replot_poles = 1;

 if length(mode) & any(mode==1), % positive root locus
  set(stat_bar,'string','Positive Root Locus settings');
  set(pos_loc,'checked','on');
  set(neg_loc,'checked','off');
  set(pos_rad,'value',1);
  set(neg_rad,'value',0);
  rt_locus = [];
  dispfrac
 end

 if length(mode) & any(mode==2), % negative root locus
  set(stat_bar,'string','Negative Root Locus settings');
  set(pos_loc,'checked','off');
  set(neg_loc,'checked','on');
  set(pos_rad,'value',0);
  set(neg_rad,'value',1);
  rt_locus = [];
  dispfrac
 end

% clear all children off of axis
 axes(axs_hand);
 cla;

% determine various states of root locus environment
 if ~length(mode), mode = 0; end
 ct = 2;
 for k = range,
  if strcmp(get(ui_han(k),'checked'),'on'),
   mode(ct) = k-(range(1)-1);
   if k==range(length(range)), mode(3)=0; end
  else
   mode(ct) = 0;
  end
  ct = ct + 1;
 end

end

% obtain all open loop poles and zeros
ol_zeros = []; ol_poles = []; rts = [];
for k = 2:length(term_mat(:,1)),

 if term_mat(k,4) == 2, % integrators/differentiators
  if term_mat(k,1) > 0,
   ol_poles = zeros(term_mat(k,1),1);
  elseif term_mat(k,1) < 0,
   ol_zeros = zeros(-term_mat(k,1),1);
  end
 elseif any(term_mat(k,4) == [4,5]), % real poles/zeros
  rts = -term_mat(k,1);
 elseif any(term_mat(k,4)==[6,7]), % complex poles/zeros
  zeta = term_mat(k,1);
  wn = term_mat(k,2);
  rts = roots([1,2*zeta*wn,wn^2]);
 end

 if any(term_mat(k,4)==[4,6]),
  ol_poles = [ol_poles; rts(:)];
 elseif any(term_mat(k,4)==[5,7]),
  ol_zeros = [ol_zeros; rts(:)];
 end

end

% determine if system is proper or strictly proper
more_zeros = (length(ol_zeros) > length(ol_poles));

% determine whether it is a positive or negative root locus
neg_locus = strcmp(get(neg_loc,'checked'),'on');

% set axis limits so that all poles and zeros can be viewed
all_ele = [ol_poles;ol_zeros];
if length(all_ele),

% plot open-loop poles and zeros
 if replot_poles,
  if length(ol_poles),
   ln1 = line('xdata',real(ol_poles),'ydata',imag(ol_poles),'linestyle','none',...
        'marker','x',...
        'markersize',12,...
        'color','k','erase',ers,'tag','1510',...
        'buttondownfcn','dragele');
%        'color','r','erase',ers,'buttondownfcn','pagemous(1,5,10)');
  end
  if length(ol_zeros),
   ln2 = line('xdata',real(ol_zeros),'ydata',imag(ol_zeros),'linestyle','none',...
        'marker','o',...
        'markersize',12,...
        'color','k','erase',ers,'tag','1510',...
        'buttondownfcn','dragele');
%       'color','b','erase',ers,'buttondownfcn','pagemous(1,5,10)');
  end
%  lins = [ln1,ln2];
%  lims = [1/eps,eps,1/eps,eps];
%  for k = 1:length(lins),
%   xdata = get(lins(k),'xdata');
%   ydata = get(lins(k),'ydata');
%   lims(1) = min([xdata(:);lims(1)]);
%   lims(2) = max([xdata(:);lims(2)]);
%   lims(3) = min([ydata(:);lims(3)]);
%   lims(4) = max([ydata(:);lims(4)]);
%  end
%  set(axs_hand,'xlim',lims(1:2)*1.1+[-1,1],'ylim',lims(3:4)*1.1+[-1,1],...
%               'nextplot','add');

  plot([-1000,1000],[0,0],':k',[0,0],[-1000,1000],':k',...
      'tag','1520');
%      'buttondownfcn','pagemous(1,5,10)');
  designpt(5);

 end

elseif replot_poles,

  plot([-1000,1000],[0,0],':k',[0,0],[-1000,1000],':k',...
      'tag','1520');
%      'buttondownfcn','pagemous(1,5,10)');

end

if more_zeros & any(mode~=9),
 set(stat_bar,'string','More Zeros than Poles.  Only <Closed-Loop Poles> option allowed.');
end

if any(mode==3) & (~more_zeros), % real axis loci

% draw real axis loci
 if strcmp(get(real_loc,'checked'),'off') | length(mode) > 1,

  set(stat_bar,'string','Computing real axis loci');
  real_poles = []; real_zeros = [];
  if length(ol_poles),
   real_poles = ol_poles(find(imag(ol_poles)==0));
  end
  if length(ol_zeros),
   real_zeros = ol_zeros(find(imag(ol_zeros)==0));
  end
  all_real = flipud(sort([real_poles;real_zeros]));
  [r,c] = size(all_real);

  neg_l = neg_locus;
  if neg_l & term_mat(1,1)<0, neg_l = 0;
  elseif ~neg_l & term_mat(1,1)<0, neg_l = 1; end

  ct = 1; lin = [];
  for k=1:r,
   loci = rem(k-1,2);
   if ~neg_l,
    if loci,
     xdata = [all_real(k),all_real(k-1)];
    elseif k==r,
     xdata = [-1000,all_real(k)];
    else
     xdata = [NaN,NaN];
    end
    lin(ct) = line('xdata',xdata,'ydata',[0,0],'color','g','erase',ers,...
                   'linewidth',2);
    ct=ct+1;
   else
    if k==1,
     xdata = [1000,all_real(k)];
    elseif ~loci,
     xdata = [all_real(k),all_real(k-1)];
    elseif k==r,
     xdata = [-1000,all_real(k)];
    else
     xdata = [NaN,NaN];
    end
    lin(ct) = line('xdata',xdata,'ydata',[0,0],'color','g','erase',ers);
    ct=ct+1;
   end
  end

  if length(lin),
   set(real_loc,'checked','on','userdata',lin);
   set(lin,'tag','1521');
%   set(lin,'buttondownfcn','pagemous(1,5,10)');
  else
   set(real_loc,'checked','on','userdata',[]);
   set(stat_bar,'string','There are no real axis loci');
  end

% remove real axis loci
 else

  dlin = get(real_loc,'userdata');
  if length(dlin),
   set(stat_bar,'string','Removing real axis loci');
   delete(dlin);
  end
  set(real_loc,'checked','off','userdata',[]);

 end

end

if any(mode==4) & (~more_zeros), % asymptotes

 np = length(ol_poles); nz = length(ol_zeros);

 if (np - nz - 1) > 0,

% draw asymptotes
  if strcmp(get(asymptotes,'checked'),'off') | length(mode) > 1,
   set(stat_bar,'string','Computing asymptotes');

   asym_cen = (sum(ol_poles) - sum(ol_zeros))/(np-nz);
   q = 0:(np-nz-1);
   asym_ang = ((2*q + 1)/(np-nz))*pi;

   neg_l = neg_locus;
   if neg_l & term_mat(1,1)<0, neg_l = 0;
   elseif ~neg_l & term_mat(1,1)<0, neg_l = 1; end

   lin = [];
   for k = 1:length(asym_ang),
    xdata = asym_cen+[(~neg_l - neg_l)*2000*cos(asym_ang(k)),0];
    ydata = [2000*sin(asym_ang(k)),0];
    lin(k) = line('xdata',xdata,'ydata',ydata,'color','k','erase',ers);
   end

   if length(lin),
    set(asymptotes,'checked','on','userdata',lin);
    set(lin,'tag','1522');
%    set(lin,'buttondownfcn','pagemous(1,5,10)');
   else
    set(asymptotes,'checked','on','userdata',[]);
   end

% remove asymptotes
  else

   dlin = get(asymptotes,'userdata');
   if length(dlin),
    set(stat_bar,'string','Removing asymptotes');
    delete(dlin);
   end
   set(asymptotes,'checked','off','userdata',[]);

  end

 else

  set(asymptotes,'checked','on','userdata',[]);
  set(stat_bar,'string','The real axis is the asymptote.');

 end
end

if any(mode==5) & (~more_zeros), % breakaway/in

% determine breakaway/in points
 if strcmp(get(breakaway,'checked'),'off') | length(mode) > 1,

  set(stat_bar,'string','Computing breaks');
  [num,den] = termextr(term_mat);

  if ~length(rt_locus),
   if length(kvec2),
    if length(num) > 1 | length(den) > 1,
     rt_locus = rlocus((~neg_locus - neg_locus)*num,den,kvec2);
    else
     rt_locus = [];
    end
   else
    if length(num) > 1 | length(den) > 1,
     [rt_locus,kvec] = rlocus((~neg_locus - neg_locus)*num,den);
    else
     rt_locus = []; kvec = [];
    end
    set(ui_han(38),'userdata',kvec);
   end
   set(ui_han(37),'userdata',rt_locus);
  end

  [r,c] = size(rt_locus);
  ct = 1; lin = [];
  for k = 1:c,
   comp_loc = find(imag(rt_locus(:,k))~=0);
   if length(comp_loc) ~= r & length(comp_loc),
    first = comp_loc(1);
    last = comp_loc(length(comp_loc));
    if all(diff(comp_loc)==1),
     if first == 1,
      breakpt = real(rt_locus(last,k));
      ydata = 0;
     elseif last == r,
      breakpt = real(rt_locus(first,k));
      ydata = 0;
     elseif first ~= 1 & last ~= r,
      breakpt = [real(rt_locus(first,k)),real(rt_locus(last,k))];
      ydata = [0,0];
     end
     lin(ct) = line('xdata',breakpt,'ydata',ydata,'linestyle','none',...
                    'marker','d','markersize',10,'color','k','erase',ers);
     if ct > 1,
      linXdata = get(lin(ct-1),'xdata');
      linYdata = get(lin(ct-1),'ydata');
      if all(linXdata == breakpt) & all(linYdata == ydata),
         set(lin(ct),'vis','off');
      end
     end
     ct = ct + 1;
    else
     brk_loc = find(diff(comp_loc)~=1);
     brk_loc = sort([first;comp_loc(brk_loc);last])';
     brk_loc([0,diff(brk_loc)==0])=[];
     for k2 = 1:length(brk_loc),
      if brk_loc(k2) ~= 1 & brk_loc(k2) ~= r,
       breakpt = real(rt_locus(brk_loc(k2),k));
       lin(ct) = line('xdata',real(rt_locus(brk_loc(k2),k)),'ydata',0,...
                    'linestyle','none','marker','d',...
                    'markersize',12,'color','k','erase',ers);
       if ct > 1,
        linXdata = get(lin(ct-1),'xdata');
        linYdata = get(lin(ct-1),'ydata');
        if all(linXdata == breakpt) & all(linYdata == ydata),
         set(lin(ct),'vis','off');
        end
       end

       ct = ct+1;
      end
     end
    end

   end
  end

  if length(lin),
   set(breakaway,'checked','on','userdata',lin);
   set(lin,'tag','1523');
%   set(lin,'buttondownfcn','pagemous(1,5,10)');
  else
   set(breakaway,'checked','on','userdata',[]);
   set(stat_bar,'string','There are no breakaway-reentry points');
  end

 else

  dlin = get(breakaway,'userdata');
  if length(dlin),
   set(stat_bar,'string','Removing breakaway-reentry points');
   delete(dlin);
  end
  set(breakaway,'checked','off','userdata',[]);

 end
end

if any(mode==6) & (~more_zeros), % imag axis crossing

% determine imaginary axis crossings
 if strcmp(get(imag_cross,'checked'),'off') | length(mode) > 1,

  set(stat_bar,'string','Computing imaginary axis crossings');
  [num,den] = termextr(term_mat);

  if ~length(rt_locus),
   if length(kvec2),
    if length(num) > 1 | length(den) > 1,
     rt_locus = rlocus((~neg_locus - neg_locus)*num,den,kvec2);
    else
     rt_locus = [];
    end
   else
    if length(num) > 1 | length(den) > 1,
     [rt_locus,kvec] = rlocus((~neg_locus - neg_locus)*num,den);
    else
     rt_locus = []; kvec = [];
    end
    set(ui_han(38),'userdata',kvec);
   end
   set(ui_han(37),'userdata',rt_locus);
  end

  [r,c] = size(rt_locus);

  ct = 1; lin = [];
  for k = 1:c,
   sign_vec = sign(real(rt_locus(:,k)));
   diff_vec = [0,diff(sign_vec)'];
   cross_loc = find(abs(diff_vec)==2);
   for k2 = 1:length(cross_loc),
    cross_val = imag(rt_locus(cross_loc(k2),k));
    s = i*[(cross_val/1.2):((cross_val*1.2)-(cross_val/1.2))/30:(cross_val*1.2)];
    if cross_val ~= 0,
     n=find(num~=0); d=find(den~=0);
     dcgain = num(n(length(n)))/den(d(length(d)));
     K = -polyval(den,s)./polyval(dcgain*num,s);
     [jk,cross_loc2] = min(abs(imag(K)./real(K)));
     crossing = imag(s(cross_loc2));
     lin(ct) = line('xdata',0,'ydata',crossing,'linestyle','none',...
                    'marker','s','markersize',10,'color','b','erase',ers);
     ct = ct + 1;
    end
   end
  end

  if length(lin),
   set(imag_cross,'checked','on','userdata',lin);
   set(lin,'tag','1524');
%   set(lin,'buttondownfcn','pagemous(1,5,10)');
  else
   set(imag_cross,'checked','on','userdata',[]);
   set(stat_bar,'string','There are no imaginary axis crossings');
  end

 else

  dlin = get(imag_cross,'userdata');
  if length(dlin),
   set(stat_bar,'string','Removing imaginary axis crossings');
   delete(dlin);
  end
  set(imag_cross,'checked','off','userdata',[]);

 end
end

if any(mode==7) & (~more_zeros), % arrival/departure from complex zeros/poles

% place text for angles
 if strcmp(get(angles,'checked'),'off') | length(mode) > 1,
  set(stat_bar,'string','Computing angles of departure-arrival');

% find all complex poles and zeros
  comp_poles = []; comp_zeros = [];
  if length(ol_poles),
   comp_poles = ol_poles(find(imag(ol_poles)~=0));
  end
  if length(ol_zeros),
   comp_zeros = ol_zeros(find(imag(ol_zeros)~=0));
  end

  neg_l = neg_locus;
  if neg_l & term_mat(1,1)<0, neg_l = 0;
  elseif ~neg_l & term_mat(1,1)<0, neg_l = 1; end

% determine departure angles from complex poles
  ct = 1; txt = [];
  for k = 1:length(comp_poles),
   comp_pole = comp_poles(k);
   dep_ang = 180 - ((sum(angle(comp_pole-ol_poles)) - sum(angle(comp_pole-ol_zeros)))*180/pi);
   dep_ang = rem(dep_ang,360);
   if dep_ang < -180, dep_ang = dep_ang + 360;
   elseif dep_ang > 180, dep_ang = dep_ang - 360; end
   if neg_l,
    dep_ang = dep_ang - (sign(dep_ang)*180);
   end
   txt(ct) = text(real(comp_pole),imag(comp_pole),num2str(dep_ang),...
             'erase',ers,'color','k');
   if dep_ang > 0,
    set(txt(ct),'verticalalignment','top');
   else
    set(txt(ct),'verticalalignment','bottom');
   end
   ct = ct + 1;
  end

% determine arrival angles into complex zeros
  for k = 1:length(comp_zeros),
   comp_zero = comp_zeros(k);
   arr_ang = 180 + ((sum(angle(comp_zero-ol_poles)) - sum(angle(comp_zero-ol_zeros)))*180/pi);
   arr_ang = rem(arr_ang,360);
   if arr_ang < -180, arr_ang = arr_ang + 360;
   elseif arr_ang > 180, arr_ang = arr_ang - 360; end
   if neg_l,
    arr_ang = arr_ang - (sign(arr_ang)*180);
   end
   txt(ct) = text(real(comp_zero),imag(comp_zero),num2str(arr_ang),...
             'erase',ers,'color','k');
   if arr_ang > 0,
    set(txt(ct),'verticalalignment','top');
   else
    set(txt(ct),'verticalalignment','bottom');
   end
   ct = ct + 1;
  end

  if length(txt),
   set(angles,'checked','on','userdata',txt);
   set(txt,'tag','1525');
%   set(txt,'buttondownfcn','pagemous(1,5,10)');
  else
   set(angles,'checked','on','userdata',[]);
   set(stat_bar,'string','There are no angles of departure-arrival');
  end

% remove text of angles
 else

  dlin = get(angles,'userdata');
  if length(dlin),
   set(stat_bar,'string','Removing angles of departure-arrival');
   delete(dlin);
  end
  set(angles,'checked','off','userdata',[]);

 end
end

if any(mode==8) & (~more_zeros), % root locus

% draw root locus
 if strcmp(get(root_locus,'checked'),'off') | length(mode)>1,

  set(root_locus,'checked','on');
  set(stat_bar,'string','Computing root locus');

% draw real axis loci if not already drawn
  rlin = get(real_loc,'userdata');
  if ~length(rlin),
   set(real_loc,'checked','on');
   set(real_chk,'value',1);

   real_poles = []; real_zeros = [];
   if length(ol_poles),
    real_poles = ol_poles(find(imag(ol_poles)==0));
   end
   if length(ol_zeros),
    real_zeros = ol_zeros(find(imag(ol_zeros)==0));
   end
   all_real = flipud(sort([real_poles;real_zeros]));
   [r,c] = size(all_real);

   neg_l = neg_locus;
   if neg_l & term_mat(1,1)<0, neg_l = 0;
   elseif ~neg_l & term_mat(1,1)<0, neg_l = 1; end

   ct = 1;
   lin = [];
   for k=1:r,
    loci = rem(k-1,2);
    if ~neg_l,
     if loci,
      xdata = [all_real(k),all_real(k-1)];
     elseif k==r,
      xdata = [-1000,all_real(k)];
     else
      xdata = [NaN,NaN];
     end
     lin(ct) = line('xdata',xdata,'ydata',[0,0],'color','g','erase',ers,...
                    'linewidth',2);
     ct=ct+1;
    else
     if k==1,
      xdata = [1000,all_real(k)];
     elseif ~loci,
      xdata = [all_real(k),all_real(k-1)];
     elseif k==r,
      xdata = [-1000,all_real(k)];
     else
      xdata = [NaN,NaN];
     end
     lin(ct) = line('xdata',xdata,'ydata',[0,0],'color','g','erase',ers,...
                    'linewidth',2);
     ct=ct+1;
    end
   end
   set(lin,'tag','1521');
%   set(lin,'buttondownfcn','pagemous(1,5,10)');
   set(real_loc,'userdata',lin);
  end

% draw rest of root locus

% obtain numerator/denominator of current terms
  [num,den] = termextr(term_mat);

  if ~length(rt_locus),
   set(stat_bar,'string','Computing root locus');
   if length(kvec2),
    if length(num) > 1 | length(den) > 1,
     rt_locus = rlocus((~neg_locus-neg_locus)*num,den,kvec2);
    else
     rt_locus = [];
    end
   else
    if length(num) > 1 | length(den) > 1,
     [rt_locus,kvec] = rlocus((~neg_locus-neg_locus)*num,den);
    else
     rt_locus = []; kvec = [];
    end
    set(ui_han(38),'userdata',kvec);
   end
   set(ui_han(37),'userdata',rt_locus);
  end

  [r,c] = size(rt_locus);
  ct = 1; lin = [];
  for k = 1:c,
   comp_loc = find(imag(rt_locus(:,k))~=0);
   comp_loci = rt_locus(comp_loc,k);
   comp_loci = comp_loci.';
   if length(comp_loci),
    first_loc = comp_loc(1);
    last_loc = comp_loc(length(comp_loc));
    if all(diff(comp_loc)==1),
     if first_loc ~= 1,
      comp_loci = [real(comp_loci(1)),comp_loci];
     end
     if last_loc ~= r & (~isinf(real(rt_locus(r,k)))),
      comp_loci = [comp_loci,real(comp_loci(length(comp_loci)))];
     end
     lin(ct) = line('xdata',real(comp_loci),'ydata',imag(comp_loci),...
                   'color','g','erase',ers);
     ct = ct+1;
    else
     brk_loc = find(diff(comp_loc)~=1);
     brk_loc = sort([first_loc;comp_loc(brk_loc);comp_loc(brk_loc+1);last_loc])';
     brk_loc(logical([0,diff(brk_loc)==0]))=[];
     for k2 = 1:2:length(brk_loc),
      locus = rt_locus(brk_loc(k2):brk_loc(k2+1),k);
      if brk_loc(k2) == 1 & brk_loc(k2+1) ~= r,
       temp_loci = [locus;real(locus(length(locus)))];
      elseif brk_loc(k2) ~= 1 & brk_loc(k2+1) ~= r,
       temp_loci = [real(locus(1));locus;real(locus(length(locus)))];
      elseif brk_loc(k2) ~= 1 & brk_loc(k2+1) == r,
       temp_loci = [real(locus(2));locus];
      end
      temp_loci = temp_loci.';
      lin(ct) = line('xdata',real(temp_loci),'ydata',imag(temp_loci),...
                    'color','g','erase',ers);
      ct = ct+1;
     end
    end

   end
  end
  set(lin,'tag','1521');
%  set(lin,'buttondownfcn','pagemous(1,5,10)');
  set(root_locus,'userdata',lin);

 else

  dlin = get(root_locus,'userdata');
  if length(dlin),
   set(stat_bar,'string','Removing root locus');
   delete(dlin);
  end
  set(root_locus,'checked','off','userdata',[]);

 end

end

if any(mode==9), % closed-loop poles

% plot closed-loop poles
 if strcmp(get(closed_rts,'checked'),'off') | length(mode) > 1,

  set(stat_bar,'string','Computing closed-loop poles');
  [num,den] = termextr(term_mat);
  ln = length(num); ld = length(den);
  num = (~neg_locus - neg_locus)*[zeros(1,ld-ln),num];
  den = [zeros(1,ln-ld),den];
  rts = roots(den + num);

  lin = [];
  if length(rts),
   lin = line('xdata',real(rts),'ydata',imag(rts),'linestyle','none',...
       'marker','*',...
       'markersize',12,...
       'erase',ers,...
       'color','k');
   set(closed_rts,'checked','on','userdata',lin);
   set(lin,'tag','1526');
%   set(lin,'buttondownfcn','pagemous(1,5,10)');

  else

   set(stat_bar,'string','There are no closed-loop poles');
   delete(get(closed_rts,'userdata'));
   set(closed_rts,'checked','on','userdata',[]);
  end

% remove closed-loop poles
 else

  dlin = get(closed_rts,'userdata');
  if length(dlin),
   set(stat_bar,'string','Removing closed-loop poles');
   delete(dlin);
  end
  set(closed_rts,'checked','off','userdata',[]);

 end

end

axs_lims = axis;

if any(mode == 13) | any(mode == 15) | all(abs(axs_lims)==1),
 pageview(1,axs_hand);
end