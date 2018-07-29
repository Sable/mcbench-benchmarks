% -----------------------------------------------------------
% |Nagi Hatoum, Candlestick chart "ploter" function, 5/29/03 |
% |Edited and expanded by Jelle C.J. Veraa, 3/28/2009        |
% -----------------------------------------------------------
% 
% Important: date plotting subroutine needs 'tlabel' by Carlos Adrian 
%   Vargas Aguilera 
%   Available at the MATLAB Central File Exchange site, File ID: #19314  
%   http://www.mathworks.com/matlabcentral/fileexchange/19314
% 
% function cndlV2(O,H,L,C)
%          cndlV2(O,H,L,C,date)
%          cndlV2(O,H,L,C,date,colorUp,colorDown,colorLine)
%          cndlV2(OHLC)
%          cndlV2(OHLC,date)
%          cndlV2(OHLC,date,colorUp,colorDown,colorLine)
%
% To use colors without a date, put '0' as date
%     i.e. cndlV2(OHLC,0,'b','r','k');
%
% required inputs: column vectors of O(pen), H(igh), L(ow)
% and C(lose) prices of commodity. 
% Alternative: OHLC matrix of size [rowsx4] 
%
% optional inputs [default]: 
% - date: serial date number (make with 'datenum') [no dates, index#]
% - colorUp: Color for up candle                   ['w']
% - colorDown: Color for down candle               ['k']
% - colorLine: Color for lines                     ['k']
%
% Note: identical inputs as required for barChartPlot except for colors

function cndlV2(varargin)
% See if we have [OHLC] or seperate vectors and retrieve our 
% required variables (Feel free to make this code more pretty ;-)
isMat = size(varargin{1},2);
indexShift = 0;
useDate = 0;

if isMat == 4,
    O = varargin{1}(:,1);
    H = varargin{1}(:,2);
    L = varargin{1}(:,3);
    C = varargin{1}(:,4);
else
    O = varargin{1};
    H = varargin{2};
    L = varargin{3};
    C = varargin{4};
    indexShift = 3;
end
if nargin+isMat < 7,
    colorDown = 'k'; 
    colorUp = 'w'; 
    colorLine = 'k';
else
    colorUp = varargin{3+indexShift};
    colorDown = varargin{4+indexShift};
    colorLine = varargin{5+indexShift};
end
if nargin+isMat < 6,
    date = (1:length(O))';
else
    if varargin{2+indexShift} ~= 0
        date = varargin{2+indexShift};
        useDate = 1;
    else
        date = (1:length(O))';
    end
end

% w = Width of body, change multiplier to draw body thicker or thinner
% the 'min' ensures no errors on weekends ('time gap Fri. Mon.' > wanted
% spacing)
w=.3*min([(date(2)-date(1)) (date(3)-date(2))]);
%%%%%%%%%%%Find up and down days%%%%%%%%%%%%%%%%%%%
d=C-O;
l=length(d);
hold on
%%%%%%%%draw line from Low to High%%%%%%%%%%%%%%%%%
for i=1:l
   line([date(i) date(i)],[L(i) H(i)],'Color',colorLine)
end
%%%%%%%%%%draw white (or user defined) body (down day)%%%%%%%%%%%%%%%%%
n=find(d<0);
for i=1:length(n)
    x=[date(n(i))-w date(n(i))-w date(n(i))+w date(n(i))+w date(n(i))-w];
    y=[O(n(i)) C(n(i)) C(n(i)) O(n(i)) O(n(i))];
    fill(x,y,colorDown)
end
%%%%%%%%%%draw black (or user defined) body(up day)%%%%%%%%%%%%%%%%%%%
n=find(d>=0);
for i=1:length(n)
    x=[date(n(i))-w date(n(i))-w date(n(i))+w date(n(i))+w date(n(i))-w];
    y=[O(n(i)) C(n(i)) C(n(i)) O(n(i)) O(n(i))];
    fill(x,y,colorUp)
end

if (nargin+isMat > 5) && useDate, 
    tlabel('x');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold off