%% #######################     HEADER START    ############################
%*************************************************************************
%
% Filename:				AddMultipleLegends.m
%
% Author:				A. Mering
% Created:				07-Aug-2013
%
% Changed on:			XX-XX-XXXX  by USERNAME		SHORT CHANGE DESCRIPTION
%						XX-XX-XXXX  by USERNAME		SHORT CHANGE DESCRIPTION
%
%*************************************************************************
%
% Description:
%		Add further legends to a given axes.
% 
%
% Input parameter:
%		- figure_handle:		Handle to the working figure
%		- first_axes_handle:	Handle to the first axes
%		- legend_data:			Array of struct, containing the different legend entries
%		- legend_settings:		Structure with additional legend settings (for each legend)
%
% Output parameter:
%		- none
%
%*************************************************************************
%
% Intrinsic Subfunctions
%		- none
%
% Intrinsic Callbacks
%		- none
%
% #######################      HEADER END     ############################

%% #######################    FUNCTION START   ############################
function AddMultipleLegends(figure_handle, first_axes_handle, legend_data, legend_settings)

%% --- Input data conversion
% are all structure fields of type cell?
if ~all(structfun(@iscell, legend_settings))
	settings_content = struct2cell(legend_settings);
	settings_content(~cellfun(@iscell, settings_content)) = cellfun(@(x) {{x}}, settings_content(~cellfun(@iscell, settings_content)));
	legend_settings = cell2struct(settings_content, fieldnames(legend_settings))
end

% is the legend_data a cell array
if all(cellfun(@isstruct, legend_data))
	legend_data = {legend_data(:)};
end

%% --- Input error checking
if ~ishandle(figure_handle) || ~isequal(get(figure_handle, 'Type'), 'figure')
	error('Given figure handle is not a proper handle to a figure!')
end
	
if ~ishandle(first_axes_handle) || ~isequal(get(first_axes_handle, 'Type'), 'axes')
	error('Given axes handle is not a proper handle to a axes!')
end

if length(unique(structfun(@length, legend_settings))) ~= 1
	disp(legend_settings)
	error('Legend settings are inconsistent!')
end

if isfield(legend_settings, 'Location') && (~all(cellfun(@ischar, legend_settings.Location)) || ~all(ismember(legend_settings.Location, {'', 'North', 'South', 'East', 'West', 'NorthEast', 'NorthWest', 'SouthEast', 'SouthWest', 'NorthOutside', 'SouthOutside', 'EastOutside', 'WestOutside', 'NorthEastOutside', 'NorthWestOutside', 'SouthEastOutside', 'SouthWestOutside', 'Best', 'BestOutside'})))
	error('Legend location not valid!')
end

if ~all(cell2mat(cellfun(@(x) all(cell2mat(cellfun(@(y) isstruct(y) + isempty(y), x, 'UniformOutput', false))), legend_data, 'UniformOutput', false)))
	error('Legend data should be given as cell-array of struct!')
end

if unique(structfun(@length, legend_settings)) ~= length(legend_data)
	error('Legend settings should be given for each legend!')
end

%% --- Initialize
% get first axes properties
first_axes_position = get(first_axes_handle,'Position');
first_axes_xlim		= xlim(first_axes_handle);
first_axes_ylim		= ylim(first_axes_handle);

% get first legend properties
first_legend_handle = legend(first_axes_handle);
if isempty(first_legend_handle)
	legend_property_list = {'FontSize'};
else
	legend_property_list = {'FontSize', 'FontName', 'FontWeight', 'FontUnits', 'FontAngle'};
	legend_properties = get(first_legend_handle, legend_property_list);
end

legend_properties{1} = 7;   % used fixed font size

%% --- Build
for legend_num = 1: length(legend_data)
	
	% create axes
	second_axes_handle(legend_num) = axes('Parent',figure_handle,'Position', first_axes_position, 'Xlim', first_axes_xlim, 'Ylim', first_axes_ylim);
	hold on

	% create lines
	for entry_num = 1: length(legend_data{legend_num})
		if ~isempty(legend_data{legend_num}{entry_num})
			plot(0, 0,legend_data{legend_num}{entry_num})
		end
	end
	
	% create legend
	legend(second_axes_handle(legend_num), 'Location', 'Best')
	set(legend(second_axes_handle(legend_num)), cell2struct(legend_properties, legend_property_list, 2), structfun(@(x) x{legend_num}, legend_settings, 'UniformOutput', false))
	
	% link axes XLim and YLim with first axes
	lp2 = linkprop([second_axes_handle(legend_num), first_axes_handle], {'XLim', 'YLim'});	% needed to make zoom and pan work
	set(second_axes_handle(legend_num), 'UserData', lp2)
	
	% make second axes content invisible
	set(second_axes_handle(legend_num),'Visible','off')
	set(allchild(second_axes_handle(legend_num)),'Visible','off')
end

%% --- Finalize
% link axes properties
lp1 = linkprop([first_axes_handle, second_axes_handle], 'Position');
set(first_axes_handle, 'UserData', lp1)


% #######################     FUNCTION END    ############################

%% #######################  SUBFUNCTION START  ############################


% #######################   SUBFUNCTION END   ############################

%% #######################    CALLBACK START   ############################


% #######################     CALLBACK END    ############################

