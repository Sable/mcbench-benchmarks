function sl_customization(cm)
% Customizes Simulink context menu with all blocks from a model file
% custom_context_menu_blocks.mdl file. These blocks are then accessible 
% through context menu: Add custom block / List of blocks from library.
% The chosen block is added at the position of mouse context menu click.
%
% Please feel free to modify custom_context_menu_blocks.mdl to meet your
% expectations.
%
% OUTPUTS:  Customised Simulink context
%
% Author: Paul Proteus (e-mail: proteus.paul (at) yahoo (dot) com)
% Version: 1.0
% Changes tracker:  31.01.2011  - First version
%
% Note:  It might be neccessery to run sl_refresh_customizations to refresh
%        Simulink context menu or set the Matlab path correctly.
%
% Inspired by and parts of code taken from:
%   1. Alex - Add Simulink Commonly Used Blocks with context menu (#22067)
%   2. Giacomo Faggiani - Create From Blocks (#25736)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Register custom menu function.
cm.addCustomMenuFcn('Simulink:PreContextMenu', @getMyMenuItems);
end

%% Define the custom menu function.
function schemaFcns = getMyMenuItems(callbackInfo) 
  schemaFcns = {@addSimulinkBlock}; 
end

%% Define the schema function for first menu item.
function schema = addSimulinkBlock(callbackInfo)     
  schema = sl_container_schema;
  schema.label  = 'Add custom block';
  % Get mouse position
  mousePosition = get(0,'PointerLocation');
  % Get available block from the library
  customMDL = 'custom_context_menu_blocks'; 
  load_system(customMDL);
  availableBlocks = find_system(customMDL,'SearchDepth',1);
  for iBlock=2:length(availableBlocks),  
     blockName = availableBlocks{iBlock};
     blockName = blockName(max(strfind(blockName,'/'))+1:end);
     childFunc(iBlock-1) = {{@addLibraryBlock,{customMDL,blockName,mousePosition}}};
  end
  schema.childrenFcns = childFunc;
end 

function schema = addLibraryBlock(callbackInfo)
  schema = sl_action_schema;
  schema.label = callbackInfo.userdata{2};	
  schema.userdata = callbackInfo.userdata;
  schema.callback = @slAddLibraryBlock; 
end

% SUB-FUNCTIONS
function slAddLibraryBlock(inArgs)

% Define initial information
modelName     = gcs;
customMDL     = inArgs.Userdata{1};
blockName     = inArgs.Userdata{2};
mousePosition = inArgs.Userdata{3};

% Source and destination path
dstStr = [modelName '/' blockName];
srcStr = [customMDL '/' blockName];

% Get more information for position calculation
blockSizeRef = get_param(srcStr, 'Position');
locationBase = get_param(modelName,'Location');
scrollOffset = get_param(modelName,'ScrollbarOffset');
screenSize   = get(0,'ScreenSize');

% Calculate new position
p_X = mousePosition(1) - locationBase(1) + scrollOffset(1);
p_Y = screenSize(4) - mousePosition(2) - locationBase(2) + scrollOffset(2) ;
width = blockSizeRef(3) - blockSizeRef(1);
height = blockSizeRef(4) - blockSizeRef(2);
location = [p_X p_Y p_X+width p_Y+height];

% Add block
block = add_block(srcStr, dstStr, 'MakeNameUnique', 'on');
set(block, 'Position', location);

close_system(customMDL);
        
end
 
