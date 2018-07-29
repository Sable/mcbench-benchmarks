function SimulinkLED_mSfcn4(block)
% Level-2 M file S-Function
%
% Simulink LED
%
% Used to display status of signal.
%
% --------------------------------------------------------------
% 'Outport' Checkbox is for displaying the current value,
% the user can connect the outport with a display block,
% the value from the outport of LED is equal to the inport.
%
% The range syntax:       (-inf 1]
%                         (0.5  0.7)
%                         [0 1]
%                         (2 inf)
%
% please make sure that the '-inf' and 'inf' are always with
% brackets '(' and ')'.
%
% Hint:
% Using with only one Range (should be Range1),
% please leave Range2 being empty.
% --------------------------------------------------------------
%
% version 1.2
% Po.Hu
% 30.04.2006
%
% version 1.4
% Add shape option
% Po.Hu
% 03.08.2006

setup(block);

%endfunction

function setup(block)

%% Register number of dialog parameters
block.NumDialogPrms = 7;


%% Register number of input and output ports
block.NumInputPorts = 1;

%% Setup functional port properties to dynamically
%% inherited.
block.SetPreCompInpPortInfoToDynamic;
outportflag = block.DialogPrm(1).Data;
if outportflag == 1
    block.SetPreCompOutPortInfoToDynamic;
    block.NumOutputPorts = 1;
else
    block.NumOutputPorts = 0;
end

block.InputPort(1).DirectFeedthrough = true;

%% Set block sample time to inherited
block.SampleTimes = [-1 0];

%% Run accelerator on TLC
block.SetAccelRunOnTLC(true);

%% Register methods

block.RegBlockMethod('Outputs', @Output);

%endfunction

function Output(block)

% Outport Active
outportflag = block.DialogPrm(1).Data;
if outportflag == 1
    block.OutputPort(1).Data = block.InputPort(1).Data;
end


range1    = block.DialogPrm(3).Data;
color1    = block.DialogPrm(4).Data;
range2    = block.DialogPrm(5).Data;
color2    = block.DialogPrm(6).Data;
colorRest = block.DialogPrm(7).Data;



color1    = lower(color1);
color2    = lower(color2);
colorRest = lower(colorRest);


% convert Color Strings to Color Numbers
color1No  = colorStr2colorNo(color1);
color2No  = colorStr2colorNo(color2);
colorRestNo = colorStr2colorNo(colorRest);


if range1 == '0'
    error('The first range should not be empty!')
    return
end
% This part is very important for convertion of string to numeric
valueRange1 = sscanf(range1, '%c %f %f %c');

% range syntax check
if ~isequal(size(valueRange1,1), 4)
    error(['Range syntax error. Please check your range settings' ])
end


% check border
if valueRange1(2) > valueRange1(3)
    error('The border of the range is wrong, max < min !');
    return
end


% set block color
if isempty(range2)

    if eval([num2str(block.InputPort(1).Data), signcheck(valueRange1(1)), num2str(valueRange1(2))])...
            && eval([num2str(block.InputPort(1).Data), signcheck(valueRange1(4)), num2str(valueRange1(3))])
        currentMDisplay = get_param(block.BlockHandle, 'MaskDisplay');
        currentColor = ['[',currentMDisplay(12:16),']'];
        if ~isequal(currentColor,color1No)
            set_param(block.BlockHandle,'MaskDisplay',['patch(x,y,',color1No,');patch([rx],[ry],[cw]);']);
            % set_param(block.BlockHandle, 'Backgroundcolor',color1)
            %             MDisplay2 = ['disp(','''',range1,'''',')'];
            %             set_param(block.BlockHandle, 'MaskDisplay', MDisplay2);
            set_param(block.BlockHandle,'Description',['-ranges-',sprintf('\n'),range1]);
        end
        % set_param(block.BlockHandle, 'MaskDisplay', MDisplay)
    else
        currentMDisplay = get_param(block.BlockHandle, 'MaskDisplay');
        currentColor = ['[',currentMDisplay(12:16),']'];
        if ~isequal(currentColor,colorRestNo)
            set_param(block.BlockHandle,'MaskDisplay',['patch(x,y,',colorRestNo,');patch([rx],[ry],[cw]);']);
            % set_param(block.BlockHandle, 'Backgroundcolor',colorRest)
            %             MDisplay2 = ['disp(','''','other','''',')'];
            %             set_param(block.BlockHandle, 'MaskDisplay', MDisplay2);
            set_param(block.BlockHandle,'Description',['-ranges-',sprintf('\n'),'Other']);
        end
        %         set_param(block.BlockHandle, 'MaskDisplay', MDisplay)
    end
else
    % This part is very important for convertion of string to numeric
    valueRange2 = sscanf(range2, '%c %f %f %c');

    % range syntax check
    if ~isequal(size(valueRange2,1), 4)
        error(['Range syntax error. Please check your range settings' ])
    end

    % check border
    if valueRange2(2) > valueRange2(3)
        error('The border of the range is wrong, max < min !');
        return
    end
    if eval([num2str(block.InputPort(1).Data), signcheck(valueRange1(1)), num2str(valueRange1(2))])...
            && eval([num2str(block.InputPort(1).Data), signcheck(valueRange1(4)), num2str(valueRange1(3))]);
        currentMDisplay = get_param(block.BlockHandle, 'MaskDisplay');
        currentColor = ['[',currentMDisplay(12:16),']'];
        if ~isequal(currentColor,color1No)
            set_param(block.BlockHandle,'MaskDisplay',['patch(x,y,',color1No,');patch([rx],[ry],[cw]);']);
            %set_param(block.BlockHandle, 'Backgroundcolor',color1)
            %             MDisplay2 = ['disp(','''',range1,'''',')'];
            %             set_param(block.BlockHandle, 'MaskDisplay', MDisplay2);
            set_param(block.BlockHandle,'Description',['-ranges-',sprintf('\n'),range1]);
        end
        %         set_param(block.BlockHandle, 'MaskDisplay', MDisplay)

    elseif eval([num2str(block.InputPort(1).Data), signcheck(valueRange2(1)), num2str(valueRange2(2))])...
            && eval([num2str(block.InputPort(1).Data), signcheck(valueRange2(4)), num2str(valueRange2(3))]);
        currentMDisplay = get_param(block.BlockHandle, 'MaskDisplay');
        currentColor = ['[',currentMDisplay(12:16),']'];
        if ~isequal(currentColor,color2No)
            set_param(block.BlockHandle,'MaskDisplay',['patch(x,y,',color2No,');patch([rx],[ry],[cw]);']);
            %set_param(block.BlockHandle, 'Backgroundcolor',color2)
            %             MDisplay2 = ['disp(','''',range2,'''',')'];
            %             set_param(block.BlockHandle, 'MaskDisplay', MDisplay2);
            set_param(block.BlockHandle,'Description',['-ranges-',sprintf('\n'),range2]);
        end
        %         set_param(block.BlockHandle, 'MaskDisplay', MDisplay)
    else
        currentMDisplay = get_param(block.BlockHandle, 'MaskDisplay');
        currentColor = ['[',currentMDisplay(12:16),']'];
        if ~isequal(currentColor,colorRestNo)
            set_param(block.BlockHandle,'MaskDisplay',['patch(x,y,',colorRestNo,');patch([rx],[ry],[cw]);']);
            %set_param(block.BlockHandle, 'Backgroundcolor',colorRest)
            %             MDisplay2 = ['disp(','''','other','''',')'];
            %             set_param(block.BlockHandle, 'MaskDisplay', MDisplay2);
            set_param(block.BlockHandle,'Description',['-ranges-',sprintf('\n'), 'other']);
        end
        %         set_param(block.BlockHandle, 'MaskDisplay', MDisplay)
    end
end
%endfunction


function sign = signcheck(value)

switch char(value)
    case '('
        sign = '>';
    case '['
        sign = '>=';
    case ')'
        sign = '<';
    case ']'
        sign = '<=';
    otherwise
        error('The brekets can not be identified!')
end
%endfunction

function colorNo = colorStr2colorNo(colorStr)
% convert color string to color number(string array) format.
switch colorStr
    case 'black'
        colorNo = '[0 0 0]';
    case 'white'
        colorNo = '[1 1 1]';
    case 'red'
        colorNo = '[1 0 0]';
    case 'green'
        colorNo = '[0 1 0]';
    case 'blue'
        colorNo = '[0 0 1]';
    case 'yellow'
        colorNo = '[1 1 0]';
    case 'magenta'
        colorNo = '[1 0 1]';
    case 'cyan'
        colorNo = '[0 1 1]';
    case 'gray'
        colorNo = '[0.5 0.5 0.5]';
    otherwise
        error('Color(string) is not identified')
end
%endfunction

function colorStr = colorNo2colorStr(colorNo)
% convert color number to color string format.

colorNo = num2str(colorNo); % convert to String

switch colorNo
    case '0  0  0'
        colorStr = 'black';
    case '1  1  1'
        colorStr = 'white';
    case '1  0  0'
        colorStr = 'red';
    case '0  1  0'
        colorStr = 'green';
    case '0  0  1'
        colorStr = 'blue';
    case '1  1  0'
        colorStr = 'yellow';
    case '1  0  1'
        colorStr = 'magenta';
    case '0  1  1'
        colorStr = 'cyan';
    case '0.5  0.5  0.5'
        colorStr = 'gray';
    otherwise
        error('Color(number) is not identified')
end
%endfunction







