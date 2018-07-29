function [Haxes] = CMATplot_the_carpet(...
    Matrix, Constraints,Objectives, x0, fignum,lb,ub,XLabels)

Objectives.plotall = false;
if get_yes_or_no(...
        'Plot all objectives in addition to composite objective? Y/[N]: ',false)
    Objectives.plotall = true;
    disp('Objectives with weighting of 0 not plotted')
end
disp(' ')
uppertriflag = false; %not plotting upper triangular
diagonalflag = false; %not plotting diagonal (change >= to > if you change)

Vmax = [Objectives.ObjectiveValue0; Objectives.ObjVals0(:)];
Vmin = .99*Vmax;

Haxes = gen_carpetmat_skeleton(fignum,x0,lb,ub,XLabels,uppertriflag,diagonalflag);

absbestcomp = inf;
for kk = 1:numel(Matrix)
    jnk = Matrix(kk).MarStack;
    feasible = all(jnk>=0,3);
    thisbest = Matrix(kk).ObjStack(:,:,1);
    thisbest = thisbest(feasible);
    thisbest = min(thisbest(:));
    if thisbest<absbestcomp
        absbestcomp = thisbest;
    end
end

[ii,jj] = size(Matrix);

for ii = 1:ii
    for jj = 1:jj
        if (ii > jj) || uppertriflag %|| diagonalflag

            Current_Axes=Haxes(ii,jj);
            x0loc = [x0(jj) x0(ii)];
            if ii~=jj
                plot_me(Matrix(ii,jj),Constraints,...
                    Objectives,Current_Axes,Vmin,Vmax,x0loc,absbestcomp)
            end
            plot(Current_Axes,x0(jj),x0(ii),'ok','MarkerEdgeColor','r',...
                'MarkerFaceColor','k','MarkerSize',7)
        end
    end
end

printkey(Constraints);

end

function []=printkey(Constraints)

colornames = {'Blue   ';'Green  ';'Red    ';'Cyan   ';'Magenta'};
stylenames = {'Solid  '; 'Solid  ';'Solid  ';'Solid  '};
for ii = 1:length(colornames)
    for jj = 1:length(stylenames)
        Constraints.linetype{ii,jj} = [stylenames{jj,:}, colornames{ii,:}];
    end
end
linetype=[Constraints.linetype(:);Constraints.linetype(:)];

disp('----------------- Color Key -----------------')
disp('               Constraint    Type   Color');
disp(' ')
labelstouse = [Constraints.activePPLabels;Constraints.activeNonLLabels];
for ii = 1:length(labelstouse)
    fprintf('%25s    %s\n',labelstouse{ii},linetype{ii})
end
end

function Haxes = gen_carpetmat_skeleton(fignum,x0,lb,ub,XLabels,uppertriflag,diagonalflag)

nvars = length(x0);
labelspace = .07;
gapspace = .015;
plotwidth = (1-labelspace-gapspace)/(nvars-~diagonalflag);

figure(fignum)
clf

Haxes = NaN(nvars,nvars);
for ii = 1:nvars
    for jj = 1:nvars;
        %%
        if (ii>jj) || uppertriflag  %|| diagonalflag
            subplot('Position',...
                [labelspace+plotwidth*(jj-1) labelspace+plotwidth*(nvars-ii)...
                .98*plotwidth .98*plotwidth]);
            hold on
            Haxes(ii,jj) = gca;
            axis([lb(jj) ub(jj) lb(ii) ub(ii)])
            axis manual

%             grey background
            set(gca,'Color',[.98 .98 .98])
            if ii == nvars % add x label and ticks
                xlabel(XLabels{jj},'FontSize',15,'FontWeight','demi')
            else
                set(gca,'xtick',[],'XColor',[1 1 1],'XTickLabel',[])
            end
            if jj == 1 %add y label
                ylabel(XLabels{ii},'FontSize',15,'FontWeight','demi')
            else   % take away ticks
                set(gca,'ytick',[],'YColor',[1 1 1],'YTickLabel',[])
            end
        end
    end
end
end


function plot_me(Matrix,Constraints,Objectives,Current_Axes,...
    Vmin,Vmax,x0loc,absbestcomp)
colors = {'-b';'-g';'-.r';'-c';'-m'};
colors = [colors;colors;colors;colors;colors;colors;colors;colors;colors];

MM = Matrix.MarStack;
ConLabels = [Constraints.activePPLabels;Constraints.activeNonLLabels];
Obj = Matrix.ObjStack;

X = Matrix.X;
Y = Matrix.Y;
colormap([.75 1 .75
    .75 1 .75]);
feasible = all(MM>=0,3);
if any(feasible(:))
%put in patch for point explicitly evaluated as feasible
contourf(Current_Axes,X,Y,feasible,[.999,.999],'LineColor','none');
colormap(Current_Axes,[.8 1 .9])
end

% put a dot on best composite evaluated point
CompObj = Obj(:,:,1);
CompObj(~feasible) = NaN;
tempbestcomp = min(CompObj(:));
[Indbest1,Indbest2] = find(CompObj == tempbestcomp,1);
plot(Current_Axes,X(Indbest1,Indbest2),Y(Indbest1,Indbest2),'pk')
if tempbestcomp == absbestcomp
    plot(Current_Axes,X(Indbest1,Indbest2),Y(Indbest1,Indbest2),'.r')
end


% lines
plot(Current_Axes,[x0loc(1),x0loc(1)],get(Current_Axes,'ylim'),...
    '-y','LineWidth',2)
plot(Current_Axes,get(Current_Axes,'xlim'),[x0loc(2),x0loc(2)],...
    '-y','LineWidth',2)

ObjLabels = [{'Comp.'};Objectives.ObjLabels];

buffer = .01;
for ii = 1:length(ConLabels)
    contour(Current_Axes,X,Y,-MM(:,:,ii),[-buffer,-buffer],...
        [':' colors{ii}(end)],'LineWidth',.5);
    contour(Current_Axes,X,Y,-MM(:,:,ii),[0,0],...
        ['-' colors{ii}(end)],'LineWidth',2);
    switch colors{ii}(end)
        case 'b'; col = 'blue';
        case 'g'; col = 'green';
        case 'r'; col = 'red';
        case 'c'; col = 'cyan';
        case 'm'; col = 'magenta';
        otherwise; col = 'black';
    end
    [c,h] = contour(Current_Axes,X,Y,-MM(:,:,ii),[0,0],...
        ['-' colors{ii}(end)],'LineWidth',2);
    try
    clabel(c,h,'String',['\color{' col '}' ConLabels{ii}],...
        'VerticalAlignment','bottom','LabelSpacing',10000);
    catch
    end
end

for ii = 1:size(Obj,3)
    ObjP = Obj(:,:,ii);
    if ii == 1; %Composite Objective
        contour(Current_Axes,X,Y,ObjP,[Vmax(ii),Vmax(ii)],...
            '-k','LineWidth',2.5);      
        contour(Current_Axes,X,Y,ObjP,[Vmin(ii),Vmin(ii)],...
            '--k','LineWidth',.5);
    
    elseif (Objectives.plotall && Objectives.weightings(ii-1) ...
            && ~all(ObjP(:)==ObjP(1)))
        contour(Current_Axes,X,Y,ObjP,[Vmax(ii),Vmax(ii)],...
            '-k','LineWidth',1,'LineColor',[.4 .4 .4]);
        [c,h]=contour(Current_Axes,X,Y,ObjP,[Vmax(ii),Vmax(ii)],...
            '-k','LineWidth',1,'LineColor',[.4 .4 .4]);
        if ~isempty(c) && size(c,2) > 2
            clabel(c,h,'String',ObjLabels{ii},...
                'LabelSpacing',400,'VerticalAlignment','bottom');
        end
        contour(Current_Axes,X,Y,ObjP,[Vmin(ii),Vmin(ii)],...
            '-.k','LineWidth',.5,'LineColor',[.7 .7 .7]);        
    end
end
end
