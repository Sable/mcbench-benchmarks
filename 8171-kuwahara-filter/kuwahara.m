function [Y,Xpad] = kuwahara(X,WINSZ,progress)
% [Y,Xpad] = KUWAHARA(X[,WINSZ][,progress])
% perform kuwahara nonlinear edge-preserving filtering on an intensity
% image
%
% * If no window size WINSZ is specified, the default is 5.
% * Setting progress to a nonzero value causes KUWAHARA to display
%   the current row it is processing.
%
% Description:
% The Kuwahara filter works on a window divided into 4 overlapping
% subwindows (typically 5x5 pixels, see below). In each subwindow, the mean and
% variance are computed. The output value (located at the center of the
% window) is set to the mean of the subwindow with the smallest variance.
%
%    ( a  a  ab   b  b)
%    ( a  a  ab   b  b)
%    (ac ac abcd bd bd)
%    ( c  c  cd   d  d)
%    ( c  c  cd   d  d)
%
% Notes:
% Image is converted to double format for processing.
%
% References:
% http://www.incx.nec.co.jp/imap-vision/library/wouter/kuwahara.html
% 
% Copyright Art Barnes, 2005 artbarnes<at>ieee<dot>org

if nargin >= 3
    verboseFlag = true;
else
    verboseFlag = false;
end

if nargin < 2
    WINSZ = 5;
end

if ~isa(X,'double')
    X = im2double(X);
end

PADDING = floor(WINSZ/2);

Xpad = padarray(X,[PADDING PADDING],'replicate');
[padRows,padCols] = size(Xpad);
Y = zeros(size(X));

nRowIters = length((PADDING+1):(padRows-PADDING));
count = 1;
for i = (PADDING+1):(padRows-PADDING)
    for j = (PADDING+1):(padCols-PADDING)
        % window & subwindows
        W = Xpad((i-PADDING):(i+PADDING),(j-PADDING):(j+PADDING));
        Wnw = W(1:(PADDING+1),1:(PADDING+1));
        Wne = W(1:(PADDING+1),(PADDING+1):WINSZ);
        Wsw = W((PADDING+1):WINSZ,1:(PADDING+1));
        Wse = W((PADDING+1):WINSZ,(PADDING+1):WINSZ);

        % find the variances
        s = var([Wnw(:) Wne(:) Wsw(:) Wse(:)]);
        m = mean([Wnw(:) Wne(:) Wsw(:) Wse(:)]);
        [y,k] = min(s);
            
        % assign the mean of the subwindow with the least variance to 
        % the center pixel
        Y(i,j) = m(k);
    end
    
    if verboseFlag
        fprintf('Kuwahara: %d/%d\n',count,nRowIters);
        count = count + 1;
    end
end
