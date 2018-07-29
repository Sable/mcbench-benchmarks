function AddShortcut(label, callback, icon, category, editable, overwrite)
%ADDSHORTCUT Adds a shortcut to the specified category.
% 
% ADDSHORTCUT(LABEL, CALLBACK, ICON, CATEGORY, EDITABLE) adds a
% shortcut to the specified category, which by default is the toolbar.
% LABEL is a string giving the name label to be displayed if 'Show
% Labels' is selected. 
% CALLBACK is a string containing the expression to be executed when the
% shortcut is clicked.
% ICON should be either 'Standard Icon' (the default) or 'Matlab Icon'
% or a path to an icon file.
% CATEGORY names the category of shortcuts that this should be included
% in; 'Toolbar Shortcuts' by default.
% EDITABLE denoted whether or not the shortcut should be editable.  It
% should take the value 'true' or 'false'. (Logical values are converted
% to character.)
% 
% ADDSHORTCUT(SHORTCUT) adds a shortcut.  (SHORTCUT is assumed to
% be a struct with some or all of the fields 'label', 'callback',
% 'icon', 'category' and 'editable'.)
% 
% Examples:
% 
% AddShortcut('Tidy', 'close all hidden; clear all; clc;', ...
%    fullfile(IconDir, 'TTE_delete.gif'), 'Other shortcuts');
% 
% See also: RemoveShortcuts, AddBrowserFavourite,
% AddShortcutCategory
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/151033

% $Author: rcotton $	$Date: 2010/10/01 13:58:56 $	$Revision: 1.2 $
% Copyright: Health and Safety Laboratory 2010

shortcutUtils = GetShortcutUtils();

SetDefaultValue(2, 'callback', '');
SetDefaultValue(3, 'icon', 'Standard Icon');
SetDefaultValue(4, 'category', DefaultToolbarCategoryName());
SetDefaultValue(5, 'editable', 'true');
SetDefaultValue(5, 'overwrite', 'false');

if isstruct(label)
   callback = SafeGetField(label, 'callback', callback, false);
   icon = SafeGetField(label, 'icon', icon, false);
   category = SafeGetField(label, 'category', category, false);
   editable = SafeGetField(label, 'editable', editable, false);
   label = SafeGetField(label, 'label', '', false);  
end

if strcontains(label, GetShortcutNames(category))
   if overwrite
      warning('AddToolbarShortcut:ReplacingShortcut', ...
         'Replacing existing shortcut.');
      RemoveShortcuts(category, label);
   else
      error('AddToolbarShortcut:ShortcutExists', ...
         'A shortcut in this category with this label already exists.');
   end
end

if islogical(editable)
   if editable
      editable = 'true';
   else
      editable = 'false';
   end
end

shortcutUtils.addShortcutToBottom(label, callback, icon, ...
   category, editable);

end
