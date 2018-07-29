function colors = getColorChoices
%getColorChoices Returns a structure containing several high-contrast colors.
%   COLORS = getColorChoices returns a structure containing several colors
%   defined as RGB triplets.

%   Copyright 2005 The MathWorks, Inc.
%   $Revision $  $Date: 2005/05/27 14:07:15 $

% First color in the list will be the default.
temp = {'Medium Blue',   [ 72  72 248]/255
        'Light Blue',    [ 72 136 248]/255
        'Light Red',     [248  79  79]/255
        'Green',         [ 72 248  72]/255
        'Yellow',        [248 246  74]/255
        'Magenta',       [248  72 248]/255
        'Cyan',          [ 72 248 248]/255
        'Light Gray',    [232 232 232]/255
        'Black',         [  0   0   0]/255};

colors = struct('Label', temp(:,1), 'Color', temp(:,2));
