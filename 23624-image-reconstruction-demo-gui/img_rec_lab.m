%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2008 Copyright (c) Hamed Hamid Muhammed %%
%% All rights reserved.                    %%
%%                                         %%
%% School of Technology and Health         %%
%% Royal Institute of Tachnology           %%
%% E-mail: hamed@sth.kth.se                %%
%% Phone: +46-(0)8-790 48 55               %%
%% Address: Alfred Nobels Alle 10          %%
%% 141 52 Huddinge                         %%
%% Sweden                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function img_rec_lab()
  
  figure('Resize', 'off', 'MenuBar','none', ...
    'Name','Image Reconstruction Demo', ...
    'NumberTitle','off','Position',[200 150 480 500], ...
    'Color',[0.941 0.941 0.941]);

  uicontrol('Style','Text', 'FontSize', 20, 'FontName', 'Arial', ...
    'Position',[10 460 380 30], 'HorizontalAlignment','left', ...
    'ForegroundColor', [0.078 0.169 0.549], ...
    'String', 'Image Reconstruction Demo', ...
    'BackgroundColor', [0.941 0.941 0.941]);

  PushButton1 = uicontrol('FontSize',14,'Style','PushButton','String',...
    'Open','Position',[40,350,100,50],'CallBack', @open_Callback);

  PushButton2 = uicontrol('FontSize',14,'Style','PushButton','String',...
    '(Filtered) Back Projection','Position',[40,245,260,60],...
    'CallBack', @PushButton2Selected);

  PushButton3 = uicontrol('FontSize',14,'Style','PushButton','String',...
    'Exit','Position',[40,150,100,50],'CallBack', @PushButton3Selected);

  uicontrol('Style','Text', 'FontSize', 14, 'FontName', 'Arial', ...
    'Position',[330 400 140 20], 'HorizontalAlignment','left', ...
    'ForegroundColor', [0.078 0.169 0.549], ...
    'String', 'Filter', ...
    'BackgroundColor', [0.941 0.941 0.941]);

  uicontrol('Style','Text', 'FontSize', 14, 'FontName', 'Arial', ...
    'Position',[330 290 140 20], 'HorizontalAlignment','left', ...
    'ForegroundColor', [0.078 0.169 0.549], ...
    'String', 'Interpolation', ...
    'BackgroundColor', [0.941 0.941 0.941]);
  
  List1 = {'None','Ram-Lak (Ramp)','Shepp-Logan','Ram-Lak Cosine',...
    'Ram-Lak Hamming','Ram-Lak Hann','Special'};

  List2 = {'Linear','Nearest','Spline','Cubic'};

  PopupMenu1 = uicontrol('Style','PopupMenu', 'FontSize', 12,'String',...
    List1,'Value',1,'Position',[330,360,100,20],'CallBack',...
    @PopupMenuCallBack1);

  PopupMenu2 = uicontrol('Style','PopupMenu', 'FontSize', 12,'String',...
    List2,'Value',1,'Position',[330,250,100,20],'CallBack',...
    @PopupMenuCallBack2);

  uicontrol('Style','Text', 'FontSize', 10, 'FontName', 'Arial', ...
    'Position',[10 10 470 80], 'HorizontalAlignment','left', ...
    'ForegroundColor', [0.078 0.169 0.549], ...
    'String', ['2008 Copyright (c) Hamed Hamid Muhammed, ' ...
    'School of Technology and Health, Royal Institute of Tachnology. '...
    '                                                                '...
    'E-mail: hamed@sth.kth.se, Phone: +46-(0)8-790 48 55'...
    '                                      '...
    'Address: Alfred Nobels Alle 10, 141 52 Huddinge, Sweden.'], ...
    'BackgroundColor', [0.941 0.941 0.941]);
  
  function PopupMenuCallBack1(varargin)  
    Lissst = get(PopupMenu1,'String');
    Val = get(PopupMenu1,'Value');
    list1_val = Lissst{Val};
  end

  function PopupMenuCallBack2(varargin)  
    Lissst = get(PopupMenu2,'String');
    Val = get(PopupMenu2,'Value');
    list2_val = Lissst{Val};
  end

  uicontrol('Style','Text', 'FontSize', 14, 'FontName', 'Arial', ...
    'Position',[230 180 200 20], 'HorizontalAlignment','left', ...
    'ForegroundColor', [0.078 0.169 0.549], ...
    'String', 'Number of Projections', ...
    'BackgroundColor', [0.941 0.941 0.941]);
  
  Edit = uicontrol('Style','Edit','String','180','Position',[230,150,100,20],...
    'CallBack', @EditCallBack, 'HorizontalAlignment','left');

  Slider = uicontrol('Style','Slider','Position',[350,150,100,20],...
    'CallBack', @SliderCallBack, 'Value',180,'Min',1,'Max',180);
  
  function EditCallBack(varargin)
    num = str2num(get(Edit,'String'));
    num = round(num);
    if length(num) == 1 && num <=180 && num >=1
      set(Slider,'Value',num);
      antal_projektioner = num;
      set(Edit, 'String', num2str(num));
    else
      msgbox('The value should be a number in the range [1,180]','ERROR','error','modal');
    end  
  end
    
  function SliderCallBack(varargin)    
    num = get(Slider, 'Value');
    num = round(num);
    set(Slider,'Value',num);
    set(Edit, 'String', num2str(num));
    antal_projektioner = num;
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%

  function open_Callback(h, eventdata)
    [file_name, mach_path] = uigetfile( ...
      {'*.MAT', 'All MAT-Files (*.MAT)'}, ... 
      'Select File');
 
    % If "Cancel" is selected then return
    if isequal([file_name,mach_path],[0,0])
      return   
      % Otherwise construct the fullfilename and Check and load the file
    end
 
    filename=file_name;
    length_fn=length(filename);
    st_pt=length_fn+1-4;
    file_ext=filename(st_pt:length_fn);
    
    if upper(file_ext) == '.MAT' % if the file is a mat file
      data = load(file_name);
      figure
      imagesc(data.sinogram), colormap(hot)
      title(data.txt)
    else
      msgbox('That was NOT a MAT file!','ERROR','error','modal')
      disp('That was NOT a MAT file!')
    end
  end

  function PushButton2Selected(h, eventdata)
    switch list1_val
      case 'None'
        filter_val = 'None';
      case 'Ram-Lak (Ramp)'
        filter_val = 'Ram-Lak';
      case 'Shepp-Logan'
        filter_val = 'Shepp-Logan';
      case 'Ram-Lak Cosine'
        filter_val = 'Cosine';
      case 'Ram-Lak Hamming'
        filter_val = 'Hamming';
      case 'Ram-Lak Hann'
        filter_val = 'Hann';
      case 'Special'
        filter_val = 'Special';
    end
    
    switch list2_val
      case 'Linear'
        interpol_val = 'linear';
      case 'Nearest'
        interpol_val = 'nearest';
      case 'Spline'
        interpol_val = 'spline';
      case 'Cubic'
        interpol_val = 'pchip';
    end

    theta = round(0 : 180/antal_projektioner : 179);
    del_sinogram = data.sinogram(:, theta+1);

    if strcmp(filter_val, 'Special') == 1
      if strcmp(file_name(end-4:end), '3.mat') == 1
        data.SB = data.SB + 0.3 * rand(size(data.SB));
      end
      
      if strcmp(file_name(end-4:end), 'f.mat') == 1
        filter_val = 'Hamming';
        rec_img = iradon(del_sinogram, theta, interpol_val, filter_val);
      else
        FFT_sinogram = fftshift(fft(del_sinogram),1);
        FFT_sinogram = FFT_sinogram .* data.SB(:, theta+1);
        del_sinogram = ifft(ifftshift(FFT_sinogram,1));
        rec_img = iradon(del_sinogram, theta, interpol_val);
      end
    else
      rec_img = iradon(del_sinogram, theta, interpol_val, filter_val);
    end
    
    figure, imagesc(rec_img), colormap(pink)
    title([data.txt ': ' num2str(antal_projektioner) ' projections, ' list1_val ' filter, ' list2_val ' interpolation'])
  end
  
  function PushButton3Selected(h, eventdata)
    close
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%
  
  list1_val = 'None';
  filter_val = 'None';

  list2_val = 'Linear';
  interpol_val = 'linear'; 
  
  data = 0;
  SB = 0;
  antal_projektioner = 180;
  file_name = '';
end

