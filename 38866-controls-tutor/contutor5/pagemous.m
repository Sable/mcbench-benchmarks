function pagemous(mode,environ,system)
% PAGEMOUS Mouse button presses.
%          PAGEMOUS manages the mouse down button presses for CONTUTOR.
%
%          mode - what type of axis was pressed.
%          environ - nyquist, bode, nichols, etc.
%          system - line selected

% Author: Craig Borghesani
% Date: 8/30/94
% Revised: 10/19/94, 1/17/95
% Copyright (c) 1999, Prentice-Hall

% obtain handle information
f = gcf;
ui_data = get(f,'userdata');
ui_han = ui_data{1};
ui_obj = ui_data{2};
rht_butn = ui_obj.SysUI(13);
%rht_butn  = ui_han(9);
term_axes = ui_han(10);
loc_axes  = ui_han(11);
loc_lis   = ui_obj.SysUI(17);
plot_info = ui_obj.SysUI(16);
sys_axes  = ui_han(12);
plant     = ui_han(30);
for_cont  = ui_han(31);
bac_cont  = ui_han(32);
neg_loc   = ui_han(68);
cur_sys = get(ui_han(30),'userdata');
stat_bar = get(ui_han(43),'userdata');
fontname = 'times';
line_name = [];
loc_str = {};

% due to bug with buttondownfcn, needed to use window button down fcn
cur_obj = get(f,'currentobject');
if nargin == 0, % window button down function
 cur_tag = get(cur_obj,'tag');
 if length(cur_tag),
  mode = str2num(cur_tag(1));
  if length(cur_tag) > 1,
   environ = str2num(cur_tag(2));
   system = str2num(cur_tag(3:length(cur_tag)));
  end
 else
  return;
 end
end

% mouse click in transfer function axes
if length(mode) & any(mode == [0,9]),

 if mode == 0,
  if strcmp(get(plant,'checked'),'on'),
   term_mat = get(ui_han(3+cur_sys),'userdata');
  elseif strcmp(get(for_cont,'checked'),'on'),
   term_mat = get(ui_han(6+cur_sys),'userdata');
  else
   term_mat = get(ui_han(9+cur_sys),'userdata');
  end
  term_loc = get(cur_obj,'userdata');

  if length(term_loc)==1,

% determine element type selected
   term_typ = term_mat(term_loc,4);

% Edit operation
   termmang(term_typ,2,term_loc);

% Delete operation
   set(rht_butn,'callback',['termimpl(',int2str(term_typ),',4,',int2str(term_loc),')']);

  elseif length(term_loc)==2,
   if term_loc(2) == 0, % pid controller

    pid_typ = term_loc(1);
    pidmang(pid_typ,2);

   else % delay time

% determine element type selected
    term_typ = 10;
    term_loc = 1;

% Edit operation
    termmang(term_typ,2,term_loc);

   end
  end
 else
  set(stat_bar,'string','Incorrect format to update transfer function; you need Individual/Factored');
 end

% mouse click within a response axis
elseif length(mode) & any(mode == [1,2,3]),

 line_type = system;
 old_sys = get(ui_han(30),'userdata');
 cur_page = get(ui_han(31),'userdata');
 sys_state = get(ui_han(33),'userdata');
 page_setup = get(ui_han(34),'userdata');
 page_layout = get(ui_han(35),'userdata');
 font_size = get(ui_han(42),'userdata');
 lab_txt = get(ui_han(44),'userdata');

% double-click on top of response
 sel_type = get(f,'selectiontype');

 if strcmp(sel_type,'open') & line_type < 20,

  system = rem(system,3) + 3*(rem(system,3)==0);
  dispfrac(system);

 end

 cur_str = int2str(cur_sys);
 if sys_state(1,cur_sys),
  tf_name = ['Plant ',cur_str];
 elseif sys_state(2,cur_sys),
  tf_name = ['Forward Controller ',cur_str];
 else
  tf_name = ['Feedback Controller ',cur_str];
 end

 if ~isempty(line_type),
   sys_line = int2str(rem(line_type,3) + 3*(rem(line_type,3)==0));
 else
   sys_line = [];
 end

 if environ == 1,
  set(plot_info,'string','Nyquist Plot Info');
  if any(line_type == [1:3]),
   line_name = ['System ',sys_line,', exact open-loop response'];
  elseif any(line_type == [4:6]),
   line_name = ['System ',sys_line,', exact open-loop response'];
  elseif any(line_type == [7:9]),
   line_name = ['System ',sys_line,', gain margin'];
  elseif any(line_type == [10:12]),
   line_name = ['System ',sys_line,', phase margin'];
  else
   line_name = 'Nyquist location';
  end
 elseif environ == 2,
  set(plot_info,'string','Bode (Magnitude) Plot Info');
  if any(line_type == [1:3]),
   line_name = ['System ',sys_line,', exact open-loop response'];
  elseif any(line_type == [4:6]),
   line_name = ['System ',sys_line,', exact closed-loop response'];
  elseif any(line_type == [7:9]),
   line_name = ['System ',sys_line,', straight-line open-loop response'];
  elseif any(line_type == [10:12]),
   line_name = ['System ',sys_line,', straight-line closed-loop response'];
  elseif any(line_type == [13:15]),
   line_name = ['System ',sys_line,', gain margin'];
  else
   line_name = 'Bode (Magnitude) location';
  end
 elseif environ == 3,
  set(plot_info,'string','Bode (Phase) Plot Info');
  if any(line_type == [1:3]),
   line_name = ['System ',sys_line,', exact open-loop response'];
  elseif any(line_type == [4:6]),
   line_name = ['System ',sys_line,', exact closed-loop response'];
  elseif any(line_type == [7:9]),
   line_name = ['System ',sys_line,', straight-line open-loop response'];
  elseif any(line_type == [10:12]),
   line_name = ['System ',sys_line,', straight-line closed-loop response'];
  elseif any(line_type == [13:15]),
   line_name = ['System ',sys_line,', phase margin'];
  else
   line_name = 'Bode (Phase) location';
  end
 elseif environ == 4,
  set(plot_info,'string','Nichols Plot Info');
  if any(line_type == [1:3]),
   line_name = ['System ',sys_line,', exact open-loop response'];
  elseif any(line_type == [4:6]),
   line_name = ['System ',sys_line,', exact closed-loop response'];
  elseif any(line_type == [7:9]),
   line_name = ['System ',sys_line,', gain margin'];
  elseif any(line_type == [10:12]),
   line_name = ['System ',sys_line,', phase margin'];
  else
   line_name = 'Nichols location';
  end
 elseif environ == 5,
  set(plot_info,'string','Root Locus Plot Info');
  if line_type == 20,
   line_name = ['System ',cur_str,', root locus location'];
  elseif line_type == 21,
   line_name = ['System ',cur_str,', root locus'];
  elseif line_type == 22,
   line_name = ['System ',cur_str,', asymptotes'];
  elseif line_type == 23,
   line_name = ['System ',cur_str,', breakaway-reentry'];
  elseif line_type == 24,
   line_name = ['System ',cur_str,', imaginary axis crossing'];
  elseif line_type == 25,
   line_name = ['System ',cur_str,', arrival-departure angle'];
  elseif line_type == 26,
   line_name = ['System ',cur_str,', closed-loop poles with respect to ',tf_name];
  end
 elseif environ == 6,
  set(plot_info,'string','Gain (Magnitude) Plot Info');
  line_name = ['Gain (Magnitude) location, ',tf_name];
 elseif environ == 7,
  set(plot_info,'string','Gain (Phase) Plot Info');
  line_name = ['Gain (Phase) location, ',tf_name];
 elseif environ == 8,
  set(plot_info,'string','Time Response Plot Info');
  if line_type == 20,
   line_name = ['System ',cur_str,', time response location'];
  elseif line_type == 21,
   line_name = ['System ',cur_str,', open-loop impulse response'];
  elseif line_type == 22,
   line_name = ['System ',cur_str,', open-loop step response'];
  elseif line_type == 23,
   line_name = ['System ',cur_str,', open-loop ramp response'];
  elseif line_type == 24,
   line_name = ['System ',cur_str,', closed-loop impulse response'];
  elseif line_type == 25,
   line_name = ['System ',cur_str,', closed-loop step response'];
  elseif line_type == 26,
   line_name = ['System ',cur_str,', closed-loop ramp response'];
  elseif any(line_type == [27,28]),
   tim_str = 'rise time';
   if rem(line_type,2),
    line_name = ['System ',cur_str,', open-loop ',tim_str];
   else
    line_name = ['System ',cur_str,', closed-loop ',tim_str];
   end
  elseif any(line_type == [29,30]),
   tim_str = 'delay time';
   if rem(line_type,2),
    line_name = ['System ',cur_str,', open-loop ',tim_str];
   else
    line_name = ['System ',cur_str,', closed-loop ',tim_str];
   end
  elseif any(line_type == [31,32]),
   tim_str = 'peak time';
   if rem(line_type,2),
    line_name = ['System ',cur_str,', open-loop ',tim_str];
   else
    line_name = ['System ',cur_str,', closed-loop ',tim_str];
   end
  elseif any(line_type == [33,34]),
   tim_str = '% overshoot';
   if rem(line_type,2),
    line_name = ['System ',cur_str,', open-loop ',tim_str];
   else
    line_name = ['System ',cur_str,', closed-loop ',tim_str];
   end
  elseif any(line_type == [35,36]),
   tim_str = '2% settling';
   if rem(line_type,2),
    line_name = ['System ',cur_str,', open-loop ',tim_str];
   else
    line_name = ['System ',cur_str,', closed-loop ',tim_str];
   end
  elseif any(line_type == [37,38]),
   tim_str = '5% settling';
   if rem(line_type,2),
    line_name = ['System ',cur_str,', open-loop ',tim_str];
   else
    line_name = ['System ',cur_str,', closed-loop ',tim_str];
   end
  end
 end

 set(stat_bar,'string',line_name);

 cur_sys = get(ui_han(30),'userdata');
 old_axs = get(ui_han(32),'userdata');
 old_data = get(old_axs,'userdata');
 old_environ = old_data(1);
 cur_plots = page_setup(:,cur_page); cur_plots(find(cur_plots==0))=[];
 cur_axs = page_layout(find(cur_plots==environ),cur_page);
 set(ui_han(32),'userdata',cur_axs);
 cur_res = get(ui_han(cur_sys),'userdata');

 loc_plot = find(environ==cur_plots);
 next_environ = cur_plots(rem(loc_plot,length(cur_plots))+1);
 if length(cur_plots) > 1,
  set(lab_txt(2),'callback',['pagemous(3,',int2str(next_environ),',20)']);
 end

 axs_pt = get(cur_axs,'currentpoint');

 if (all(environ ~= [5,6,7])) & old_environ ~= environ,
  plant_mat = get(ui_han(3+cur_sys),'userdata');
  for_mat = get(ui_han(6+cur_sys),'userdata');
  bac_mat = get(ui_han(9+cur_sys),'userdata');
  systemin(environ,sys_axes,font_size,cur_res,plant_mat,for_mat,bac_mat);
 end

 if environ == 1 & mode < 3, % nyquist

  s = axs_pt(1,1)+i*axs_pt(1,2);
  loc_str{end+1} = ['Loc: ',num2str(s)];

  if line_type < 7,
   line_loc = rem(line_type,3) + 3*(rem(line_type,3)==0);
   lin_res = get(ui_han(line_loc),'userdata');
   if line_type > 3, lin_res = conj(lin_res); end
   loc = findresp(axs_pt(1,1),axs_pt(1,2),lin_res,cur_axs,3);
  end

  if line_type < 7,
   if length(loc),
    ol_cplx = lin_res(2,loc);
    freq = sprintf('%0.3f',lin_res(1,loc));
    freq_str = ['Frequency: ',freq,' rad/sec'];
    db_ol = sprintf('%0.2f',20*log10(abs(ol_cplx)));
    ph_ol = sprintf('%0.2f',phase4(ol_cplx)*180/pi);
    ol_str = ['O.L.: ',ph_ol,' deg, ',db_ol,' dB'];
   else
    freq_str = 'Frequency: N/A';
    db_ol = sprintf('%0.2f',20*log10(abs(s)));
    ph_ol = sprintf('%0.2f',phase4(s)*180/pi);
    ol_str = ['O.L.: ',ph_ol,' deg, ',db_ol,' dB'];
   end
  else
   freq_str = 'Frequency: N/A';
   db_ol = sprintf('%0.2f',20*log10(abs(s)));
   ph_ol = sprintf('%0.2f',phase4(s)*180/pi);
   ol_str = ['O.L.: ',ph_ol,' deg, ',db_ol,' dB'];
  end

%  axes(loc_axes);
%  cla;
%  y_loc = 1;
%  txt=text(0,y_loc,loc_str,'fontsize',font_size,'verticalalignment','top',...
%           'fontname',fontname,'color','w');
%  txt_ext = get(txt,'extent');
%  y_loc = y_loc - txt_ext(4);
%  text(0,y_loc,freq_str,'fontsize',font_size,'verticalalignment','top',...
%           'fontname',fontname,'color','w');
%  y_loc = y_loc - txt_ext(4);
%  text(0,y_loc,ol_str,'fontsize',font_size,'verticalalignment','top',...
%           'fontname',fontname,'color','w');
  loc_str{end+1} = freq_str;
  loc_str{end+1} = ol_str;
  set(loc_lis,'string',loc_str,'value',1);

 elseif environ == 2 & mode < 3, % bode (magnitude)

  if line_type < 4,
   line_loc = rem(line_type,3) + 3*(rem(line_type,3)==0);
   lin_res = get(ui_han(line_loc),'userdata');
   loc = findresp(axs_pt(1,1),axs_pt(1,2),lin_res,cur_axs,1);
  end

  if line_type < 4,
   if length(loc),
    ol_cplx = lin_res(2,loc);
    db_ol = sprintf('%0.2f',20*log10(abs(ol_cplx)));
    loc_str{end+1} = ['Magnitude: ',db_ol,' dB'];
    freq = sprintf('%0.3f',lin_res(1,loc));
    freq_str = ['Frequency: ',freq,' rad/sec'];
    ph_ol = sprintf('%0.2f',phase4(ol_cplx)*180/pi);
    ol_str = ['O.L.: ',ph_ol,' deg, ',db_ol,' dB'];
   else
    loc_str{end+1} = ['Magnitude: ',sprintf('%0.2f',axs_pt(1,2)),' dB'];
    freq = sprintf('%0.3f',axs_pt(1,1));
    freq_str = ['Frequency: ',freq,' rad/sec'];
    ol_str = '';
   end
  else
   loc_str{end+1} = ['Magnitude: ',sprintf('%0.2f',axs_pt(1,2)),' dB'];
   freq = sprintf('%0.3f',axs_pt(1,1));
   freq_str = ['Frequency: ',freq,' rad/sec'];
   ol_str = '';
   if any(line_type==[7:12]),
    cur_data = get(cur_axs,'userdata');
    ydata = get(cur_data(1+line_type),'ydata');
    xdata = get(cur_data(1+line_type),'xdata');
    locdata = find(xdata > axs_pt(1,1));
    if length(locdata),
     loc = locdata(1);
     if loc > 1,
      delx = log10(xdata(loc)) - log10(xdata(loc-1));
      dely = ydata(loc) - ydata(loc-1);
      slope = dely/delx;
      ol_str = ['Slope: ',sprintf('%0.2f',slope),' dB/dec'];
     end
    end
   end
  end

%  axes(loc_axes);
%  cla;
%  y_loc = 1;
%  txt=text(0,y_loc,loc_str,'fontsize',font_size,'verticalalignment','top',...
%           'fontname',fontname,'color','w');
%  txt_ext = get(txt,'extent');
%  y_loc = y_loc - txt_ext(4);
%  text(0,y_loc,freq_str,'fontsize',font_size,'verticalalignment','top',...
%           'fontname',fontname,'color','w');
%  y_loc = y_loc - txt_ext(4);
%  text(0,y_loc,ol_str,'fontsize',font_size,'verticalalignment','top',...
%           'fontname',fontname,'color','w');

  loc_str{end+1} = freq_str;
  loc_str{end+1} = ol_str;
  set(loc_lis,'string',loc_str,'value',1);

 elseif environ == 3 & mode < 3, % Bode (Phase)

  if line_type < 4,
   line_loc = rem(line_type,3) + 3*(rem(line_type,3)==0);
   lin_res = get(ui_han(line_loc),'userdata');
   loc = findresp(axs_pt(1,1),axs_pt(1,2),lin_res,cur_axs,2);
  end

  if line_type < 4,
   if length(loc),
    ol_cplx = lin_res(2,loc);
    ph_ol = sprintf('%0.2f',phase4(ol_cplx)*180/pi);
    loc_str{end+1} = ['Phase: ',ph_ol,' deg'];
    freq = sprintf('%0.3f',lin_res(1,loc));
    freq_str = ['Frequency: ',freq,' rad/sec'];
    db_ol = sprintf('%0.2f',20*log10(abs(ol_cplx)));
    ol_str = ['O.L.: ',ph_ol,' deg, ',db_ol,' dB'];
   else
    loc_str{end+1} = ['Phase: ',sprintf('%0.2f',axs_pt(1,2)),' deg'];
    freq = sprintf('%0.3f',axs_pt(1,1));
    freq_str = ['Frequency: ',freq,' rad/sec'];
    ol_str = '';
   end
  else
   loc_str{end+1} = ['Phase: ',sprintf('%0.2f',axs_pt(1,2)),' deg'];
   freq = sprintf('%0.3f',axs_pt(1,1));
   freq_str = ['Frequency: ',freq,' rad/sec'];
   ol_str = '';
   if any(line_type==[7:12]),
    cur_data = get(cur_axs,'userdata');
    ydata = get(cur_data(1+line_type),'ydata');
    xdata = get(cur_data(1+line_type),'xdata');
    locdata = find(xdata > axs_pt(1,1));
    if length(locdata),
     loc = locdata(1);
     if loc > 1,
      delx = log10(xdata(loc)) - log10(xdata(loc-1));
      dely = ydata(loc) - ydata(loc-1);
      slope = dely/delx;
      ol_str = ['Slope: ',sprintf('%0.2f',slope),' deg/dec'];
     end
    end
   end
  end

%  axes(loc_axes);
%  cla;
%  y_loc = 1;
%  txt=text(0,y_loc,loc_str,'fontsize',font_size,'verticalalignment','top',...
%            'fontname',fontname,'color','w');
%  txt_ext = get(txt,'extent');
%  y_loc = y_loc - txt_ext(4);
%  text(0,y_loc,freq_str,'fontsize',font_size,'verticalalignment','top',...
%            'fontname',fontname,'color','w');
%  y_loc = y_loc - txt_ext(4);
%  text(0,y_loc,ol_str,'fontsize',font_size,'verticalalignment','top',...
%            'fontname',fontname,'color','w');

  loc_str{end+1} = freq_str;
  loc_str{end+1} = ol_str;
  set(loc_lis,'string',loc_str,'value',1);

 elseif environ == 4 & mode < 3, % nichols

  if line_type < 4,
   line_loc = rem(line_type,3) + 3*(rem(line_type,3)==0);
   lin_res = get(ui_han(line_loc),'userdata');
   loc = findresp(axs_pt(1,1),axs_pt(1,2),lin_res,cur_axs,1);
  end

  if line_type < 4,
   if length(loc),
    ol_cplx = lin_res(2,loc);
    db_ol = sprintf('%0.2f',20*log10(abs(ol_cplx)));
    ph_ol = sprintf('%0.2f',phase4(ol_cplx)*180/pi);
    loc_str{end+1} = ['Loc: ',ph_ol,' deg, ',db_ol,' dB'];
    freq = sprintf('%0.3f',lin_res(1,loc));
    freq_str = ['Frequency: ',freq,' rad/sec'];
    ol_str = ['O.L.: ',ph_ol,' deg, ',db_ol,' dB'];
    db_cl = sprintf('%0.2f',20*log10(abs(ol_cplx/(1+ol_cplx))));
    ph_cl = sprintf('%0.2f',180/pi*phase4(ol_cplx/(1+ol_cplx)));
    cl_str = ['C.L.: ',ph_cl,' deg, ',db_cl,' dB'];
   else
    ol_cplx = 10^(axs_pt(1,2)/20)*exp(i*axs_pt(1,1)*pi/180);
    db_ol = sprintf('%0.2f',20*log10(abs(ol_cplx)));
    ph_ol = sprintf('%0.2f',phase4(ol_cplx)*180/pi);
    loc_str{end+1} = ['Loc: ',ph_ol,' deg, ',db_ol,' dB'];
    freq_str = 'Frequency: N/A';
    ol_str = ['O.L.: ',ph_ol,' deg, ',db_ol,' dB'];
    db_cl = sprintf('%0.2f',20*log10(abs(ol_cplx/(1+ol_cplx))));
    ph_cl = sprintf('%0.2f',180/pi*phase4(ol_cplx/(1+ol_cplx)));
    cl_str = ['C.L.: ',ph_cl,' deg, ',db_cl,' dB'];
   end
  else
   ol_cplx = 10^(axs_pt(1,2)/20)*exp(i*axs_pt(1,1)*pi/180);
   db_ol = sprintf('%0.2f',20*log10(abs(ol_cplx)));
   ph_ol = sprintf('%0.2f',phase4(ol_cplx)*180/pi);
   loc_str{end+1} = ['Loc: ',ph_ol,' deg, ',db_ol,' dB'];
   freq_str = 'Frequency: N/A';
   ol_str = ['O.L.: ',ph_ol,' deg, ',db_ol,' dB'];
   db_cl = sprintf('%0.2f',20*log10(abs(ol_cplx/(1+ol_cplx))));
   ph_cl = sprintf('%0.2f',180/pi*phase4(ol_cplx/(1+ol_cplx)));
   cl_str = ['C.L.: ',ph_cl,' deg, ',db_cl,' dB'];
  end

%  axes(loc_axes);
%  cla;
%  y_loc = 1;
%  txt=text(0,y_loc,loc_str,'fontsize',font_size,'verticalalignment','top',...
%        'fontname',fontname,'color','w');
%  txt_ext = get(txt,'extent');
%  y_loc = y_loc - txt_ext(4);
%  text(0,y_loc,freq_str,'fontsize',font_size,'verticalalignment','top',...
%        'fontname',fontname,'color','w');
%  y_loc = y_loc - txt_ext(4);
%  text(0,y_loc,ol_str,'fontsize',font_size,'verticalalignment','top',...
%        'fontname',fontname,'color','w');
%  y_loc = y_loc - txt_ext(4);
%  text(0,y_loc,cl_str,'fontsize',font_size,'verticalalignment','top',...
%        'fontname',fontname,'color','w');

  loc_str{end+1} = freq_str;
  loc_str{end+1} = ol_str;
  loc_str{end+1} = cl_str;
  set(loc_lis,'string',loc_str,'value',1);

 elseif environ == 5 & mode < 3, % root locus

  xlim = get(cur_axs,'xlim');
  ylim = get(cur_axs,'ylim');
  plant_mat = get(ui_han(3+cur_sys),'userdata');
  for_mat = get(ui_han(6+cur_sys),'userdata');
  bac_mat = get(ui_han(9+cur_sys),'userdata');
  designpt = get(ui_han(25),'userdata');

  [term_mat,for_mat,bac_mat] = termjoin(plant_mat,for_mat,bac_mat);
  neg_locus = strcmp(get(neg_loc,'checked'),'on');

  [num,den] = termextr(term_mat);
  num = num/abs(term_mat(1,1));

  s = axs_pt(1,1)+i*axs_pt(1,2);
  if abs(axs_pt(1,2)) < sum(abs(ylim))/100,
   s = real(s);
  end
  if abs(axs_pt(1,1)) < sum(abs(xlim))/100,
   s = i*imag(s);
  end
  K = -polyval(den,s)/polyval((~neg_locus-neg_locus)*num,s);
  if strcmp(get(plant,'checked'),'on'),
   K_prime = K/(for_mat(1,1)*bac_mat(1,1));
   K_str = 'Plant Gain: ';
  elseif strcmp(get(for_cont,'checked'),'on'),
   K_prime = K/(plant_mat(1,1)*bac_mat(1,1));
   K_str = 'Forward Cont. Gain: ';
  else
   K_prime = K/(plant_mat(1,1)*for_mat(1,1));
   K_str = 'Feedback Cont. Gain: ';
  end

  loc_str{end+1} = ['loc: ',num2str(s)];
  if real(K) > 0,
   if abs(imag(K)/real(K)) < 0.05,
    K_str = [K_str,sprintf('%0.3f',real(K_prime))];
    ln = length(num); ld = length(den);
    num = [zeros(1,ld-ln),(~neg_locus - neg_locus)*num];
    den = [zeros(1,ln-ld),den];
    rts = roots(den + real(K)*num);
   else
    K_str = [K_str,'N/A'];
    rts = 'C.L. Poles: N/A';
   end
  else
   K_str = [K_str,'N/A'];
   rts = 'C.L. Poles: N/A';
  end

%  axes(loc_axes);
%  cla;
%  y_loc = 1;
%  txt=text(0,y_loc,loc_str,'fontsize',font_size,'verticalalignment','top',...
%            'fontname',fontname,'color','w');
%  ext_txt = get(txt,'extent');
%  y_loc = y_loc - ext_txt(4);
%  text(0,y_loc,K_str,'fontsize',font_size,'verticalalignment','top',...
%            'fontname',fontname,'color','w');
  loc_str{end+1} = K_str;

  if length(designpt),
   zeta = designpt(1); wn = designpt(2);
   pt = [-zeta*wn + i*wn*sqrt(1-zeta^2);-zeta*wn - i*wn*sqrt(1-zeta^2)];
   per_dist = abs(s - pt)./abs(pt) * 100;
   per_str = ['Tolerance: ',num2str(min(per_dist)),'%'];
%   y_loc = y_loc - ext_txt(4);
%   text(0,y_loc,per_str,'fontsize',font_size,'verticalalignment','top',...
%            'fontname',fontname,'color','w');
   loc_str{end+1} = per_str;
  end
  set(loc_lis,'string',loc_str,'value',1);

  systemin(environ,sys_axes,font_size,rts);

 elseif environ == 6 & mode < 3, % gain (magnitude) response

  K = axs_pt(1,1); mag = axs_pt(1,2);
  plant_mat = get(ui_han(3+cur_sys),'userdata');
  for_mat = get(ui_han(6+cur_sys),'userdata');
  bac_mat = get(ui_han(9+cur_sys),'userdata');
  [term_mat,for_mat,bac_mat] = termjoin(plant_mat,for_mat,bac_mat);
  if strcmp(get(plant,'checked'),'on'),
   K_prime = K*(for_mat(1,1)*bac_mat(1,1));
   K_str = ['Plant Gain: ',sprintf('%0.3f',K)];
  elseif strcmp(get(for_cont,'checked'),'on'),
   K_prime = K*(plant_mat(1,1)*bac_mat(1,1));
   K_str = ['Forward Cont. Gain: ',sprintf('%0.3f',K)];
  else
   K_prime = K*(plant_mat(1,1)*for_mat(1,1));
   K_str = ['Feedback Cont. Gain: ',sprintf('%0.3f',K)];
  end
  mag_str = ['Natural Freq: ',sprintf('%0.3f',mag)];
  neg_locus = strcmp(get(neg_loc,'checked'),'on');

  [num,den] = termextr(term_mat);
  num = num/abs(term_mat(1,1));
  ln = length(num); ld = length(den);
  num = [zeros(1,ld-ln),(~neg_locus - neg_locus)*num];
  den = [zeros(1,ln-ld),den];
  rts = roots(den + K_prime*num);

%  axes(loc_axes);
%  cla;
%  y_loc = 1;
%  txt = text(0,y_loc,K_str,'fontsize',font_size,'verticalalignment','top',...
%            'fontname',fontname,'color','w');
%  ext_txt = get(txt,'extent');
%  y_loc = y_loc - ext_txt(4);
%  text(0,y_loc,mag_str,'fontsize',font_size,'verticalalignment','top',...
%            'fontname',fontname,'color','w');
  loc_str{end+1} = K_str;
  loc_str{end+1} = mag_str;
  set(loc_lis,'string',loc_str,'value',1);

  systemin(environ,sys_axes,font_size,rts);

 elseif environ == 7 & mode < 3, % gain (phase) response

  K = axs_pt(1,1); phs = axs_pt(1,2);
  plant_mat = get(ui_han(3+cur_sys),'userdata');
  for_mat = get(ui_han(6+cur_sys),'userdata');
  bac_mat = get(ui_han(9+cur_sys),'userdata');
  [term_mat,for_mat,bac_mat] = termjoin(plant_mat,for_mat,bac_mat);
  if strcmp(get(plant,'checked'),'on'),
   K_prime = K*(for_mat(1,1)*bac_mat(1,1));
   K_str = ['Plant Gain: ',sprintf('%0.3f',K)];
  elseif strcmp(get(for_cont,'checked'),'on'),
   K_prime = K*(plant_mat(1,1)*bac_mat(1,1));
   K_str = ['Forward Cont. Gain: ',sprintf('%0.3f',K)];
  else
   K_prime = K*(plant_mat(1,1)*for_mat(1,1));
   K_str = ['Feedback Cont. Gain: ',sprintf('%0.3f',K)];
  end
  phs_str = ['Zeta: ',sprintf('%0.3f',-cos(phs*pi/180))];
  neg_locus = strcmp(get(neg_loc,'checked'),'on');

  [num,den] = termextr(term_mat);
  num = num/abs(term_mat(1,1));
  ln = length(num); ld = length(den);
  num = [zeros(1,ld-ln),(~neg_locus - neg_locus)*num];
  den = [zeros(1,ln-ld),den];
  rts = roots(den + K_prime*num);

%  axes(loc_axes);
%  cla;
%  y_loc = 1;
%  txt = text(0,y_loc,K_str,'fontsize',font_size,'verticalalignment','top',...
%            'fontname',fontname,'color','w');
%  ext_txt = get(txt,'extent');
%  y_loc = y_loc - ext_txt(4);
%  text(0,y_loc,phs_str,'fontsize',font_size,'verticalalignment','top',...
%            'fontname',fontname,'color','w');
  loc_str{end+1} = K_str;
  loc_str{end+1} = phs_str;
  set(loc_lis,'string',loc_str,'value',1);

  systemin(environ,sys_axes,font_size,rts);

 elseif environ == 8 & mode < 3, % time response

  sec = sprintf('%0.3f',axs_pt(1,1));
  amp = sprintf('%0.3f',axs_pt(1,2));
  loc_str{end+1} = ['Loc: ',sec,' sec, ',amp,' amp'];

%  axes(loc_axes);
%  cla;
%  y_loc = 1;
%  text(0,y_loc,loc_str,'fontsize',font_size,'verticalalignment','top',...
%    'fontname',fontname,'color','w');
  set(loc_lis,'string',loc_str,'value',1);
  set(loc_lis,'string',loc_str,'value',1);

 end
end