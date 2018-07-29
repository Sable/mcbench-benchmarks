function h=ShadePlotForEmpahsis( x,colors,alphas)
% ShadePlotForEmpahsis
% Plots a shaded bar for emphasis as commonly seen on cconomic charts
%
% INPUTS:
%  x     where the bar is placed.   If you want a bar from x=4:8 then
%        use [4 8].  If you want x=[4:8,10:20] then use {4:8,10:20}
% colors Use 'y' to make all bars yellow.  Use {'y','g','r'} for
%        yellow, green and red bars.
% alphas Use 0.5 if you want all bars to be translucent.  Use {0,.5,1}
%        for transparent, translucet and opaque bars.
%
% USAGE:
% % DEFINE DATA
% P=[ ...
% 98 98 94 91 84 83 82 87 88 89 91 91 90 89 89 90 91 91 87 86 87 84 79 80 ...
% 85 86 86 85 93 93 93 93 97 97 95 93 93 94 95 96 96 92 89 90 91 91 91 92 ...
% 93 95 99 98 99 97 95 95 94 90 92 93 93 95 94 95 93 92 92 92 91 90 89 89 ...
% 90 89 90 89 88 84 84 83 84 85 85 84 82 82 82 79 80 79 80 78 78 81 83 82 ...
% 81 79 77 77 78 77 78 79 79 81 81 81 78 78 78 78 77 78 79 79 79 79 81 85 ...
% 86 86 86 87 85 84 85 86 88 88 90 88 88 87 86 86 85 87 87 87 86 85 84 83 ...
% 82 81 81 82 81 80 82 81 79 80 81 80 80 79 85 85 82 83 84 85 86 87 86 86 ...
% 85 85 85 83 79 81 83 83 84 82 80 80 80 80 84 81 80 76 71 70 70 69 69 68 ...
% 67 68 68 68 67 68 68 70 70 72 72 71 69 68 68 68 67 68 67 66 67 67 67 66 ...
% 65 66 65 62 60 60 59 59 59 59 65 66 63 65 68 68 68 68 69 73 74 71 71 69 ...
% 71 72 72 76 76 74 77 80 82 80 78 80 80 80 80 81 80 79 77];
% T=today-length(P)+1:today;
% Y={today-[13 74],today-[142 172]};
% G={today-[30 51]};
%
% % PLOT THE DATA
% plot(T,P);
% datetick;
% line(get(gca,'Xlim'),[80 80])
% line(get(gca,'Xlim'),[68 68])%
% title({'ShadePlotForEmphasis','(P<80 yellow, P<68 green)'});
%
% % DRAW SOME YELLOW BARS
% ShadePlotForEmpahsis(Y,'y',0.5);
%
% % DRAW A GREEN BAR
% ShadePlotForEmpahsis(G,'g',0.5);
%
%
% | ##  _#__/
% | ##  / #
% | ## / #
% | /#\_/  #
% |/ ##   #
% |__##_____#_____
%
% IT'S NOT FANCY BUT IT WORKS

% Michael Robbins
% robbins@bloomberg.net
% michael.robbins@us.cibc.com

if nargin<1
   x={[today-50 today-30],[today-20 today-10]};
end;
if nargin<2 colors='y'; end;
if nargin<2 alphas=.5; end;

if ~iscell( x)  x={ x}; end;
if ~iscell(colors) colors={colors}; end;
if ~iscell(alphas) alphas={alphas}; end;

if length(colors)>length( x) colors=colors(1:length( x)); end;
if length(colors)<length( x) t=colors{1}; colors=[]; for i=1:length( x) colors{i}=t; end; end;

if length(alphas)>length( x) alphas=alphas(1:length( x)); end;
if length(alphas)<length( x) t=alphas{1}; alphas=[]; for i=1:length( x) alphas{i}=t; end; end;

for i=1:length( x)
  h(i)=patch([repmat( x{i}(1),1,2) repmat( x{i}(2),1,2)], ...
    [get(gca,'YLim') fliplr(get(gca,'YLim'))], ...
    [0 0 0 0],colors{i});
    set(h(i),'FaceAlpha',alphas{i});
end;
