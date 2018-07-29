function colorize_documentbar(varargin)
%% COLORIZE_DOCUMENTBAR Colorize the document bar of the Matlab editor
% The file names in the document bar of the Matlab editor are colorized
% according to the folders they are stored in.
% The colors are chosen to allow maximal distinct. 
% 
% Different modes can be selected
% colorize_documentbar()
%    Colors are chosen automatically; each folder gets its own color.
%
% colorize_documentbar('folder',LIST_FOLDERS,LIST_COLORS)
%    with inputs
%         LIST_FOLDERS      cellarray with string (1 x n)
%         LIST_COLORS       n x 3 colormatrix (RGB values)
%    Files in one of the folders or subfolders listed in LIST_FOLDERS
%    get the color given in LIST_COLORS.
%    All other files get colors which are chosen automatically.
%
% colorize_documentbar('root',list_folders_root,LIST_ROOTCOLORS)
%    with inputs
%         list_folders_root:       cellarray with string (1 x n)
%         LIST_ROOTCOLORS: n x 3 colormatrix (RGB values)
%    Files in one of the folders listed in list_folders_root get colorized 
%    with the color given in LIST_ROOTCOLORS. Files in subfolders of the folder
%    get a color similar to the one of the parent directory. Each subfolder
%    has its own color.
%    All other files get colors which are chosen automatically.
%
% colorize_documentbar('folder',LIST_FOLDERS,LIST_COLORS,'root',list_folders_root,LIST_ROOTCOLORS)
%    Combination of the two modes listed above.
% 
% colorize_documentbar('sort')
%    Sorts the opened documents by color. (Experimental)
%
% Dependencies:
%   The functions 'findjobj' and 'distinguishable_colors' from
%   MATLABcentral need to be in the matlab search path.
%
% example: 
%   colorize_documentbar()
%   colorize_documentbar('fixed',matlabroot,[0 0 1]);  % all Matlab are colored in red
%   colorize_documentbar('root',{'D:\Matlab\myclass','H:\Matlab\myproject'},[0 1 0;1 0 0]);


% Check for additional functions
function_names = {'distinguishable_colors','findjobj'};
function_matlabcentralid = [29702 14317];
for I_function = 1:length(function_names);
   if exist(function_names{I_function},'file')~=2
        error('The function ''%s'' is needed. You can download it from MatlabCentral (<a href="http://www.mathworks.com/matlabcentral/fileexchange/%d?download=true">download know</a>).',function_names{I_function},function_matlabcentralid(I_function));
        return;
   end
end

if nargin>0 && strcmp(varargin{1},'sort')
   sortbycolor() 
   return
end

% Initialize appdata with empty lists
% set lists with folders
setappdata(0,'list_folders_opened',{});
setappdata(0,'list_folders_fixed',{});
setappdata(0,'list_folders_root',{});

% set lists with colors
setappdata(0,'list_colors_opened',[]);
setappdata(0,'list_colors_fixed',[]);
setappdata(0,'list_colors_root',[]);

% Save inputs as appdata
if nargin > 0
    if strcmp(varargin{1},'fixed')
        if ~iscell(varargin{2})
            varargin{2} = {varargin{2}};
        end
        % sort folderlist by length
        [~,I_sort] = sort(cellfun(@length,varargin{2}),2,'descend');
        setappdata(0,'list_folders_fixed',varargin{2}(I_sort));
        setappdata(0,'list_colors_fixed',varargin{3}(I_sort,:));
    end
    if strcmp(varargin{1},'root')
        if ~iscell(varargin{2})
            varargin{2} = {varargin{2}};
        end
        % sort folderlist by length
        [~,I_sort] = sort(cellfun(@length,varargin{2}),2,'descend');
         setappdata(0,'list_folders_root',varargin{2}(I_sort));
         setappdata(0,'list_colors_root',varargin{3}(I_sort,:));
    end
end
if nargin > 3
    if strcmp(varargin{4},'fixed')
        if ~iscell(varargin{5})
            varargin{5} = {varargin{5}};
        end
        % sort folderlist by length
        [~,I_sort] = sort(cellfun(@length,varargin{5}),2,'descend');
         setappdata(0,'list_folders_fixed',varargin{5}(I_sort));
         setappdata(0,'list_colors_fixed',varargin{6}(I_sort,:));
    end
    if strcmp(varargin{4},'root') 
        if ~iscell(varargin{5})
            varargin{5} = {varargin{5}};
        end
        % sort folderlist by length
        [~,I_sort] = sort(cellfun(@length,varargin{4}),2,'descend');
         setappdata(0,'list_folders_root',varargin{5}(I_sort));
         setappdata(0,'list_colors_root',varargin{6}(I_sort,:));
    end
end

% get handles
jEditor = getEditor();
jh_gp = getGroupPanel(jEditor);

% callback for opening documents
jh_gp_handle = handle(jh_gp,'CallbackProperties');
set(jh_gp_handle,'ComponentAddedCallback',@callbackFcn);

% set callback for closing of document bar
set(handle(jh_gp.getParent.getParent.getParent.getParent.getParent,'CallbackProperties'),'ComponentShownCallback',{@callbackFcn,jh_gp});

% colorize buttons
colorizeDocumentButtons(jh_gp);

end

%% subfunctions

% get Matlab editor handle
function [jEditor,editor_started] = getEditor()
    try
        % Matlab 7
        desktop = com.mathworks.mde.desk.MLDesktop.getInstance;
        jEditor = desktop.getGroupContainer('Editor').getTopLevelAncestor;
        % we get a com.mathworks.mde.desk.MLMultipleClientFrame object
        editor_started = 0;
    catch
        %warning('Opening Editor!')
        % Editor is not opened
        matlab.desktop.editor.newDocument; % open Editor with two Documents
        matlab.desktop.editor.newDocument;
        desktop = com.mathworks.mde.desk.MLDesktop.getInstance;
        jEditor = desktop.getGroupContainer('Editor').getTopLevelAncestor;
        editor_started = 1;
    end
end

% get group panel handle
function jh_gp = getGroupPanel(jEditor)
    if isempty(jEditor)
        jh_gp = [];
    else
        % Find Editor Group Frame (this is platform independent)
        jh_gf = findjobj(jEditor,'-property',{'name','EditorGroupFrame'});
        % Get Group Panel
        jh_gp = jh_gf.getComponent(0).getComponent(0).getComponent(1).getComponent(0).getComponent(0).getComponent(0).getComponent(0).getComponent(0).getComponent(0);
        if ~isa(jh_gp,'com.mathworks.widgets.desk.DTDocumentBar$GroupPanel')
            jh_gp = jh_gf.getComponent(0).getComponent(0).getComponent(1).getComponent(0).getComponent(0).getComponent(0).getComponent(0).getComponent(0).getComponent(0).getComponent(0);
            if ~isa(jh_gp,'com.mathworks.widgets.desk.DTDocumentBar$GroupPanel')
                error('colorize_documentbar:getGroupPanel:notfound','Can''t find Group Panel')
            end
        end
    end
end

function colorizeDocumentButtons(jh_gp)
    % get filenames and folders of opened documents from mouse hover tips 
    folders = {};
    filenames = {};
    for I = 1:(length(jh_gp.getComponents)-1)/2
        filename = get(jh_gp.getComponent(2*I-1).getAction,'Tip');
        [folders{I}, filenames{I}] = fileparts(filename);
    end
    folders_unique = unique(folders);
    
    % get lists with folders
    list_folders_opened = getappdata(0,'list_folders_opened');
    list_folders_fixed  = getappdata(0,'list_folders_fixed');
    list_folders_root   = getappdata(0,'list_folders_root');
    
    % get lists with colors
    list_colors_opened = getappdata(0,'list_colors_opened');
    list_colors_fixed  = getappdata(0,'list_colors_fixed');
    list_colors_root   = getappdata(0,'list_colors_root');
    
    % check if file was closed
    [~,I] = setdiff(list_folders_opened,folders_unique);
    list_folders_opened(I) = [];
    list_colors_opened(I,:) = [];
    
    % folders not in current list with opened folders
    folders_new = setdiff(folders_unique,list_folders_opened);
    
    % if new folders were opened
    if ~isempty(folders_new)
        % determine new colors for folders not in current list
        for I_folder = 1:length(folders_new)
            % check if subdirectory of rootfolder
            root_found = 0;
            for I_folder_root = 1:length(list_folders_root)
                root_found = strfind(folders_new{I_folder},list_folders_root{I_folder_root});
                if root_found == 1 % rootdirecotry was found
                    % number of subdirectories already opened with this rootfolder
                    N_already_opened = sum(cellfun(@(x) any(strfind(x,list_folders_root{I_folder_root})),list_folders_opened));
                    color_new = sub_color(list_colors_root(I_folder_root,:),N_already_opened+1);
                    break
                else
                    root_found = 0;
                end
            end
            % check if subdirectory of fixed folders
            fixed_found = 0;
            for I_folder_fixed = 1:length(list_folders_fixed)
                fixed_found = strfind(folders_new{I_folder},list_folders_fixed{I_folder_fixed});
                if fixed_found == 1 % rootdirecotry was found
                    color_new = list_colors_fixed(I_folder_fixed,:);
                    break
                else
                    fixed_found = 0;
                end
            end
            % determine new color for folder if not subdirectory of fixed
            % or root folders
            if ~fixed_found && ~root_found
                color_new = distinguishable_colors(1,[list_colors_opened;0 0 0;list_colors_fixed;list_colors_root]);
            end
            
            % extend lists with opened folders and colors
            list_folders_opened = [list_folders_opened,folders_new(I_folder)];
            list_colors_opened = [list_colors_opened;color_new];
        end

        % sort folderlist according to tree structure
        [~,I_sort] = sort(lower(list_folders_opened));
        list_folders_opened = list_folders_opened(I_sort);
        list_colors_opened = list_colors_opened(I_sort,:);
        
        % set lists with folders
        setappdata(0,'list_folders_opened',list_folders_opened);
        % set lists with colors
        setappdata(0,'list_colors_opened',list_colors_opened);
    end    
    
%     % set callback properties of group panel (for dragging of tabs)
%     jhh = handle(jh_gp,'CallbackProperties');
%     set(jhh,'ComponentAddedCallback',@propertyChange);

    % transform colors to be bright
    colors = color_transform(list_colors_opened);
    
    % set background colors
    for I = 1:length(filenames)
        % get tab
        jh_2 = jh_gp.getComponent(2*I-1);
        % set callbackproperties (for unsaved documents' *)
        jhhh = handle(jh_2,'CallbackProperties');
        set(jhhh,'PropertyChangeCallback',@callbackFcn)
        % get index out of list with opened folders
        I_color = find(strcmp(folders{I},list_folders_opened));
        % set background color
        jh_2.setBackground(java.awt.Color(colors(I_color,1), colors(I_color,2), colors(I_color,3)));
    end
end

% transform colors to be bright
function colors_out = color_transform(colors)
    colors = rgb2hsv(colors);
    colors(:,2) = colors(:,2)*0.5;
    colors(:,3) = colors(:,3)*0.5+0.5;
    colors_out = hsv2rgb(colors);
end

function callbackFcn(varargin)
    try
        if isa(varargin{1},'javahandle_withcallbacks.com.mathworks.widgets.desk.DTDocumentBar$DocumentButton') 
            if strcmp(get(varargin{2},'PropertyName'),'ToolTipText')
                % rename document
                if ~isempty(varargin{1}.getParent) % close document
                    colorizeDocumentButtons(varargin{1}.getParent)
                end
            end
        elseif isa(varargin{1},'javahandle_withcallbacks.com.mathworks.widgets.desk.DTDocumentBar')
            % open document bar
            colorizeDocumentButtons(varargin{1}.getComponent(0).getComponent(0).getComponent(0).getComponent(0).getComponent(0))
        elseif isa(varargin{1},'javahandle_withcallbacks.com.mathworks.widgets.desk.DTDocumentBar$GroupPanel')
            % open new document
            colorizeDocumentButtons(varargin{1})
        else
           %keyboard 
           disp('hallo')
        end
    catch em
        disp(em.message)
    end
end

% determine a color similar to existing one
function color_new = sub_color(color,I)
    z = ((I-(2.^(1+floor(log(I)/log(2))))./2)*2+1)./(2.^(1+floor(log(I)/log(2))));
    color_new = hsv2rgb(rgb2hsv(color).*[1 1 0.5] +  0.5*z*[0 0 1]);
end

function sortbycolor(varargin)
    %TODO: the tab order doesn't change

    % get group panel handle
    jEditor = getEditor();
    jh_gp = getGroupPanel(jEditor);
    
    % get folder list
    list_folders_opened = getappdata(0,'list_folders_opened');
    list_colors_opened = getappdata(0,'list_colors_opened');

    % sort folder list
    [~,I_sort] = sort(lower(list_folders_opened));
    list_folders_opened = list_folders_opened(I_sort);
    list_colors_opened = list_colors_opened(I_sort,:);

    % set lists with folders
    setappdata(0,'list_folders_opened',list_folders_opened);
    % set lists with colors
    setappdata(0,'list_colors_opened',list_colors_opened);
    
    % get filenames and folders of opened documents
    folders = {};
    for I = 1:(length(jh_gp.getComponents)-1)/2
        filename = get(jh_gp.getComponent(2*I-1).getAction,'Tip');
        [folders{I}, filenames{I}] = fileparts(filename);
        color(I) = find(strcmp(folders{I},list_folders_opened));
    end
    
    % sort by filenames
    [~,I_sort_filenames] = sort(lower(filenames));
    color = color(I_sort_filenames);
    
    % sort by color
    [~,I_sort_color] = sort(color);
    
    % get all components (document buttons)
    components = jh_gp.getComponents();    
    
    % get actions of each document button (every other component)
    for I_comp = 1:(length(jh_gp.getComponents)-1)/2
       actions(I_comp) = components(I_comp*2).getAction;
       actionCommands(I_comp) = components(I_comp*2).getActionCommand;
       labels(I_comp) = components(I_comp*2).getLabel;
       names(I_comp) = components(I_comp*2).getName;
    end
    % 
    % sort by filenames
    actions = actions(I_sort_filenames);
    actionCommands = actionCommands(I_sort_filenames);
    labels = labels(I_sort_filenames);
    names = names(I_sort_filenames);

    % sort by color
    actions = actions(I_sort_color);
    actionCommands = actionCommands(I_sort_color);
    labels = labels(I_sort_color);
    names = names(I_sort_color);
    
    % replace actions according to new order
    for I_comp = 1:(length(jh_gp.getComponents)-1)/2
        components(I_comp*2).setAction(actions(I_comp));
        components(I_comp*2).setActionCommand(actionCommands(I_comp));
        components(I_comp*2).setLabel(labels(I_comp));
        components(I_comp*2).setName(names(I_comp));
    end

end
