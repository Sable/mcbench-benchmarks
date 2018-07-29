function f=radarplot(R,Lable,LineColor,FillColor,LineStyle,LevelNum)
%Creates a radar (spider) plot for multi-data series.
%edit by Cheng Li
%Tsinghua University

%INPUT: 
%R
%   Data, if R is a m*n matrix, means m samples with n options

%Label
%   Label, Label of options
%	Cells of string

%LineColor
%	Color of Line
%	Cells of MatLab colors
%
%FillColor
%	Cells of MatLab colors
%
%LineStyle
%	Cells of MatLab colors
%
%LevelNum
%	number of axis's levels
%
%Example:
%radarplot([1 2 3 4 5 6])
%radarplot([1 2 3 4 5 6;7 8 9 10 11 12.5])
%radarplot([1 2 3 4 5 6;7 8 9 10 11 12.5],{'option1','a','b','','c','d'})
%radarplot([1 2 3 4 5 6;7 8 9 10 11 12.5],{'option1','','','','',''},{'r','g'})
%radarplot([1 2 3 4 5 6;7 8 9 10 11 12.5],{'option1','','','','',''},{},{'b','r'})
%radarplot([1 2 3 4 5 6;7 8 9 10 11 12.5],{'option1','','','','',''},{'r','g'})
%radarplot([1 2 3 4 5 6;7 8 9 10 11 12.5],{'option1','','','','',''},{'r','g'},{'b','r'},{'no',':'}
%radarplot([1 2 3 4 5 6;7 8 9 10 11 12.5],{'option1','a','b','c','','e'},{'r','g'},{'b','r'},{'no',':'},5)

n=size(R,2);
m=size(R,1);

if nargin<6
    LevelNum=4;
end


R=[R R(:,1)];

[Theta,M]=meshgrid(2*pi/n*[0:n]+pi/n,ones(1,size(R,1)));

X=R.*sin(Theta);
Y=R.*cos(Theta);

A=plot(X',Y','LineWidth',2);


MAXAXIS=max(max(R))*1.1;
axis([-MAXAXIS MAXAXIS -MAXAXIS MAXAXIS]);
axis equal
axis off


if LevelNum>0
    AxisR=linspace(0,max(max(R)),LevelNum);
    for i=1:LevelNum
        text(AxisR(i)*sin(pi/n-0.3),AxisR(i)*cos(pi/n-0.3),num2str(AxisR(i),2),'FontSize',10)
    end
    [M,AxisR]=meshgrid(ones(1,n),AxisR);
    AxisR=[AxisR AxisR(:,1)];
    [AxisTheta,M]=meshgrid(2*pi/n*[0:n]+pi/n,ones(1,size(AxisR,1)));
    AxisX=AxisR.*sin(AxisTheta);
    AxisY=AxisR.*cos(AxisTheta);
    hold on
    plot(AxisX,AxisY,':k')
    plot(AxisX',AxisY',':k')
end


if nargin>1
    if length(Lable)>=n
        LableTheta=2*pi/n*[0:n-1]+pi/n;
        LableR=MAXAXIS;
        LableX=LableR.*sin(LableTheta);
        LableY=LableR.*cos(LableTheta);
        for i=1:n
            if ~sum(strcmpi({'' },Lable(i)))
                text(LableX(i), LableY(i),cell2mat(Lable(i)), 'FontSize',14,'HorizontalAlignment','center','Rotation',0)
            end
        end
    end
else
    return
end

if nargin>2
    if length(LineColor)>=m
        for i=1:m
            if sum(strcmpi({'y' 'm' 'c' 'r' 'g' 'b' 'w' 'k' },LineColor(i)))
                set(A(i),'Color',cell2mat(LineColor(i)))
            end
        end
    end
else
    return
end

if nargin>3
    if length(FillColor)>=m
        for i=1:m
            if sum(strcmpi({'y' 'm' 'c' 'r' 'g' 'b' 'w' 'k' },FillColor(i)))
                hold on;
                F=fill(X(i,:),Y(i,:),cell2mat(FillColor(i)),'LineStyle','none');
                set(F,'FaceAlpha',0.3)
            end
        end
    end
else
    return
end

if nargin>4
    if length(LineStyle)>=m
        for i=1:m
            if sum(strcmpi({'-' '--' ':' '-.'},LineStyle(i)))
                set(A(i),'LineStyle',cell2mat(LineStyle(i)))
            end
        end
    end
else
    return
end

