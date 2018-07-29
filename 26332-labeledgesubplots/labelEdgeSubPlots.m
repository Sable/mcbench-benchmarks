function varargout=labelEdgeSubPlots(xl,yl,onlyBottom)
% labelEdgeSubPlots - label subplots only along edges
%
% function H=labelEdgeSubPlots(xl,yl,onlyBottom)    
%
% Purpose
% If all subplots have the same quantities on the x and y axes then
% there's no point labeling all of them. Often it looks neater to
% simply have y labels only on the plots along the left hand
% edge and x labels only on the plots along the bottom. This
% function does this automatically for the current figure. 
%
% Inputs
% xl - a string specifying what to label the x axes. 
% yl - a string specifying what to label the y axes. 
% onlyBottom - by default this is zero and the function adds an
%              x-axis to appropriate plots from the penultimate row
%              if the bottom row of plots is incomplete. set
%              onlyBottom to 1 to suppress this behaviour. 
%              * in addition: onlyBottom can be a vector of axis handles to
%                be processsed. 
% Outputs
% H - a structure containing handles to the x and y axis labels
%
% Example
% clf
% for i=1:5
% subplot(2,3,i)
% x=[0:10]; y=1+0.01*x.^3+randn(size(x))*0.2;
% plot(x,y,'ok'), xlabel('will be removed')
% end    
%    
% H=labelEdgeSubPlots('beer [pints]','faux pas'); 
% %or:    
% H=labelEdgeSubPlots('beer [pints]','faux pas',1);
% %One can also do:
% set(H.xlabels,'color','red','fontweight','bold')
%
% %proccess only some subplots
% ax=[];
% for i=1:25
% subplot(5,5,i), box on
% if mod(i,5)==1, ax=[gca,ax]; end
% end
% labelEdgeSubPlots('X','Y',ax);
% 
% Rob Campbell - January 2009    
    

if nargin<3, onlyBottom=0; end    
    

%Find the axes if none were provided
if length(onlyBottom)==1 
    c=get(gcf,'children');
else
    c=onlyBottom;
    onlyBottom=0;
end

    
c=c(strmatch('axes',get(c,'type')));

%Anything with a 'location' property is likely to be a Matlab-generated
%legend box or color bar. Delete these
for i=length(c):-1:1
    if isfield(get(c(i)),'Location')
        c(i)=[];
    end
end



%Remove any currently existing axis labels
pos=ones(length(c),4);
for i=1:length(c)
     pos(i,:)=get(c(i),'position');
     set(get(c(i),'xlabel'),'string','')
     set(get(c(i),'ylabel'),'string','')
end


%Add x labels
h.xlabels=[];
for ii=1:length(c)
    if pos(ii,2)==min(pos(:,2));
        h.xlabels=[h.xlabels,get(c(ii),'xlabel')];
        set(h.xlabels(end),'string',xl)
    end
end


%Add y labels
h.ylabels=[];
for ii=1:length(c)
    if pos(ii,1)==min(pos(:,1));
        h.ylabels=[h.ylabels,get(c(ii),'ylabel')];
        set(h.ylabels(end),'string',yl)
    end
end




%Only return labels if the user asked for this
if nargout==1, varargout{1}=h; end



%When using subplot, it is possible that the bottom row of plots
%won't be full. In this case it would be nice to insert x labels
%onto the penultimate row. This behaviour can be suppressed if
%onlyBottom==1

nTop    = length(find(pos(:,2)==max(pos(:,2))));
nBottom = length(find(pos(:,2)==min(pos(:,2))));

if nTop==nBottom | onlyBottom, return, end



%Make life easier and just remove handles to the plots we're not
%going to label.
pos(:,end+1)=c;
f=find(pos(:,2)==min(pos(:,2))); pos(f,:)=[];
f=find(pos(:,2)==min(pos(:,2))); pos=sortrows(pos(f,:),1);

pos(1:nBottom,:)=[]; 

for i=1:size(pos,1)
    h.xlabels=[h.xlabels,get(pos(i,end),'xlabel')];
    set(h.xlabels(end),'string',xl)
end


