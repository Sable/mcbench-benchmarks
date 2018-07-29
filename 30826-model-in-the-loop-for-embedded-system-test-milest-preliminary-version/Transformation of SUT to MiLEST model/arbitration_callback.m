function [] = arbitration_callback(block)

% arbitration_callback acting if the Nr of 'requirement' signal changed

set_param(block, 'LinkStatus', 'none');
load_system('Simulink'); % Load Simulink library (background)
load_system('MIL_Test');

No = str2double(get_param(block,'No')); % Get # of Reqs
OldNo = length(find_system(block, 'regexp', 'on','LookUnderMasks','all','Name','<Preconditions name>'));

for i = 1:max(No,OldNo)
    if OldNo > No && i > No && i <= OldNo % Remove
        % disp(' del line');
        
        
    elseif No > OldNo && i > OldNo && i <= No % Add
        % Add blocks
        % Add Outports of Bus Selector
        % OutSignal of Bus Seletor
        %Signal1 = 'signal1.signal1.signal1';
        %for j = 2 : i    
        %ans = get_param(block, 'Name');
        %disp(' add line');
    end
end

% Remove Outport of Bus Selector & Input of Bus Creator4

    




