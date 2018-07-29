%*******************************************************************
%Summary: This file runs the specified model and logs the data from the listed signals 
%and plots the results.  
%
%In this file you specify the name of the signal
%that you want to log.  You can also specify a decimation for the logged
%signals.  This models uses a variation of the Simulink Demo model named
%'sldemo_househeat'
% JAD - 1/6/06
%*********************************************************************

%**********Prepare workspace************
    clear
    clc
    close all
    name_mod='sldemo_househeat1'; %Name of model to simulate
%***************end***************************

    % Simulation Time Calculationss *******    
    
    Sub_Sample_Time=3; % Log every third value


%Structure file that will contain the name of the signals to log
%Comment all names to disable signal logging

    log_struct{1}='Set_Temp';
    log_struct{2}='blower_cmd';
    log_struct{3}='Tout';
    log_struct{4}='Temp_in';
    log_struct{5}='Heat_Cost';
    log_struct{6}='Tout2';
    log_struct{7}='time';  %The time value can also be obtained from the logged Structure

    log_struct{8}='House/Sub_Temp';
%     log_struct{9}='';
%     log_struct{10}='';
%     log_struct{11}='';
%     log_struct{12}='';
%     log_struct{13}='';
%         
%     log_struct{14}='';
%     log_struct{15}='';
%     log_struct{16}='';
%     log_struct{17}='';    
%     log_struct{18}='';
%     log_struct{19}='';


    %Turn on logging for specified signals in the model
    if exist('log_struct') 
                   %log_signals(name of model,name_of_log_var, enable_decimation, decimation_time) 
        signal_name=log_signals(name_mod,log_struct,'off',Sub_Sample_Time);
    end
    

    % ********* Run Sim  ***********************************************
    tic
     sim(name_mod)
    toc
%***************end***************************

%*************Save logged values in the workspace************************
if exist('log_struct')    

    for i=1:length(log_struct)
        index=findstr(log_struct{i},'/');

        if isempty(index)
           temp=[signal_name{i},'=logsout.',signal_name{i},'.Data;'];
           eval(temp);

        elseif (length(index)>1) % If this signal is in a subsystem
            sys_name=log_struct{i}(1:index(1)-1); %Grab the name of the system
            sub_sys_name=log_struct{i}(index(1)+1:index(2)-1); %Grab the name of the subsystem
            temp=[signal_name{i},'=logsout.(''',sys_name,''').',sub_sys_name,'.',signal_name{i},'.Data;'];
            eval(temp);
        else  %This signal is not in a subsystem
           temp1=log_struct{i}(1:index(1)-1); %Grab the name of the system
           temp=[signal_name{i},'=logsout.(''',temp1,''').',signal_name{i},'.Data;'];
           eval(temp);
        end
    end
end
%***************end***************************


%Close model and do not save model changes
%       close_system(name_mod,0);
 %Plot results
 
    figure(1)
    subplot(2,1,1)
    plot(time,Tout,time,Tout2)
    subplot(2,1,2)
    plot(Heat_Cost,time)
    
    
    