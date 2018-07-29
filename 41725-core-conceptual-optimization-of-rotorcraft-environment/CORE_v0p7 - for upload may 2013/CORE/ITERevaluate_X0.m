function [C,CompositeObjectiveValue, SingleObjectiveValues]=ITERevaluate_X0...
    (Problem,Constraints,Spec,Objectives,askflag,printflag)

if nargin < 5; askflag = true; end
if nargin < 6; printflag = true; end
if askflag
choice = txtmenu('What do you want to evaluate?',...
    'Current design point','Lower bound','Upper bound');
% choice = 0;
switch choice
    case 0
        x0 = Problem.x0(Problem.activeX);
    case 1
        x0 = Problem.lb(Problem.activeX);
    case 2
        x0 = Problem.ub(Problem.activeX);
end
else
    x0 = Problem.x0(Problem.activeX);
end
        
[C] = EVALnonlcons(x0,Problem,Constraints,Spec);

if printflag
jnk=Constraints.conLabels(Constraints.active_cons);
fprintf('%30s\t\t%s\n','CONSTRAINT','MARGIN (%)');
for ii = 1:nnz(Constraints.active_cons)
    fprintf('%30s\t\t%-3.1f\n',jnk{ii},-100*C(ii));
end
disp(' ')
end

[CompositeObjectiveValue, SingleObjectiveValues] = EVALobjective...
    (x0,Problem,Objectives,Spec,0,'single');

if printflag
jnk=Objectives.ObjLabels;


fprintf('%15s\t\t%10s\t\t%s\n','OBJECTIVE','WEIGHTING','VALUE');
for ii = 1:Objectives.nObj
    if Objectives.weightings(ii)
     fprintf('%15s\t\t%9.2f\t\t%-3.2d\n',jnk{ii},...
         Objectives.weightings(ii),SingleObjectiveValues(ii));
    end
end

disp(' ')
fprintf('Composite Objective Value:   %d\n',CompositeObjectiveValue')
end