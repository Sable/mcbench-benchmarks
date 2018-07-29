function msfun_realtime_pacer(block)
% Help for Writing Level-2 M-File S-Functions:
%   web([docroot '/toolbox/simulink/sfg/f7-67622.html']
%   http://www.mathworks.com/access/helpdesk/help/toolbox/simulink/sfg/f7-67622.html

% Copyright 2009, The MathWorks, Inc.

% instance variables 
mySimTimePerRealTime = 1;
myRealTimeBaseline = 0;
mySimulationTimeBaseline = 0;
myResetBaseline = true;
myTotalBurnedTime = 0;
myNumUpdates = 0;

setup(block);

%% ---------------------------------------------------
    function setup(block)
        % Register the number of ports.
        block.NumInputPorts  = 0;
        block.NumOutputPorts = 0;
        
        % Set up the states
        block.NumContStates = 0;
        block.NumDworks = 0;
        
        % Register the parameters.
        block.NumDialogPrms     = 1; % scale factor
        block.DialogPrmsTunable = {'Nontunable'};
        
        % Block is fixed in minor time step, i.e., it is only executed on major
        % time steps. With a fixed-step solver, the block runs at the fastest
        % discrete rate.
        block.SampleTimes = [0 1];
        
        block.SetAccelRunOnTLC(false); % run block in interpreted mode even w/ Acceleration
        
        % methods called during update diagram/compilation.
        block.RegBlockMethod('CheckParameters', @CheckPrms);
                
        % methods called at run-time
        block.RegBlockMethod('Start', @Start);
        block.RegBlockMethod('Update', @Update);
        block.RegBlockMethod('SimStatusChange', @SimStatusChange);
        block.RegBlockMethod('Terminate', @Terminate);
    end

%%
    function CheckPrms(block)
        try
            validateattributes(block.DialogPrm(1).Data, {'double'},{'real', 'scalar', '>', 0});
        catch %#ok<CTCH>
            throw(MSLException(block.BlockHandle, ...
                'Simulink:Parameters:BlkParamUndefined', ...
                'Enter a number greater than 0'));
        end        
    end
        
%%        
    function Start(block) 
        mySimTimePerRealTime = block.DialogPrm(1).Data;
        myTotalBurnedTime = 0;
        myNumUpdates = 0;
        myResetBaseline = true;
        if strcmp(pause('query'),'off')
            fprintf('%s: Enabling MATLAB PAUSE command\n', getfullname(block.BlockHandle));            
            pause('on');            
        end            
    end
        
%%        
    function Update(block)        
        if  myResetBaseline 
            myRealTimeBaseline = tic;  
            mySimulationTimeBaseline = block.CurrentTime;  
            myResetBaseline = false; 
        else
            if isinf(mySimTimePerRealTime)
                return;
            end            
            elapsedRealTime = toc(myRealTimeBaseline);
            differenceInSeconds = ((block.CurrentTime - mySimulationTimeBaseline) / mySimTimePerRealTime) - elapsedRealTime;
            if differenceInSeconds >= 0
                pause(differenceInSeconds);
                myTotalBurnedTime = myTotalBurnedTime + differenceInSeconds;
                myNumUpdates = myNumUpdates + 1;
            end
        end            
    end
        
%%        
    function SimStatusChange(block, status)        
        if status == 0, 
            % simulation paused
            fprintf('%s: Pausing real time execution of the model (simulation time = %g sec)\n', ...
                getfullname(block.BlockHandle), block.CurrentTime);
        elseif status == 1
            % Simulation resumed
            fprintf('%s: Continuing real time execution of the model\n', ...
                getfullname(block.BlockHandle));
            myResetBaseline = true; 
        end        
    end
        
%%
    function Terminate(block) 
        if myNumUpdates > 0
            fprintf('%s: Average idle real time per major time step = %g sec\n', ...
                getfullname(block.BlockHandle),  myTotalBurnedTime / myNumUpdates);
        end
    end

end

