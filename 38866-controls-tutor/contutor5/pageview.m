function pageview(mode,cur_axs)
% PAGEVIEW View menu.
%          PAGEVIEW handles all the axis limit altering options under the
%          View pulldown menu.

% Author: Craig Borghesani
% Date: 8/10/94
% Revised: 10/18/94
% Copyright (c) 1999, Prentice-Hall

% obtain handle information
f = gcf;
ui_data = get(f,'userdata');
ui_han = ui_data{1};
last_lims = ui_han(36);

stat_bar = get(ui_han(43),'userdata');

if nargin == 1,
 cur_axs = get(ui_han(32),'userdata');
end

axs_data = get(cur_axs,'userdata');
axs_typ = axs_data(1);

if mode == 1, % Full

 if nargin == 1, set(stat_bar,'string','Setting axis limits to Full'); end

 cur_xlim = get(cur_axs,'xlim');
 cur_ylim = get(cur_axs,'ylim');
 set(last_lims,'userdata',[cur_axs,cur_xlim,cur_ylim]);

 lins = get(cur_axs,'children');
 cur_xlabel = get(cur_axs,'xlabel');
 cur_ylabel = get(cur_axs,'ylabel');
 cur_title = get(cur_axs,'title');
 lims = [1/eps,-1/eps,1/eps,-1/eps];
 for k = 1:length(lins),
  if strcmp(get(lins(k),'vis'),'on'),
   if strcmp(get(lins(k),'type'),'line'),
    xdata = get(lins(k),'xdata');  ydata = get(lins(k),'ydata');
   elseif ~any(lins(k) == [cur_xlabel,cur_ylabel,cur_title]),
    locdata = get(lins(k),'pos');
    xdata = locdata(1); ydata = locdata(2);
   else
    xdata = []; ydata = [];
   end
   if length(xdata) & (abs(xdata(1))<1000 & abs(ydata(1))<1000 & axs_typ==5) | axs_typ~=5,
    lims(1) = min([xdata(~isnan(xdata)),lims(1)]);
    lims(2) = max([xdata(~isnan(xdata)),lims(2)]);
    lims(3) = min([ydata(~isnan(ydata)),lims(3)]);
    lims(4) = max([ydata(~isnan(ydata)),lims(4)]);
   end
  end
 end

 if (lims(1) == 1/eps) | (lims(2) == -1/eps) | all(lims(1:2)==0),
  if any(axs_typ == [1,5]), lims(1) = -1; lims(2) = 1;
  elseif any(axs_typ==[2,3,6,7]), lims(1) = 0.01; lims(2) = 1000;
  elseif axs_typ == 4, lims(1) = -360; lims(2) = 0;
  elseif axs_typ == 8, lims(1) = 0; lims(2) = 10; end
 end

 if (lims(3) == 1/eps) | (lims(4) == -1/eps) | all(lims(3:4)==0),
  if any(axs_typ == [1,5]), lims(3) = -1; lims(4) = 1;
  elseif any(axs_typ == [2,4]), lims(3) = -20; lims(4) = 20;
  elseif axs_typ == 3, lims(3) = -360; lims(4) = 0;
  elseif axs_typ == 6, lims(3) = 0.1; lims(4) = 10;
  elseif axs_typ == 7, lims(3) = 0; lims(4) = 360;
  elseif axs_typ == 8, lims(3) = 0; lims(4) = 5; end
 end

 if any(axs_typ==[1,4,5]),
  if diff(lims(1:2))==0, lims(1:2) = [-abs(lims(1)),abs(lims(1))]; end
  if diff(lims(3:4))==0, lims(3:4) = [-abs(lims(3)),abs(lims(3))]; end
  lims(1:2) = lims(1:2) + diff(lims(1:2))*[-0.1,0.1];
  lims(3:4) = lims(3:4) + diff(lims(3:4))*[-0.1,0.1];
 elseif any(axs_typ == [2,3,7,8]),
  if diff(lims(3:4))==0, lims(3:4) = [lims(3)-10,lims(3)+10]; end
  lims(3:4) = lims(3:4) + diff(lims(3:4))*[-0.1,0.1];
 else
  loglims = log10(lims(3:4));
  loglims = loglims + diff(loglims)*[-0.1,0.1];
  lims(3:4) = 10 .^(loglims);
 end

 if axs_typ == 3,
  if lims(3) < -360, lims(3) = -360; end
  if lims(4) > 0, lims(4) = 0; end
 elseif axs_typ == 4,
  if lims(1) < -360, lims(1) = -360; end
  if lims(2) > 0, lims(2) = 0; end
 elseif axs_typ == 5,
  if lims(1) > 0, lims(1) = -1; end
  if lims(2) < 0, lims(2) = 1; end
 end

 if any(axs_typ == [1, 5]),
  set(cur_axs,{'xlim','ylim'},ctsqaxes(cur_axs,lims(1:2),lims(3:4)));
 else
  set(cur_axs,'xlim',lims(1:2),'ylim',lims(3:4));
 end

elseif any(mode == [2,3]), % In/Out

 if mode == 2,
  out = 0.15;
  if nargin == 1, set(stat_bar,'string','Zooming In'); end
 else
  out = -0.15;
  if nargin == 1, set(stat_bar,'string','Zooming Out'); end
 end

 cur_xlim = get(cur_axs,'xlim');
 cur_ylim = get(cur_axs,'ylim');
 set(last_lims,'userdata',[cur_axs,cur_xlim,cur_ylim]);

 if any(axs_typ == [1,4,5,8]),
  delx = diff(cur_xlim);
  new_xlim = cur_xlim+out*[delx,-delx];
  dely = diff(cur_ylim);
  new_ylim = cur_ylim+out*[dely,-dely];
 elseif any(axs_typ == [2,3,7]),
  loglims = log10(cur_xlim);
  delx = diff(loglims);
  loglims = loglims + out*[delx,-delx];
  new_xlim = 10 .^(loglims);
  dely = diff(cur_ylim);
  new_ylim = cur_ylim+out*[dely,-dely];
 else
  loglims = log10(cur_xlim);
  delx = diff(loglims);
  loglims = loglims + out*[delx,-delx];
  new_xlim = 10 .^(loglims);
  loglims = log10(cur_ylim);
  dely = diff(loglims);
  loglims = loglims + out*[dely,-dely];
  new_ylim = 10 .^(loglims);
 end

 if axs_typ == 3,
  if new_ylim(1) < -360, new_ylim(1) = -360; end
  if new_ylim(2) > 0, new_ylim(2) = 0; end
 elseif axs_typ == 4,
  if new_xlim(1) < -360, new_xlim(1) = -360; end
  if new_xlim(2) > 0, new_xlim(2) = 0; end
 end

 if any(axs_typ == [1, 5]),
  set(cur_axs,{'xlim','ylim'},ctsqaxes(cur_axs,new_xlim,new_ylim));
 else
  set(cur_axs,'xlim',new_xlim,'ylim',new_ylim);
 end

elseif mode == 4, % Zoom

 set(stat_bar,'string','Zoom Mode: press and drag mouse to define new limits');
 set(f,'pointer','crosshair');
 set(f,'windowbuttondownfcn','pageview(10)','windowbuttonupfcn','1;');

elseif mode == 10, % Zoom (RBBOX stage)

 cur_obj = get(f,'currentobject');
 par_cur = get(cur_obj,'parent');
 sel_axs = 0;
 if par_cur == f, % if the parent is the figure, we have an axis object
  sel_axs = cur_obj;
 elseif par_cur,  % if the parent is not the root, then it must be an axis
  sel_axs = par_cur;
 end

 if sel_axs,

  set(stat_bar,'string','Selecting region...');
  pt0 = get(sel_axs,'currentpoint');
  rbbox([get(f,'currentpoint'),0,0],get(f,'currentpoint'));
  drawnow;

  set(stat_bar,'string','Setting new axis limits');
  pt1 = get(sel_axs,'currentpoint');

  cur_xlim = get(sel_axs,'xlim');
  cur_ylim = get(sel_axs,'ylim');
  set(last_lims,'userdata',[sel_axs,cur_xlim,cur_ylim]);

  new_xlim = [min(pt0(1,1),pt1(1,1)), max(pt0(1,1),pt1(1,1))];
  new_ylim = [min(pt0(1,2),pt1(1,2)), max(pt0(1,2),pt1(1,2))];

  if axs_typ == 3,
   if new_ylim(1) < -360, new_ylim(1) = -360; end
   if new_ylim(2) > 0, new_ylim(2) = 0; end
  elseif axs_typ == 4,
   if new_xlim(1) < -360, new_xlim(1) = -360; end
   if new_xlim(2) > 0, new_xlim(2) = 0; end
  end

  set(f,'windowbuttondownfcn','pagemous','windowbuttonupfcn','',...
        'pointer','arrow');

  axs_data = get(sel_axs,'userdata');
  axs_typ = axs_data(1);
  if any(axs_typ == [1, 5]),
   set(sel_axs,{'xlim','ylim'},ctsqaxes(sel_axs,new_xlim,new_ylim));
  else
   set(sel_axs,'xlim',new_xlim,'ylim',new_ylim);
  end

 else

  set(stat_bar,'string','Need to be in an axis region to use Zoom');

 end

elseif mode == 5, % Last

 data = get(last_lims,'userdata');
 set(stat_bar,'string','Restoring Last axis limits');

 cur_xlim = get(cur_axs,'xlim');
 cur_ylim = get(cur_axs,'ylim');
 set(last_lims,'userdata',[cur_axs,cur_xlim,cur_ylim]);

 axs_data = get(data(1),'userdata');
 axs_typ = axs_data(1);
 if any(axs_typ == [1, 5]),
  set(data(1),{'xlim','ylim'},ctsqaxes(cur_axs,cur_xlim,cur_ylim));
 else
  set(data(1),'xlim',cur_xlim,'ylim',cur_ylim);
 end

elseif mode == 6, % grid on/off

 if strcmp(get(cur_axs,'xgrid'),'on'),
  set(stat_bar,'string','Turning grid Off');
  set(cur_axs,'xgrid','off','ygrid','off');
 else
  set(stat_bar,'string','Turning grid On');
  set(cur_axs,'xgrid','on','ygrid','on');
 end

end