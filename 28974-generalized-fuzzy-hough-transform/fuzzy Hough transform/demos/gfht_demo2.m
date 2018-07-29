% 'gfht_demo2.m'
%
% This is a medical application of the generalized fuzzy Hough transform 
% for the autiomatic identification of Regions Of Interest (ROIs) in 
% Cardiac Magnetic Resonance Images (CMRIs).
%
% Copyright (c) 2010 by Pau Micó

close all; clear; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Source load
%
srcs = [{'SA06'}; ...
        {'HLA02'}; ...
        {'VLA05'}];                                                         % sources located in './data/images'
msgbox({'Select the CMR source for the pattern definition'; ...
    ' '; ...
    '1.- CMRI short axis view'; ...
    '2.- CMRI horizontal long axis view'; ...
    '3.- CMRI vertical long axis view'}, ...
    'Source load', 'help', 'modal');
index = input('source (number) = ');

I = imread([srcs{index} '.bmp']);
I = adapthisteq(I, 'NumTiles',[3 3], 'ClipLimit',0.015, ...
      'Distribution','uniform', 'Range','full');                            % histogram equalization
click(I, 'Source');
disp('Click ''enter'' to continue...'), pause;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pattern definition
%
thr = [0 (mean(I(:))-double(min(I(:))))/double(max(I(:)))];
E = edge(I, 'canny', thr, 1.5);
E = cedge(E, 8);                                                            % delete unimportant edges
click(E, 'Binarized');
disp('Click ''enter'' to continue...'), pause;

msgbox({'Select points to define the pattern and right click to create the mask.'; ...
    'The mask should be a closed shape.'; ...
    'To close the shape raight-click on the first defined point'}, ...
    'Pattern definition (R-table)', 'help', 'modal');
[BW, x, y] = roipoly(E);
msgbox({'Define ''x0'' and ''y0'' from the figure'; ...
    'Please click on ''data cursor'' to get the center coordinates)'; ...
    'Finally input ''x0'' and ''y0'' in the shell.'}, ...
    'Pattern definition (R-table)', 'help', 'modal');
x0 = input('x0 = ');
y0 = input('y0 = ');
patt = round([x-x0 y-y0]);
patt(end,:) = [];
click(E, 'Defined pattern'); hold on;
plot(x, y, 'x-r', 'LineWidth',2); hold off;
disp('Click ''enter'' to continue...'), pause;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gfht input parametres
%
rhorange = 0.9:0.1:1.2;
thetarange = -pi/40:pi/60:pi/40;
ewidth = 5;

% ================ algorithms
for i=1:length(srcs)
    disp(['source: CMRI ' num2str(i) ' of ' num2str(length(srcs)) '(' srcs{i} ')']);
    [pratio, scl, rot, x0, y0] = gfht(srcs{i}, patt, rhorange, thetarange, ewidth);
    ratio(i) = pratio;
end
figure; plot(ratio, 'o-b');
title('Matching values for the pattern vs each source')
xlabel(['Max ratio = ' num2str(max(ratio))]);
