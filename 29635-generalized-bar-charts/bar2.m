function bar2(varargin)
%BAR2 Generalized Bar graph (Stacked, Groups, Clustered, Floating, Mixed)
%   BAR2(X,Y) draws the columns of the M-by-N-by-Q matrix Y as N main
%   categories with (M/2) subcategories (as default, see below) and Q
%   simultaneous data sets with same X coordinates displayed on the
%   same graph
%
%   For MIXED charts, use input as a cell with each row containing the
%   information for each type of chart, see example below
%
%   BAR2(Y) uses the default value of X=1:N.
%
%   BAR2(X,Y,'SPACING',SPACING) specifies the spacing parameters [w s]
%   with w=width of bar and s=spacing between bars within a subcategory.
%
%   BAR2(...,'BASE',VAL) interprets Y to be M subcategories starting
%   from VAL.  VAL must be a single numeric value.
%   Note: The default is (M/2) subcategories with [low high]
%   given for each one
%
%   BAR2(...,'XLABEL',XLABEL) labels the X-axis categories
%
%   BAR2(...,'STACKED') plots a stacked chart, with possibility of
%   subcategories.
%
%
%   X must be a vector of length N (if given)
%   Y must be a matrix of length M-by-N-by-Q, with
%      Columns : Main Categories
%      Rows    : Alternating [low high] for each subcategory within a
%                group, or if 'base' is set then the height from zero.
%      3rd Dim : (optional) Multiple vertical bars within each subcategory
%
%   Uses NaN to ignore any plot within the subcategories.
%
%
%   EXAMPLES:
%
%   SIMPLE BAR CHART
%   data=rand(1,4);
%   bar2(data)
%
%   BAR CHART with spaced data and labels:
%   data=rand(1,4);
%   bar2([1 2 7 8],data,'BASE','XLABEL',{'A','B','C','D'})
%
%   FLOATING BAR CHART:
%   data=rand(2,4);  
%   bar2([1 2 7 8],data,'XLABEL',{'A','B','C','D'})
%
%   BAR CHART WITH LOG AXIS AND USER SPECIFIED BASE:
%   data=rand(1,4);
%   bar2([1 2 7 8],data,'BASE',1e-3,'XLABEL',{'A','B','C','D'});
%   set(gca,'Yscale', 'log'), grid on;
%
%   CLUSTERED BAR CHART:
%   data=rand(3,4);
%   bar2([1 2 7 8],data,'BASE','XLABEL',{'A','B','C','D'})
%
%   FLOATING CLUSTERED BAR CHART:
%   data=rand(6,4);   %Six rows representing three vertical [low high]
%   bar2(data)
%   legend({'A','B','C'},'Location','BestOutside')
%
%   FLOATING CLUSTERED BAR CHART: (with NaNs)
%   data=rand(6,4); data([3,4],[2 3])=NaN;
%   bar2(data)
%   legend({'A','B','C'},'Location','BestOutside')
%
%   STACKED BAR CHART:
%   data=rand(1,4,3);  %Note: One row for one vertical column per category
%   bar2(data,'STACKED')
%
%   STACKED CLUSTERED BAR CHART:
%   data=rand(2,4,3);  %Two clusters, both stacked
%   bar2([1 2 5 6],data,'STACKED','XLABEL',{2001,2002,2005,2006})
%   legend({'A','B','C','D','E','F'},'Location','BestOutside')
%
%   Multiple data sets on same X-coordinate:
%   data=rand(6,4,2);
%   data(:,:,2)=data(:,:,2)+max(data(:)); %for illustration
%   bar2(data,'XLABEL',{'A','B','C','D'})
%
%   MIXED CHARTS
%   (Bar chart + Clustered Bar Chart + Stacked Bar Chart + Floating)
%   alldata{1}={[1 2 6 10],rand(1,4),'BASE','XLABEL',{'B1','B2','B3','B4'}};
%   alldata{2}={[3 7 8 12],rand(3,4),'BASE','XLABEL',{'CB1','CB2','CB3','CB4'}};
%   alldata{3}={[4 5 11 13],rand(1,4,3),'STACKED','XLABEL',{'S1','S2','S3','S4'}};
%   alldata{4}={9,rand(2,1),'XLABEL',{'FLOAT'}};
%   bar2(alldata)
%   legend({'Bar','CB_1','CB_2','CB_3','V_1','V_2','V_3','Float'},'Location','BestOutside')
%
%

%   Mike Sheppard
%   Last Modified: 14-Dec-2010



%Parse inputs
S = parsevar(varargin);


%Using X and Y data points construct Xc and Yc in the right format that is
%needed for PATCH
for indx=1:size(S.Y,2)
    X=S.X{indx};
    Y=S.Y{indx};
    dist=S.dist{indx};
    sbcts=S.sbcts{indx};
    cts=S.cts{indx};
    vplts=S.vplts{indx};
    Xc=repmat(sort(repmat(X,1,sbcts)),4,1);
    Xc=Xc+repmat([dist(1:2:end);dist(2:2:end);dist(2:2:end);dist(1:2:end)],1,cts);
    Yc=reshape(Y,2,cts*sbcts,vplts);
    Yc=Yc([1 1 2 2],:,:);
    S.Xc{indx}=Xc;
    S.Yc{indx}=Yc;
    S.numcols{indx}=sbcts*vplts;
end

totalnumcols=sum(cell2mat(S.numcols));

%Use range of colormap
c=colormap;
clrindx=round(linspace(1,length(c),totalnumcols));
c=c(clrindx,:);
cindx=1;


%Instead of calling PATCH once, with all coordinates and colors specified,
%a for loop is done so that the legend will be correct; else the overall
%patch will be grouped and legend will only consist of one value.
hold on
for indx=1:size(S.Y,2)
    vplts=S.vplts{indx};
    sbcts=S.sbcts{indx};
    Yc=S.Yc{indx};
    Xc=S.Xc{indx};
    for sbctsindx=1:sbcts     %Loop through all subcategories
        for vpltsindx=1:vplts %With each vertical bar being a different color
            Yplot=Yc(:,:,vpltsindx);
            %Same color of vertical bar within subcategories among all categories
            patch(Xc(:,sbctsindx:sbcts:end),Yplot(:,sbctsindx:sbcts:end),c(cindx,:));
            cindx=cindx+1;
        end
    end
    
end
hold off

%Combine X coordinates and possible Xlabels into one
X=[];
Xlabel=[];
for indx=1:size(S.Y,2)
    X=[X S.X{indx}];
    if S.Xlabelind{indx}
        Xlabel=[Xlabel S.Xlabel{indx}];
    else
        Xlabel=[Xlabel num2cell(X)];
    end
end

[X,indx]=unique(X);
Xlabel=Xlabel(indx);

%Replace tickmarks, add labels and change scale if need be
set(gca,'XTick',X)
set(gca,'xticklabel',Xlabel)


end







%SUBFUNCTION, Parsing of inputs

function S = parsevar(args1)

%Turn cell args into struct S
%S.X         : X coordinates
%S.Y         : Y coordinates
%S.cts       : Categories
%S.sbcts     : Subcategories
%S.vplts     : Vertical categories
%S.dist      : distance vector
%S.Xlabelind : X label indicator
%S.Xlabel    : X label


%Inputs may be multiple formats depending on user specifications
%Change formatted to be consistent, one cell containing everything in the
%correct format used in parsevar

if isnumeric(args1{1})        %bars2(var1,[var2,var3,...])
    args1={{args1}};
elseif ~iscell(args1{:}{1})   %bar2(cell1) where cell1 is one row
    args1={args1};
end                           %Else its bar2(celln) where celln is n rows
args1=args1{:}; %Format to one cell, length of which is number of unique charts


%Loop through rows of cell args1,
%format and parse inputs then save to struct
%For almost every case, other then MIXED charts, the length will be one
args1rows=length(args1);

for args1indx=1:args1rows
    
    args=args1{args1indx};
    
    %Initialize
    Xlabelind=0;
    logind=0;
    Xlabel=[];
    spacing=[NaN NaN];
    
    %Find X and Y
    if numel(args)==1
        X=1:size(args{1},2);
        Y=args{1};
        %Check to see if input was just Y values and no other input
        %make into simple bar chart
        if (length(args)==1)&&(isvector(Y)), args{2}='BASE'; end
    else
        if ~isnumeric(args{2})
            X=1:size(args{1},2);
            Y=args{1};
        else
            X=args{1};
            Y=args{2};
        end
    end
    
    sz=size(Y);
    
    for i=1:numel(args)
        if isequal(args{i},'BASE')
            %X is to taken as starting from 0 or user specified value;
            %Change so it is written as [low high] to set low=0 or user
            %specified value for all
            if i==numel(args)
                tempY=zeros([sz(1)*2 sz(2)]);
            elseif (isnumeric(args{i + 1}))
                tempY=ones([sz(1)*2 sz(2)]) * args{i + 1};
            else
                tempY=zeros([sz(1)*2 sz(2)]);
            end
            tempY(2:2:end)=Y;
            Y=tempY;
        end
        if isequal(args{i},'XLABEL') Xlabelind=1; Xlabel=args{i+1}; end
        if isequal(args{i},'SPACING') spacing=args{i+1}; end
        %if isequal(args{i},'LOG') logind=1; end
        
        if isequal(args{i},'STACKED')
            tempY=zeros([sz(1)*2 sz(2) sz(3)]);
            for j=1:sz(3)
                tempY(2:2:end,:,j)=Y(:,:,j);
            end
            %Make it cumulative (stacked)
            for j=2:sz(3)
                tempY(1:2:end,:,j)=tempY(2:2:end,:,j-1);
                tempY(2:2:end,:,j)=tempY(1:2:end,:,j)+tempY(2:2:end,:,j);
            end
            Y=tempY;
        end
    end
    
    %Find how many categories, subcats , and vertical plots
    sz=size(Y);
    cts=sz(2);       %Main categories
    sbcts=sz(1)/2;   %Sub categories (within each group), divided by two since [low high] for each
    
    if length(sz)==3
        vplts=sz(3);  %(optional) number of vertical plots (default=1)
    else
        vplts=1;
    end
    
    if isnan(spacing)
        %if param not given use default
        s=1/(2*((2*sbcts)+(sbcts-1)));
        w=2*s;
    else
        w=spacing(1);
        s=spacing(2);
    end
    
    dist=[0 cumsum(repmat([w s],1,sbcts))];
    dist(end)=[];
    dist=dist-(dist(end)/2);
    
    %Catch Errors
    if length(X)~=size(Y,2)
        error('X must have same number of elements as columns of Y');
    end
    
    if (Xlabelind)&&(length(X)~=length(Xlabel))
        error('XLabel must have same number of elements as X');
    end
    
    %Save all variables to Struct and clear vars before next inputs
    S.X{args1indx}=X; clear X;
    S.Y{args1indx}=Y; clear Y;
    S.cts{args1indx}=cts; clear cts;
    S.sbcts{args1indx}=sbcts; clear sbcts;
    S.vplts{args1indx}=vplts; clear vplts;
    S.dist{args1indx}=dist; clear dist;
    S.Xlabelind{args1indx}=Xlabelind; clear Xlabelind;
    S.Xlabel{args1indx}=Xlabel; clear Xlabel;
    S.logind{args1indx}=logind; clear logind;
    
end  %Loop through args


end
