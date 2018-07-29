function cttools(mode)

f = gcf;
ui_data = get(f,'userdata');
ui_obj = ui_data{2};
eraser2 = ui_obj.eraser2;
tab_uis = ui_obj.ToolTabs;

% define various shades of grey
grey = get(0,'defaultuicontrolbackground');
ltgrey = [0.5,0.5,0.5]*1.5;
dkgrey = [0.5,0.5,0.5]*0.5;

switch mode
   case 'Freq',

      %sel_dims = [-3,0,+6,+2];
      %unsel_dims = [3,0,-6,-2];

      sel_dims = [0,0,0,+2];
      unsel_dims = [0,0,0,-2];

      sel_tab = findobj(f,'tag','selected_tab2');
      cur_obj = tab_uis(1);
      if sel_tab == cur_obj, return; end

      if length(sel_tab),
         tab_pos = get(sel_tab,'pos');
         set(sel_tab,'pos',tab_pos+unsel_dims,'tag','',...
                     'back',ltgrey);
      end

      cur_pos = get(cur_obj,'pos');
      set(cur_obj,'pos',cur_pos+sel_dims,'tag','selected_tab2',...
                  'back',grey);
      eraser_pos = cur_pos+sel_dims;
      set(eraser2,'pos',[eraser_pos(1:3)+[2,0,-4],2]);

      set([ui_obj.RootUI, ui_obj.TimeUI],'vis','off');
      set(ui_obj.FreqUI,'vis','on');

   case 'Root',

      %sel_dims = [-3,0,+6,+2];
      %unsel_dims = [3,0,-6,-2];

      sel_dims = [0,0,0,+2];
      unsel_dims = [0,0,0,-2];

      sel_tab = findobj(f,'tag','selected_tab2');
      cur_obj = tab_uis(2);
      if sel_tab == cur_obj, return; end

      if length(sel_tab),
         tab_pos = get(sel_tab,'pos');
         set(sel_tab,'pos',tab_pos+unsel_dims,'tag','',...
                     'back',ltgrey);
      end

      cur_pos = get(cur_obj,'pos');
      set(cur_obj,'pos',cur_pos+sel_dims,'tag','selected_tab2',...
                  'back',grey);
      eraser_pos = cur_pos+sel_dims;
      set(eraser2,'pos',[eraser_pos(1:3)+[2,0,-4],2]);

      set([ui_obj.FreqUI, ui_obj.TimeUI],'vis','off');
      set(ui_obj.RootUI,'vis','on');

   case 'Time',

      %sel_dims = [-3,0,+6,+2];
      %unsel_dims = [3,0,-6,-2];

      sel_dims = [0,0,0,+2];
      unsel_dims = [0,0,0,-2];

      sel_tab = findobj(f,'tag','selected_tab2');
      cur_obj = tab_uis(3);
      if sel_tab == cur_obj, return; end

      if length(sel_tab),
         tab_pos = get(sel_tab,'pos');
         set(sel_tab,'pos',tab_pos+unsel_dims,'tag','',...
                     'back',ltgrey);
      end

      cur_pos = get(cur_obj,'pos');
      set(cur_obj,'pos',cur_pos+sel_dims,'tag','selected_tab2',...
                  'back',grey);
      eraser_pos = cur_pos+sel_dims;
      set(eraser2,'pos',[eraser_pos(1:3)+[2,0,-4],2]);

      set([ui_obj.FreqUI, ui_obj.RootUI],'vis','off');
      set(ui_obj.TimeUI,'vis','on');

end