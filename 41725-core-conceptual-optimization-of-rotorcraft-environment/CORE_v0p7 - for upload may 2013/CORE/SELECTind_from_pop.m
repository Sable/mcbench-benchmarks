function Problem = SELECTind_from_pop...
    (Problem,Constraints,Objectives,Spec,sol,fval,population,scores)
% sol: pareto set
% fval: pareto set scores
% population: whole population
% scores: whole population score

disp('Evaluating pareto set feasibility and composite objective scores')
nsol = size(sol,1);
feasible= false(nsol,1);
solXset = NaN(nsol,length(Problem.activeX));
CompObjVal = zeros(nsol,1);
ParetoC = NaN(nsol,nnz(Constraints.active_cons));
for ii = 1:size(sol,1)
    
    jnk = Problem.x0;
    jnk(Problem.activeX) = sol(ii,:);
    solXset(ii,:) = jnk;
    CompObjVal(ii) = sum(fval(ii,:).*...
        Objectives.weightings(Objectives.weightings~=0)');
    ParetoC(ii,:) = EVALnonlcons(sol(ii,:),Problem,Constraints,Spec);
    buffer = .0004;
    if all(ParetoC(ii,:)-buffer<=0)
        feasible(ii,1) = true;
    else feasible(ii,1) = false;
    end
    
end

bestfeas = min(min(CompObjVal(feasible)));
if isempty(bestfeas)
    bestfeas = NaN;
end
bestfeasi = feasible & (CompObjVal == bestfeas);

fignum = 300;
figure(fignum); clf(fignum);

Objlab = Objectives.ObjLabels(Objectives.weightings~=0);
Xlab = Problem.XLabels(Problem.activeX);

[AXE, legendloc] = gen_mat_skeleton(Xlab,Objlab);
objlablen = length(Objlab);
njnk = length(Objlab)+length(Xlab);
jnkall = [scores population];
jnkpareto = [fval sol];


FeasPareto = jnkpareto(feasible,:);
solfeas = sol(feasible,:);
fvalfeas = fval(feasible,:);
CompObjValfeas = CompObjVal(feasible);

[CompObjValfeas,feassortindex] = sortrows(CompObjValfeas);
FeasPareto = FeasPareto(feassortindex,:);
solfeas = solfeas(feassortindex,:);
fvalfeas = fvalfeas(feassortindex,:);


jnkbest = jnkpareto(bestfeasi,:);
hold on
for ii = 1:njnk
    for jj = 1:njnk
        if ii>=jj% layer some scatter plots
            plot(AXE(ii,jj),...
                jnkall(:,jj),jnkall(:,ii),'MarkerEdgeColor',[.9 .9 .9],...
                'Marker','o','LineStyle','none',...
                'XDataSource',sprintf('jnkall(:,%s)',int2str(jj)),...
                'YDataSource',sprintf('jnkall(:,%s)',int2str(ii)));%,...
            %     'HandleVisibility','off');
            plot(AXE(ii,jj),...
                jnkpareto(:,jj),jnkpareto(:,ii),'ok',...
                'XDataSource',sprintf('jnkpareto(:,%s)',int2str(jj)),...
                'YDataSource',sprintf('jnkpareto(:,%s)',int2str(ii)));
            plot(AXE(ii,jj),...
                FeasPareto(:,jj),FeasPareto(:,ii),'ok',...
                'MarkerEdgeColor','k','MarkerFaceColor','b',...
                'XDataSource',sprintf('FeasPareto(:,%s)',int2str(jj)),...
                'YDataSource',sprintf('FeasPareto(:,%s)',int2str(ii)));
            plot(AXE(ii,jj),jnkbest(:,jj),jnkbest(:,ii),'.r',...
                'XDataSource',sprintf('jnkbest(:,%s)',int2str(jj)),...
                'YDataSource',sprintf('jnkbest(:,%s)',int2str(ii)));
        end
    end
end
% set(AXE(~isnan(AXE)),'XlimMode','auto','YlimMode','auto')
axeobjobj = AXE(1:objlablen,1:objlablen);
set(axeobjobj(~isnan(axeobjobj)),'Color',[.945 .969 .949]);
axeobjvar = AXE(objlablen+1:end,1:objlablen);
set(axeobjvar(:),'Color',[1 .969 .962]);
axevarvar = AXE(objlablen+1:end,objlablen+1:end);
set(axevarvar(~isnan(axevarvar)),'Color',[.961 .976 .992]);
set(AXE(logical(eye(njnk))),'Color',[1 1 1]);

hold off
linkdata(fignum,'on')

for ii = 1:njnk
    linkaxes(AXE(ii,1:ii),'y')
    linkaxes(AXE(ii:end,ii),'x')
end
legend('Population','Pareto Set','Feasible Pareto Set',...
    'Best Composite Score',...
    'Location',legendloc)
legend boxoff

% let em know that it's done
beep;pause(.5);beep;pause(.5);beep;pause(.5);beep;pause(.5);beep;pause(.5);

%% Brushing and exploration
brush(fignum,'on')
brush(fignum,'g')

objlabstr = sprintf('%-10s',Objlab{:});
itemlist{1,1} = ['Explore data\n\nIndex   Comp.Obj  ' objlabstr];
for ii = 1:nnz(feasible)
    itemlist{ii+1,1} = num2str([CompObjValfeas(ii) fvalfeas(ii,:)], '%-10.5f');
end
itemlist{end,1} = [num2str([CompObjValfeas(ii) fvalfeas(ii,:)], '%-10.5f') '\n'];
itemlist{end+1,1} = 'Don''t change X0';

chosenindex = 0;
while ~chosenindex
    chosenindex = txtmenu('Choose the index of the cadidate for new X0',itemlist);
    if ~chosenindex
        openvar('FeasPareto')
        figure(fignum);
        disp('[Objective_Values X_Vector] in variable editor')
        disp('Use brushing in variable editor and in figure to explore data.')
        disp('Hit F5 when done')
        keyboard;
    end
end

if chosenindex <= nnz(feasible)    % populate full X vector
    chosensol = solfeas(chosenindex,:);
    chosensolX = Problem.x0;
    chosensolX(Problem.activeX) = chosensol;
    Problem.x0 = chosensolX;
end

end

function [Haxes,legendloc] = gen_mat_skeleton(Xlab,Objlab)
labs = [Objlab;Xlab];
nvars = length(labs);
labelspace = .07;
gapspace = .015;
plotwidth = (1-labelspace-gapspace)/nvars;

legendloc = [labelspace+plotwidth labelspace+plotwidth*(nvars-1)...
    2*plotwidth plotwidth];

Haxes = NaN(nvars,nvars);
for ii = 1:nvars
    for jj = 1:nvars;
        if ii>=jj
            subplot('Position',...
                [labelspace+plotwidth*(jj-1) labelspace+plotwidth*(nvars-ii)...
                .98*plotwidth .98*plotwidth]);
            hold on
            Haxes(ii,jj) = gca;
            set(gcf,'Color',[1 1 1]);
            
            if ii == nvars % add x label and ticks
                xlabel(labs{jj})
            else
                set(gca,'xtick',[],'XColor',[1 1 1],'XTickLabel',[])
            end
            if jj == 1 %add y label
                ylabel(labs{ii})
            else   % take away ticks
                set(gca,'ytick',[],'YColor',[1 1 1],'YTickLabel',[])
            end
        end
    end
end
end