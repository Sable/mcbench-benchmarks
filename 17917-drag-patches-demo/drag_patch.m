function drag_patch
%DRAG_PATCH  Demo to show how to create patches that can be moved around
%
% Example:
%     drag_patch;  % runs the code
%
% Author: Joseph Kirk
% Email: jdkirk630@gmail.com
% Release: 1.0
% Release Date: 12/6/07

figure('WindowButtonMotionFcn',@figButtonMotion);
ax = axes;

np = 25; % number of patches to create
p = zeros(1,np); % patch handles
x = cell(1,np); % shape x-values
y = cell(1,np); % shape y-values
% Create the Patches
for k = 1:np
    sides = ceil(5*rand); % number sides on shape
    if sides < 3
        sides = 50;
    end
    psi = 2*pi*(rand + (0:sides-1)/sides);
    x{k} = cos(psi); % shape XData
    y{k} = sin(psi); % shape YData
    clr = sqrt(rand(1,3)); % shape Color
    p(k) = patch(x{k}+5*randn,y{k}+5*randn,clr);
    set(p(k),'UserData',k,'ButtonDownFcn',{@patchButtonDown,p(k)});
end
axis equal
title('Click on the Patches to Move Them Around!')
patch_clicked = 0;
this_p = p(1);
this_k = 1;

% Function for Identifying Clicked Patch
    function patchButtonDown(this,varargin)
        this_p = this;
        this_k = get(this,'UserData');
        patch_clicked = ~patch_clicked;
    end

% Function for Moving Selected Patch
    function figButtonMotion(varargin)
        if patch_clicked
            % Get the Mouse Location
            curr_pt = get(ax,'CurrentPoint');
            % Change the Position of the Patch
            set(this_p,'XData',x{this_k}+curr_pt(1,1),'YData',y{this_k}+curr_pt(1,2));
        end
    end
end

