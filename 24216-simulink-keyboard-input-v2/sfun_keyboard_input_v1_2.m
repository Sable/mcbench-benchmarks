function sfun_keyboard_input_v1_2(block)
% modified from sfun_keyboard_input_v1_01.m of Marc Compere by Emanuele Ruffaldi
% created : 17 June 2003
% modified: 20 June 2003
% created: 19 May 2009 => Level 2 and terminate
%

% Level-2 M file S-Function with keyboard
%   Copyright 1990-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $ 

  setup(block);
  
%endfunction

function setup(block)
  
  block.NumDialogPrms  = 0;
  block.NumInputPorts  = 0;
  block.NumOutputPorts = 2;

  block.OutputPort(1).Dimensions       = 1;
  block.OutputPort(1).SamplingMode = 'Sample';
  block.OutputPort(1).DatatypeID  = 0;
  block.OutputPort(2).Dimensions       = 1;
  block.OutputPort(2).SamplingMode = 'Sample';
  block.OutputPort(2).DatatypeID  = 0;
  block.SampleTimes = [-1, 0];
%end
  
  %% Register methods
%  block.RegBlockMethod('CheckParameters', @CheckPrms);
  block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
  block.RegBlockMethod('InitializeConditions',    @InitConditions);  
  block.RegBlockMethod('Outputs',                 @Output);  
  block.RegBlockMethod('Update',                  @Update);  
  block.RegBlockMethod('Terminate',                 @Terminate);    
%endfunction

function DoPostPropSetup(block)

  %% Setup Dwork
  block.NumDworks = 3;
  block.Dwork(1).Name = 'key'; 
  block.Dwork(1).Dimensions      = 1;
  block.Dwork(1).DatatypeID      = 0;
  block.Dwork(1).Complexity      = 'Real';
  block.Dwork(1).UsedAsDiscState = true;

  block.Dwork(2).Name = 'fig'; 
  block.Dwork(2).Dimensions      = 1;
  block.Dwork(2).DatatypeID      = 0;
  block.Dwork(2).Complexity      = 'Real';
  block.Dwork(2).UsedAsDiscState = false;

  block.Dwork(3).Name = 'new'; 
  block.Dwork(3).Dimensions      = 1;
  block.Dwork(3).DatatypeID      = 0;
  block.Dwork(3).Complexity      = 'Real';
  block.Dwork(3).UsedAsDiscState = true;
%endfunction

function InitConditions(block)

  %% Initialize Dwork
  block.Dwork(1).Data = 0;
   handle.figure=findobj('type','figure','Tag','keyboard input figure');
   
   if isempty(handle.figure)
      % 'position' args -> [left, bottom, width, height]
      handle.figure=figure('position',[100 100 400 200],...
                           'WindowStyle','Modal',...
                           'Name','Keyboard Input',...
                           'Color',get(0,'DefaultUicontrolBackgroundColor')); %,...
                           %'HandleVisibility','callback');
      %handle.figure=figure('position',[800 620 400 300]);
      %handle.figure=figure('position',[800 620 400 300],'WindowButtonDownFcn',@myCallback)
      %handle.figure=figure('position',[800 620 400 300],'WindowButtonMoveFcn',@myCallback_move,'WindowButtonDownFcn',@myCallback_clickdown)
      set(handle.figure,'Tag','keyboard input figure');

      % Make the OFF button (position args->[left bottom width height])
      handle.offbutton = uicontrol(handle.figure,...
          'Style','pushbutton',...
          'Units','characters',...
          'Position',[5 5 46 2],...
          'String','Disable exclusive figure-keyboard input',...
          'Callback',{@turn_modal_off,handle});

      % Make the ON button (position args->[left bottom width height])
      handle.onbutton = uicontrol(handle.figure,...
          'Style','pushbutton',...
          'Units','characters',...
          'Position',[5 1 46 2],...
          'String','Re-enable exclusive figure-keyboard input',...
          'Callback',{@turn_modal_on,handle});

   else, % reset the figure to 'modal' to continue accepting keyboard input
      set(handle.figure,'WindowStyle','Modal')
   end
  block.Dwork(2).Data = handle.figure;

  
%endfunction

function Output(block)

  block.OutputPort(1).Data = block.Dwork(1).Data;
  block.OutputPort(2).Data = block.Dwork(3).Data;
  
%endfunction

function Update(block)

   handle.figure = block.Dwork(2).Data;
   %handle = get(handle.figure,'userdata');

   current_char=get(handle.figure,'CurrentCharacter'); % a single character, like 'b'

   % update the grahics object
   %set(handle.point,'Xdata',[x(1) x(1)],'Ydata',[x(2) x(2)],'Zdata',[-1 +1]);


   % conditionally update the (numeric) state
   if ~isempty(current_char)
      block.Dwork(1).Data =double(current_char);
      block.Dwork(3).Data = 1;
	   % reset 'CurrentCharacter' so if user lifts up from key, this is noticed
	   set(handle.figure,'CurrentCharacter',char(0)) % the plus key is the only key that may be
   else,
      block.Dwork(3).Data = 0;
   end

                                   % pressed, but when the user stops, is not noticed

   % notes:
   %    - use sprintf() to convert string -> number contained in a string (or character) variable
   %    - use char() to convert floating point number -> ascii character
   %    - use str2num() to convert the string-number into a (double) floating point number
   %    - use str2num() with char() to convert a number-string into a char-string
   %         char(97) == char(str2num('97')) --> 'a'
   %    - use num2str() to convert a (double) number into the same number but contained
   %      in a string variable
   % For example:
   %    tmp='a';                        % assign a string
   %    tmp_num=sprintf('%i',tmp)       % convert that string into a number contained in a string variable, tmp_num
   %        (tmp_num is the string containing the characters '97')
   %    tmp_char=char(str2num(tmp_num)) % convert that string variable back into a number, then into the original string


  
%endfunction



% Callback for turning Modal OFF
function turn_modal_off(obj,eventdata,handle)
%disp('turn_modal_off:')
%handle
set(handle.figure,'WindowStyle','Normal')
%end


% Callback for turning Modal ON
function turn_modal_on(obj,eventdata,handle)
%disp('turn_modal_on:')
%handle
set(handle.figure,'WindowStyle','Modal')
%end


% % Callback for 'WindowButtonMoveFcn' in figure
% function myCallback_move(obj,eventdata)
% str=sprintf('\tWindowButtonMoveFcn callback executing');disp(str)
% end
% 
% % Callback for 'WindowButtonDownFcn' in figure
% function myCallback_clickdown(obj,eventdata)
% str=sprintf('\t\tWindowButtonDownFcn callback executing');disp(str)
% end



function Terminate(block)
   handle.figure = block.Dwork(2).Data;
   if handle.figure ~= 0
       close (handle.figure);
   end