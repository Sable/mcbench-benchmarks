% to the value of the slider.
   function slider1_callback(hObject,eventdata)
   global fh slider1_data
      % Get 'slider' appdata.
      slider1_data = getappdata(fh,'slider'); 
      slider1_data.previous_val = slider1_data.val;
      slider1_data.val = get(hObject,'Value');
%      set(eth,'String',num2str(slider_data.val));
      sprintf('You changed the slider value--> %6.3f',...
              slider1_data.val)
      % Save 'slider' appdata before returning.
      setappdata(fh,'slider',slider1_data) 
end