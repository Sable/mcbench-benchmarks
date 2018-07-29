function name_signal=log_signals(model,signal_names,status,sub_sample)
%This function parses the name of the desired logged signals and turns on
% %the signal logging.
%  name_signal-->name of signal to log
%  model-->Name of model that is simulating
%  signal_names-->array that contains signal names and possibly subsystem names
%  status--> enable or disable decimation
%  sub_sample-->subsampling rate of the signal to reduce time required to plot signal results
%JAD 12/6/05


%Parse signal name and set signal properties for the signals in the log_struct
for i=1:length(signal_names)
 
    %Parse signal name
    name_parse=signal_names{i};
    index=findstr(name_parse,'/');
    name_system=(name_parse(1:max(index-1)));
    is_triggered='';
    
    if isempty(index)%Do this routine if the signal does not reside in a subsystem
          model_system=model;
          name_signal{i}=name_parse;
    else   %Do this if the signal is in a subsystem
       model_system=[model,'/',name_system]; %Concatenate names
       name_signal{i}=name_parse(max(index)+1:end); %Strip out name of signal
       is_triggered = find_system(model_system,'BlockType','TriggerPort');%Check to see if this subsystem is triggered or enabled
       
    end

    sub_sample_str=num2str(sub_sample);
    open(model); %Open Simulink model
    Sig_handle = find_system(model_system, 'FindAll', 'on', 'type', 'line','Name',name_signal{i}); %find handle for all listed signals
    Srcport_handle = get_param(Sig_handle,'SrcPortHandle');

    if length(Srcport_handle)>1 %This is necessary when the same signal has multiple handles
    
        set_param(Srcport_handle{2},'DataLogging','on');%Turn Datalogging on
        if isempty(is_triggered) && strcmp('on',status) %Set the decimation if this is not a triggered susbsystem
                set_param(Srcport_handle{2},'DataLoggingDecimateData','on'); % Turn Decimation on
                set_param(Srcport_handle{2},'DataLoggingDecimation',sub_sample_str);% Set Decimation Value
        end
            
    else  %This is necessary when the same signal has one handle
        
        set_param(Srcport_handle,'DataLogging','on');  %Turn Datalogging on
        if isempty(is_triggered) && strcmp('on',status) %Set the decimation if this is not a triggered susbsystem
                set_param(Srcport_handle,'DataLoggingDecimateData','on'); % Turn Decimation on
                set_param(Srcport_handle,'DataLoggingDecimation',sub_sample_str) % Set Decimation Value
        end
    end
end
return
