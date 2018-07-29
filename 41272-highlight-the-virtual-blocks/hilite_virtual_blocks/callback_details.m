%-----------------------------------------------------------------------
% Developed by: Neelakanda Bharathiraja
% Email: syslancer@gmail.com
%-----------------------------------------------------------------------
% Script file to set the add_exec_event_listener during model startfcn
% callback.

% Logic: We can identify whether a block is used during the model
% simulation and it is not optimized by the following methods.
% 1. If we can setup add_exec_event_listener for the block
% 2. If we can get the run time object of the block.
% We are using second method. Because with the first one, the script can't
% be used more than once in the same session.

warning('off','Simulink:Engine:RTI_Listener_Const_SampleTime');
allBlocks = find_system(bdroot(gcs));
for ii = 1:length(allBlocks)
    try
        r(ii) = get_param(allBlocks{ii}, 'RuntimeObject');
        % h(ii) = add_exec_event_listener(allBlocks{ii}, 'PostOutputs',@unhilite_blocks);
    catch
        % Failed to set a listener, then hilite the block.
        hilite_system(allBlocks{ii});
    end
end
warning('on','Simulink:Engine:RTI_Listener_Const_SampleTime');
