%% Description errorb(x,y,varargin)
% errorb(Y,E) plots Y and draws an error bar at each element of Y. The
% error bar is a distance of E(i) above and below the curve so that each
% bar is symmetric and 2*E(i) long.
% If Y and E are a matrices, errob groups the bars produced by the elements
% in each row and plots the error bars in their appropriate place above the
% bars.
% 
% errorb(X,Y,E) plots Y versus X with
% symmetric error bars 2*E(i) long. X, Y, E must
% be the same size. When they are vectors, each error bar is a distance of E(i) above
% and below the point defined by (X(i),Y(i)).
% 
% errorb(X,Y,'Parameter','Value',...) see below
% 
%% Optional Parameters
%    horizontal: will plot the error bars horizontally rather than vertically
%    top: plot only the top half of the error bars (or right half for horizontal)
%    barwidth: the width of the little hats on the bars (default scales with the data!)
%              barwidth is a scale factor not an absolute value.
%    linewidth: the width of the lines the bars are made of (default is 2)
%    points: will plot the points as well, in the same colors.
%    color: specify a particular color for all the bars to be (default is black, this can be anything like 'blue' or [.5 .5 .5])
%    multicolor: will plot all the bars a different color (thanks to my linespecer function)
%    fill: this will plot error bounds in shaded color.
%                colormap: in the case that multicolor is specified, one
%                           may also specify a particular colormap to
%                           choose the colors from.
%% Examples 
% y=rand(1,5)+1; e=rand(1,5)/4;
% hold off; bar(y,'facecolor',[.8 .8 .8]); hold on;
% errorb(y,e);
% 
% defining x and y
% x=linspace(0,2*pi,8); y=sin(x); e=rand(1,8)/4;
% hold off; plot(x,y,'k','linewidth',2); hold on;
% errorb(x,y,e) 
% 
% group plot:
% values=abs(randn(2,3))+2; errors=abs(randn(2,3)/1.5+.5)/2;
% errorb(values,errors);
% errorb(values,errors,'top');
% 
% % motivation for the function
% It is possible to plot nice error bars on top of a bar plot with Matlab's
% built in errorbar function by setting tons of different parameters to be
% various things.
% This function plots what I would consider to be nice error bars as the
% default, with no modifications necessary.
% It also plots, only the error bars, and in black. There are some very
% useful abilities that this function has over the matlab one, see below:
% 
%% Acknowledgments
% Thank you to the AP-Lab at Boston University for funding me while I
% developed these functions. Thank you to the AP-Lab, Avi and Eli for help
% with designing and testing them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Jonathan Lansey, last update Oct 2011,                                  %
%                   questions to Lansey at gmail.com                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function errorb(x,y,varargin)
%% first things first
%save the initial hold state of the figure.
hold_state = ishold;
if ~hold_state
    cla;
end

h=[];

%% If you are plotting errobars on Matlabs grouped bar plot
if size(x,1)>1 && size(x,2)>1 % if you need to do a group plot
% Plot bars
    num2Plot=size(x,2);
    e=y; y=x;
	handles.bars = bar(x, 'edgecolor','k', 'linewidth', 2);
	hold on
	for i = 1:num2Plot
		x =get(get(handles.bars(i),'children'), 'xdata');
		x = mean(x([1 3],:)); 
%       Now the recursive call!
		errorb(x,y(:,i), e(:,i),'barwidth',1/(num2Plot),varargin{:}); %errorb(x,y(:,i), e(:,i),'barwidth',1/(4*num2Plot),varargin{:});
    end
    if ~hold_state
        hold off;
    end
    return; % no need to see the rest of the function
else
    x=x(:)';
    y=y(:)';
    num2Plot=length(x);
end
%% Check if X and Y were passed or just X

if ~isempty(varargin)
    if ischar(varargin{1})
        justOneInputFlag=1;
        e=y; y=x; x=1:num2Plot;
    else
        justOneInputFlag=0;
        e=varargin{1}(:)';
    end
else % not text arguments, not even separate 'x' argument
    e=y; y=x; x=1:length(e);
    justOneInputFlag=0;
end

hold on; % axis is already cleared if hold was off
%% Check that your vectors are the proper length
if num2Plot~=length(e) || num2Plot~=length(y)
    error('your data must be vectors of all the same length')
end

%% Check that the errors are all positive
signCheck=min(0,min(e(:)));
if signCheck<0
    error('your error values must be greater than zero')
end

%% In case you don't specify color:
color2Plot = [ 0 0 0];
% set all the colors for each plot to be the same one ... hope you like black
for kk=1:num2Plot
    lineStyleOrder{kk}=color2Plot;
end

%% Initialize some things before accepting user parameters
horizontalFlag=0;
topFlag=0;
pointsFlag=0;
barFactor=1;
linewidth=2;
colormapper='jet';
multicolorFlag=0;
fillFlag=0;

%% User entered parameters
%  if there is just one input, then start at 1,
%  but if X and Y were passed then we need to start at 2
k = 1 + 1 - justOneInputFlag; %
% 
while k <= length(varargin) && ischar(varargin{k})
    switch (lower(varargin{k}))
      case 'horizontal'
        horizontalFlag=1;
        if justOneInputFlag % need to switch x and y now
            x=y; y=1:num2Plot; % e is the same
        end
      case 'color' %
        color2Plot = varargin{k + 1};
%       set all the colors for each plot to be the same one
        for kk=1:num2Plot
            lineStyleOrder{kk}=color2Plot;
        end
        k = k + 1;
      case 'linewidth'
        linewidth = varargin{k + 1};
        k = k + 1;
      case {'barwidth','width','thickness'} 
        barFactor = varargin{k + 1};
%         barWidthFlag=1;
        k = k + 1;
      case 'points'
        pointsFlag=1;
      case 'multicolor'
          multicolorFlag=1;
      case 'colormap' % used only if multicolor
        colormapper = varargin{k+1};
        k = k + 1;
      case 'top'
          topFlag=1;
        case 'fill'
            fillFlag=1;
      otherwise
        warning('Dude, you put in the wrong argument');
    end
    k = k + 1;
end


if ~fillFlag % plot errobars normally.

if multicolorFlag
    lineStyleOrder=linspecer(num2Plot,colormapper);
end

%% Set the bar's width if not set earlier
if num2Plot==1
%   defaultBarFactor=how much of the screen the default bar will take up if
%   there is only one number to work with.
    defaultBarFactor=20;
    p=axis;
    if horizontalFlag
        barWidth=barFactor*(p(4)-p(3))/defaultBarFactor;
    else
        barWidth=barFactor*(p(2)-p(1))/defaultBarFactor;
    end
else % is more than one datum
    if horizontalFlag
        barWidth=barFactor*(y(2)-y(1))/4;
    else
        barWidth=barFactor*(x(2)-x(1))/4;
    end
end

%% Plot the bars
for k=1:num2Plot
    if horizontalFlag
        ex=e(k);
        esy=barWidth/2;
%       the main line
        if ~topFlag || x(k)>=0  %also plot the bottom half.
            h(end+1) = plot([x(k)+ex x(k)],[y(k) y(k)],'color',lineStyleOrder{k},'linewidth',linewidth);
    %       the hat     
            h(end+1) = plot([x(k)+ex x(k)+ex],[y(k)+esy y(k)-esy],'color',lineStyleOrder{k},'linewidth',linewidth);
        end
        if ~topFlag || x(k)<0  %also plot the bottom half.
            h(end+1) = plot([x(k) x(k)-ex],[y(k) y(k)],'color',lineStyleOrder{k},'linewidth',linewidth);
            h(end+1) = plot([x(k)-ex x(k)-ex],[y(k)+esy y(k)-esy],'color',lineStyleOrder{k},'linewidth',linewidth);
            %rest?
        end
    else %plot then vertically
        ey=e(k);
        esx=barWidth/2;
%         the main line
        if ~topFlag || y(k)>=0 %also plot the bottom half.
            h(end+1) = plot([x(k) x(k)],[y(k)+ey y(k)],'color',lineStyleOrder{k},'linewidth',linewidth);
    %       the hat
            h(end+1) = plot([x(k)+esx x(k)-esx],[y(k)+ey y(k)+ey],'color',lineStyleOrder{k},'linewidth',linewidth);
        end
        if ~topFlag || y(k)<0 %also plot the bottom half.
            h(end+1) = plot([x(k) x(k)],[y(k) y(k)-ey],'color',lineStyleOrder{k},'linewidth',linewidth);
            h(end+1) = plot([x(k)+esx x(k)-esx],[y(k)-ey y(k)-ey],'color',lineStyleOrder{k},'linewidth',linewidth);
        end
    end
end
%
%% plot the points, very simple

if pointsFlag
    for k=1:num2Plot
        h(end+1) = plot(x(k),y(k),'o','markersize',8,'color',lineStyleOrder{k},'MarkerFaceColor',lineStyleOrder{k});
    end
end

else % plot error bars by filling them in.
    
%     Plot the mean:
    plot(x,y,'linewidth',2,'color',color2Plot);
%     Make the polygon:

    xPoly = [x  fliplr(x) x(1)];
    yPoly = [y+e fliplr(y-e) y(1)+e(1)];
    
    h(end+1) = plot(xPoly,yPoly,'color',color2Plot)
    hReg = fill(xPoly,yPoly,color2Plot); % draw region
    set(get(get(hReg,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Exclude line from legend
    
end % fillFlag check over

for hLoop = 1:length(h)
    set(get(get(h(hLoop),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); 
end


drawnow;
% return the hold state of the figure
if ~hold_state
    hold off;
end

end

%%

function lineStyleOrder=linspecer(N,varargin)

% default colormap
colormap hot; A=colormap;

%% interperet varagin
if ~isempty(varargin)>0
    colormap (varargin{1}); A=colormap;
end      
      
%%      

if N<=0
    lineStyleOrder={};
    return;
end

values=round(linspace(1,50,N));
for n=1:N
    lineStyleOrder(n) = {A(values(n),:)};
end


end