function [hpol,radlab_h] = polarLabels(theta,rho,line_style,labelrotate,rlabshift,clear)
% [hpol,radlab_h] = polarLabels(theta,rho,line_style,labelrotate,rlabshift,clear)
%
% polarLabels   Polar coordinate plot. (with added options)
%   polarLabels(THETA, RHO) makes a plot using polar coordinates of
%   the angle THETA, in radians, versus the radius RHO.
%   polarLabels(THETA,RHO,S) uses the linestyle specified in string S.
%   See PLOT for a description of legal linestyles.
%
%   See also PLOT, LOGLOG, SEMILOGX, SEMILOGY.
%
% Additions
%   Plot is labelled +/-180 instead of 0-360
%   Additional input options
%       labelrotate     value (in degrees) to add to angle labels to facilitate rotation of LABEL
%                       def = 0
%       rlabshift       value to add to radial labels to facilitate impression of negative values
%                       def = 0
%       clear           make polar background clear
%                       def = false (0)
%
% Ex. polarlabels([0:360]*pi/180,abs(sin([0:360]*pi/180))*10,'b',-90,-10)
%
%   Additional output option
%       [hpol,radlab_h] = polarLabels(theta,rho,line_style,labelrotate,rlabshift,clear)
%       radlab_h           vector of handles to radial text labels
%
%       Backward compatible with standard POLAR
%       For multiple plots (hold on) should only need to be used with the first one

%   Revised by BFGK 26-mars-2002
%    For better access to labels
%   Revised by BFGK 27-mai-2002
%    Fix to work with full 360 plot
%   Revised by BFGK 22-mai-2003
%    Added "clear" option for special background application
%    Tidied up nargin section

if nargin < 1
    error('Requires at least 2 input arguments.')
elseif nargin == 2 
    if isstr(rho)
        line_style = rho;
        rho = theta;
        [mr,nr] = size(rho);
        if mr == 1
            theta = 1:nr;
        else
            th = (1:mr)';
            theta = th(:,ones(1,nr));
        end
    else
        line_style = 'auto';
    end
elseif nargin == 1
    line_style = 'auto';
    rho = theta;
    [mr,nr] = size(rho);
    if mr == 1
        theta = 1:nr;
    else
        th = (1:mr)';
        theta = th(:,ones(1,nr));
    end
end

if ~isequal(size(theta),size(rho))
    error('THETA and RHO must be the same size.');
end

% Dealing with additional arguments
if nargin < 4,  labelrotate = 0 ;    end
if nargin < 5,  rlabshift = 0   ;    end
if nargin < 6,  clear = 0       ;    end

if isstr(theta) | isstr(rho) | isstr(labelrotate) | isstr(rlabshift)
    error('Input arguments must be numeric.');
end


% get hold state
cax = newplot;
next = lower(get(cax,'NextPlot'));
hold_state = ishold;

% get x-axis text color so grid is in same color
tc = get(cax,'xcolor');
ls = get(cax,'gridlinestyle');

% Hold on to current Text defaults, reset them to the
% Axes' font attributes so tick marks use them.
fAngle  = get(cax, 'DefaultTextFontAngle');
fName   = get(cax, 'DefaultTextFontName');
fSize   = get(cax, 'DefaultTextFontSize');
fWeight = get(cax, 'DefaultTextFontWeight');
fUnits  = get(cax, 'DefaultTextUnits');
set(cax, 'DefaultTextFontAngle',  get(cax, 'FontAngle'), ...
    'DefaultTextFontName',   get(cax, 'FontName'), ...
    'DefaultTextFontSize',   get(cax, 'FontSize'), ...
    'DefaultTextFontWeight', get(cax, 'FontWeight'), ...
    'DefaultTextUnits','data')

% only do grids if hold is off
if ~hold_state

% make a radial grid
    hold on;
    maxrho = max(abs(rho(:)));
    hhh=plot([-maxrho -maxrho maxrho maxrho],[-maxrho maxrho maxrho -maxrho]);
    set(gca,'dataaspectratio',[1 1 1],'plotboxaspectratiomode','auto')
    v = [get(cax,'xlim') get(cax,'ylim')];
    ticks = sum(get(cax,'ytick')>=0);
    delete(hhh);
% check radial limits and ticks
    rmin = 0; rmax = v(4); rticks = max(ticks-1,2);
    if rticks > 5   % see if we can reduce the number
        if rem(rticks,2) == 0
            rticks = rticks/2;
        elseif rem(rticks,3) == 0
            rticks = rticks/3;
        end
    end

% define a circle
    th = 0:pi/50:2*pi;
    xunit = cos(th);
    yunit = sin(th);
% now really force points on x/y axes to lie on them exactly
    inds = 1:(length(th)-1)/4:length(th);
    xunit(inds(2:2:4)) = zeros(2,1);
    yunit(inds(1:2:5)) = zeros(3,1);
% plot background if necessary
    if (~isstr(get(cax,'color')) & ~clear),
       patch('xdata',xunit*rmax,'ydata',yunit*rmax, ...
             'edgecolor',tc,'facecolor',get(gca,'color'),...
             'handlevisibility','off');
    end

% draw radial circles
    c82 = cos(82*pi/180);
    s82 = sin(82*pi/180);
    rinc = (rmax-rmin)/rticks;
    cnt = 1;
    for i=(rmin+rinc):rinc:rmax
        hhh = plot(xunit*i,yunit*i,ls,'color',tc,'linewidth',1,...
                   'handlevisibility','off');
        radlab_h(cnt) = text((i+rinc/20)*c82,(i+rinc/20)*s82, ...
            ['  ' num2str(i+rlabshift)],'verticalalignment','bottom',...
            'handlevisibility','off');
        cnt = cnt+1;
    end
    set(hhh,'linestyle','-') % Make outer circle solid

% plot spokes
    th = (1:6)*2*pi/12;
    cst = cos(th); snt = sin(th);
    cs = [-cst; cst];
    sn = [-snt; snt];
    plot(rmax*cs,rmax*sn,ls,'color',tc,'linewidth',1,...
         'handlevisibility','off')

% annotate spokes in degrees
    rt = 1.1*rmax;
    for i = 1:length(th)
        angTextNum = (i*30)+labelrotate    ;
        text(rt*cst(i),rt*snt(i),int2str(angTextNum),...
             'horizontalalignment','center',...
             'handlevisibility','off');
        if i == length(th)
            loc = int2str(0+labelrotate);
        else
            angTextNum = 180+(i*30)+labelrotate    ;
            if angTextNum > 180, angTextNum = angTextNum - 360; end
            loc = int2str(angTextNum);
        end
        text(-rt*cst(i),-rt*snt(i),loc,'horizontalalignment','center',...
             'handlevisibility','off')
    end

% set view to 2-D
    view(2);
% set axis limits
    axis(rmax*[-1 1 -1.15 1.15]);
end

% Reset defaults.
set(cax, 'DefaultTextFontAngle', fAngle , ...
    'DefaultTextFontName',   fName , ...
    'DefaultTextFontSize',   fSize, ...
    'DefaultTextFontWeight', fWeight, ...
    'DefaultTextUnits',fUnits );

% transform data to Cartesian coordinates.
xx = rho.*cos(theta);
yy = rho.*sin(theta);

% plot data on top of grid
if strcmp(line_style,'auto')
    q = plot(xx,yy);
else
    q = plot(xx,yy,line_style);
end
if nargout > 0
    hpol = q;
end
if ~hold_state
    set(gca,'dataaspectratio',[1 1 1]), axis off; set(cax,'NextPlot',next);
end
set(get(gca,'xlabel'),'visible','on')
set(get(gca,'ylabel'),'visible','on')


