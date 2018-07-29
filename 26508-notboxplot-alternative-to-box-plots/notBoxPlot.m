function varargout=notBoxPlot(y,x,jitter,style)
% notBoxPlot - Doesn't plot box plots!
%
% function notBoxPlot(y,x,jitter,style)
%
%
% Purpose
% An alternative to a box plot, where the focus is on showing raw
% data. Plots columns of y as different groups located at points
% along the x axis defined by the optional vector x. Points are
% layed over a 1.96 SEM (95% confidence interval) in red and a 1 SD
% in blue. The user has the option of plotting the SEM and SD as a
% line rather than area. Raw data are jittered along x for clarity. This
% function is suited to displaying data which are normally distributed.
% Since, for instance, the SEM is meaningless if the data are bimodally
% distributed. 
%
%
% Inputs
% y - each column of y is one variable/group. If x is missing or empty
%     then each column is plotted in a different x position. 
%
% x - optional, x axis points at which y columns should be
%     plotted. This allows more than one set of y values to appear
%     at one x location. Such instances are coloured differently. 
% Note that if x and y are both vectors of the same length this function
% behaves like boxplot (see Example 5).
%
% jitter - how much to jitter the data for visualization
%          (optional). The width of the boxes are automatically
%          scaled to the jitter magnitude.
%
% style - a string defining plot style of the data.
%        'patch' [default] - plots SEM and SD as a box using patch
%                objects. 
%        'line' - create a plot where the SD and SEM are
%                constructed from lines. 
%        'sdline' - a hybrid of the above, in which only the SD is 
%                replaced with a line.
%
%
% Outputs
% H - structure of handles for plot objects.
%
%
% Example 1 - simple example
% clf 
% subplot(2,1,1)  
% notBoxPlot(randn(20,5));
% subplot(2,1,2)
% h=notBoxPlot(randn(10,40));
% d=[h.data];
% set(d(1:4:end),'markerfacecolor',[0.4,1,0.4],'color',[0,0.4,0])
%  
% Example 2 - overlaying with areas
% clf  
% x=[1,2,3,4,5,5];
% y=randn(20,length(x));
% y(:,end)=y(:,end)+3;
% y(:,end-1)=y(:,end-1)-1;
% notBoxPlot(y,x);
%
% Example 3 - lines
% clf
% H=notBoxPlot(randn(20,5),[],[],'line');
% set([H.data],'markersize',10)
%
% Example 4 - mix lines and areas [note that the way this function
% sets the x axis limits can cause problems when combining plots
% this way]
%
% clf
% h=notBoxPlot(randn(10,1)+4,5,[],'line');
% set(h.data,'color','m')  
% h=notBoxPlot(randn(50,10));
% set(h(5).data,'color','m')
%  
% Example 5 - x and y are vectors
% clf
% x=[1,1,1,3,2,1,3,3,3,2,2,3,3];
% y=[7,8,6,1,5,7,2,1,3,4,5,2,4];
% notBoxPlot(y,x);
% 
% Note: an alternative to the style used in Example 5 is to call
% notBoxPlot from a loop in an external function. In this case, the
% user will have to take care of the x-ticks and axis limits. 
%    
% Example 6 - replacing the SD with bars
% clf
% y=randn(50,1);
% clf
% notBoxPlot(y,1,[],'sdline')
% notBoxPlot(y,2)   
% xlim([0,3])
%
%
% Rob Campbell - January 2010
%
% also see: boxplot


    
    
% Check input arguments
error(nargchk(0,4,nargin))
if nargin==0
    help(mfilename)
    return
end


if isvector(y), y=y(:); end

if nargin<2 || isempty(x)
    x=1:size(y,2);
end

if nargin<3 || isempty(jitter)
    jitter=0.3; %larger value means greater amplitude jitter
end

if nargin<4
  style='patch'; %Can also be 'line' or 'sdline'
end
style=lower(style);

if jitter==0 && strcmp(style,'patch') 
    warning('A zero value for jitter means no patch object visible')
end


if isvector(y) & isvector(x) & length(x)>1
    x=x(:);
   
    if length(x)~=length(y)
        error('length(x) should equal length(y)')
    end
    
    u=unique(x);
    for ii=1:length(u)
        f=find(x==u(ii));
        h(ii)=notBoxPlot(y(f),u(ii),jitter,style);
    end


    %Make plot look pretty
    if length(u)>1
        xlim([min(u)-1,max(u)+1])
        set(gca,'XTick',u)
    end
    
    if nargout==1
        varargout{1}=h;
    end

    return
    
end



 
if length(x) ~= size(y,2)
    error('length of x doesn''t match the number of columns in y')
end



    
    


%We're going to render points with the same x value in different
%colors so we loop through all unique x values and do the plotting
%with nested functions. No clf in order to give the user more
%flexibility in combining plot elements.
hold on
[uX,a,b]=unique(x);

h=[];
for ii=1:length(uX)
    f=find(b==ii);
    h=[h,myPlotter(x(f),y(:,f))];
end

hold off

%Tidy up plot: make it look pretty 
if length(x)>1
    set(gca,'XTick',unique(x))
    xlim([min(x)-1,max(x)+1])
end


if nargout==1
    varargout{1}=h;
end



%Nested functions follow


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h=myPlotter(X,Y)

SEM=SEM_calc(Y); %Supplied external function
SD=nanstd(Y);  %Requires the stats toolbox 
mu=nanmean(Y); %Requires the stats toolbox 

%The plot colors to use for multiple sets of points on the same x
%location
cols=hsv(length(X)+1)*0.5;
cols(1,:)=0;
jitScale=jitter*0.55; %To scale the patch by the width of the jitter

for k=1:length(X)
    thisY=Y(:,k);
    thisY=thisY(~isnan(thisY));    
    thisX=repmat(X(k),1,length(thisY));

    if strcmp(style,'patch') 
      h(k).sdPtch=patchMaker(SD(k),[0.6,0.6,1]);
    end
    
    if strcmp(style,'patch') || strcmp(style,'sdline')
      h(k).semPtch=patchMaker(SEM(k),[1,0.6,0.6]);
      h(k).mu=plot([X(k)-jitScale,X(k)+jitScale],[mu(k),mu(k)],'-r',...
           'linewidth',2);
    end
    
    %Plot jittered raw data
    C=cols(k,:);
    J=(rand(size(thisX))-0.5)*jitter;

        
    h(k).data=plot(thisX+J, thisY, 'o', 'color', C,...
                   'markerfacecolor', C+(1-C)*0.65);
end

if strcmp(style,'line') | strcmp(style,'sdline')
  for k=1:length(X)    
    %Plot SD
    h(k).sd=plot([X(k),X(k)],[mu(k)-SD(k),mu(k)+SD(k)],...
                 '-','color',[0.2,0.2,1],'linewidth',2);
    set(h(k).sd,'ZData',[1,1]*-1)
  end
end

if strcmp(style,'line')
    for k=1:length(X)     
        %Plot mean and SEM
        h(k).mu=plot(X(k),mu(k),'o','color','r',...
            'markerfacecolor','r',...
            'markersize',10);
        
        h(k).sem=plot([X(k),X(k)],[mu(k)-SEM(k),mu(k)+SEM(k)],'-r',...
            'linewidth',2);   
        h(k).xAxisLocation=x(k);  
    end
end




function ptch=patchMaker(thisInterval,color)
    l=mu(k)-thisInterval;
    u=mu(k)+thisInterval;
    ptch=patch([X(k)-jitScale, X(k)+jitScale, X(k)+jitScale, X(k)-jitScale],...
           [l,l,u,u], 0);
    set(ptch,'edgecolor','none','facecolor',color)
end %function patchMaker

    
    
end %function myPlotter






end %function notBoxPlot
