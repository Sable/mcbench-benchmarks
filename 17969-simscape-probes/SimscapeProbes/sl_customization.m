function sl_customization(cm)

% Copyright 1990-2013 The MathWorks, Inc.
% $Revision: 1.1.8.1 $
   
    cm.addCustomMenuFcn('Simulink:ContextMenu',@getMyMenuItems);
    cm.addCustomFilterFcn('sig_call_back',@myFilter);
end

%% Define the custom menu function.
function schemaFcns = getMyMenuItems(callbackInfo) 
  schemaFcns = {@getItem1}; 
end

%% create filter for menu to appear only for Simscape Probe blocks
function state = myFilter(callbackInfo)
  if strmatch(get_param(gcb,'maskdescription'),'Simscape Probe','exact')
    state = 'Enabled';
  else
    state = 'Hidden';
  end
end


%% Define the schema function for first menu item.
function schema = getItem1(callbackInfo)
  schema = sl_container_schema;
  if strmatch(get_param(gcb,'maskdescription'),'Simscape Probe','exact')
    schema.state = 'Enabled';
    schema.childrenFcns = {@units, @outPort @tagType}; 
    schema.label = 'Configure Probe';
  else
    schema.state = 'Hidden';
  end
end
%% Define Sub-menu entries
function schema = units(callbackInfo)
  schema = sl_action_schema;
  schema.label = 'Set Units';
  schema.callback = @setUnits;
end

function schema = outPort(callbackInfo)
  schema = sl_action_schema;
  schema.label = 'Add Output Port';
  schema.callback = @addOutputPort;
end

function schema = tagType(callbackInfo)
  schema = sl_toggle_schema;
  schema.label = 'Global';
  if strcmp(get_param([gcb, '/Goto'], 'TagVisibility'),'global') == 1
    schema.checked = 'checked';
  else
    schema.checked = 'unchecked';
  end
  schema.callback = @setTag;
end

%% Function callbacks from menu options
function setUnits(callbackInfo)

open_system([gcb, '/PS-S']) % Open PS-S dialog box to set units
    
end

function addOutputPort(callbackInfo)
p=get_param([gcb, '/PS-S'],'Position'); % get position of PS-S block as a reference
hOutblock = add_block('built-in/Outport', [gcb '/Out'],...
            'MakeNameUnique', 'on','Position', ...
            [p(1)+150 p(2)+100 p(3)+175 p(4)+100]); 
add_line(gcb, ['PS-S', '/1'], ['Out', '/1'],'autorouting','on');
end

function setTag(callbackInfo)
tv=get_param([gcb, '/Goto'],'TagVisibility');
  if  regexp(tv,'global') == 1
     set_param([gcb, '/Goto'],'TagVisibility', 'local');
  elseif regexp(tv,'local') == 1
     set_param([gcb, '/Goto'],'TagVisibility', 'global');
  end
end

