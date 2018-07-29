function msfun_realtime_elapsed(block)
% Help for Writing Level-2 M-File S-Functions:
%   web([docroot '/toolbox/simulink/sfg/f7-67622.html']
%   http://www.mathworks.com/access/helpdesk/help/toolbox/simulink/sfg/f7-67622.html

% Copyright 2009, The MathWorks, Inc.

% instance variables 
myRealTimeBaseline = 0;

setup(block);

%% ---------------------------------------------------
    function setup(block)
        % Register the number of ports.
        block.NumInputPorts  = 0;
        block.NumOutputPorts = 1;
        
        block.SetPreCompOutPortInfoToDynamic;
        block.OutputPort(1).Dimensions  = 1;
        block.OutputPort(1).SamplingMode = 'sample';
        
        % Set up the states
        block.NumContStates = 0;
        block.NumDworks = 0;
        
        % Register the parameters.
        block.NumDialogPrms     = 0; % scale factor        
        
        % Block is fixed in minor time step, i.e., it is only executed on major
        % time steps. With a fixed-step solver, the block runs at the fastest
        % discrete rate.
        block.SampleTimes = [0 1];
        
        block.SetAccelRunOnTLC(false); % run block in interpreted mode even w/ Acceleration
                        
        % methods called at run-time
        block.RegBlockMethod('Start', @Start);        
        block.RegBlockMethod('Outputs', @Output);
        block.RegBlockMethod('SimStatusChange', @SimStatusChange);
    end
        
%%        
    function Start(block)  %#ok<INUSD>
        myRealTimeBaseline = tic;
    end
                
%%     
    function Output(block)
         block.OutputPort(1).Data = toc(myRealTimeBaseline);
    end
        
%%        
    function SimStatusChange(block, status)         %#ok<INUSL>
        if status == 1,  % resume
            myRealTimeBaseline = tic; 
        end        
    end
        
end

