function ho=addmarkers(hi,n)
% ADDMARKERS    Add a pre-defined number of markers to a plot instead of
% one at each datapoint which is default in Matlab.
%
% Usage:
% ADDMARKERS(HI) adds 5 markers to the input handle HI, J=1..length(HI)
% ADDMARKERS(HI,N) adds N markers to the input handle HI, J=1..length(HI)
% HO=ADDMARKERS(...) returns the output handle HO for future usage such as
% changing colors, markers, etc.
%
% Hint: use the output handle when adding legends, e.g.
% LEGEND(HO,'legend 1',...,'legend N')
%
% The markers will be added in the following order:
%
% o     Circle
% s     Square
% d     Diamond
% x     Cross
% +     Plus sign
% *     Asterisk
% .     Point
% ^     Upward-pointing triangle
% v     Downward-pointing triangle
% >     Right-pointing triangle
% <     Left-pointing triangle
% p     Five-pointed star (pentagram)
% h     Six-pointed start (hexagram)
%
% By Matthijs Klomp at Saab Automobile AB, 2009-10-11
% E-mail: matthijs.klomp@gm.com
%
if nargin<2, n=5; end % default number of markers
if nargin<1, error('Supply an input handle as input argument.'), end
figure(get(get(hi(1),'parent'),'parent'))% plot in the figure of the handle
subplot(get(hi(1),'parent'))            % plot in the subplot of the handle
hold on                                 % do not overwrite the current plot
markers = {'o','s','d','^','v','x','+','*','.','>','<','p','h'};
ho = hi;                                % initialize output handle
for i = 1:length(hi)
    x = get(hi(i),'xdata');             % get the independent variable
    y = get(hi(i),'ydata');             % get the dependent variable data
    s = linspace(1,n,length(x));        % sampling independent variable
    sn = [1 (2:n-1)+randn(1,n-2)/n n];  % add some noise to avoid overlap
    xrs = interp1(s,x,sn,'nearest');    % downsample to n datapoints
    yrs = interp1(s,y,sn,'nearest');    % downsample to n datapoints
    plot(xrs,yrs,...                    % Plot the markers
        'Marker',markers{i},'LineStyle','None','Color',get(hi(i),'Color'));
    ho(i) = plot([0 1],[1 1]*NaN,...    % Create the output handle
        'Marker',markers{i},...
        'LineStyle',get(hi(i),'Linestyle'),...
        'Color',get(hi(i),'Color'));
end
if nargout==0, clear ho, end
