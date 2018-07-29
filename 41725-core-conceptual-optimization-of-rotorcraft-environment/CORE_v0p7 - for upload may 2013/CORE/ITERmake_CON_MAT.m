function Problem = ITERmake_CON_MAT(Problem, Constraints, Objectives, Spec)

disp(' ')
nxny = input('Number of instances of swept variables [7]: ');
if isempty(nxny); nxny = 7; end
nxny = round(nxny);
if nxny < 3; return; end
disp(' ')

tic;
nPPreqs = Spec.nPPrequirements;
Constraints.current_active_cons = Constraints.active_cons(1:nPPreqs);
if length(Constraints.active_cons)>nPPreqs
    Constraints.current_active_nonlcons = Constraints.active_cons(nPPreqs+1:end);
    Constraints.activeNonLLabels = Constraints.conLabels(nPPreqs+1:end);
    Constraints.activeNonLLabels = Constraints.activeNonLLabels(Constraints.current_active_nonlcons);
else
    Constraints.current_active_nonlcons = [];
    Constraints.activeNonLLabels = [];
end

Constraints.activePPLabels = Constraints.conLabels(1:nPPreqs);
Constraints.activePPLabels = Constraints.activePPLabels(Constraints.current_active_cons);

Constraints.nactiveMar = nnz(Constraints.current_active_cons);
Constraints.nactivenonL = nnz(Constraints.current_active_nonlcons);

Constraints.colors = [0 0 1
    0 1 0
    1 0 0
    0 1 1
    1 0 1];
while length(Constraints.colors)<Constraints.nactiveMar+Constraints.nactivenonL
    Constraints.colors = [Constraints.colors;Constraints.colors];
end
Constraints.colors = Constraints.colors(1:Constraints.nactiveMar+Constraints.nactivenonL);

activeX = Problem.activeX;
x0 = Problem.x0(activeX); %the x0 of active values;
nvars = nnz(activeX);
lb = Problem.lb(activeX);
ub = Problem.ub(activeX);
XLabels=Problem.XLabels(activeX);


if nvars < 2; 
    disp('Visualizer for 2 or more decision variables')
    beep; return
end

% first get values for baseline aircraft:
disp ('Evaluating baseline aircraft...')
[Constraints.C0,~,Constraints.MarStack0,...
    Constraints.NonLMarStack0] = EVALnonlcons(x0,Problem,Constraints,Spec);
[Objectives.ObjectiveValue0, Objectives.ObjVals0] = EVALobjective...
    (x0,Problem,Objectives,Spec,Constraints,'single');
nsubplots = nvars*(nvars-1)/2;
ticker = 0;
progressbar('Constraint matrix progress' , 'Subplot sweep')
Matrix(nvars,nvars).X = [];
for ii = 1:nvars;
    for jj = 1:nvars;
        if ii~=jj %make a plot from Matrix
            if jj > ii %make a carpet plot and store it
                action = ['Generating plot ' XLabels{ii} ' versus ' XLabels{jj} '...'];
                disp(action);
                [Matrix(ii,jj).X,Matrix(ii,jj).Y,Matrix(ii,jj).ObjStack,...
                    Matrix(ii,jj).MarStack,Matrix(ii,jj).feasible,...
                    Matrix(ii,jj).feasCompObj]=...
                    carpet_plot_vals(ii,jj,...
                    x0,lb,ub,Problem, Constraints, Objectives, Spec, nxny,...
                    ticker, nsubplots);
            ticker = ticker+1;
                progressbar(ticker/nsubplots);
            elseif jj < ii %just do a reflection
                Matrix(ii,jj).Y = Matrix(jj,ii).X;
                Matrix(ii,jj).X = Matrix(jj,ii).Y;
                Matrix(ii,jj).ObjStack = Matrix(jj,ii).ObjStack;
                Matrix(ii,jj).MarStack = Matrix(jj,ii).MarStack;
                Matrix(ii,jj).feasible = Matrix(jj,ii).feasible;
            end 
        end
    end
end
progressbar(1);
save
disp('Workspace saved to matlab.mat')
Tstamp = num2str(fix(clock),'%02d');
fname = ['Autosaves\CarpetMatrixData' Tstamp '.mat'];
save(fname)
toc; 
beep;pause(.5);beep;pause(.5);beep;pause(.5);
beep;pause(.1);beep;pause(.1);beep;
Haxes = CMATplot_the_carpet...
    (Matrix, Constraints,Objectives,x0,200,lb,ub,XLabels);
toc;
Problem = CMATpick_point(Problem,Constraints,Spec,Objectives,Haxes);
if get_yes_or_no('Save result to History.xls? [Y]/N: ',true)
    ITERsave_hist(Problem,Constraints,Objectives,Spec,'Visualizer');
end
end
            
function [XX,YY,ObjStack,MarsStack,feasible,feasCompObj]=...
    carpet_plot_vals(Xyind,Xxind,x0,lb,ub,...
    Problem, Constraints, Objectives, Spec, nxny,...
    ticker, nsubplots)
% nx = 9; ny = 8;
nx = nxny;
ny = nxny;

xx = linspace3(lb(Xxind),x0(Xxind),ub(Xxind),nx);
yy = linspace3(lb(Xyind),x0(Xyind),ub(Xyind),ny);

[YY,XX]=meshgrid(yy,xx);

ObjStack = NaN(nx,ny,1+Objectives.nObj);
MarsStack = NaN(nx,ny,Constraints.nactiveMar+Constraints.nactivenonL);

waitbar1tot = nx*ny-1;
waitbar1prog = 0;
progressbar([],0)
for ii = 1:length(xx)
    for jj = 1:length(yy)

        X = x0;
        X(Xxind) = xx(ii);
        X(Xyind) = yy(jj);
        if all(X==x0) %skip evaluating the seed point
            ObjStack(ii,jj,:) = ...
                [Objectives.ObjectiveValue0; Objectives.ObjVals0(:)];
            MarsStack(ii,jj,:) = -Constraints.C0(:);
        else
            C = EVALnonlcons(X,Problem,Constraints,Spec);
            MarsStack(ii,jj,:) = -C(:);
            [ObjectiveValue, ObjVals] = EVALobjective...
                (X,Problem,Objectives,Spec,Constraints,'single');
            ObjStack(ii,jj,:) = [ObjectiveValue; ObjVals(:)];
            waitbar1prog = waitbar1prog+1;
            frac2 = waitbar1prog/waitbar1tot;
            progressbar((ticker+frac2)/nsubplots,frac2)
        end
    end
end
feasible = all(MarsStack>=0,3);
feasCompObj = ObjStack(:,:,1);
feasCompObj(~feasible) = NaN;
end
