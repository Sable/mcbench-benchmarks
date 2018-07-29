function hilite_virtual_blocks(modelName)
% This function highlight the virtual blocks that are not going to
% contribute to the simulation of a system.
%
% Useful to study the impact of optimization settings in the model
% configuration parameters.
%
% This function potentially can be used for studying model coverage.
%-----------------------------------------------------------------------
% Developed by: Neelakanda Bharathiraja
% Email: syslancer@gmail.com
%-----------------------------------------------------------------------

open_system(modelName);

% Set the start function call back which adds the listener to the blocks.
oldStartFcn = get_param(modelName, 'StartFcn');
newStartFcn = sprintf('%s\n%s ', oldStartFcn, 'callback_details');
set_param(modelName, 'StartFcn', newStartFcn);

% Just start and stop the model to have the callback run.
set_param(modelName,'SimulationCommand', 'start');
set_param(modelName, 'SimulationCommand', 'Stop');

% Cleanup the changes done in the model properties.
set_param(modelName, 'StartFcn', oldStartFcn);

uiwait(msgbox(['The virtual blocks are highlighted. Please review it.' char(10) ...
    'The model has unsaved changes, but they won''t affect the model behaviour.' char(10) ...
    'You can also close and open the model without saving it.'],'Highlight Virtual Blocks','modal'));

return;