function [] = system_name2(block)

% Callback processing function for mask parameter
% - number of <Requirement name> used in the System
set_param(block, 'LinkStatus', 'none');
load_system('Simulink'); % Load Simulink library (background)
load_system('MIL_Test');

No = str2double(get_param(block,'No')); % Get # of VF-s
OldNo = length(find_system(block, 'regexp', 'on','LookUnderMasks','all','Name','<Requirement name>'));

if OldNo > No  % Remove
    % Redraw all the lines and Reset the in-out ports of all related block
    % Remove all the lines from Bus Selector
    In_B4a = get_param([block '/Bus Creator4'], 'Inputs');
    In_B4a = str2num(In_B4a);
    SigFrBS_l = get_param([block '/Bus Selector'], 'LineHandles');
    for i = 1:In_B4a
    delete_line(SigFrBS_l.Outport(i));
    end
end
for i = 1:max(No,OldNo)
    if OldNo > No && i > No && i <= OldNo % Remove
        % Remove lines
        set_param([block '/Bus Creator'], 'Inputs', num2str(No));
        SigAtTLines = get_param([block '/<Requirement name>' num2str(i)],'LineHandles');
        delete_line(SigAtTLines.Inport(1));
        delete_line(SigAtTLines.Outport(1));
        %delete_line([block '/Arbitration'],['In' num2str(i) '/' num2str(1)],['Collect Verdicts/' num2str(i)]);
       
        % Redraw the lines from Bus Selector
        % Find how many VFs in the Requirement block, which will be deleted
        
        NoVF = length(find_system([block '/<Requirement name>' num2str(i)], 'regexp', 'on','LookUnderMasks','all','Name','<Preconditions name>'));
        No_In_o = length(find_system([block '/Arbitration'], 'regexp', 'on','LookUnderMasks','all','Name','In'));
        delete_line([block '/Arbitration'],['Memory/' num2str(1)],['Collect Verdicts/' num2str(No_In_o+1)]);
        % Delete Signals from Bus Selector
        SigFrBS_n = get_param([block '/Bus Selector'], 'OutputSignals');
        % delete the number of VFs singals in Arbitration    
        for j = 1:NoVF
                No_In = length(find_system([block '/Arbitration'], 'regexp', 'on','LookUnderMasks','all','Name','In'));
                delete_line([block '/Arbitration'],['In' num2str(No_In) '/' num2str(1)],['Collect Verdicts/' num2str(No_In)]);
                delete_block([block '/Arbitration/In' num2str(No_In)]);
                p = strcat(',','signal',num2str(i),'.signal',num2str(j),'.signal1');
                SigFrBS_n = strrep(SigFrBS_n,p,'');
        end
        % Redesign the Verdicts Collection
        set_param([block '/Arbitration/Collect Verdicts'], 'Inputs', num2str(No_In_o-NoVF+1));
        add_line([block '/Arbitration'],['Memory/' num2str(1)],['Collect Verdicts/' num2str(No_In_o-NoVF+1)],'autorouting','on');
        % Reset the inports of Bus Creator4 and Selector
        set_param([block '/Bus Creator4'], 'Inputs', num2str(No_In_o-NoVF));
        set_param([block '/Bus Selector'], 'OutputSignals',SigFrBS_n);
        % Remove blocks
        delete_block([block '/<Requirement name>' num2str(i)]);
        
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
        In_B4 = get_param([block '/Bus Creator4'], 'Inputs');
        In_B4 = str2num(In_B4)+1;
        set_param([block '/Bus Creator4'], 'Inputs', num2str(In_B4));
        
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
        %add_line(block,['Bus Selector/' num2str(i)],['Bus Creator4/' num2str(i)],'autorouting','on');
        add_line(block,['Bus Selector/' num2str(In_B4)],['Bus Creator4/' num2str(In_B4)],'autorouting','on');
        % Add Input to Arbitration
        add_block('Simulink/Ports & Subsystems/In1',[block '/Arbitration/In' num2str(In_B4)]);
        if i == 2
             posi = get_param([block '/Arbitration/In1'], 'Position');
        else
            In_in = In_B4-1;
            posi = get_param([block '/Arbitration/In' num2str(In_in)], 'Position');
        end
        pos1 = posi(1);
        pos3 = posi(3);
        pos2 = posi(2)+40;
        pos4 = posi(4)+40;
        set_param([block '/Arbitration/In' num2str(In_B4)], 'Position',[pos1 pos2 pos3 pos4]);
        
        % fix position of Memory
        fix_pos([block '/Arbitration/Collect Verdicts'],[block '/Arbitration/Memory'],0,10);
        
        % Add Line from Bus Selector to Arbitration
        add_line(block,['Bus Selector/' num2str(In_B4)],['Arbitration/' num2str(In_B4)],'autorouting','on');
        
        % Set Inputports of 'Collect Verdicts'
        In_CV = In_B4+1;
        set_param([block '/Arbitration/Collect Verdicts'], 'Inputs', num2str(In_CV));
        
        % Put the Memory Outsignal always in the last Inport of Collect
        % Verdicts
        delete_line([block '/Arbitration'],['Memory/' num2str(1)],['Collect Verdicts/' num2str(In_B4)]);
        add_line([block '/Arbitration'],['Memory/' num2str(1)],['Collect Verdicts/' num2str(In_CV)],'autorouting','on');
        
        % Add line from 'in' to 'Collect Verdicts', which happens in the
        % undersystem Arbitration
        add_line([block '/Arbitration'],['In' num2str(In_B4) '/' num2str(1)],['Collect Verdicts/' num2str(In_B4)],'autorouting','on');
    end
end

% Remove Outport of Bus Selector & Input of Bus Creator4

if OldNo > No  % Remove
    % Redraw all the lines and Reset the in-out ports of all related block
    % Add Line from Bus Selector to Arbitration
    SigF_N = get_param([block '/Bus Selector'], 'OutputSignals');
    N_SigF= length(findstr(SigF_N, ','))+1;
   for j = 1:N_SigF
    add_line(block,['Bus Selector/' num2str(j)],['Arbitration/' num2str(j)],'autorouting','on');
    % Add lines between Bus Selector and Bus Creator4
    add_line(block,['Bus Selector/' num2str(j)],['Bus Creator4/' num2str(j)],'autorouting','on');
   end       
end




