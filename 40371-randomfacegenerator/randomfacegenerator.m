function randomfacegenerator;
% randomfacegenerator;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by Joseph Hollmann, February 2013
% This file may be copied, used, or modified for educational and research purposes provided 
% that this header information is not removed or altered. Other distribution is prohibited
% without permission. We assume no liability for use of the code and no obligation to provide 
% support, Nevertheless we would like to improve this package, and would be happy to receive comments
% Email - hollmann.j@husky.neu.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% As written, the function does not require any inputs
% generates a randomly created face and plots it. Nothing else

% face
dx = 0.01;
rx = .75+.1*(0.5-rand(1));
ry = 1+.1*(0.5-rand(1));
x = [-1:dx:1];
y1 = real(ry*sqrt(1-(x/rx).^2));
y2 = real(-ry*sqrt(1-(x/rx).^2));
z = find(y1 == 0);
[~,ctfnd] = max(diff(z));
ct = [1:z(ctfnd-1),z(ctfnd+1)+1:length(y1)];
y1(ct) = []; y2(ct) = []; x(ct) = [];

% smile
len = 0.5+.1*rand(1);
posy = -0.5;
amp = 0.1*(0.5-rand(1));
phs = round(rand(1)*4);
xsm = -len/2:dx:len/2;
ysm = posy+amp*cos(pi*xsm/xsm(end)+phs);

% nose
len = 0.3+0.1*rand(1);
wid = 0.3+0.1*rand(1);

xns = [-wid/3 -wid/2 0 wid/2 wid/3];
yns = [len/2 -len/4 -len/2 -len/4 len/2];

% eyes -- draw ovals
rxe = 0.1+0.1*(0.5-rand(1));
rye = 0.1+0.1*(0.5-rand(1));
xe = [-0.1:dx:0.1];
y1e = 0.3+real(rye*sqrt(1-(xe/rxe).^2));
y2e = 0.3+real(-rye*sqrt(1-(xe/rxe).^2));
xelft = -0.3+xe;
xert = 0.3+xe;
yce = 0.3;
xce = 0.3;

% hair
hrstrt = 0.25+0.75*rand(1);
hairind = find(y1 > hrstrt);

yhair = [y1(hairind);y1(hairind)+2*rand(1)];
xhair = [x(hairind);x(hairind)];

% % % %% ears
% % % rx = 0.1*rand(1);
% % % midx1 = x(1)-.1+.01*rand(1);
% % % midx2 = x(end)+.1+.01*rand(1);
% % % xer1 = midx1-rx:dx:midx1+rx;
% % % xer2 = midx2-rx:dx:midx2+rx;
% % % midy = 0.2*(0.5-rand(1));
% % % ry = 0.2*rand(1);
% % % 
% % % yer11 = real(ry*sqrt(1-(xer1/rx).^2));
% % % yer12 = real(ry*sqrt(1-(xer2/rx).^2));
% % % 
% % % yer21 = real(ry*sqrt(1-(xer1/rx).^2));
% % % yer22 = real(ry*sqrt(1-(xer2/rx).^2));


% define colors
p = [1 0.78 0.80];

hc = {'y','g','r','k'};
sk = {'k','y'};
e = {'b','g','k'};
et = {'*','o','.','x','+'};
lpp = 'r';

hcp = hc{randi(4,1)};
skp = sk{randi(2,1)};
ep = [e{randi(3,1)},et{randi(5,1)}];
% lpp = lp{randi(2,1)};


if strcmpi(get(gcf,'Name'),'Your New Face'),
    figure(gcf);
else,
%     figure;
    set(gcf,'name','Your New Face');
end;
plot(x,y1,skp,x,y2,skp,xsm,ysm,lpp,xns,yns,skp,xhair,yhair,hcp...
    ,xelft,y1e,skp,xelft,y2e,skp,xert,y1e,skp,xert,y2e,skp,-xce,yce,ep,xce,yce,ep,'linewidth',4)
axis tight
set(gca,'XTickLabel',[],'yticklabel',[],'xtick',0,'ytick',0)









