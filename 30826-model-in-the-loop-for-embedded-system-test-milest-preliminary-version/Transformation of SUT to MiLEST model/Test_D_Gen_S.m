function [] = Test_D_Gen_S(block,signal)

% Callback processing function for mask parameter
% - number of <Requirement name> used in the System
set_param(block, 'LinkStatus', 'none');
load_system('Simulink'); % Load Simulink library (background)
load_system('MIL_Test');
if signal < 0 
No = str2double(get_param(block,'So')); % Get # of VF-s
else
    No = signal;
end

T1 = strcat(block, '/<Requirement name>/<Preconditions name>');
T2 = strcat(block, '/<Requirement name>');
OldNo = length(find_system(T1, 'regexp', 'on','LookUnderMasks','all','Name','Feature generation'));
OldNoReq = length(find_system(block, 'regexp', 'on','LookUnderMasks','all','Name','<Requirement name>'));
for i = 1:max(No,OldNo)
    if OldNo > No && i > No && i <= OldNo % Remove
        % delete lines
        
        % block
      
        SigAtTLines2 = get_param([block '/switch <signal' num2str(i) '>'],'LineHandles');
        delete_line(SigAtTLines2.Outport(1));
        for j = 1:(OldNoReq+1)
         delete_line(SigAtTLines2.Inport(j));
        end
        delete_block([block '/<signal' num2str(i) '>']);
        delete_block([block '/switch <signal' num2str(i) '>']);
        %T2
        for k = 1:OldNoReq
            if k == 1
           T1 = strcat(block, '/<Requirement name>/<Preconditions name>');
           T2 = strcat(block, '/<Requirement name>');
        SigAtTLines1 = get_param([T2 '/switch <signal' num2str(i) '>'],'LineHandles');
        delete_line(SigAtTLines1.Outport(1));
        delete_line(SigAtTLines1.Inport(1));
        delete_line(SigAtTLines1.Inport(2));
        delete_line(SigAtTLines1.Inport(3));
        
        % T1
        SigAtTLines = get_param([T1 '/Feature generation' num2str(i)],'LineHandles');
        %delete_line(SigAtTLines.Inport(1));
        delete_line(SigAtTLines.Outport(1));
        % delete block
        delete_block([T2 '/<signal' num2str(i) '>']);
        delete_block([T2 '/switch <signal' num2str(i) '>']);
        delete_block([T1 '/Feature generation' num2str(i)]);
        delete_block([T1 '/<signal' num2str(i) '>']);
            else
                 T1 = strcat(block, '/<Requirement name>', num2str(k), '/<Preconditions name>');
                 T2 = strcat(block, '/<Requirement name>', num2str(k));
                 SigAtTLines1 = get_param([T2 '/switch <signal' num2str(i) '>'],'LineHandles');
        delete_line(SigAtTLines1.Outport(1));
        delete_line(SigAtTLines1.Inport(1));
        delete_line(SigAtTLines1.Inport(2));
        delete_line(SigAtTLines1.Inport(3));
        
        % T1
        SigAtTLines = get_param([T1 '/Feature generation' num2str(i)],'LineHandles');
        %delete_line(SigAtTLines.Inport(1));
        delete_line(SigAtTLines.Outport(1));
        % delete block
        delete_block([T2 '/<signal' num2str(i) '>']);
        delete_block([T2 '/switch <signal' num2str(i) '>']);
        delete_block([T1 '/Feature generation' num2str(i)]);
        delete_block([T1 '/<signal' num2str(i) '>']);
            end
        end
        
       
    elseif No > OldNo && i > OldNo && i <= No % Add
         % Block
                add_block('Simulink/Sinks/Out1',[block '/<signal' num2str(i) '>']);
                fix_pos([block '/<signal' num2str(i-1) '>'],[block '/<signal' num2str(i) '>'],0,145);
                add_block([block '/switch <signal1>'],[block '/switch <signal' num2str(i) '>']);
                fix_pos([block '/switch <signal' num2str(i-1) '>'],[block '/switch <signal' num2str(i) '>'],0,60);
                add_line(block,['switch <signal' num2str(i) '>' '/1'],['<signal' num2str(i) '>/' num2str(1)],'autorouting','on');
                add_line(block,['Bus Selector/1'],['switch <signal' num2str(i) '>/' num2str(1)],'autorouting','on');
        % Add blocks
        % <Test data generator>/<Requirement name>/<Preconditions name>
        for j = 1:OldNoReq
           if j == 1
               T1 = strcat(block, '/<Requirement name>/<Preconditions name>');
               T2 = strcat(block, '/<Requirement name>');
               add_block('Simulink/Sinks/Out1',[block '/<Requirement name>/<Preconditions name>/<signal' num2str(i) '>']);
               fix_pos([block '/<Requirement name>/<Preconditions name>/<signal' num2str(i-1) '>'],[block '/<Requirement name>/<Preconditions name>/<signal' num2str(i) '>'],0,-70);
               add_block([block '/<Requirement name>/<Preconditions name>/Feature generation'],[block '/<Requirement name>/<Preconditions name>/Feature generation' num2str(i)]);
               fix_pos([block '/<Requirement name>/<Preconditions name>/Feature generation'],[block '/<Requirement name>/<Preconditions name>/Feature generation' num2str(i)],0,-i*50);
               add_line(T1,['Feature generation' num2str(i) '/1'],['<signal' num2str(i) '>/' num2str(1)],'autorouting','on');
               % T2
               add_block('Simulink/Sinks/Out1',[T2 '/<signal' num2str(i) '>']);
               fix_pos([T2 '/<signal' num2str(i-1) '>'],[T2 '/<signal' num2str(i) '>'],0,145);
               add_block([T2 '/switch <signal1>'],[T2 '/switch <signal' num2str(i) '>']);
               fix_pos([T2 '/switch <signal' num2str(i-1) '>'],[T2 '/switch <signal' num2str(i) '>'],0,60);
               add_line(T2,['switch <signal' num2str(i) '>' '/1'],['<signal' num2str(i) '>/' num2str(1)],'autorouting','on');
               add_line(T2,['Sequencing of test data in time due to Preconditions/1'],['switch <signal' num2str(i) '>/' num2str(1)],'autorouting','on');
               add_line(T2,['Initialisation & Stabilisation/1'],['switch <signal' num2str(i) '>/' num2str(3)],'autorouting','on');
               add_line(T2,['<Preconditions name>/' num2str(i+1)],['switch <signal' num2str(i) '>/' num2str(2)],'autorouting','on');
               % Block
               add_line(block,['<Requirement name>/' num2str(i)],['switch <signal' num2str(i) '>/' num2str(2)],'autorouting','on');
           else
           
                T1 = strcat(block, '/<Requirement name>', num2str(j), '/<Preconditions name>');
                T2 = strcat(block, '/<Requirement name>', num2str(j));
                
                add_block('Simulink/Sinks/Out1',[T1 '/<signal' num2str(i) '>']);
                fix_pos([T1 '/<signal' num2str(i-1) '>'],[T1 '/<signal' num2str(i) '>'],0,-70);
                add_block([T1 '/Feature generation'],[T1 '/Feature generation' num2str(i)]);
                fix_pos([T1 '/Feature generation'],[T1 '/Feature generation' num2str(i)],0,-i*50);
                add_line(T1,['Feature generation' num2str(i) '/1'],['<signal' num2str(i) '>/' num2str(1)],'autorouting','on');
                % T2
                add_block('Simulink/Sinks/Out1',[T2 '/<signal' num2str(i) '>']);
                fix_pos([T2 '/<signal' num2str(i-1) '>'],[T2 '/<signal' num2str(i) '>'],0,145);
                add_block([T2 '/switch <signal1>'],[T2 '/switch <signal' num2str(i) '>']);
                fix_pos([T2 '/switch <signal' num2str(i-1) '>'],[T2 '/switch <signal' num2str(i) '>'],0,60);
                add_line(T2,['switch <signal' num2str(i) '>' '/1'],['<signal' num2str(i) '>/' num2str(1)],'autorouting','on');
                add_line(T2,['Sequencing of test data in time due to Preconditions/1'],['switch <signal' num2str(i) '>/' num2str(1)],'autorouting','on');
                add_line(T2,['Initialisation & Stabilisation/1'],['switch <signal' num2str(i) '>/' num2str(3)],'autorouting','on');
                add_line(T2,['<Preconditions name>/' num2str(i+1)],['switch <signal' num2str(i) '>/' num2str(2)],'autorouting','on');
                add_line(block,['<Requirement name>' num2str(j) '/' num2str(i)],['switch <signal' num2str(i) '>/' num2str(j+1)],'autorouting','on');
           end    
        end
           
      
    end
end



