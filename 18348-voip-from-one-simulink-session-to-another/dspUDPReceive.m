function dspUDPReceive(block)
% dspUDPReceive A UDP server
%
% Copyright 2007-2009 The MathWorks, Inc.
%

% Declare the array of java sockets (used by instantces of this class).
persistent socket

if ~exist('socket','var') || isempty(socket)
    socket = {};
end

% Register parameters: port, outputLength, sampleTime
block.NumDialogPrms     = 3;
block.DialogPrmsTunable = {'Nontunable','Nontunable','Nontunable'};
port         = block.DialogPrm(1).Data;
outputLength = block.DialogPrm(2).Data;
sampleTime   = block.DialogPrm(3).Data;

% Set up some static variables
bufferSize = max(8192, outputLength);
timeout    = 1; % timeout in milliseconds

% Register number of ports
block.NumInputPorts  = 0;
block.NumOutputPorts = 1;

% Setup port properties to be inherited or dynamic
block.SetPreCompOutPortInfoToDynamic;

% Override output port properties
block.OutputPort(1).DatatypeID  = 3; % uint8
block.OutputPort(1).Dimensions  = outputLength;
block.OutputPort(1).Complexity  = 'Real';
block.OutputPort(1).SamplingMode = 'Sample';

% Register sample times
block.SampleTimes = [sampleTime 0];

%% Options
block.SetAccelRunOnTLC(false);

block.RegBlockMethod('CheckParameters', @mdlCheckParameters);
block.RegBlockMethod('SetOutputPortDimensions', @mdlSetOutputPortDimensionInfo);
block.RegBlockMethod('SetOutputPortDataType', @mdlSetOutputPortDataType);
block.RegBlockMethod('SetOutputPortComplexSignal', @mdlSetOutputPortComplexSignal);
block.RegBlockMethod('PostPropagationSetup', @mdlSetWorkWidths);

block.RegBlockMethod('ProcessParameters', @mdlProcessParameters);
block.RegBlockMethod('InitializeConditions', @mdlInitializeConditions);
block.RegBlockMethod('Start', @mdlStart);
block.RegBlockMethod('Outputs', @mdlOutputs);
block.RegBlockMethod('Terminate', @mdlTerminate);

%block.RegBlockMethod('WriteRTW', @mdlRTW);

%% The initialization steps
    function mdlCheckParameters(block)
        port = block.DialogPrm(1).Data;
        if ~strcmp(class(port), 'double')
            error('Invalid parameter');
        end
        outputLength = block.DialogPrm(2).Data;
        if ~strcmp(class(outputLength), 'double')
            error('Invalid parameter');
        end
        sampleTime = block.DialogPrm(3).Data;
        if ~strcmp(class(sampleTime), 'double')
            error('Invalid parameter');
        end
    end

    function mdlSetOutputPortDimensionInfo(block, idx, di)
        block.OutputPort(idx).Dimensions = di;
    end

    function mdlSetOutputPortDataType(block, idx, dt)
        block.OutputPort(idx).DataTypeID  = 3;
    end

    function mdlSetOutputPortComplexSignal(block, idx, c)
        block.OutputPort(idx).Complexity = c;
    end

    function mdlSetWorkWidths(block)
        block.NumDworks = 2;
        block.Dwork(1).Name            = 'nextSocket';
        block.Dwork(1).Dimensions      = 1;
        block.Dwork(1).DatatypeID      = 0; % real
        block.Dwork(1).Complexity      = 'Real';
        block.Dwork(1).UsedAsDiscState = true;

        block.Dwork(2).Name            = 'buffer';
        block.Dwork(2).Dimensions      = bufferSize;
        block.Dwork(2).DatatypeID      = 3; % uint8
        block.Dwork(2).Complexity      = 'Real';
        block.Dwork(2).UsedAsDiscState = true;
        % Register all tunable parameters as runtime parameters.
        block.AutoRegRuntimePrms;
    end

    function mdlInitializeConditions(block)
    end

%% The runtime loop
    function mdlProcessParameters(block)
        block.AutoUpdateRuntimePrms;
    end

    function mdlStart(block)
        block.Dwork(1).Data = length(socket) +1;
        try
            % Attempt to create the socket
            socket{block.Dwork(1).Data} = java.net.DatagramSocket(port);
            socket{block.Dwork(1).Data}.setSoTimeout(timeout);
        catch
            error('An error was reported opening a UDP Socket on port %d: %s',...
                port, lasterr);
            block.Dwork(1).Data = 0;
        end
    end

    function mdlOutputs(block)
        data = javaArray('java.lang.Byte', outputLength);
        
        totalAmtRead = 0;
        while totalAmtRead < outputLength
            try
                packet = java.net.DatagramPacket(block.Dwork(2).Data,...
                    outputLength-totalAmtRead);
            catch
                error('Error creating DatagramPacket: %s', lasterr);
            end
            try
                socket{block.Dwork(1).Data}.receive(packet);
                amtRead = packet.getLength();
                signed = double(packet.getData());
                signed = signed(1:amtRead);
                signed(signed < 0) = 256 + signed(signed < 0);
                block.OutputPort(1).Data(totalAmtRead+1:totalAmtRead+amtRead) = uint8(signed);
                totalAmtRead = totalAmtRead + amtRead;
            catch
                % warning('Data underrun: emitting zeros.');
                % We could warn about invalid data here, but we just
                % return zeros for now.
                block.OutputPort(1).Data(totalAmtRead+1:outputLength) = uint8(0);
                break
            end
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


