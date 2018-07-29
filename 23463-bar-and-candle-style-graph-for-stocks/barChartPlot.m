% ---------------------------------------------------------------
% |Jelle C.J. Veraa, Stock Bar chart plotter function, 3/28/2009 |
% |inspired by and some code from:                               |
% |Nagi Hatoum, Candlestick chart ploter (sic) function, 5/29/03 |
% ---------------------------------------------------------------
%
% Important: date plotting subroutine needs 'tlabel' by Carlos Adrian 
%   Vargas Aguilera 
%   Available at the MATLAB Central File Exchange site, File ID: #19314  
%   http://www.mathworks.com/matlabcentral/fileexchange/19314
%
% function barChartPlot(O,H,L,C)
%          barChartPlot(O,H,L,C,date)
%          barChartPlot(O,H,L,C,date,colorLine)
%          barChartPlot([O H L C])
%          barChartPlot([O H L C],date)
%          barChartPlot([O H L C],date,colorLine)
%
% To use colors without a date, put '0' as date
%     i.e. barChartPlot(OHLC,0,'g');
%
% Required inputs: column vectors of O(pen), H(igh), L(ow)
% and C(lose) prices of commodity. 
% Alternative: [rowsx4] OHLC matrix
%
% optional inputs [default]: 
% - date: serial date number (make with 'datenum') [no dates, index#]
% - colorLine: Color for lines                     ['k']
%
% Note: identical inputs as required for cndlV2 except for colors

function barChartPlot(varargin)
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
    colorLine = 'k';
else
    colorLine = varargin{3+indexShift};
end

if nargin+isMat < 6
    date = (1:length(O))';
else
    if varargin{2+indexShift} ~= 0
        date = varargin{2+indexShift};
        useDate = 1;
    else
        date = (1:length(O))';
    end
end

% Get the length of the data
l=length(O);
% Start plotting
hold on
% Draw line from Low to High%%%%%%%%%%%%%%%%%
for i=1:l
   line([date(i) date(i)], [L(i) H(i)],'Color',colorLine)
end

% w = Width of body, change multiplier to draw body thicker or thinner
% the 'min' ensures no errors on weekends ('time gap Fri. Mon.' > wanted
% spacing)
w=.4*min([(date(2)-date(1)) (date(3)-date(2))]);
% Draw open/close marks
 for i=1:l               
    xOpen=[date(i)-w date(i)];
    xClose=[date(i)+w date(i)];
    yOpen=[O(i) O(i)];
    yClose=[C(i) C(i)];
    line(xOpen,yOpen,'Color',colorLine);
    line(xClose,yClose,'Color',colorLine);
 end

%%%%%%%%%% if dates supplied, put them on the x axis%%%%%%%%%%
if (nargin+isMat > 5) && useDate, 
    tlabel('x');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold off