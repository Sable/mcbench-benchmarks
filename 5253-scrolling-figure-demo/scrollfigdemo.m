function scrollfigdemo

% Created by Evan Brooks, evan.brooks@wpafb.af.mil
%
% Adaptation of scrollplotdemo by Steven Lord:
% -> Created by Steven Lord, slord@mathworks.com
% -> Uploaded to MATLAB Central
% -> http://www.mathworks.com/matlabcentral
% -> 7 May 2002
% ->
% -> Permission is granted to adapt this code for your own use.
% -> However, if it is reposted this message must be intact.
%

% create new figure window
f = figure;
set(f,'doublebuffer', 'on', 'resize', 'off')

% set columns of plots
cols = 2;

% create 5 data sets to plot
x=0:1e-2:2*pi;
y{1}=sin(x);
y{2}=cos(x);
y{3}=tan(x);
y{4}=x.^2;
y{5}=x.^3;

% determine required rows of plots
rows = ceil(length(y)/cols);

% increase figure width for additional axes
fpos = get(gcf, 'position');
scrnsz = get(0, 'screensize');
fwidth = min([fpos(3)*cols, scrnsz(3)-20]);
fheight = fwidth/cols*.75; % maintain aspect ratio
set(gcf, 'position', [10 fpos(2) fwidth fheight])

% setup all axes
buf = .15/cols; % buffer between axes & between left edge of figure and axes
awidth = (1-buf*cols-.08/cols)/cols; % width of all axes
aidx = 1;
rowidx = 0;
while aidx <= length(y)
    for i = 0:cols-1
        if aidx+i <= length(y)
            start = buf + buf*i + awidth*i;
            apos{aidx+i} = [start 1-rowidx-.92 awidth .85];
            a{aidx+i} = axes('position', apos{aidx+i});
        end
    end
    rowidx = rowidx + 1; % increment row
    aidx = aidx + cols;  % increment index of axes
end

% make plots
axes(a{1}), plot(x,y{1}), title('sine'), xlabel('x'), ylabel('sin(x)')
axes(a{2}), plot(x,y{2}), title('cosine'), xlabel('x'), ylabel('cos(x)')
axes(a{3}), plot(x,y{3}), title('tangent'), xlabel('x'), ylabel('tan(x)')
axes(a{4}), plot(x,y{4}), title('x^2'), xlabel('x'), ylabel('x^2')
axes(a{5}), plot(x,y{5}), title('x^3'), xlabel('x'), ylabel('x^3')

% determine the position of the scrollbar & its limits
swidth = max([.03/cols, 16/scrnsz(3)]);
ypos = [1-swidth 0 swidth 1];
ymax = 0;
ymin = -1*(rows-1);

% build the callback that will be executed on scrolling
clbk = '';
for i = 1:length(a)
    line = ['set(',num2str(a{i},'%.13f'),',''position'',[', ...
            num2str(apos{i}(1)),' ',num2str(apos{i}(2)),'-get(gcbo,''value'') ', num2str(apos{i}(3)), ...
            ' ', num2str(apos{i}(4)),'])'];
    if i ~= length(a)
        line = [line,','];
    end
    clbk = [clbk,line];
end

% create the slider
uicontrol('style','slider', ...
    'units','normalized','position',ypos, ...
    'callback',clbk,'min',ymin,'max',ymax,'value',0);
