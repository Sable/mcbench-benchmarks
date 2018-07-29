function [] = Test_D_Gen(block)

% Callback processing function for mask parameter
% - number of <Requirement name> used in the System
set_param(block, 'LinkStatus', 'none');
load_system('Simulink'); % Load Simulink library (background)
load_system('MIL_Test');

No = str2double(get_param(block,'No')); % Get # of VF-s
OldNo = length(find_system(block, 'regexp', 'on','LookUnderMasks','all','Name','<Requirement name>'));
T1 = strcat(block, '/<Requirement name>/<Preconditions name>');
OldNoS = length(find_system(T1, 'regexp', 'on','LookUnderMasks','all','Name','Feature generation'));

for i = 1:max(No,OldNo)
    if OldNo > No && i > No && i <= OldNo % Remove
        % Remove lines
        
        SigAtTLines = get_param([block '/<Requirement name>' num2str(i)],'LineHandles');
        delete_line(SigAtTLines.Inport(1));
        for j = 1:OldNoS
          delete_line(SigAtTLines.Outport(j));
        end
        % Remove blocks
        for j = 1:OldNoS
          set_param([block '/switch <signal' num2str(j) '>'], 'Inputs', num2str(No));
        end
        delete_block([block '/<Requirement name>' num2str(i)]);
        
        
        
    elseif No > OldNo && i > OldNo && i <= No % Add
        % Add blocks
        if i == 2
            add_block([block '/<Requirement name>'],[block '/<Requirement name>' num2str(i)]);
        else
            add_block([block '/<Requirement name>' num2str(i-1)],[block '/<Requirement name>' num2str(i)]);
        end
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
        
        for k = 1:OldNoS
            
            set_param([block '/switch <signal' num2str(k) '>'], 'Inputs', num2str(i));
            
        end
        % Add lines
        for m = 1:OldNoS
            add_line(block,['<Requirement name>' num2str(i) '/' num2str(m)],['switch <signal' num2str(m) '>/' num2str(i+1)],'autorouting','on');
        end
        add_line(block,['Out Bus/1'],['<Requirement name>' num2str(i) '/1'],'autorouting','on');
        
        
    end
end

