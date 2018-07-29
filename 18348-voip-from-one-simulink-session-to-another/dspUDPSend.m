function dspUDPSend(block)
% dspUDPSend A UDP client
%
% Copyright 2007-2009 The MathWorks, Inc.
%

% Declare the array of java sockets (used by instantces of this class).
persistent socket

if ~exist('socket', 'var') || isempty(socket)
    socket = {};
end

% Register parameters: port, outputLength, sampleTime
block.NumDialogPrms     = 2;
block.DialogPrmsTunable = {'Nontunable','Nontunable'};
url  = block.DialogPrm(1).Data;
port = block.DialogPrm(2).Data;

% Register number of ports
block.NumInputPorts  = 1;
block.NumOutputPorts = 0;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;

% Override input port properties
block.InputPort(1).DatatypeID  = 3;  % uint8
block.InputPort(1).Complexity  = 'Real';

% Register sample times
block.SampleTimes = [-1 0];

% Options
block.SetAccelRunOnTLC(false);

block.RegBlockMethod('CheckParameters', @mdlCheckParameters);
block.RegBlockMethod('SetInputPortSamplingMode', @mdlSetInputPortFrameData);
block.RegBlockMethod('SetInputPortDimensions', @mdlSetInputPortDimensionInfo);
block.RegBlockMethod('SetInputPortDataType', @mdlSetInputPortDataType);
block.RegBlockMethod('SetInputPortComplexSignal', @mdlSetInputPortComplexSignal);
block.RegBlockMethod('PostPropagationSetup', @mdlSetWorkWidths);

block.RegBlockMethod('ProcessParameters', @mdlProcessParameters);
block.RegBlockMethod('InitializeConditions', @mdlInitializeConditions);
block.RegBlockMethod('Start', @mdlStart);
block.RegBlockMethod('Update', @mdlUpdate);
block.RegBlockMethod('Terminate', @mdlTerminate);

%block.RegBlockMethod('WriteRTW', @mdlRTW);

%% The initialization steps
    function mdlCheckParameters(block)
        if ~strcmp(class(url), 'char')
            error('Invalid parameter');
        end
        if ~strcmp(class(port), 'double')
            error('Invalid parameter');
        end
    end

    function mdlSetInputPortFrameData(block, idx, fd)
        block.InputPort(idx).SamplingMode = fd;
    end

    function mdlSetInputPortDimensionInfo(block, idx, di)
        block.InputPort(idx).Dimensions = di;
    end

    function mdlSetInputPortDataType(block, idx, dt)
        block.InputPort(idx).DataTypeID = dt;
    end

    function mdlSetInputPortComplexSignal(block, idx, c)
        block.InputPort(idx).Complexity = c;
    end

    function mdlSetWorkWidths(block)
        block.NumDworks = 1;
        block.Dwork(1).Name            = 'nextSocket';
        block.Dwork(1).Dimensions      = 1;
        block.Dwork(1).DatatypeID      = 0; % real
        block.Dwork(1).Complexity      = 'Real';
        block.Dwork(1).UsedAsDiscState = true;
        % Register all tunable parameters as runtime parameters.
        block.AutoRegRuntimePrms;
    end

%% The runtime loop
    function mdlProcessParameters(block)
        block.AutoUpdateRuntimePrms;
    end

    function mdlInitializeConditions(block)
    end

    function mdlStart(block)
        block.Dwork(1).Data = length(socket) +1;
        try
            % Attempt to create the socket
            socket{block.Dwork(1).Data} = java.net.DatagramSocket();
            address = java.net.InetAddress.getByName(url);
            socket{block.Dwork(1).Data}.connect(address, port);
        catch
            error('An error was reported opening a UDP Socket on port %d: %s',...
                port, lasterr);
            block.Dwork(1).Data = 0;
        end
    end

    function mdlUpdate(block)
        try
            packet = java.net.DatagramPacket(block.InputPort(1).Data,...
                length(block.InputPort(1).Data) );
        catch
            error('Error creating DatagramPacket: %s', lasterr);
        end
        try
            socket{block.Dwork(1).Data}.send(packet);
        catch
            warning('Error sending data.');
        end

    end

    function mdlTerminate(block)
        if block.Dwork(1).Data
            socket{block.Dwork(1).Data}.close;
            socket(block.Dwork(1).Data) = [];
            block.Dwork(1).Data = 0;
        end
    end

end
