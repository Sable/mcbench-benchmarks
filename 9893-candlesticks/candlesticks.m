% Plot Candlesticks
%--------------------------------------------------------------------------
% The first 19 lines of code are a small test driver.
% You can delete or comment out this part when you are done validating the 
% function to your satisfaction.
%
% Bill Davidson, quellen@yahoo.com
% 13 Nov 2005

function []=candlesticks()
npoints=15;
x=rand(npoints,1)-0.5;
opens=50+cumsum(x);
highs=opens+rand(npoints,1);
lows=opens-rand(npoints,1);
closes=opens+(highs-lows).*(rand(npoints,1)-0.5);

plot_candlesticks(highs,lows,opens,closes);

%-------------------------------------------------------------------------
% Bill Davidson, quellen@yahoo.com
% 14 Jan 2005
%
function []=plot_candlesticks(highs,lows,opens,closes)
middle=0.5;
hwbody=middle/2;
hwshad=hwbody/10;
xbody=middle+[-hwbody hwbody hwbody -hwbody -hwbody];
xshad=middle+[-hwshad hwshad hwshad -hwshad -hwshad];
npoints=length(highs);
days=(1:npoints);
colors=closes<opens;colors=char(colors*'k'+(1-colors)*'w');
for i=1:npoints
    patch(days(i)+xshad,[lows(i),lows(i),highs(i),highs(i),lows(i)],'k');
    patch(days(i)+xbody,[opens(i),opens(i),closes(i),closes(i),opens(i)],colors(i));
end
