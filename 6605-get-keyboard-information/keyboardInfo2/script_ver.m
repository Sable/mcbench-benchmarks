function script_ver
%% clear timer existed already 
h_timer = timerfind;
if ~isempty(h_timer)
    delete(h_timer);
end

%% create a timer object
h_timer = timer('TimerFcn',@worker, 'Period', 0.1, 'ExecutionMode', 'fixedRate', 'TasksToExecute' , 100);
start(h_timer)

    function worker(arg1, arg2)
        data = keyinfo;
        fprintf('%d %d %d \n', data);
    end

end