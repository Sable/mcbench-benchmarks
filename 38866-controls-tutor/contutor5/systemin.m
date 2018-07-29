function systemin(environ,sys_axes,font_size,input1,input2,input3,input4)
% SYSTEMIN System information.

% Author: Craig Borghesani
% Date: 11/15/94
% Revised:
% Copyright (c) 1999, Prentice-Hall

f=gcf;
ui_data     = get(f,'userdata');
ui_han      = ui_data{1};
ui_obj      = ui_data{2};
sys_list    = ui_obj.SysUI(15);

fontname = 'times';
list_str = {};

if any(environ==[1,2,3,4]),

 w = input1(1,:);
 sys_cplx = input1(2,:);
 plant_mat = input2;
 for_mat = input3;
 bac_mat = input4;

 db = 20*log10(abs(sys_cplx));
 deg = phase4(sys_cplx)*180/pi;
 [Gm,Wcg,Pm,Wcp] = termmarg(db,deg,w);

 plant_mat = termjoin(plant_mat,for_mat,bac_mat);
 [num,den] = termextr(plant_mat);
 ln = length(num); ld = length(den);
 num = [zeros(1,ld-ln),num]; den = [zeros(1,ln-ld),den];
 rts = roots(den + num);

 if environ ~= 1, Gm = 20*log10(Gm); end

% axes(sys_axes);
% cla

 if plant_mat(1,2) == 0,
  stable_str = 'Stable Closed-Loop';
  if any(real(rts)>0), stable_str = 'UNstable Closed-Loop'; end
 else
  stable_str = '';
 end

 type_num = plant_mat(2,1);
 if type_num < 0, type_num = 0; end
 type_str = ['System Type: ',int2str(type_num)];

% loc_3dB = find(db <= -3);
% if length(loc_3dB) < length(db) & length(loc_3dB) ~= 0,
%  threedB_str = ['-3 dB

 if environ ~= 1,
  gain_str = ['G.M.: ',sprintf('%0.2f',Gm),' dB'];
 else
  gain_str = ['G.M.: ',sprintf('%0.2f',Gm)];
 end

 if ~isnan(Wcg),
  gain_str = [gain_str,', w = ',sprintf('%0.3f',Wcg)];
 end

 phas_str = ['P.M.: ',sprintf('%0.2f',Pm),' deg'];
 if ~isnan(Wcp),
  phas_str = [phas_str,', w = ',sprintf('%0.3f',Wcp)];
 end

 y_loc = 1;
 if plant_mat(1,2) == 0,
%  txt=text(0,y_loc,stable_str,'fontsize',font_size,'verticalalignment','top',...
%           'fontname',fontname,'color','w');
%  ext_txt = get(txt,'extent');
%  y_loc = y_loc - ext_txt(4);
  list_str{end+1} = stable_str;
 end

% txt=text(0,y_loc,type_str,'fontsize',font_size,'verticalalignment','top',...
%          'fontname',fontname,'color','w');
% ext_txt = get(txt,'extent');
% y_loc = y_loc - ext_txt(4);
 list_str{end+1} = type_str;

% text(0,y_loc,gain_str,'fontsize',font_size,'verticalalignment','top',...
%          'fontname',fontname,'color','w');
% y_loc = y_loc - ext_txt(4);
 list_str{end+1} = gain_str;

% text(0,y_loc,phas_str,'fontsize',font_size,'verticalalignment','top',...
%          'fontname',fontname,'color','w');
 list_str{end+1} = phas_str;
 set(sys_list,'string',list_str);

elseif any(environ == [5,6,7]),

 rts = input1;

 [r,c] = size(rts); ct = 1;
% axes(sys_axes);
% cla;
 if ~isstr(rts),
  stable_str = 'Stable Closed-Loop';
  if any(real(rts)>0), stable_str = 'UNstable Closed-Loop'; end
  y_loc = 1;
%  txt=text(0,y_loc,stable_str,'fontsize',font_size,'verticalalignment','top',...
%       'fontname',fontname,'color','w');
%  ext_txt=get(txt,'extent');
%  y_loc = y_loc - ext_txt(4);
  list_str{end+1} = stable_str;
%  txt=text(0,y_loc,'C.L. Poles: ','fontsize',font_size,'verticalalignment','top',...
%       'fontname',fontname,'color','w');
  list_str{end+1} = 'C.L. Poles: ';
%  ext_txt=get(txt,'extent');
%  x_loc = sum(ext_txt([1,3]));
  while ct <= r,
   if abs(imag(rts(ct)))<0.01,
    rts_str = sprintf('     %0.3f',real(rts(ct)));
    ct = ct + 1;
   else
    rts_str = sprintf('     %0.3f +/- %0.3fi',real(rts(ct)),imag(rts(ct)));
    ct = ct + 2;
   end
%   text(x_loc,y_loc,rts_str,'fontsize',font_size,'verticalalignment','top',...
%       'fontname',fontname,'color','w');
%   y_loc = y_loc - ext_txt(4);
   list_str{end+1} = rts_str;
  end
 else
%  y_loc = 1;
%  text(0,y_loc,rts,'fontsize',font_size,'verticalalignment','top',...
%    'fontname',fontname,'color','w');
  list_str{end+1} = rts;
 end
 set(sys_list,'string',list_str,'value',1);

elseif any(environ == 8),

 plant_mat = input2;
 for_mat = input3;
 bac_mat = input4;

 plant_mat = termjoin(plant_mat,for_mat,bac_mat);
 [num,den] = termextr(plant_mat);
 ln = length(num); ld = length(den);
 num = [zeros(1,ld-ln),num]; den = [zeros(1,ln-ld),den];
 rts = roots(den + num);

% axes(sys_axes);
% cla

 if plant_mat(1,2) == 0,
  stable_str = 'Stable Closed-Loop';
  if any(real(rts)>0), stable_str = 'UNstable Closed-Loop'; end
 else
  stable_str = '';
 end

 type_num = plant_mat(2,1);
 if type_num < 0, type_num = 0; end
 type_str = ['System Type: ',int2str(type_num)];

 if length(num) == 1 & length(den) == 1,

  step_str = 'S.S.E.(Step): n/a';
  ramp_str = 'S.S.E.(Ramp): n/a';

 else

 % steady-state error to a step input
  if polyval(den,0) == 0,
   Kp = inf;
  else
   Kp = polyval(num,0)/polyval(den,0);
  end
  e_step = 1/(1+Kp);
  step_str = ['S.S.E.(Step): ',num2str(e_step)];

 % steady-state error to a ramp input
  plant_mat(2,1) = plant_mat(2,1)-1;
  [num,den] = termextr(plant_mat);
  if polyval(den,0) == 0,
   Kv = inf;
  else
   Kv = polyval(num,0)/polyval(den,0);
  end
  if Kv == 0,
   e_ramp = inf;
  else
   e_ramp = 1/Kv;
  end
  ramp_str = ['S.S.E.(Ramp): ',num2str(e_ramp)];
 end

 y_loc = 1;
 if plant_mat(1,2) == 0,
%  txt=text(0,y_loc,stable_str,'fontsize',font_size,'verticalalignment','top',...
%           'fontname',fontname,'color','w');
%  ext_txt = get(txt,'extent');
%  y_loc = y_loc - ext_txt(4);
  list_str{end+1} = stable_str;
 end

% txt=text(0,y_loc,type_str,'fontsize',font_size,'verticalalignment','top',...
%          'fontname',fontname,'color','w');
% ext_txt = get(txt,'extent');
% y_loc = y_loc - ext_txt(4);
 list_str{end+1} = type_str;

% text(0,y_loc,step_str,'fontsize',font_size,'verticalalignment','top',...
%          'fontname',fontname,'color','w');
% y_loc = y_loc - ext_txt(4);
 list_str{end+1} = step_str;

% text(0,y_loc,ramp_str,'fontsize',font_size,'verticalalignment','top',...
%          'fontname',fontname,'color','w');
 list_str{end+1} = ramp_str;
 set(sys_list,'string',list_str);
end