function [] = system_name1(block)

% Callback processing function for mask parameter
% - number of <Requirement name> used in the System
set_param(block, 'LinkStatus', 'none');
load_system('Simulink'); % Load Simulink library (background)
load_system('MIL_Test');

No = str2double(get_param(block,'No')); % Get # of VF-s
OldNo = length(find_system(block, 'regexp', 'on','LookUnderMasks','all','Name','<Requirement name>'));

for i = 1:max(No,OldNo)
    if OldNo > No && i > No && i <= OldNo % Remove
        % Remove lines
        set_param([block '/Bus Creator'], 'Inputs', num2str(No));
        SigAtTLines = get_param([block '/<Requirement name>' num2str(i)],'LineHandles');
        delete_line(SigAtTLines.Inport(1));
        delete_line(SigAtTLines.Outport(1));
        delete_line([block '/Arbitration'],['In' num2str(i) '/' num2str(1)],['Collect Verdicts/' num2str(i)]);
        % Remove blocks
        delete_block([block '/<Requirement name>' num2str(i)]);
        
        % remove lines from Bus Selector
        SigFrBS = get_param([block '/Bus Selector'], 'LineHandles');
        delete_line(SigFrBS.Outport(i));
        
        % remove Outport of Arbitration
        delete_block([block '/Arbitration/In' num2str(i)]);
        
        % Remove Inport of Bus Creator4
        
        
    elseif No > OldNo && i > OldNo && i <= No % Add
        % Add blocks
        add_block('MIL_Test/Validation Function/Test Evaluation Architecture/<system name>/<Requirement name>',[block '/<Requirement name>' num2str(i)]);
        set_param([block '/<Requirement name>' num2str(i)], 'LinkStatus', 'none');
        if i == 2
             pos = get_param([block '/<Requirement name>'], 'Position');
        else pos = get_param([block '/<Requirement name>' num2str(i-1)], 'Position');
        end
        pos1 = pos(1);
        pos3 = pos(3);
        pos2 = pos(2)+80;
        pos4 = pos(4)+80;
        set_param([block '/<Requirement name>' num2str(i)], 'Position',[pos1 pos2 pos3 pos4]);
        set_param([block '/Bus Creator'], 'Inputs', num2str(i));
        
        % Add Inports of Bus Creator4
        set_param([block '/Bus Creator4'], 'Inputs', num2str(i));
        
        % Add Outports of Bus Selector
        % OutSignal of Bus Seletor
        %Signal1 = 'signal1.signal1.signal1';
        %for j = 2 : i    
        SignalP = strcat(',','signal',num2str(i),'.signal1.signal1');
        %Signal1 = strcat(Signal1,SignalP);
        Signal1 = get_param([block '/Bus Selector'], 'OutputSignals');
        Signal1 = strcat(Signal1,SignalP); 
        %end
        set_param([block '/Bus Selector'], 'OutputSignals',Signal1)
        
        % Add lines
        add_line(block,['<Requirement name>' num2str(i) '/1'],['Bus Creator/' num2str(i)],'autorouting','on');
        add_line(block,['Signal Conversion/1'],['<Requirement name>' num2str(i) '/1'],'autorouting','on');
        
        % Add lines between Bus Selector and Bus Creator4
        add_line(block,['Bus Selector/' num2str(i)],['Bus Creator4/' num2str(i)],'autorouting','on');
        
        % Add Input to Arbitration
        add_block('Simulink/Ports & Subsystems/In1',[block '/Arbitration/In' num2str(i)]);
        if i == 2
             posi = get_param([block '/Arbitration/In1'], 'Position');
        else posi = get_param([block '/Arbitration/In' num2str(i-1)], 'Position');
        end
        pos1 = posi(1);
        pos3 = posi(3);
        pos2 = posi(2)+40;
        pos4 = posi(4)+40;
        set_param([block '/Arbitration/In' num2str(i)], 'Position',[pos1 pos2 pos3 pos4]);
        
        % fix position of Memory
        fix_pos([block '/Arbitration/Collect Verdicts'],[block '/Arbitration/Memory'],0,10);
        
        % Add Line from Bus Selector to Arbitration
        add_line(block,['Bus Selector/' num2str(i)],['Arbitration/' num2str(i)],'autorouting','on');
        
        % Set Inputports of 'Collect Verdicts'
        set_param([block '/Arbitration/Collect Verdicts'], 'Inputs', num2str(i+1));
        
        % Put the Memory Outsignal always in the last Inport of Collect
        % Verdicts
        delete_line([block '/Arbitration'],['Memory/' num2str(1)],['Collect Verdicts/' num2str(i)]);
        add_line([block '/Arbitration'],['Memory/' num2str(1)],['Collect Verdicts/' num2str(i+1)],'autorouting','on');
        
        % Add line from 'in' to 'Collect Verdicts', which happens in the
        % undersystem Arbitration
        add_line([block '/Arbitration'],['In' num2str(i) '/' num2str(1)],['Collect Verdicts/' num2str(i)],'autorouting','on');
    end
end

% Remove Outport of Bus Selector & Input of Bus Creator4

    if OldNo > No  % Remove
        set_param([block '/Bus Creator4'], 'Inputs', num2str(No));
        delete_line([block '/Arbitration'],['Memory/' num2str(1)],['Collect Verdicts/' num2str(OldNo+1)]);
        set_param([block '/Arbitration/Collect Verdicts'], 'Inputs', num2str(No+1));
        add_line([block '/Arbitration'],['Memory/' num2str(1)],['Collect Verdicts/' num2str(No+1)],'autorouting','on');
        if No == 1
            S1 = 'signal1.signal1.signal1';
        else
            S1 = 'signal1.signal1.signal1';
            for j = 2:No
              S1 = strcat(S1,',','signal',num2str(j),'.signal1.signal1');    
           end
        end
        set_param([block '/Bus Selector'], 'OutputSignals',S1);
        
    end




