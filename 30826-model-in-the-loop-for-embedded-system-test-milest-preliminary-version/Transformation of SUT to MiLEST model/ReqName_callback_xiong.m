function [] = ReqName_callback(block)

% Callback processing function for mask parameter
% - number of Preconditions used in the Requirment Name Set
set_param(block, 'LinkStatus', 'none');
load_system('Simulink'); % Load Simulink library (background)
load_system('MIL_Test');

No = str2double(get_param(block,'No')); % Get # of Reqs
OldNo = length(find_system(block, 'regexp', 'on','LookUnderMasks','all','Name','<Precondition name>'));


% Add or remove model items
for i = 1:max(No,OldNo)
    if OldNo > No && i > No && i <= OldNo % Remove
        % Remove lines
        set_param([block '/switch <signal1>'], 'Inputs', num2str(No+1));
        PreLines = get_param([block '/<Precondition name>' num2str(i)],'LineHandles');
        
        delete_line(PreLines.Inport(1));
        delete_line(PreLines.Outport(2));
     
        % Remove blocks
        delete_block([block '/<Precondition name>' num2str(i)]);
      
    elseif No > OldNo && i > OldNo && i <= No % Add
        % Add blocks
        add_block('MIL_Test/Test Data/Test Data Architecture/<Test data generator>/<Requirement name>/<Precondition name>',[block '/<Precondition name>' num2str(i)]);
        set_param([block '/<Precondition name>' num2str(i)], 'LinkStatus', 'none');
        if i == 2
             pos = get_param([block '/<Precondition name>'], 'Position');
        else pos = get_param([block '/<Precondition name>' num2str(i-1)], 'Position');
        end
        pos1 = pos(1);
        pos3 = pos(3);
        pos2 = pos(2)+100;
        pos4 = pos(4)+100;
        set_param([block '/<Precondition name>' num2str(i)], 'Position', [pos1 pos2 pos3 pos4]);
        set_param([block '/switch <signal1>'], 'Inputs', num2str(i+1));
        % Add lines
      
        add_line(block,['Out Bus/1'],['<Precondition name>' num2str(i) '/1'],'autorouting','on');
        add_line(block,['<Precondition name>' num2str(i) '/2'],['switch <signal1>/' num2str(i+2)],'autorouting','on');
        
    end
    
    
end
if No == 1
        InPos = get_param([block '/<Precondition name>'], 'Position');
else
        InPos = get_param([block '/<Precondition name>' num2str(No)], 'Position');
end
       InP1 = InPos(1)+130;
       InP3 = InPos(3)+120;
       InP2 = InPos(2)+80;
       InP4 = InPos(4)+70;
       set_param([block '/Initialisation & Stabilisation'], 'Position',[InP1 InP2 InP3 InP4]);
parentOfReq = get_param(block, 'Parent');
system_name1(parentOfReq);