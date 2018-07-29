function varargout=sigstar(groups,stats,nosort)

% SIGSTAR Add significance stars to bar charts, boxplots, line charts, etc,
%
% H = SIGSTAR(GROUPS,STATS,NSORT)
%
% Purpose
% Add stars and lines highlighting significant differences between pairs of groups. 
% The user specifies the groups and associated p-values. The function handles much of 
% the placement and drawing of the highlighting. Stars are drawn according to:
%   * represents p<=0.05
%  ** represents p<=1E-2
% *** represents p<=1E-3
%
%
% Inputs
% GROUPS - a cell array defining the pairs of groups to compare. Groups defined 
%          either as pairs of scalars indicating locations along the X axis or as 
%          strings corresponding to X-tick labels. Groups can be a mixture of both 
%          definition types.
% STATS -  a vector of p-values the same length as GROUPS. If empty or missing it's 
%          assumed to be a vector of 0.05s the same length as GROUPS. Nans are treated
%          as indicating non-significance.
% NSORT -  optional, 0 by default. If 1, then significance markers are plotted in 
%          the order found in GROUPS. If 0, then they're sorted by the length of the 
%          bar.
%
% Outputs
% H - optionally return handles for significance highlights. Each row is a different
%     highlight bar. The first column is the line. The second column is the text (stars).
%     
%
% Examples
% 1. 
% bar([5,2,1.5])
% sigstar({[1,2], [1,3]})
%
% 2. 
% bar([5,2,1.5])
% sigstar({[2,3],[1,2], [1,3]},[nan,0.05,0.05])
%
% 3. 
% R=randn(30,2);
% R(:,1)=R(:,1)+3;
% boxplot(R)
% set(gca,'XTick',1:2,'XTickLabel',{'A','B'})
% H=sigstar({{'A','B'}},0.01);
% ylim([-3,6.5])
% set(H,'color','r')
%
% 4. Note the difference in the order with which we define the groups in the 
%    following two cases. 
% x=[1,2,3,2,1];
% subplot(1,2,1)
% bar(x)
% sigstar({[1,2], [2,3], [4,5]})
% subplot(1,2,2)
% bar(x)
% sigstar({[2,3],[1,2], [4,5]})
%
% ALSO SEE: demo_sigstar
%
% KNOWN ISSUES:
% 1. Algorithm for identifying whether significance bar will overlap with 
%    existing plot elements may not work in some cases (see line 277)
% 2. Bars may not look good on exported graphics with small page sizes.
%    Simply increasing the width and height of the graph with the 
%    PaperPosition property of the current figure should fix things.
%
% Rob Campbell - CSHL 2013



%Input argument error checking

%If the user entered just one group pair and forgot to wrap it in a cell array 
%then we'll go easy on them and wrap it here rather then generate an error
if ~iscell(groups) & length(groups)==2
	groups={groups};
end

if nargin<2 
	stats=repmat(0.05,1,length(groups));
end
if isempty(stats)
	stats=repmat(0.05,1,length(groups));
end
if nargin<3
	nosort=0;
end




%Check the inputs are of the right sort
if ~iscell(groups)
	error('GROUPS must be a cell array')
end

if ~isvector(stats)
	error('STATS must be a vector')
end

if length(stats)~=length(groups)
	error('GROUPS and STATS must be the same length')
end






%Each member of the cell array GROUPS may be one of three things:
%1. A pair of indices.
%2. A pair of strings (in cell array) referring to X-Tick labels
%3. A cell array containing one index and one string
%
% For our function to run, we will need to convert all of these into pairs of
% indices. Here we loop through GROUPS and do this. 

xlocs=nan(length(groups),2); %matrix that will store the indices 
xtl=get(gca,'XTickLabel');  

for ii=1:length(groups)
	grp=groups{ii};

	if isnumeric(grp)
		xlocs(ii,:)=grp; %Just store the indices if they're the right format already

	elseif iscell(grp) %Handle string pairs or string/index pairs

		if isstr(grp{1})
			a=strmatch(grp{1},xtl);
		elseif isnumeric(grp{1})
			a=grp{1};
		end
		if isstr(grp{2})
			b=strmatch(grp{2},xtl);
		elseif isnumeric(grp{2})
			b=grp{2};
		end

		xlocs(ii,:)=[a,b];
	end

	%Ensure that the first column is always smaller number than the second
	xlocs(ii,:)=sort(xlocs(ii,:));

end

%If there are any NaNs we have messed up. 
if any(isnan(xlocs(:)))
	error('Some groups were not found')
end






%Optionally sort sig bars from shortest to longest so we plot the shorter ones first
%in the loop below. Usually this will result in the neatest plot. If we waned to 
%optimise the order the sig bars are plotted to produce the neatest plot, then this 
%is where we'd do it. Not really worth the effort, though, as few plots are complicated
%enough to need this and the user can define the order very easily at the command line. 
if ~nosort
	[~,ind]=sort(xlocs(:,2)-xlocs(:,1),'ascend');
	xlocs=xlocs(ind,:);groups=groups(ind);
	stats=stats(ind);
end



%-----------------------------------------------------
%Add the sig bar lines and asterisks 
holdstate=ishold;
hold on

H=ones(length(groups),2); %The handles will be stored here

y=ylim;
yd=range(y)*0.05; %separate sig bars vertically by 5% 

for ii=1:length(groups)
	thisY=findMinY(xlocs(ii,:))+yd;
	H(ii,:)=makeBar(xlocs(ii,:),thisY,stats(ii));
end
%-----------------------------------------------------




%Now we can add the little downward ticks on the ends of each line. We are
%being extra cautious and leaving this it to the end just in case the y limits
%of the graph have changed as we add the highlights. The ticks are set as a
%proportion of the y axis range and we want them all to be the same the same
%for all bars.
yd=range(ylim)*0.01; %Ticks are 1% of the y axis range
for ii=1:length(groups)
	y=get(H(ii,1),'YData');
	y(1)=y(1)-yd;
	y(4)=y(4)-yd;	
	set(H(ii,1),'YData',y)
end




%Be neat and return hold state to whatever it was before we started
if ~holdstate
	hold off
elseif holdstate
	hold on
end


%Optionally return the handles to the plotted significance bars (first column of H)
%and asterisks (second column of H).
if nargout>0
	varargout{1}=H;
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Internal functions


function H=makeBar(x,y,p)
%makeBar produces the bar and defines how many asterisks we get for a 
%given p-value


if p<=1E-3
	stars='***'; 
elseif p<=1E-2
	stars='**';
elseif p<=0.05
	stars='*';
elseif isnan(p)
	stars='n.s.';
else
	stars='';
end
		
x=repmat(x,2,1);
y=repmat(y,4,1);
H(1)=plot(x(:),y,'-k','LineWidth',1.5);

%Increase offset between line and text if we will print "n.s."
%instead of a star. 
if ~isnan(p)
    offset=0.005;
else
    offset=0.02;
end

H(2)=text(mean(x(:)),mean(y)+range(ylim)*offset,stars,...
   	'HorizontalAlignment','Center',...
   	'BackGroundColor','none');





function Y=findMinY(x)
%Find the minimum y value needed to clear all the plotted data present 
%over a given range of x values. This allows the significance bar to
%be plotted in the best location. 
%

%First look for patch objects (bars in a bar-chart, most likely)
p=findobj(gca,'Type','Patch');
xd=get(p,'XData');
if iscell(xd)
	xd=groupedBarFix(xd,'x');
end

xd(xd<x(1))=0;
xd(xd>x(2))=0;

overlapping=any(xd,1); %These x locations overlap

%Find the corresponding y values 
clear xd
yd=get(p,'YData');
if iscell(yd)
	yd=groupedBarFix(yd,'y');
end
yd=yd(:,overlapping);

%So we must have a value of at least Y in order to miss all the 
%plotted bar data:
Y=max(yd(:));



%Now let's check if any other plot elements (such as significance bars we've 
%already added) exist over this range of x values.
%
% NOTE! This code doesn't identify all cases where there is overlap. 
%For example, if you have a significance bar going from 3 to 7 along the x
%axis and you then try to add a new one from 4 to 5, then it won't see the 
%existing one as overlapping. However, I've yet to find this a problem in
%practice so I'll leave things be. Can easily be fixed if leads to bugs. 

p=findobj(gca,'Type','Line');
tmpY=nan(1,length(p));

for ii=1:length(p)
	xd=get(p(ii),'XData');


	xd(xd<x(1))=0;
	xd(xd>x(2))=0;

	overlapping=xd>0; %These x locations overlap

	if ~any(overlapping)
		continue
	end

	clear xd
	yd=get(p(ii),'YData');
	yd=yd(overlapping);
	tmpY(ii)=max(yd);

end

Y=max([Y,tmpY]);


%The patch coords of grouped error bars aren't a matrix but a cell array. This needs to be
%converted to a suitable matrix in order for the code to work. This function does that.  
function out=groupedBarFix(in,xy)
	out=ones([size(in{1}),length(in)]);
	for ii=1:length(in)
		out(:,:,ii)=in{ii};
	end

	switch xy
	case 'x'
		out=mean(out,3);
	case 'y'
		out=max(out,[],3);
	end

