function pixels = makebitmap(y, width, height, ThreeDee)
% Copyright (c) 2009, The MathWorks, Inc.
%
% Creates a bitmap image of marix y
% Size of the bitmap is determined by arguments
% width and height, and more (2D or 3D visualization)
% by argument ThreeDee.

persistent bitmapHandle;

if ishandle(bitmapHandle)
    % if figure exists, use that for plotting
    figure(bitmapHandle);
    cla;
else
    % create figure if it doesn't exist
    bitmapHandle = figure('Visible', 'off');
    set(bitmapHandle, 'Color', [1 1 1]);
    set(bitmapHandle, 'PaperPositionMode', 'auto');
end;
set(bitmapHandle, 'Visible', 'off');

% Store figure location
a = get(bitmapHandle, 'Position');
a(3) = width;
a(4) = height;

if ThreeDee
    surf(y);
else
    plot(y);
end;

axis tight;
% Resize figure
set(bitmapHandle, 'Position', a);
pixels = hardcopy(bitmapHandle,'-dOpenGL','-r0');
% Size of the bitmap produced by hardcopy may be larger than that 
% specified by the figure width & height.
% Figure is transposed to get the correct bitmap orientation for .ToVector
for i = 3:-1:1, 
    pixs(:,:,i) = pixels(1:height,1:width,i)'; %#ok : not growing
end;
pixels = pixs(:); % In order to use .ToVector in C#
