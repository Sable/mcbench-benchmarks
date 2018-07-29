function [] = ReqName_callback(block)

% Callback processing function for mask parameter
% - number of VF-s used in the Validation Functions Set
set_param(block, 'LinkStatus', 'none');
load_system('Simulink'); % Load Simulink library (background)
load_system('MIL_Test');

No = str2double(get_param(block,'No')); % Get # of Reqs
OldNo = length(find_system(block, 'regexp', 'on','LookUnderMasks','all','Name','<Preconditions name>'));
SysN = get_param(block, 'parent');
ReqN = get_param(block, 'Name');
ReqN_V = ReqN(end:-1:1);
Nr = ReqN_V(1);
if Nr == '>'
    Nr = 1;
end
SigFrBS = get_param([SysN '/Bus Selector'], 'OutputSignals');
OldNo_Sig = length(findstr(SigFrBS, ','))+1;
SigFrBS_l = get_param([SysN '/Bus Selector'], 'LineHandles');
% 0 is not allowed as VF-s SSm doesn't make sense in that case
% Add or remove model items

if OldNo > No  % Remove
    % Redraw all the lines and Reset the in-out ports of all related block
    % Remove all the lines from Bus Selector
    for i = 1:OldNo_Sig
    delete_line(SigFrBS_l.Outport(i));
    end
    % Reset the inports of Bus Creator4
    set_param([SysN '/Bus Creator4'], 'Inputs', num2str(OldNo_Sig-(OldNo-No)));
    
end

for i = 1:max(No,OldNo)
    if OldNo > No && i > No && i <= OldNo % Remove
        % Remove lines
        set_param([block '/Bus Creator'], 'Inputs', num2str(No));
        PreLines = get_param([block '/<Preconditions name>' num2str(i)],'LineHandles');
        AssLines = get_param([block '/<Assertions name>' num2str(i)],'LineHandles');
        delete_line(PreLines.Inport(1));
        delete_line(PreLines.Outport(1));
        delete_line(AssLines.Inport(2));
        delete_line(AssLines.Outport(1));
        % Remove blocks
        delete_block([block '/<Preconditions name>' num2str(i)]);
        delete_block([block '/<Assertions name>' num2str(i)]);
        %==================================================================
        %==================================================================
        % Delete Signals between Bus Selector and Arbitration
        % Delete Signals in Arbitration 
        No_In = length(find_system([SysN '/Arbitration'], 'regexp', 'on','LookUnderMasks','all','Name','In'));
        delete_line([SysN '/Arbitration'],['In' num2str(No_In) '/' num2str(1)],['Collect Verdicts/' num2str(No_In)]);
        delete_line([SysN '/Arbitration'],['Memory/' num2str(1)],['Collect Verdicts/' num2str(No_In+1)]);
        % Delete Signals from Bus Selector
        SigFrBS_n = get_param([SysN '/Bus Selector'], 'OutputSignals');
        p = strcat(',','signal',Nr,'.signal',num2str(i),'.signal1');
        SigFrBS_n = strrep(SigFrBS_n,p,'');
        set_param([SysN '/Bus Selector'], 'OutputSignals',SigFrBS_n);
        % Delete Inports of Arbitration and Collection Verdicts
        delete_block([SysN '/Arbitration/In' num2str(No_In)]);
        set_param([SysN '/Arbitration/Collect Verdicts'], 'Inputs', num2str(No_In));
        add_line([SysN '/Arbitration'],['Memory/' num2str(1)],['Collect Verdicts/' num2str(No_In)],'autorouting','on');
        
        %==================================================================
        %==================================================================
    elseif No > OldNo && i > OldNo && i <= No % Add
        % Add blocks
        add_block('MIL_Test/Validation Function/Test Evaluation Architecture/<system name>/<Requirement name>/<Preconditions name>',[block '/<Preconditions name>' num2str(i)]);
        add_block('MIL_Test/Validation Function/Test Evaluation Architecture/<system name>/<Requirement name>/<Assertions name>',[block '/<Assertions name>' num2str(i)]);
        set_param([block '/<Preconditions name>' num2str(i)], 'LinkStatus', 'none');
        set_param([block '/<Assertions name>' num2str(i)], 'LinkStatus', 'none');
        pos2 = (((i-1)*120)+24);
        pos4 = (((i-1)*120)+66);
        set_param([block '/<Preconditions name>' num2str(i)], 'Position', [165 pos2 265 pos4]);
        posi2 = (((i-1)*120)+94);
        posi4 = (((i-1)*120)+136);
        set_param([block '/<Assertions name>' num2str(i)],  'Position', [315 posi2 450 posi4]);
        set_param([block '/Bus Creator'], 'Inputs', num2str(i));
        % Add lines
        add_line(block,['<Preconditions name>' num2str(i) '/1'],['<Assertions name>' num2str(i) '/1'],'autorouting','on');
        add_line(block,['InOut Bus/1'],['<Assertions name>' num2str(i) '/2'],'autorouting','on');
        add_line(block,['InOut Bus/1'],['<Preconditions name>' num2str(i) '/1'],'autorouting','on');
        add_line(block,['<Assertions name>' num2str(i) '/1'],['Bus Creator/' num2str(i)],'autorouting','on');
        
        % =================================================================
        % =================================================================
        % Add Signals between Bus Selector and Arbitration
        
        
        % Nr = str2num(ReqN_V(1));
        
        % Add Outports of Bus Selector
        % Here OutSignal of Bus Seletor, the Outports quere depends on the click
        % quere
        Signal1 = get_param([SysN '/Bus Selector'], 'OutputSignals');
        SignalP = strcat(Signal1,',','signal',Nr,'.signal',num2str(i),'.signal1');
        set_param([SysN '/Bus Selector'], 'OutputSignals',SignalP);
        % Add Inports of Bus Creator4
        In_nr = get_param([SysN '/Bus Creator4'], 'Inputs');
        In_nr = str2num(In_nr)+1;
        set_param([SysN '/Bus Creator4'], 'Inputs', num2str(In_nr));
        % Add Input to Arbitration, also needs signals in the Arbitration
        % added at the same time
        No_In = length(find_system([SysN '/Arbitration'], 'regexp', 'on','LookUnderMasks','all','Name','In'));
        add_block('Simulink/Ports & Subsystems/In1',[SysN '/Arbitration/In' num2str(No_In+1)]);
        posi = get_param([SysN '/Arbitration/In' num2str(No_In)], 'Position');
        pos1 = posi(1);
        pos3 = posi(3);
        pos2 = posi(2)+40;
        pos4 = posi(4)+40;
        set_param([SysN '/Arbitration/In' num2str(No_In+1)], 'Position',[pos1 pos2 pos3 pos4]);
        % fix position of Memory
        fix_pos([SysN '/Arbitration/Collect Verdicts'],[SysN '/Arbitration/Memory'],0,10);
        % Set Inputports of 'Collect Verdicts'
        set_param([SysN '/Arbitration/Collect Verdicts'], 'Inputs', num2str(No_In+2));
        % Put the Memory Outsignal always in the last Inport of Collect
        % Verdicts
        delete_line([SysN '/Arbitration'],['Memory/' num2str(1)],['Collect Verdicts/' num2str(No_In+1)]);
        add_line([SysN '/Arbitration'],['Memory/' num2str(1)],['Collect Verdicts/' num2str(No_In+2)],'autorouting','on');
        % Add line from 'in' to 'Collect Verdicts', which happens in the
        % undersystem Arbitration
        add_line([SysN '/Arbitration'],['In' num2str(No_In+1) '/' num2str(1)],['Collect Verdicts/' num2str(No_In+1)],'autorouting','on');
        % Add Line from Bus Selector to Arbitration
        add_line(SysN,['Bus Selector/' num2str(No_In+1)],['Arbitration/' num2str(No_In+1)],'autorouting','on');
        % Add lines between Bus Selector and Bus Creator4
        add_line(SysN,['Bus Selector/' num2str(No_In+1)],['Bus Creator4/' num2str(No_In+1)],'autorouting','on');
        % =================================================================
        % =================================================================
        
    end
end

% Remove Outport of Bus Selector & Input of Bus Creator4
if OldNo > No  % Remove
    % Redraw all the lines and Reset the in-out ports of all related block
    % Add Line from Bus Selector to Arbitration
    SigF_N = get_param([SysN '/Bus Selector'], 'OutputSignals');
    N_SigF= length(findstr(SigF_N, ','))+1;
   for j = 1:N_SigF
    add_line(SysN,['Bus Selector/' num2str(j)],['Arbitration/' num2str(j)],'autorouting','on');
    % Add lines between Bus Selector and Bus Creator4
    add_line(SysN,['Bus Selector/' num2str(j)],['Bus Creator4/' num2str(j)],'autorouting','on');
   end       
end

system_name1(SysN);
 

%----------------------------------------------------------------
% HELPER

% parentOfReq = get_param(block, 'Parent'); 
% %in the parentOfReq find the block having name Bus Selector
% BS = find_system(parentOfReq, 'SearchDepth', 1,'regexp', 'on','LookUnderMasks','all','BlockType','BusSelector');
% outSignals = get_param(BS, 'outputSignals'); 
% outSignalsOldNo = length(findstr(outSignals, ','))+1; % number of outSignals from Bus Selector currently present in the model 
% inpSignals = get_param(BS, 'InputSignals'); 
% lenInpS = length(inpSignals);
% 
% for i =1:lenInpS
%     outSignalsNb(i) = length(BSInpSign{i,1}{1,2}); 
% end 
%     outSignalsNo = sum(outSignalsNo); % New number of outsignals  for Bus Selector
