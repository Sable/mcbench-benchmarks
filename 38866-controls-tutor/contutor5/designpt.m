function designpt(mode)
%
% Utility Function: DESIGNPT
%
% The purpose of this function is to allow the user to place a zeta line
% and wn cirlce on the root locus plot

% Author: Craig Borghesani
% Date: 9/2/94
% Revised:
% Copyright (c) 1999, Prentice-Hall

% obtain handle information
f = gcf;
ui_data = get(f,'userdata');
ui_han = ui_data{1};
ui_obj = ui_data{2};
%edt_top = ui_han(4);
%edt_btm = ui_han(5);
%sld_top = ui_han(6);
%sld_btm = ui_han(7);
%lft_btn = ui_han(8);
%rht_btn = ui_han(9);
edt_top = ui_obj.SysUI(7);
edt_btm = ui_obj.SysUI(10);
sld_top = ui_obj.SysUI(8);
sld_btm = ui_obj.SysUI(11);
lft_btn = ui_obj.SysUI(12);
rht_btn = ui_obj.SysUI(13);

if any(mode == [0,1]), % add/update zeta line and wn circle

 zeta = str2num(get(edt_top,'string'));
 wn = str2num(get(edt_btm,'string'));

 if (~length(zeta) | (~length(wn))),
  katcherr(2,11); return;
 elseif wn==0,
   katcherr(4,11); return;
 end

% zeta line
 zeta_ang = acos(zeta);
 x_pt = -abs(wn+0.5*wn)*cos(zeta_ang);
 y_pt = abs(wn+0.5*wn)*sin(zeta_ang);

% wn circle
 circ = pi/2:0.05:3/2*pi;
 wn_circ = [wn*exp(i*circ),NaN];

 if mode == 0,

  cur_page = get(ui_han(31),'userdata');
  page_setup = get(ui_han(34),'userdata');
  page_layout = get(ui_han(35),'userdata');
  rt_loc = find(page_setup(:,cur_page)==5);
  axes(page_layout(rt_loc,cur_page));

  lin(1) = line('xdata',[x_pt,0],'ydata',[y_pt,0],'linestyle','none',...
        'marker',':',...
       'tag','1520');
  lin(2) = line('xdata',real(wn_circ),'ydata',imag(wn_circ),'linestyle','none',...
        'marker',':',...
       'tag','1520');

  set(ui_han(26),'userdata',lin);
  set(sld_top,'enable','on','callback','designpt(2)',...
              'min',-1,'max',1,'value',zeta);
  set(sld_btm,'enable','on','callback','designpt(3)',...
              'min',wn*0.5,'max',wn*1.5,'value',wn);
  set(lft_btn,'string','Update','callback','designpt(1)');
  set(rht_btn,'callback','designpt(4)','enable','on');
 else
  lin = get(ui_han(26),'userdata');
  set(lin(1),'xdata',[x_pt,0],'ydata',[y_pt,0]);
  set(lin(2),'xdata',real(wn_circ),'ydata',imag(wn_circ));
  set(sld_top,'enable','on','value',zeta);
  set(sld_btm,'enable','on','min',wn*0.5,'max',wn*1.5,'value',wn);
 end

 set(ui_han(25),'userdata',[zeta,wn]);

elseif mode == 2, % iterating zeta line

 data = get(ui_han(25),'userdata');
 lin = get(ui_han(26),'userdata');

 wn = str2num(get(edt_btm,'string'));
 zeta = get(sld_top,'value');
 set(edt_top,'string',num2str(zeta));

% zeta line
 zeta_ang = acos(zeta);
 x_pt = -abs(wn+0.5*wn)*cos(zeta_ang);
 y_pt = abs(wn+0.5*wn)*sin(zeta_ang);

 set(lin(1),'xdata',[x_pt,0],'ydata',[y_pt,0]);

 data(1) = zeta;
 set(ui_han(25),'userdata',data);

elseif mode == 3, % iterating wn circle

 data = get(ui_han(25),'userdata');
 lin = get(ui_han(26),'userdata');

 wn = get(sld_btm,'value');
 set(edt_btm,'string',num2str(wn));
 minw = get(sld_btm,'min'); maxw = get(sld_btm,'max');
 if abs(wn) <= abs(minw) | abs(wn) >= abs(maxw),
  set(sld_btm,'min',0.5*wn,'max',1.5*wn,'value',wn);
 end

 zeta = str2num(get(edt_top,'string'));

% zeta line
 zeta_ang = acos(zeta);
 x_pt = -abs(wn+0.5*wn)*cos(zeta_ang);
 y_pt = abs(wn+0.5*wn)*sin(zeta_ang);

% wn circle
 circ = pi/2:0.05:3/2*pi;
 wn_circ = [wn*exp(i*circ),NaN];

 set(lin(1),'xdata',[x_pt,0],'ydata',[y_pt,0]);
 set(lin(2),'xdata',real(wn_circ),'ydata',imag(wn_circ));

 data(2) = wn;
 set(ui_han(25),'userdata',data);

elseif mode == 4, % deleting zeta line and wn circle

 lin = get(ui_han(26),'userdata');
 delete(lin);
 set(ui_han([25,26]),'userdata',[]);
 set(rht_btn,'userdata',[],'enable','off');
 set(lft_btn,'string','Add','callback','designpt(0)');
 set([sld_top,sld_btm],'enable','off');

elseif mode == 5, % replotting of zeta line and wn circle

 data = get(ui_han(25),'userdata');

 if length(data),

  zeta = data(1);
  wn = data(2);

% zeta line
  zeta_ang = acos(zeta);
  x_pt = -abs(wn+0.5*wn)*cos(zeta_ang);
  y_pt = abs(wn+0.5*wn)*sin(zeta_ang);

% wn circle
  circ = pi/2:0.05:3/2*pi;
  wn_circ = [wn*exp(i*circ),NaN];

  lin(1) = line('xdata',[0,x_pt],'ydata',[0,y_pt],'linestyle','none',...
                'marker',':',...
                'tag','1520');
  lin(2) = line('xdata',real(wn_circ),'ydata',imag(wn_circ),'linestyle','none',...
                'marker',':',...
                'tag','1520');

  set(ui_han(26),'userdata',lin);

 end
end