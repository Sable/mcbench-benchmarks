function [i1_rect,i2_rect] = rect_pollefeys(F,i1,i2)

% function [i1_rect,i2_rect] = rect_pollefeys(i1,i2,F,P1,P2)
%
%	[i1_rect,i2_rect]=rect_pollefeys(i1,i2,F,P1,P2)
%
%
%Rectifies a pair of images related by fundamental F
%
%IN:
%	i1 - Matlab image
%	i2 - Matlab image
%	F - Fundamental matrix (p1'*F*p2=0). Assumes that image coordiantes
%		are 1..width where pixel centers are at integer locations.
%
%OUT:
%	fig - handle to the figure
[w,h,~] = size(i1);
line  = 0;

% C1 = null(P1);
% e2 = P2*C1;
e1 = null(F);
e2 = null(F');
e2 = e2/e2(3);
% C2 = null(P2);
% e1 = P1*C2;
e1 = e1/e1(3);
thetas = get_theta_bounds(e1,e2,F,[w,h]);
theta = thetas(1);
if 0,
    h0 = my_figure(gr1,gr2,F);
    ud = get(gcf, 'UserData');
end

while theta<thetas(2)
    line = line+1;
    l1 = l_from_theta_p(theta,e1);
    l2 = F_transfer_l(F',l1,e1);
    if 0,
        pts=get_line_points(l1,ud.sizes(1,:));
        axes(ud.ah(1));
        delete(ud.l1);
        delete(ud.l2);
        ud.l1=plot(pts(1,:), pts(2,:), [ud.color '-'], ...
            'LineWidth', ud.size, 'EraseMode','xor');
        pts=get_line_points(l2,ud.sizes(1,:));
        axes(ud.ah(2));
        ud.l2=plot(pts(1,:), pts(2,:), [ud.color '-'], ...
            'LineWidth', ud.size, 'EraseMode','xor');
    end
    [ps1{line},rr1(:,line)] = get_ps(l1,e1,[w,h]);
    [ps2{line},rr2(:,line)] = get_ps(l2,e2,[w,h]);
    dtheta(line) = min(1/rr1(1,line),1/rr2(1,line));
    theta = theta + dtheta(line);
end

%% project images onto new (r,theta) coordtinates
dim = nan(3,1);
dim(1) = size(ps1,2);
rr1_w = max(rr1(2,:))-min(rr1(1,:));
rr2_w = max(rr2(2,:))-min(rr2(1,:));
dim(2) = round(max(rr2_w,rr1_w));
dim(3) = 3;

i1_rect = im_project(i1,ps1,rr1,dim);
i2_rect = im_project(i2,ps2,rr2,dim);

function h0 = my_figure(i1,i2,F)

h0 = figure;
ah1 = axes('Parent', h0, 'Position',[0 0 .5 1]);
h1 = imshow(i1); hold on; title('Image 1');
set(h1, 'ButtonDownFcn','vgg_gui_F(''b1'');');

ah2 = axes('Parent',h0, ...
    'Position',[.5 0 .5 1], ...
    'Tag','Axes2');
h2=imshow(i2); hold on; title('Image 2');
set(h2, 'ButtonDownFcn','vgg_gui_F(''b2'');');

point=plot(-1000, -1000,'EraseMode','xor');
l1=plot([-1000, -1001], [-1000 -1000], 'r-','EraseMode','xor');
l2=plot([-1000, -1001], [-1000 -1000], 'r-','EraseMode','xor');

s1=size(i1); s2=size(i2);
t(:,:,1)=F';  t(:,:,2)=F;  F=t;

ud=struct('h0', h0, 'h',[h1 h2], 'ah', [ah1, ah2], ...
    'sizes', [s1(1:2); s2(1:2)], ...
    'color', 'k', 'size', 1, ...
    'F', F, 'l1', l1,'l2',l2 );

set(h0,'UserData',ud);

function pts=get_line_points(l,sz)
a=l(1); b=l(2);c=l(3);
h=sz(1); w=sz(2);

% This might cause 'divide by zero' warning:
ys=c/-b ;
yf=-(a*w+c)/b;
xs=c/-a;
xf=-(b*h+c)/a;

m1 = [[xs;1] [xf;h] [1;ys] [w;yf]];
w2 = [(xs<=w & xs>=1) (xf<=w & xf>=1) (ys<=h & ys>=1) (yf<=h & yf>=1)];
v = w2>0;
pts = [m1(:,v)];