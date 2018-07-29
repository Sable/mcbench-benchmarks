function imagemenu(handle)
%IMAGEMENU adds a context menu to change image properties
%   IMAGEMENU(handle) creates a context menu for all images with the parent
%   handle that allows image properties to be easily changed.
%   IMAGEMENU, without any input arguments, will create this context menu
%   for all images that are found in the current figure.
%   This allows users to easily change image properties, and is especially
%   useful for compiled programs, as users do not have access to MATLAB's
%   property editor.
%
%   Example:
%   ----------
%   imagesc(peaks)
%   axis image
%   imagemenu

if nargin == 0
    % Use all images in current figure as default
    handle = gcf;
end

handle = findobj(handle, 'type', 'image');

% Define the context menu
cmenu = uicontextmenu;

% Define the context menu items
colormapmenu = uimenu(cmenu, 'Label', 'Colormap');
uimenu(cmenu, 'Label', 'Reverse current colormap', 'Callback', 'colormap(flipud(colormap))');
uimenu(cmenu, 'Label', 'Toggle colorbar', 'Callback', @togglecolorbar);
if exist('pixval.m')
    % Only show this to those who have it installed...
    uimenu(cmenu, 'Label', 'Toggle pixel values', 'Callback', 'pixval');
end
uimenu(cmenu, 'Label', 'Colormap length...', 'Callback', @colormaplength);
uimenu(cmenu, 'Label', '3D plot...', 'Callback', @call3d);
uimenu(cmenu, 'Label', 'Image limits...', 'Callback', @imagelimits);
uimenu(cmenu, 'Label', 'Title...', 'Callback', @titlecallback);
uimenu(cmenu, 'Label', 'X-axis label...', 'Callback', @xaxiscallback);
uimenu(cmenu, 'Label', 'Y-axis label...', 'Callback', @yaxiscallback);

% Define colormap choices
uimenu(colormapmenu, 'Label', 'Jet', 'Callback', 'colormap(jet)');
uimenu(colormapmenu, 'Label', 'Gray', 'Callback', 'colormap(gray)');
uimenu(colormapmenu, 'Label', 'Hot', 'Callback', 'colormap(hot)');
uimenu(colormapmenu, 'Label', 'Bone', 'Callback', 'colormap(bone)');
uimenu(colormapmenu, 'Label', 'Cool', 'Callback', 'colormap(cool)');
uimenu(colormapmenu, 'Label', 'Color cube', 'Callback', 'colormap(colorcube)');
uimenu(colormapmenu, 'Label', 'HSV', 'Callback', 'colormap(hsv)');
uimenu(colormapmenu, 'Label', 'Prism', 'Callback', 'colormap(prism)');
uimenu(colormapmenu, 'Label', 'Spring', 'Callback', 'colormap(spring)');
uimenu(colormapmenu, 'Label', 'Summer', 'Callback', 'colormap(summer)');
uimenu(colormapmenu, 'Label', 'Winter', 'Callback', 'colormap(winter)');

% And apply menu to handle(s)
set(handle, 'uicontextmenu', cmenu);

% Menu callback
function togglecolorbar(obj, eventdata)
% Do we have a colorbar now?
phch = get(findall(gcf,'type','image','tag','TMW_COLORBAR'),{'parent'});
for i=1:length(phch)
    phud = get(phch{i},'userdata');
    if isfield(phud,'PlotHandle')
        if isequal(gca, phud.PlotHandle)
            delete(phch{i})
            axis image
            return
        end
    end
end

% Nope
colorbar
axis image

% Menu callback
function colormaplength(obj, eventdata)
cmap = colormap;
oldlength = length(cmap);
clength = cellstr(num2str(oldlength));
new = inputdlg({'Enter new colormap length:'}, ...
    'New colormap length', 1, clength);
newlength = str2double(new{1});
oldsteps = linspace(0, 1, oldlength);
newsteps = linspace(0, 1, newlength);
newmap = zeros(newlength, 3);

for i=1:3
    % Interpolate over RGB spaces of colormap
    newmap(:,i) = min(max(interp1(oldsteps, cmap(:,i), newsteps)', 0), 1);
end
colormap(newmap);
% And update the colorbar, if one exists
phch = get(findall(gcf,'type','image','tag','TMW_COLORBAR'),{'parent'});
for i=1:length(phch)
    phud = get(phch{i},'userdata');
    if isfield(phud,'PlotHandle')
        if isequal(gca, phud.PlotHandle)
            colorbar
        end
    end
end

% Menu callback
function imagelimits(obj, eventdata)
lims = get(gca, 'CLim');
oldlower = num2str(lims(1));
oldupper = num2str(lims(2));
new = inputdlg({'Enter new lower limit:', 'Enter new upper limit:'}, ...
    'New image limits', 1, {oldlower, oldupper});
if ~isnan(str2double(new{1})) & ~isnan(str2double(new{2}))
    set(gca, 'CLim', [str2double(new{1}) str2double(new{2})]);
end

% And update the colorbar, if one exists
phch = get(findall(gcf,'type','image','tag','TMW_COLORBAR'),{'parent'});
for i=1:length(phch)
    phud = get(phch{i},'userdata');
    if isfield(phud,'PlotHandle')
        if isequal(gca, phud.PlotHandle)
            colorbar
        end
    end
end
        
% Menu callback
function titlecallback(obj, eventdata)
old = get(gca, 'title');
oldstring = get(old, 'string');
if ischar(oldstring)
    oldstring = cellstr(oldstring);
end
new = inputdlg('Enter new title:', 'New image title', 1, oldstring);
set(old, 'string', new);

% Menu callback
function xaxiscallback(obj, eventdata)
old = get(gca, 'xlabel');
oldstring = get(old, 'string');
if ischar(oldstring)
    oldstring = cellstr(oldstring);
end
new = inputdlg('Enter new X-axis label:', 'New image X-axis label', 1, oldstring);
set(old, 'string', new);

% Menu callback
function yaxiscallback(obj, eventdata)
old = get(gca, 'ylabel');
oldstring = get(old, 'string');
if ischar(oldstring)
    oldstring = cellstr(oldstring);
end
new = inputdlg('Enter new Y-axis label:', 'New image Y-axis label', 1, oldstring);
set(old, 'string', new);

% Menu callback
function call3d(obj, eventdata)
ax = gca;
temp = double(get(gco, 'CData'));

newfig = figure;
newax = axes;
if isempty(get(get(ax, 'Parent'), 'Name'))
    set(newfig, 'Name','3D view');
else
    set(newfig, 'Name', [get(get(ax, 'Parent'), 'Name') ', 3D view']);
end
s = surf(temp, 'LineStyle', 'none');
hl = camlight;
xlabel('X distance [pixels]');
ylabel('Y distance [pixels]');
axis('tight');