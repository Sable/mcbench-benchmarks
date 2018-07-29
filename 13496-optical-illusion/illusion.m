function illusion(rows, cols)
%ILLUSION Creates a famous optical illusion
% ILLUSION(ROWS, COLS) Allows user to specify illusion dimensions
%     (ROWS and COLS should be integers)
%
% Example:
%   illusion; %draws the illusion with 7 rows and 15 columns
%
% Example:
%   illusion(9,11); %draws the illusion with 9 rows and 11 columns
%
% Author: Joseph Kirk
% Email: jdkirk630 at gmail dot com
% Release: 1.3
% Release Date: 5/17/07

if nargin < 2
  rows = 7;
  cols = 15;
end
rows = max(3,ceil(abs(rows(1))));
cols = max(5,ceil(abs(cols(1))));

illusion = ones(rows,2*cols);
illusion(1:2:rows,3:4:2*cols) = 0;
illusion(:,2:4:2*cols) = 0;
illusion(2:2:rows,1:4:2*cols) = 0;

figure('Name','Optical Illusion','Numbertitle','off','Menubar','none');
axes('Units','normalized','Position',[.05 .05 .9 .85]);
imagesc(illusion);
colormap(gray); hold on
for r = 1/2:rows+1/2
  line([1/2 2*(cols+1)], [r r], 'color', 'b', 'linewidth', 2)
end
title(' Do the blue lines look parallel to you? ')
axis([1/2 2*cols+1/2 1/2 rows+1/2])
axis off; hold off
