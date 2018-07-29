function [ places ] = subplace( R, varargin )
%SUBPLACE Computes 'Position' vectors for a center-aligned set of subplots 
%   of varying row lengths
%   
%   R = vector specifying the number of subplots in each row
%
%   subplace([3 2])       - computes returns a 5x4 vector with the positions 
%                           for subplots in the following arrangement:
%                          
%                            +--------------------------+
%                            |  +----+  +----+  +----+  |
%                            |  | 1  |  | 2  |  | 3  |  |
%                            |  +----+  +----+  +----+  |
%                            |      +----+  +----+      |
%                            |      | 4  |  | 5  |      |
%                            |      +----+  +----+      |
%                            +--------------------------+
%                         
%   subplace([3 2],1)     - returns a 1x4 vector with the position for 
%                           subplot #1
%
%   subplace([3 2],[1 2]) - returns a 2x4 array with the position vectors 
%                           for subplots #1 & #2 as row vectors
%
%   Example:  Place 8 similarly sized plots in the same window
%
%       t = 0:0.01:1;
%       x = cos(2*pi*[1:8]'*t);
%       for ii = 1:8
%           subplot('Position',subplace([3 3 2],ii));
%           plot(t,x(ii,:));
%       end
%



if isempty(varargin)
    c = 1:sum(R);
else
    c = varargin{1,1};
end

nH = length(R);
nW = max(R);

% Set three subplot panes in order to estimate spacing parameters
h  = figure;
hf = subplot(nH,nW,1);     af = get(hf,'Position');
hc = subplot(nH,nW,nW+2);  ac = get(hc,'Position');
hl = subplot(nH,nW,nH*nW); al = get(hl,'Position');
close(h)

W = af(3);                % Width of subplot
H = af(4);                % Height of subplot
Wm = 1 - (al(1) + al(3)); % Width of margins
Wax = af(1) - Wm;         % Width of first y-axis.  A fudge factor
Hm = al(2);               % Height of bottom margin
Wb = ac(1) - af(1) - W;   % Width between subplots
Hb = af(2) - ac(2) - H;   % Height between subplots

places = zeros(length(c),4);

for ii = 1:length(c)
    y = 1;              % y represents the row number of subplot c(ii)
    x = c(ii);          % x represents the row position in subplot c(ii)
    while (x - R(y))> 0
        x = x-R(y);
        y = y+1;
    end
    
    Wc = ((1 - 2*Wm - Wax) - R(y)*W - (R(y)-1)*Wb)/2; % Centering width
    
    y = nH + 1-y;       % Reorient y to count from the bottom up
    
    l = Wm + Wax + Wc + (x-1)*(W + Wb);
    b = Hm + (y-1)*(H + Hb);
    places(ii,:) = [l b W H];
end

end

