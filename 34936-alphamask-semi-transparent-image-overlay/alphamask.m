function hOVM = alphamask(bwMask, colour, transparency, axHandle)
% ALPHAMASK:  Overlay image with semi-transparent mask
%
% Overlays a semi-transparent mask over an image.  By default the 
%   currently displayed figure is overlain.
% Options include overlay colour and opacity.
% Returns a handle to the overlay mask.
%
% Usage:
%   hOVM = alphamask(bwMask, [colour, transparency, axHandle])
%           bwMask: logical matrix representing mask
%           colour: vector of three rgb values in range [0, 1] (optional; default [0 0 1])
%     transparency: scalar in range [0, 1] representing overlay opacity (optional; default 0.6)
%         axHandle: handle to axes on which to operate (optional; default current axes)
%             hOVM: handle to overlay image is returned
%
% Example:
%   figure;
%   I = peaks(200);
%   bwMask = eye(200);
%   imshow(I, [], 'Colormap', hot);
%   alphamask(bwMask, [0 0 1], 0.5);
%
% See also IMSHOW, CREATEMASK

% v0.5 (Feb 2012) by Andrew Davis -- addavis@gmail.com

% Check arguments
if ~exist('bwMask', 'var') || ~ismatrix(bwMask), error('bwMask matrix is a required argument'); end;
if ~exist('colour', 'var'), colour = [0 0 1]; end;
if ~exist('transparency', 'var'), transparency = 0.6; end;
if ~exist('axHandle', 'var'), axHandle = gca; end;
if ~isvector(colour) || ~isscalar(transparency) || ~ishandle(axHandle), error('One or more arguments is not in the correct form'); end;
maskRange = max(max(bwMask))-min(min(bwMask));
if maskRange ~= 1 && maskRange ~= 0, error('bwMask must consist only of the values 0 and 1'); end;

% Create colour image and overlay it
rgbI = cat(3, colour(1)*ones(size(bwMask)), colour(2)*ones(size(bwMask)), colour(3)*ones(size(bwMask)));
hold on,
hOVM = imshow(rgbI, 'Parent', axHandle);
set(hOVM, 'AlphaData', bwMask*transparency);       % use mask values as alpha channel of overlay
hold off;
