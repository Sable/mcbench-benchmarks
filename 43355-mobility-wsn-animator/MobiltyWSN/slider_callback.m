% Set the value of the edit text component String property
% to the value of the slider.
   function slider_callback(hObject,eventdata)
   global fh slider_data
      % Get 'slider' appdata.
      slider_data = getappdata(fh,'slider'); 
      slider_data.previous_val = slider_data.val;
      slider_data.val = get(hObject,'Value');
%      set(eth,'String',num2str(slider_data.val));
      sprintf('You changed the slider value--> %6.3f',...
              slider_data.val)
      % Save 'slider' appdata before returning.
      setappdata(fh,'slider',slider_data) 
end