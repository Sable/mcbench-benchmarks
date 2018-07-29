function pagesele(des_page,option)
% PAGESELE Turn to page selected by user.
%          PAGESELE turns on all graphical objects associated with the
%          desired page number.

% Author: Craig Borghesani
% Date: 10/17/94
% Revised:
% Copyright (c) 1999, Prentice-Hall

% obtain handle information
f = gcf;
ui_data = get(f,'userdata');
ui_han = ui_data{1};
popup = ui_han(1);
loc_axs = ui_han(11);
lab_txt = get(ui_han(44),'userdata');
cur_page = get(ui_han(31),'userdata');
page_layout = get(ui_han(35),'userdata');
page_chil = get(ui_han(90),'userdata');

set(page_chil,'checked','off');
set(page_chil(abs(des_page)),'checked','on');

if nargin == 1, option = []; end

if  length(cur_page) & cur_page ~= abs(des_page),
 axes(loc_axs);
 cla;
 cur_plots = page_layout(:,cur_page); cur_plots(find(cur_plots==0)) = [];
 set(cur_plots,'vis','off');
 for k = 1:length(cur_plots),
  data = get(cur_plots(k),'userdata');
  if any(data(1) == [1,2,3,4,8]),
   set(data(2:length(data)),'vis','off');
  else
   axes(cur_plots(k));
   cla;
  end
 end
end

des_plots = page_layout(:,abs(des_page)); des_plots(find(des_plots==0)) = [];
set(des_plots,'vis','on');
set(ui_han(31),'userdata',abs(des_page));

% set current axis
set(ui_han(32),'userdata',des_plots(1));
data = get(des_plots(1),'userdata');
if data(1) == 1, set(lab_txt(2),'string','Nyquist');
elseif data(1) == 2, set(lab_txt(2),'string','Bode (Magnitude)');
elseif data(1) == 3, set(lab_txt(2),'string','Bode (Phase)');
elseif data(1) == 4, set(lab_txt(2),'string','Nichols');
elseif data(1) == 5, set(lab_txt(2),'string','Root Locus');
elseif data(1) == 6, set(lab_txt(2),'string','Gain (Magnitude)');
elseif data(1) == 7, set(lab_txt(2),'string','Gain (Phase)');
elseif data(1) == 8, set(lab_txt(2),'string','Time Response'); end
first_plot = data(1);

if length(des_plots) > 1,
 data = get(des_plots(2),'userdata');
 set(lab_txt(2),'callback',['pagemous(3,',int2str(data(1)),',10)']);
else
 set(lab_txt(2),'callback','');
end

if des_page > 0,
 if get(popup,'value') == 11,
  popcall = get(popup,'callback');
  if popcall(1) == 't',
   termmang(1,2,1);
  else
   pidmang(1,2)
  end
 end

 pageplot(0,option);
end