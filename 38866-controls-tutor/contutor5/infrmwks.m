function infrmwks(mode,val1,val2,val3,val4)
%
% Utility Function: INFRMWKS
%
% This function provides a gateway from the workspace to the environment

% Author: Craig Borghesani
% Date: 9/5/94
% Revised: 11/15/94
% Copyright (c) 1999, Prentice-Hall

if mode == 0,
 f = gcf;
else
 f2 = gcf;
 f = get(f2,'userdata');
end
ui_data = get(f,'userdata');
ui_han = ui_data{1};
ui_obj = ui_data{2};
cur_sys = get(ui_han(30),'userdata');
sys_state = get(ui_han(33),'userdata');
ui_han2 = get(ui_han(50),'userdata');
stat_bar = get(ui_han(43),'userdata');
win_str = get(ui_han(48),'userdata');
if length(ui_han2),
 stat_bar2 = ui_han2(16);
end

if mode==0, % Setup

 if ~figflag(['In From Workspace...',win_str]),
  f2 = figure('numbertitle','off','menubar','none','name',['In From Workspace...',win_str],...
              'pos',[30,50,395,187],'color',[0.8,0.8,0.8],'resize','off',...
              'userdata',f);

% Variable Input Fields
  del = 17;
  uicontrol('style','text','string','Variable Names',...
            'pos',[10,145+del,375,17],'horizontalalignment','left',...
            'backgroundcolor',[0.8,0.8,0.8]);
  ui_han2(1) = uicontrol('style','text','string','Num:',...
            'pos',[0,123+del,40,17],'horizontalalignment','right',...
            'backgroundcolor',[0.8,0.8,0.8]);
  ui_han2(2) = uicontrol('style','edit','pos',[40,123+del,55,20],'backgroundcolor','w',...
                     'callback','infrmwks(1)',...
                     'horiz','left');

  ui_han2(3) = uicontrol('style','text','string','Den:',...
            'pos',[95,123+del,40,17],'horizontalalignment','right',...
            'backgroundcolor',[0.8,0.8,0.8]);
  ui_han2(4) = uicontrol('style','edit','pos',[135,123+del,55,20],'backgroundcolor','w',...
                     'callback','infrmwks(1)',...
                     'horiz','left');

  ui_han2(5) = uicontrol('style','text','string','',...
            'pos',[190,123+del,40,17],'horizontalalignment','right','vis','off',...
            'backgroundcolor',[0.8,0.8,0.8]);
  ui_han2(6) = uicontrol('style','edit','pos',[230,123+del,55,20],'backgroundcolor','w',...
                     'callback','infrmwks(1)','vis','off',...
                     'horiz','left');

  ui_han2(7) = uicontrol('style','text','string','',...
            'pos',[285,123+del,40,17],'horizontalalignment','right','vis','off',...
            'backgroundcolor',[0.8,0.8,0.8]);
  ui_han2(8) = uicontrol('style','edit','pos',[325,123+del,55,20],'backgroundcolor','w',...
                     'callback','infrmwks(1)','vis','off',...
                     'horiz','left');

%  set(ui_han2([1:2:7]),'backgroundcolor',[0.5,0.5,0.5]);

% Option Fields
  uicontrol('style','text','string','Format',...
            'pos',[10,100+del,180,17],'horizontalalignment','left',...
            'backgroundcolor',[0.8,0.8,0.8]);
  ui_han2(9) = uicontrol('style','radio','pos',[10,80+del,180,20],...
                     'string','Numerator/Denominator',...
                     'backgroundcolor',[0.8,0.8,0.8],...
                     'callback','infrmwks(2)','value',1);
  ui_han2(10) = uicontrol('style','radio','pos',[10,60+del,180,20],...
                     'string','Zero/Pole/Gain',...
                     'backgroundcolor',[0.8,0.8,0.8],...
                     'callback','infrmwks(2)','value',0);
  ui_han2(11) = uicontrol('style','radio','pos',[10,40+del,180,20],...
                     'string','State Space',...
                     'backgroundcolor',[0.8,0.8,0.8],...
                     'callback','infrmwks(2)','value',0);

  uicontrol('style','text','string','Transfer Function',...
            'pos',[205,100+del,180,17],'horizontalalignment','left',...
            'backgroundcolor',[0.8,0.8,0.8]);
  ui_han2(12) = uicontrol('style','radio','pos',[205,80+del,180,20],...
                     'string','Plant',...
                     'backgroundcolor',[0.8,0.8,0.8],...
                     'callback','infrmwks(3)','value',1);
  ui_han2(13) = uicontrol('style','radio','pos',[205,60+del,180,20],...
                     'string','Forward Controller',...
                     'backgroundcolor',[0.8,0.8,0.8],...
                     'callback','infrmwks(3)','value',0);
  ui_han2(14) = uicontrol('style','radio','pos',[205,40+del,180,20],...
                     'string','Feedback Controller',...
                     'backgroundcolor',[0.8,0.8,0.8],...
                     'callback','infrmwks(3)','value',0);

  for c=1:3,
   set(ui_han2(8+c),'userdata',ui_han2(:,8+[1:(c-1),(c+1):3]));
  end

  for c=1:3,
   set(ui_han2(11+c),'userdata',ui_han2(:,11+[1:(c-1),(c+1):3]));
  end

  ui_han2(15) = uicontrol('style','push','pos',[103,10+del,60,20],'string','OK');
  uicontrol('style','push','pos',[166,10+del,60,20],'string','Cancel',...
            'callback','infrmwks(5)');
  uicontrol('style','push','pos',[232,10+del,60,20],'string','Help',...
            'callback','userhelp(5,2)');

  ui_han2(16) = uicontrol('style','edit','pos',[0,0,395,20],...
             'foregroundcolor','k',...
             'horizontalalignment','left');
  stat_bar2 = ui_han2(16);
  set(ui_han(50),'userdata',ui_han2);

 end

 set(stat_bar2,'string','Enter variable names into edit boxes, press OK when done');
 drawnow;

elseif mode==1, % edit fields

% build input string
 input_str = [];

 for k = 2:2:8,
  var_str = get(ui_han2(k),'string');
  if length(var_str),
   input_str = [input_str,var_str,','];
  end
 end

% remove extra comma
 input_str(length(input_str))=[];

% setup callback to pass desired variables to environment
 callback_str = ['eval(''infrmwks(4,',input_str,');'',''infrmwks(6)'')'];
% callback_str = ['infrmwks(4,',input_str,');'];
 set(ui_han2(15),'callback',callback_str);

elseif mode==2, % format

 cur_obj = get(f2,'currentobject');
 data = get(cur_obj,'userdata');
 set(data,'value',0);
 set(cur_obj,'value',1);

 if cur_obj == ui_han2(9), % num/den
  set(ui_han2(5:8),'vis','off');
  set(ui_han2(1),'string','Num:');
  set(ui_han2(3),'string','Den:');

 elseif cur_obj == ui_han2(10), % z/p/k
  set(ui_han2(7:8),'vis','off');
  set(ui_han2(5:6),'vis','on');
  set(ui_han2(1),'string','Zero:');
  set(ui_han2(3),'string','Pole:');
  set(ui_han2(5),'string','Gain:');

 elseif cur_obj == ui_han2(11), % state space
  set(ui_han2(5:8),'vis','on');
  set(ui_han2(1),'string','A:');
  set(ui_han2(3),'string','B:');
  set(ui_han2(5),'string','C:');
  set(ui_han2(7),'string','D:');
 end

elseif mode==3, % plant or controller

 cur_obj = get(f2,'currentobject');
 data = get(cur_obj,'userdata');
 set(data,'value',0);
 set(cur_obj,'value',1);

elseif mode==4, % OK

 if nargin==3, % numerator/denominator
  term_mat = termpars(val1,val2);
 end

 if nargin==4,
  term_mat = zpk2term(val1,val2,val3);
 end

 if nargin==5,
  [z,p,k] = ss2zp(val1,val2,val3,val4,1);
  term_mat = zpk2term(z(:,1),p(:,1),k(1,1));
 end

 cur_sel = find(sys_state(1:3,cur_sys)==1);

 if get(ui_han2(12),'value'), sel = 3;
 elseif get(ui_han2(13),'value'), sel = 6;
 elseif get(ui_han2(14),'value'), sel = 9; end

 cur_mat = get(ui_han(sel+cur_sys),'userdata');
 if any(cur_mat(1,4) == [20,40]),
  set(stat_bar2,'string','You are in PID format. Switch to Num-Den format to load variables');
 elseif length(term_mat),
  set(ui_han(sel+cur_sys),'userdata',term_mat);
  plant_mat = get(ui_han(3+cur_sys),'userdata');
  for_mat = get(ui_han(6+cur_sys),'userdata');
  bac_mat = get(ui_han(9+cur_sys),'userdata');
  term_res = get(ui_han(cur_sys),'userdata');
  w = term_res(1,:);
  term_mat = termjoin(plant_mat,for_mat,bac_mat);
  new_res = termcplx(term_mat,w);
  term_res(2,:) = new_res;
  set(ui_han(cur_sys),'userdata',term_res);
  set(f2,'vis','off');

  figure(f);

  if cur_sel*3 == sel,
   dispfrac
  end

  pageplot(0,[]);

  if cur_sel*3 == sel,
   termmang(1,2,1)
  end

  set(stat_bar,'string','Variables passed into environment');

% file modification flag
  set(ui_han(47),'userdata',1);

 else

  set(stat_bar2,'string','You must fill all edit boxes');

 end

elseif mode==5, % Cancel

 set(f2,'vis','off');

elseif mode==6, % error catching

 set(stat_bar2,'string','Are all variable names entered in the workspace?');

end
