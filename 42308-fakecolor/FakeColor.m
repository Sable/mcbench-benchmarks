function [h,hcb]=FakeColor(X,Y,Z,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function h=FakeColor(X,Y,Z,clims,nc,colmap,plotcb,cbpos)
%
% Work-around for multiple colormaps
%
% ex.:
%     h=FakeColor(time,depth,u)
%     h=FakeColor(time,depth,u,0.6*[-1 1],10,'jet','right')
%     h=FakeColor(time,depth,u,0.6*[-1 1],10,'cool','right')
%
% INPUTS:
% X,Y,Z : Data to contour
% (Optional):
% clims: 1 X 2 vector with color limits [min max]
% nc: # color levels to contour (default 10)
% colmap: Colormap to use (ie 'cool'), default jet
% plotcb: true to plot, false to not plot colorbar
% cbpos: String specifiying position (see the colorbar documentation for
% options)
% Based on code at
% http://figuredesign.blogspot.com/2012/05/multiple-colormaps-in-matlab.html
% , posted by Sally Warner.
% Idea/method credit goes to Nick Beaird and Noel Pelland @ UW for figuring out
% how to do this. I just made it into a (hopefully) easy to use function.%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% AP - UW/APL - 10 Sept 2012
% apickering (at) apl (dot) washington (dot) edu
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Updates:
% 17 Spet 2012 - Make axes width same as if regular colorbar was inserted
% 20 June 2013 - Return handle to colorbar as well as axes
% 27 July 2013 - modified by Marcel Thielmann
%                   -added support for any
%                    colorbar location and changed the colorbar location
%                    identifier so that it complies with MATLAB standards
%                   -added the possibility to provide an own colormap as
%                    input
%                   -removed the axis ij command (can be done outside the
%                    function if desired)
%
% -COMMENT (Marcel Thielmann, 27 July 2013):
% When commands such as axis square are used afterwards, colorbar
% width/height does not fit axis widht/height anymore. I have not managed
% to automatically resize the colorbar once this is done, but the following
% workaround served the purpose (the plotboxpos function can be found on
% the file exchange:
% http://www.mathworks.com/matlabcentral/fileexchange/9615-plotboxpos )
%
% [c,cb] = FakeColor(x,y,z,CLIM,nc,'jet',1,'NorthOutside');
% axis square
% labels
% xlabel(c,'xlabel')
% ylabel(c,'ylabel')
%
% CPOS = plotboxpos(c);
% CBPOS = get(cb,'Position');

% set(cb,'Position',[CPOS(1) CBPOS(2) CPOS(3) CBPOS(4)])


%~~~~~~~~~~~~~~~~~
%%

nvars=numel(varargin);

% defaults if not specified
if nvars==0
    clims=[nanmin(Z(:)) nanmax(Z(:)) ];
    nc=15;
    colmap='jet';
    plotcb=1;
    cbpos='EastOutside';
elseif nvars==1
    clims=varargin{1};
    nc=15;
    colmap='jet';
    plotcb=1;
    cbpos='EastOutside';
elseif nvars==2
    clims=varargin{1};
    nc=varargin{2};
    colmap='jet';
    plotcb=1;
    cbpos='EastOutside';
elseif nvars==3
    clims=varargin{1};
    nc=varargin{2};
    colmap=varargin{3};
    plotcb=1;
    cbpos='EastOutside';
elseif nvars==4
    clims=varargin{1};
    nc=varargin{2};
    colmap=varargin{3};
    plotcb=varargin{4};
    cbpos='EastOutside';
elseif nvars==5
    clims=varargin{1};
    nc=varargin{2};
    colmap=varargin{3};
    plotcb=varargin{4};
    cbpos=varargin{5};
end

cvec=linspace(clims(1),clims(2),nc);

% make a "colormap"
%==============================================
if ischar(colmap)              % one of matlabs own builtin colormap given as string
    tcmap=eval([colmap '(nc)']);
else                           % own colormap given as matrix
    tcmap = zeros(nc,3);
    cvec_all = linspace(clims(1),clims(2),size(colmap,1));
    for i = 1:3
        tcmap(:,i) = interp1(cvec_all,colmap(:,i),cvec);
    end
end

% mimick a pcolor plot using contourf
[~,conhand]=contourf(X,Y,Z,cvec,'linecolor','none');hold on % ,'linecolor','none'
%
%get the patch object handles:
p=get(conhand,'children');
thechild=get(p,'CData');
cdat=cell2mat(thechild);
%
%loop through and manually set facecolor of each patch to the colormap you  made:
for i=1:length(cvec)
    set(p(cdat==cvec(i)),'Facecolor',tcmap(i,:))
end
%
h=gca; % get handle of axes

if plotcb
    %now you need to make a fake colorbar using the same trick:
    %define the colorbar axes location just above the subplot you are working with:
    
    % Make axes width same as if a regular colorbar was added; this way if
    % other axes have regular colorbars, all plot axes will (hopefully) line up

    cb = colorbar(cbpos);
    
    % get position of axes and colorbar for later use
    pos= get(gca,'position');
    CBPOS = get(cb,'position');
    cbprop = get(cb);
    % get axis locations and tickmarks for later use
    CBXTICK = get(cb,'XTick');
    CBYTICK = get(cb,'YTick');
    CBXAXLOC = get(cb,'XAxisLocation');
    CBYAXLOC = get(cb,'YAxisLocation');
    
    colorbar('off')
    set(gca,'position',pos);
    
    
    %contourf your fake colorbar:
    hcb             = axes('Position',CBPOS);
    
    % depending on the location, create a vertical or horizontal colorbar
    if ~isempty(strfind(cbpos,'North')) || ~isempty(strfind(cbpos,'South'))
        [~,conhand]     = contourf(cvec',[0 1],[cvec; cvec],cvec,'linecolor','none');
    else
         [~,conhand]     = contourf([0 1],cvec,[cvec' cvec'],cvec,'linecolor','none');
    end
    
    p               = get(conhand,'children');
    thechild        = get(p,'CData');
    cdat            = cell2mat(thechild);
    
    % AGAIN, loop through and manually set facecolor of each patch 
    for i=1:length(cvec)
        set(p(cdat==cvec(i)),'Facecolor',tcmap(i,:))
    end
    set(hcb,'xtick',CBXTICK,'ytick',CBYTICK,'xaxislocation',CBXAXLOC,'yaxisLocation',CBYAXLOC)
        
else
    hcb = NaN;
end 



%%