%scDraw : Draws a blank smith chart
%
%  SYNOPSIS:
%     When called without arguments, the function draws a standard smith chart.
%     Otherwise, one may want to draw only specific curves for r and/or x values.
%     For different calling syntaxes see under SYNTAX.
%
%     See also scRay, scMove, scConCirc, scMatchCirc : available for different tasks
%     
%     
%  SYNTAX:
%     [h] = scDraw(r, x, ChColor)
%           draws only the r and x lines required
%     [h] = scDraw
%           draws a standard smith chart
%
%     And one can suppress the secondary details like scales and labels by calling:
%     [h] = scDraw(0)
%           draws 'only' a standard smith chart without r and m scales etc.
%
%  INPUT ARGUMENTS:
%     r       : A vector consisting of the desired values of r 
%     x       : A vector consisting of the desired values of x
%     ChColor : Color of the smith chart
%     xL      : a vector of x values containing left termination points for r circles
%     xR      : a vector of x values containing right termination points for r circles
%     rL      : a vector of r values containing left termination points for x arcs
%     rR      : a vector of r values containing right termination points for r arcs
%
%  OUTPUT ARGUMENT:
%     h : figure handle. If no output argument is given, the handle is returned in
%         the workspace variable ans. 
%
%  EXAMPLES:
%     (1) scDraw;
%         will draw a blank smith chart
%
%     (2) h = scDraw;
%         will draw a blank smith chart and return the gigure handle h.
%
%     (3) scDraw(0);
%         will draw a blank smith chart without scales etc.
%
%     (4) scDraw([1 2 3 4 5],[.1 2 3 4]);
%         will draw only the r lines specified by [1 2 3 4 5] and x lines [.1 2 3 4]
%
%     Mohammad Ashfaq - (31-05-2000)
%     Mohammad Ashfaq - (13-04-2006) Modified (examples included)

function h = scDraw(r, x, ChColor, xR, xL, rR, rL)

FullMapWithLabels = 1;
if nargin==1
    FullMapWithLabels   = 0;
end
if nargin<=1
    % DEFINE STANDARD DEFAULT FOR r
    r= [0.00, 0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35, 0.40, 0.45, 0.50, 0.50, 0.55, 0.60, 0.65,...
            0.70, 0.75, 0.80, 0.85, 0.90, 0.95, 1.00, 1.10, 1.20, 1.30, 1.40, 1.50, 1.50, 1.60, 1.70,...
            1.80, 1.90, 2.00, 2.20, 2.40, 2.50, 2.60, 2.80, 3.00, 3.50, 4.00, 4.50, 5.00, 6.00, 7.00,...
            8.00, 9.00, 10.0, 15.0, 20.0, 50.0];
    xR=[   0,    1,    2,    1,    4,    1,    2,    1,    4,    1,    2,    5,     1,   4,    1,...
            2,    1,    4,    1,    2,    1,   10,    2,    4,    2,    4,    2,     5,   4,    2,...
            4,    2,   20,    2,    2,    5,    2,    2,   10,    5,   10,    5,    10,  10,   10,...
            10,   10,   20,   20,   50,   0];
    
    xL=[   0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     4,     0,   0,    0,...
            0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,     4,   0,    0,...
            0,    0,    0,    0,    0,    2,    0,    0,    0,    0,    0,     0,     0,   0,    0,...
            0,    0,    0,    0,    0,    0];
    rPrint = [0.1:0.1:1.0,1.5 2.0 3.0 4.0 5.0 10 20 50];
    
    % DEFINE STANDARD DEFAULT FOR x
    x=[0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35, 0.40, 0.45, 0.50,  0.50, 0.55, 0.60, 0.65, 0.70,...
            0.75, 0.80, 0.85, 0.90, 0.95, 1.00, 1.10, 1.20, 1.30, 1.40,  1.50, 1.50, 1.60, 1.70, 1.80,...
            1.90, 2.00, 2.20, 2.40, 2.50, 2.60, 2.80, 3.00, 3.20, 3.40,  3.50, 3.60, 3.80, 4.00, 4.50,...
            5.00, 6.00, 7.00, 8.00, 9.00, 10.0, 15.0, 20.0, 50.0];
    rR=  [1,    2,    1,    3,    1,    2,    1,    3,    1,    2,     5,    1,    3,    1,    2,...
            1,    3,    1,    2,    1,   10,    2,    3,    2,    3,     2,    5,    3,    2,    3,...
            2,   10,    2,    2,    5,    2,    2,   10,    2,    2,     5,    2,    2,   10,    5,...
            10,   10,   10,   10,   10,   20,   20,   50,   0];
    
    rL=  [0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     3,    0,     0,   0,    0,...
            0,    0,    0,    0,    0,    0,    0,    0,    0,    0,     0,    3,     0,   0,    0,...
            0,    0,    0,    0,    2,    0,    0,    0,    0,    0,     2,    0,     0,   0,    0,...
            0,    0,    0,    0,    0,    0,    0     0,    0];
    xPrint  = [0.1:0.1:1.0,1.5 2.0 3.0 4.0 5.0 10 20 50];
    ChColor = 'b';
end

if (nargin == 2)||(nargin ==3)
    rR = zeros(size(x));
    rL = zeros(size(x));
    xR = zeros(size(r));
    xL = zeros(size(r));
    rPrint = r;
    xPrint = x;
end
if nargin ==2 
    ChColor = 'b';
end

if isempty(get(gcf, 'name')) || nargin ==0
    h = gcf;
    set(gcf,'MenuBar','none','numbertitle','off','name','Smith Chart');
    set(gca,'position',[0.01 0.01 0.98 0.98]);
    scPresent = 0;
else
    scPresent = 1;
end


% DRAW r CIRCLES
scResCirc(r, ChColor, xR, xL);
axis equal;
axis off;


% DRAW x ARCS
scReacArc(x, 1, ChColor, rR, rL);
scReacArc(x, -1, ChColor, rR, rL);

if ~scPresent
    
    % DRAW THE OUTER CIRCLE AND THE X-AXIS
    plot([-1 1],[0 0], ChColor);
    plot(-1:.001:1, sqrt(1-(-1:.001:1).^2), ChColor);
    plot(-1:.001:1,-sqrt(1-(-1:.001:1).^2), ChColor);
    
    % PRINT r VALUES
    scPrnVal(rPrint, 'r');
    
    % PRINT x VALUES
    scPrnVal(xPrint, 'x');
    
    % DRAW THE ANGLE BOUNDARY
    scConCirc(1.01,'r');
    scConCirc(1.08,'r');
    scAngles(1.01, 1.08, 'r');
    
    % DRAW THE LENGTH BOUNDARY
    scConCirc(1.085,'m');
    scConCirc(1.16,'m');
    scLength(1.085, 1.16, 'm');
    
    if FullMapWithLabels
        scScales;
        scLabels;
    end
end

function scResCirc(r, LinCol, xR, xL)
% scResCirc: draws r circles in the smith chart
%
%  SYNOPSIS:
%     This fuction draws r circles which have their centers on the real axis and
%     the radius is always such that they pass through the point (1,0).
%     The function is called by scDraw to do so. 
%     
%  SYNTAX:
%     scResCirc(r, LinCol, xR, xL)
%
%  INPUT ARGUMENTS:
%     r      : a vector consisting of the desired values of r 
%     LinCol : desired color of the circle(s)
%     xR     : a vector containing right termination points for r circles
%     xL     : a vector containing left termination points for r circles
%
%  OUTPUT ARGUMENT:
%     none

% PLOT CIRCLES
for ii = 1:length(r)
    rc = r(ii);
    if xR(ii)~=0
        xc1 = xR(ii);
        [xco1, yco1] = scPOI(rc, xc1);
    else
        xco1 = 1;
    end
    
    if xL(ii)~=0
        [xco2, yco2] = scPOI(rc, xL(ii));
    else
        xco2 = 20;
    end
    if xco1 < xco2
        u      = linspace((rc-1)/(rc+1), xco1, 500);
        vplus  = sqrt((1/(1+rc))^2-(u-rc/(1+rc)).^2);
        vminus = (-sqrt((1/(1+rc))^2-(u-rc/(1+rc)).^2));
        plot(real(u),real(vplus),LinCol);
        hold on;
        plot(real(u),real(vminus),LinCol);
    end
    if xco2 ~= 20
        u      = linspace(xco2, xco1, 200);
        vplus  = sqrt((1/(1+rc))^2-(u-rc/(1+rc)).^2);
        vminus = (-sqrt((1/(1+rc))^2-(u-rc/(1+rc)).^2));
        plot(real(u),real(vplus),LinCol);
        hold on;
        plot(real(u),real(vminus),LinCol);
    end
end

function scReacArc(x,updown,LinCol,rR, rL)
%scReacArc: draws x arcs in the smith chart
%
%  SYNOPSIS:
%     This fuction draws x arcs which have their centers on the the line parallel
%     to the imaginary axis and passing through the point (1,0).
%
%     The function is called by scDraw to do so. 
%     
%  SYNTAX:
%     scReacArc(x, updown, LinCol, rR, rL)
%
%  INPUT ARGUMENTS:
%     x     : a vector consisting of the desired values of x
%     updown: draw arc in the upper(lower) half plane if positive(negative)
%     LinCol: desired color of the arc
%     rR    : a vector containing left termination points for x arcs
%     rL    : a vector containing right termination points for x arcs
%
%  OUTPUT ARGUMENT:
%     none

for jj=1:length(x)
    xc     = x(jj);
    if rR(jj)~=0
        rc1 = rR(jj);
        [xco1, yco1] = scPOI(rR(jj), xc);
    else
        xco1 = 1;
        yco1 = 0;
    end
    
    if rL(jj)~=0
        [xco2, yco2] = scPOI(rL(jj), xc);
    else
        xco2 = 20;
        yco2 = 0;
    end
    if xco1 < xco2 && xc~=0
        % FOR THE ARCS STARTING FROM THE OUTERMOST CIRCLE
        if xc <= 1
            % IF THE 9'O CLOCK POS. OF THE X ARC DOES NOT LIE WITHIN THE SMITH CHART
            uup = [];
            vup = [];
            udn = linspace((xc^2-1)/(xc^2+1), xco1, 500);
            vdn = sign(updown)*(1/xc-sqrt((1/xc)^2-(udn-1).^2));
            
        elseif (1/xc-sqrt((1/xc)^2-(1-1/xc-1).^2)) < yco1
            % IF THE 9'O CLOCK POS. OF THE X ARC  IS LOWER THAN POINT OF INTERSECTION
            uup = linspace(xco1,(xc^2-1)/(xc^2+1),100);
            vup = sign(updown)*(1/xc+sqrt(1/xc^2-(uup-1).^2));
            udn = [];
            vdn = [];
        else
            % IF THE 9'O CLOCK POS. OF THE X ARC  IS HIGHER THAN POINT OF INTERSECTION
            uup = linspace(1-1/xc,(xc^2-1)/(xc^2+1),100);
            vup = sign(updown)*(1/xc+sqrt(1/xc^2-(uup-1).^2));
            udn = linspace(1-1/xc,xco1,500);
            vdn = sign(updown)*(1/xc-sqrt((1/xc)^2-(udn-1).^2));
        end
    end
    if xco2~=20 && xc~=0
        if (1/xc-sqrt((1/xc)^2-(1-1/xc-1).^2)) > yco2
            uup = [];
            vup = [];
            udn = linspace(xco2, xco1, 500);
            vdn = sign(updown)*(1/xc-sqrt((1/xc)^2-(udn-1).^2));
        else
            % IF THE 9'O CLOCK POS. OF THE X ARC  IS LOWER THAN POINT OF INTERSECTION
            uup = linspace(1-1/xc,xco2,100);
            vup = sign(updown)*(1/xc+sqrt(1/xc^2-(uup-1).^2));
            udn = linspace(1-1/xc,xco1,500);
            vdn = sign(updown)*(1/xc-sqrt((1/xc)^2-(udn-1).^2));
        end
    end
    if xc~=0
        plot(real(uup),real(vup),LinCol);
        plot(real(udn),real(vdn),LinCol);
    end
end

function scPrnVal(vPrn, rORx)
%scPrnVal: Prints x and r values on the smith chart
%
%  SYNOPSIS:
%     This fuction prints x and r values on the smith chart.
%
%     THIS function is called internally from the function scDraw.
%     
%  SYNTAX:
%     scPrnVal(vPrn, rORx)
%
%  INPUT ARGUMENTS:
%     vPrn  : value to be printed
%     rORx  : whether an 'r' or an 'x' value is to be printed.
%
%  OUTPUT ARGUMENT:
%     none

if rORx == 'x'
    % PRINT x VALUES
    for jj = 1 : length(vPrn)
        xc   = vPrn(jj);
        [xco1, yco1] = scPOI(0, xc);
        [xco2, yco2] = scPOI(1, xc);
        
        if floor(xc)==xc && length(num2str(floor(xc)))>=2
            PrStr='%0.0f';
        else
            PrStr='%0.1f';
        end
        
        h = text (min(xco1), max(yco1), num2str(xc,PrStr));
        set(h,'color','r', 'rotation', 180*atan2(1-min(xco1), max(yco1)-abs(1/xc))/pi, 'fontsize', 4.5, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
        
        h = text (min(xco1), -max(yco1), num2str(xc, PrStr));
        set(h,'color','r', 'rotation', 180+180*atan2(-1+min(xco1), max(yco1)-abs(1/xc))/pi, 'fontsize', 4.5, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
        if xc <=1
            h = text (min(xco2), -max(yco2), num2str(xc, PrStr));
            set(h,'color','r', 'rotation', 180+180*atan2(-1+min(xco2), max(yco2-abs(1/xc)))/pi, 'fontsize', 4.5, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
            
            h = text (min(xco2), max(yco2), num2str(xc, PrStr));
            set(h,'color','r', 'rotation', 180*atan2(1-min(xco2), max(yco2)-abs(1/xc))/pi, 'fontsize', 4.5, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
        end
    end
elseif rORx == 'r'
    % PRINT r VALUES
    for jj = 1 : length(vPrn)
        rc   = vPrn(jj);
        xco1 = (rc-1)/(rc+1);
        yco1 = 0.01;
        [xco2, yco2] = scPOI(rc, 1);
        if floor(rc)==rc && length(num2str(floor(rc)))>=2
            PrStr='%0.0f';
        else
            PrStr='%0.1f';
        end
        h = text (xco1, yco1, num2str(rc,PrStr));
        set(h,'color','r','rotation',90,'fontsize',4.5,'HorizontalAlignment','left', 'VerticalAlignment', 'bottom');
        if rc <= 1
            h = text (xco2, yco2, num2str(rc,PrStr));
            set(h,'color','r','rotation',180*atan2(rc/(1+rc)-xco2, yco2)/pi, 'fontsize',4.5,'HorizontalAlignment','left', 'VerticalAlignment', 'bottom');
            h = text (xco2, -yco2, num2str(rc,PrStr));
            set(h,'color','r','rotation', 180+180*atan2(rc/(1+rc)-xco2, -yco2)/pi, 'fontsize',4.5,'HorizontalAlignment','left', 'VerticalAlignment', 'bottom');
        end
    end
else
    error('scPrnVal.m: The second argument must either be r or x');
end

function scAngles(inr, outr, color)
%scAngles: subdivides and shows angles on smith chart boundary
%
%  SYNOPSIS:
%     Marks angles on the outer periphery of the smith chart. The function is called
%     by scDraw to do so. May not produce desired results if called from the matlab
%     command prompt.
%
%     see also scDraw, scLength, sc
%     
%  SYNTAX:
%     scAngles(inr, outr, color)
%
%  INPUT ARGUMENTS:
%     inr   : radiur of the circle
%     outr  : radiur of the circle
%     color : desired color of the circle
%
%  OUTPUT ARGUMENT:
%     none

for ii=0:2:360
    if floor(ii/10) ~= ii/10
        plot([inr*cos(pi*ii/180), inr*1.015*cos(pi*ii/180)], [inr*sin(pi*ii/180), inr*1.015*sin(pi*ii/180)], 'k');
    else
        plot([inr*cos(pi*ii/180), inr*1.025*cos(pi*ii/180)], [inr*sin(pi*ii/180), inr*1.025*sin(pi*ii/180)], color);
        if ii~=360
            degstr = [num2str(ii),'°'];
            h = text(inr*1.04*cos(pi*(ii)/180), inr*1.04*sin(pi*(ii)/180), degstr);
            set(h,'HorizontalAlignment','center','color',color,'rotation',270+ii+2.5,'fontsize',6);
        end
    end
end

function scLength(inr, outr, color)
%scLength: draw length marks on the outer boundary of the smith chart
%
%  SYNOPSIS:
%     Marks angles on the outer periphery of the smith chart
%     
%  SYNTAX:
%     scLength(inr, outr, color)
%
%  INPUT ARGUMENTS:
%     inr   : radiur of the circle
%     outr  : radiur of the circle
%     color : desired color of the circle
%
%  OUTPUT ARGUMENT:
%     none

VecLen = 0:.002:0.5;
for ii= 1:length(VecLen)
    if floor((ii-1)/5) ~= (ii-1)/5,
        plot([inr*cos(pi*(180-100*VecLen(ii)*7.2)/180), 1.015*inr*cos(pi*(180 - 100*VecLen(ii)*7.2)/180)], [inr*sin(pi*(180 - 100*VecLen(ii)*7.2)/180), 1.015*inr*sin(pi*(180 - 100*VecLen(ii)*7.2)/180)], color);
    else
        plot([inr*cos(pi*(180 - 100*VecLen(ii)*7.2)/180), 1.025*inr*cos(pi*(180 - 100*VecLen(ii)*7.2)/180)], [inr*sin(pi*(180 - 100*VecLen(ii)*7.2)/180), 1.025*inr*sin(pi*(180 - 100*VecLen(ii)*7.2)/180)], 'k');
        if VecLen(ii)~=0.5
            h = text(inr*1.04*cos(pi*((180 - 100*VecLen(ii)*7.2))/180), inr*1.04*sin(pi*(180 - 100*VecLen(ii)*7.2)/180), num2str(VecLen(ii),'%0.2f'));
            set(h,'color',color,'rotation',90+3.6-100*VecLen(ii)*7.2,'fontsize',6,'HorizontalAlignment','center');
        end
    end
end

function scScales
%scScales: draws the reflection factor and m scales on the smith chart
%
%  SYNOPSIS:
%     This function draws the reflection factor and m scales on the smith chart
%     The function is called by scDraw to do so. 
%     
%  SYNTAX:
%     scScales
%
%  INPUT ARGUMENTS:
%     none
%
%  OUTPUT ARGUMENT:
%     none


% DRAW BASE LINES
hold on;
yB = 1.50;
xB = 0.05;

plot(xB+[0 1], (yB+0.00)*[1 1], 'r');
plot(xB+[0 1], (yB+0.01)*[1 1], 'r');

% DRAW r DIVISIONS  AND PLACE r TEXT LABELS
for jj = 0:10
    plot(xB+[jj,jj]/10, [yB+0.01, yB+.04],'r');
    if jj ~=10
        plot(xB+[jj+.5,jj+.5]/10,[yB+0.01, yB+0.03],'r');
    end
    h = text(xB+jj/10, yB+0.05,num2str((10-jj)/10,'%1.1f'));
    set(h,'rotation',90,'fontsize',5,'fontname','Times New Roman');
end

% PUT CAPTION TEXT ETC. FOR REFLECTION FACTOR
h = text(xB+0.5, yB+0.18, 'Reflection Factor |r|');
set (h, 'fontname','Times New Roman','fontsize', 8,'fontname','Times New Roman','HorizontalAlignment','center');
h = text(xB+0.15, yB+0.18, '<');
set (h, 'color','b');
plot(xB+[0.15 0.25], (yB+0.18)*[1 1]);


% DRAW REFLECTED POWER DIVISIONS  AND PLACE TEXT LABELS
PVal = [1:-0.1:0.2, 0.1:-0.02:0.02, 0.01 0.0];
for jj = 1: length(PVal)
    plot(xB+[1-sqrt(PVal(jj)), 1-sqrt(PVal(jj))], [yB, yB-0.03], 'r');
    if jj ~=length(PVal)
        plot(xB+[1-sqrt((PVal(jj)+PVal(jj+1))/2), 1-sqrt((PVal(jj)+PVal(jj+1))/2)], [yB, yB-.02], 'r');
    end
    if PVal(jj)>0 && PVal(jj)<0.1
        PrStr = '%1.2f';
    else
        PrStr = '%1.1f';
    end
    h = text(xB+1-sqrt(PVal(jj)), yB-0.04,num2str(PVal(jj),'%1.2f'));
    set(h,'rotation',90,'HorizontalAlignment','right','fontname','Times New Roman','fontsize',5);
end


% PUT CAPTION TEXT ETC. FOR REFLECTED POWER
h = text(xB+0.5, yB-0.19, 'Reflected Power');
set (h, 'fontname','Times New Roman','fontsize', 8,'fontname','Times New Roman','HorizontalAlignment','center');
h = text(xB+0.15, yB-0.19, '<');
set (h, 'color','b');
plot(xB+[0.15 0.25], (yB-0.19)*[1 1]);


% ESTABLISH AND DRAW SCALES FOR m
mValMain = 0:0.1:1;
rUpMain  = abs((mValMain-1)./(mValMain+1));
mValSub  = 0.05:0.1:0.95;
rUpSub   = abs((mValSub-1)./(mValSub+1));

mdBMain  = [0:2:10 15 20 30 40];
rDoMain  = abs((10.^(-mdBMain/20)-1)./(1+10.^(-mdBMain/20)));
mdBSub   = [1 3 5 7 9 11 12 13 14 16 17 18 19 22 24 26 28];
rDoSub   = abs((10.^(-mdBSub/20)-1)./(1+10.^(-mdBSub/20)));

plot(-xB-[0 1], (yB+0.00)*[1 1], 'r');
plot(-xB-[0 1], (yB+0.01)*[1 1], 'r');


% DRAW m DIVISIONS  AND PLACE m TEXT LABELS
for jj = 1:length(mValMain)
    plot(-xB-[rUpMain(jj),rUpMain(jj)], [yB+0.01, yB+.04],'r');
    h = text(-xB-rUpMain(jj), yB+0.05,num2str(mValMain(jj),'%1.1f'));
    set(h,'rotation',90,'fontsize',5,'fontname','Times New Roman');
end
for jj = 1:length(mValSub)
    plot(-xB-[rUpSub(jj),rUpSub(jj)], [yB+0.01, yB+.03],'r');
end

% PUT CAPTION TEXT ETC. FOR REFLECTION FACTOR
h = text(-xB-0.5, yB+0.18, 'm = |u_{min}/u_{max}|');
set (h, 'fontname','Times New Roman','fontsize', 8,'fontname','Times New Roman','HorizontalAlignment','center');
h = text(-xB-0.145, yB+0.18, '<');
set (h, 'color','b','rotation',180);
plot(-xB-[0.15 0.25], (yB+0.18)*[1 1]);



% DRAW mdB DIVISIONS  AND PLACE mdB TEXT LABELS
for jj = 1:length(mdBMain)
    plot(-xB-[rDoMain(jj),rDoMain(jj)], [yB, yB-.03],'r');
    h = text(-xB-rDoMain(jj), yB-0.04, num2str(mdBMain(jj), '%.0f'));
    set(h,'rotation',90,'fontsize',5,'fontname','Times New Roman','HorizontalAlignment','right');
end
plot(-xB-[1,1], [yB, yB-.03],'r');
h = text(-xB-1, yB-0.04, '\infty');
set(h,'rotation',90,'fontsize',5,'HorizontalAlignment','right');


for jj = 1:length(mdBSub)
    plot(-xB-[rDoSub(jj),rDoSub(jj)], [yB, yB-.02],'r');
end

% PUT CAPTION TEXT ETC. FOR mdB
h = text(-xB-0.5, yB-0.19, 'm in db');
set (h, 'fontname','Times New Roman','fontsize', 8,'fontname','Times New Roman','HorizontalAlignment','center');
h = text(-xB-0.75, yB-0.19, '<');
set (h, 'color','b');
plot(-xB-[0.65 0.75], (yB-0.19)*[1 1]);

function scLabels
%scLabels: Draws different standard labels on smith chart
%
%  SYNOPSIS:
%     This function draws different standard labels on smith chart. This function is
%     called by scDraw to to so. If called from the matlab commant prompt, it may not
%     produce the desired results.
%
%     
%  SYNTAX:
%     scLabels
%
%  INPUT ARGUMENTS:
%     none
%
%  OUTPUT ARGUMENT:
%     none

% LABEL FOR INNER SCALE
r  = 1.25;
th = (145:-.1:140)*pi/180;
plot (r*cos(th), r*sin(th),'k');
h = text(r*cos(th(1)), r*sin(th(1)), '<');
set(h,'rotation',(th(1)-pi/2)*180/pi,'VerticalAlignment','middle');

PStr = 'arg(r) Inner Scale';
th = (linspace(140,120,length(PStr)))*pi/180;
for jj = 1: length(PStr)
    h = text(r*cos(th(jj)), r*sin(th(jj)), PStr(jj));
    set(h,'rotation',(th(jj)-pi/2)*180/pi, 'fontsize',9, 'fontname','Times New Roman');
end

% LABEL FOR OUTER SCALE
r  = 1.35;
th = (125:-.1:120)*pi/180;
plot (r*cos(th), r*sin(th),'k');
h = text(r*cos(th(length(th))), r*sin(th(length(th))), '<');
set(h,'rotation',(th(length(th))+pi/2)*180/pi,'VerticalAlignment','middle');

th = [146 145 144]*pi/180;
h = text(r*cos(th(1)), r*sin(th(1)), 'l');
set(h,'rotation',(th(1)-pi/2)*180/pi, 'fontsize',9, 'fontname','mt extra');
h = text(r*cos(th(2)), r*sin(th(2)), '/');
set(h,'rotation',(th(2)-pi/2)*180/pi, 'fontsize',9, 'fontname','Times New Roman');
h = text(r*cos(th(3)), r*sin(th(3)), '\lambda');
set(h,'rotation',(th(3)-pi/2)*180/pi, 'fontsize',9);


PStr = 'Outer scale';
th = (linspace(142,126,length(PStr)))*pi/180;
for jj = 1: length(PStr)
    h = text(r*cos(th(jj)), r*sin(th(jj)), PStr(jj));
    set(h,'rotation',(th(jj)-pi/2)*180/pi, 'fontsize',9, 'fontname','Times New Roman');
end


% PRINT ZL =   AT THE BOTTOM RIGHT CORNER

h = text (1.0, -1, 'Z_L =      \Omega');
set(h, 'fontname', 'Times New Roman', 'fontsize', 14,'HorizontalAlignment', 'right');


% DRAW THE TRANSMISSION LINE SYMBOL AT THE BOTTOM LEFT CORNER

% TL OUTLINE
Lx = -1.00;
Rx = -0.75;
Ty = -0.95;
By = -1.05;
plot([Lx Rx],[Ty Ty], 'r');
plot([Lx Rx],[By By], 'r');

% CONNECTION POINTS
Cx = 0.03;
h=plot([Rx-Cx Rx-Cx Lx Lx],[Ty By Ty By], '.');
set(h,'linewidth',1.5);


% CONNECTIVE LINES
Cy = 0.02;
plot([Rx Rx],[Ty Ty-Cy], 'r');
plot([Rx Rx],[By By+Cy], 'r');

% IMPEDANCE HORIZONTAL LINES
Ix = 0.01;
plot([Rx-Ix Rx+Ix], [By+Cy By+Cy] , 'b');
plot([Rx-Ix Rx+Ix], [Ty-Cy Ty-Cy] , 'b');

% IMPEDANCE VERTICAL LINES
plot([Rx-Ix Rx-Ix], [Ty-Cy By+Cy] , 'b');
plot([Rx+Ix Rx+Ix], [Ty-Cy By+Cy] , 'b');

% LABEL R+jX
h = text (Lx,(Ty+By)/2,'R + jX');
set (h, 'fontname', 'Times New Roman', 'fontsize', 5);

% LABEL l and lines etc.
h = text ((Rx+Lx-Cx)/2, By -0.05,'l');
set (h, 'fontname', 'mt extra', 'fontsize', 5, 'HorizontalAlignment', 'center');
plot([Lx    (Rx+Lx-Cx)/2-0.01],[By-0.05 By-0.05], 'k');
plot([Rx-Cx (Rx+Lx-Cx)/2+0.01],[By-0.05 By-0.05], 'k');
plot([Lx    Lx   ], [By-0.04 By-0.06],'k');
plot([Rx-Cx Rx-Cx], [By-0.04 By-0.06],'k');