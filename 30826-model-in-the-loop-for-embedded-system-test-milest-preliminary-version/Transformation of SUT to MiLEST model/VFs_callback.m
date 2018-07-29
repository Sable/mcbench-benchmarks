function [] = VFs_callback(block)

% Callback processing function for mask parameter
% - number of VF-s used in the Validation Functions Set
set_param(block, 'LinkStatus', 'none');
load_system('Simulink'); % Load Simulink library (background)
load_system('MIL_Test');

No = str2double(get_param(block,'No')); % Get # of VF-s
OldNo = length(find_system(block, 'regexp', 'on','LookUnderMasks','all','Name','Requirement'));
%set_param([block '/Requirement'], 'Name', 'Requirement1');

CurrentNoInp = get_param([block '/Bus Creator'], 'Inputs');
CurrentNoInp = str2num(CurrentNoInp);
% Handle BusSelector
BS = find_system(block, 'SearchDepth', 1,'regexp', 'on','LookUnderMasks','all','BlockType','BusSelector');
outSignals = get_param(BS, 'outputSignals');
%    outSignalsOldNo = length(findstr(outSignals{1,1}, ','))+1; % number of outSignals from Bus Selector currently present in the model

% 0 is not allowed as VF-s SSm doesn't make sense in that case
% Add or remove model items
for i = 1:max(No,OldNo)
    if OldNo > No && i > No && i <= OldNo % Remove
        % Remove lines
        set_param([block '/Bus Creator'], 'Inputs', num2str(No));
        SigAtTLines = get_param([block '/Requirement' num2str(i)],'LineHandles');
        delete_line(SigAtTLines.Inport(1));
        delete_line(SigAtTLines.Outport(1));
        % Remove blocks
        delete_block([block '/Requirement' num2str(i)]);
    elseif No > OldNo && i > OldNo && i <= No % Add
        % Add blocks
        add_block('MIL_Test/Validation Function/Test Evaluation Architecture/Validation FunctionsTemplate/Requirement',[block '/Requirement' num2str(i)]);
        set_param([block '/Requirement' num2str(i)], 'LinkStatus', 'none');
        pos2 = (((i-1)*80)+34);
        pos4 = (((i-1)*80)+86);
        set_param([block '/Requirement' num2str(i)], 'Position', [285 pos2 430 pos4]);
        set_param([block '/Bus Creator'], 'Inputs', num2str(i));
        % Add lines
        add_line(block,['Requirement' num2str(i) '/1'],['Bus Creator/' num2str(i)],'autorouting','on');
        add_line(block,['Datatype conversion/1'],['Requirement' num2str(i) '/1'],'autorouting','on');
    end
end

% Bus Creator4
inpSignals = get_param(BS, 'InputSignals');
lenInpS = length(inpSignals{1,1});
if lenInpS ~= 1
    for j =1:lenInpS
        outSignalsNb(j) = length(inpSignals{1,1}{j,1}{1,2});
    end
    outSignalsNo = sum(outSignalsNb);
elseif lenInpS == 1
    outSignalsNb = length(inpSignals{1,1}{1,1}{1,2});
    outSignalsNo = sum(outSignalsNb); % New number of outsignals  for Bus Selector
end
%BusCreator 4
set_param([block '/Bus Creator4'], 'Inputs', num2str(outSignalsNo));
% Arbitration
set_param([block '/Arbitration/Collect Verdicts'], 'Inputs', num2str(outSignalsNo+1))
MemoLine = get_param([block '/Arbitration/Memory'],'LineHandles');
delete_line(MemoLine.Outport(1));
add_line([block '/Arbitration'],'Memory/1',['Collect Verdicts/' num2str(outSignalsNo+1)],'autorouting','on');


%    % Arbitration
%     for j =1:outSignalsNo
%         if OldNo > No && i > No && i <= OldNo % Remove
%             delete_block([block '/Arbitration/In' num2str(j)]);
%         elseif No > OldNo && i > OldNo && i <= No % Add
%             add_block('Simulink/Ports & Subsystems/In1',[block '/Arbitration/In' num2str(j)]);
% 
%         end
%     end

    %Add outputs to Bus Selector
    %set_param(BS, 'OutputSignals', 'signal1.signal2,signal1.signal1,signal1.signal2')
    % % pomysl jak dodac string zlozony z nazw of signals
    % for i=1:4
    %         inpSig1Lev= inpSignals{i,1};
    %         lenInS = length(inpSignals{i,1}{1,2});
    %         inpSig2Lev(lenInS:1)= inpSignals{i,1}{1,2};
    % end
    % strcat(inpSig2Lev)




