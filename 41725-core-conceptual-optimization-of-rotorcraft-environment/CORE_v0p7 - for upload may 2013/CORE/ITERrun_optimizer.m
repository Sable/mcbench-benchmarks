function Problem = ITERrun_optimizer(Problem,Constraints,Objectives,Spec)

weightings = Objectives.weightings;
if ~any(weightings)
    beep;
    disp('*********** No objective(s) to minimize. ***********')
    return
end

Prob = pre_process(Problem);

GenObjFn = @(X,objtype)...
    EVALobjective(X,Problem,Objectives,Spec,Constraints,objtype);

Prob.nonlcon = @(X) EVALnonlcons(X,Problem,Constraints,Spec);

choice = txtmenu('Choose optimizer to run',...
    {' Return / up menu\n\n\t\tRecommended global search:'
    'Multi-objective genetic algorithm'
    'Genetic algorithm\n\n\t\tRecommended local search:'
    'Nelder-Mead simplex search\n\n\t\tOther search methods:'
    'Steepest descent (fmincon)'
    'Pattern search'
    'Particle swarm'});

if any(choice==[1:2 4:5])
    GUIflag = get_yes_or_no('Leave and open optimization tool GUI? Y/[N]: ',false);
end

if (nnz(weightings) == 1) && (choice == 1) % only one objective for multi
    beep; disp('Only one objective. Using single-objective GA');
    choice = 2;
end

switch choice
    case 0
        return
    case 5 % pattern search
        methodstr = 'Pat. search';
        Prob.objective = @(X) GenObjFn(X,'Single');
        Prob.options = psoptimset(Prob.options,...
            'PlotFcns',{@psplotbestf @psplotmeshsize @psplotbestx});
        Prob.solver = 'patternsearch';
        if GUIflag
            optimtool(Prob);
            disp('Hit F5 to continue when done with GUI');
            keyboard;
        else
            [sol,fval] = patternsearch(Prob);
            Problem = single_solution_postprocess(Problem,sol,fval);
        end
        
    case 6 % particle swarm
        disp('Not supported')
        return
        
    case 1 %gamulti
        methodstr = 'MO GA';
        Prob.solver = 'gamultiobj';
        Prob.fitnessfcn = @(X) GenObjFn(X,'MultiPen');
        Prob.options.PlotFcns = {@gaplotstopping @gaplotpareto};
        
        if GUIflag
            optimtool(Prob);
            disp('Hit F5 to continue when done with GUI')
            keyboard;
        else
            
            [sol,fval,~,~,population,scores] = ...
                gamultiobj(Prob.fitnessfcn,Prob.nvars,...
                [],[],[],[],Prob.lb,Prob.ub,...
                Prob.options);
            save
            Problem = SELECTind_from_pop(Problem,Constraints,Objectives...
                ,Spec,sol,fval,population,scores);
        end
        
    case 2 %ga alone
        methodstr = 'GA';
        %set up problem
        Prob.solver = 'ga';
        Prob.fitnessfcn = @(X) GenObjFn(X,'SinglePen');
        Prob.options.PlotFcns = {@gaplotbestf @gaplotbestindiv...
            @gaplotscores @gaplotstopping};
        
        if GUIflag
            optimtool(Prob);
            disp('Hit F5 to continue when done with GUI')
            keyboard;
        else
            [sol,fval] = ga...
                (Prob.fitnessfcn,Prob.nvars,[],[],[],[],...
                Prob.lb,Prob.ub,[],Prob.options);
            Problem = single_solution_postprocess(Problem,sol,fval);
        end
        
    case 4 %fmincon
        methodstr = 'fmincon';
        Prob.options = optimset(Prob.options,...
            'TolFun', 1e-5,'TolX', 1e-5,'TolCon',1e-7,...
            'PlotFcns', {@optimplotx @optimplotfval ...
            @optimplotconstrviolation @optimplotstepsize});
        Prob.solver = 'fmincon';
        Prob.objective = @(X) GenObjFn(X,'Single');
        
        if GUIflag
            optimtool(Prob);
            disp('Hit F5 to continue when done with GUI')
            keyboard;
        else
            [sol,fval] = fmincon(...
                Prob.objective,Prob.x0,...
                [],[],[],[],Prob.lb,Prob.ub,...
                Prob.nonlcon,Prob.options);
            Problem = single_solution_postprocess(Problem,sol,fval);
        end
        
    case 3 %nelder mead
        methodstr = 'NM';
        Prob.options = optimset(Prob.options,...
            'Tolcon', 1e-6,'TolX', 1e-3,...
            'PlotFcns', {@optimplotx @optimplotfval});
        Prob.objective = @(X) GenObjFn(X,'Single');
        if get_yes_or_no('X0 feasible? [Y]/N: ',true)
            strictness = 'superstrict';
        else strictness = [];
        end
        
        [sol, fval, ~, optimizer_output] = ...
            optimize(Prob.objective, Prob.x0,...
            Prob.lb, Prob.ub, [],[],[],[],...
            Prob.nonlcon,strictness, Prob.options);
        
        jnkinfeasible = any(optimizer_output.constrviolation.nonl_ineq{1});
        if jnkinfeasible
            disp('Solution not feasible')
            disp('Constraint violoation:')
            disp(optimizer_output.constrviolation.nonl_ineq{2})
        else
            disp('Solution feasible')
        end
        
        Problem = single_solution_postprocess(Problem,sol,fval);
        
end

save(['Autosaves\OptimizerRun' num2str(fix(clock),'%02d') '.mat'])

if get_yes_or_no('Save result to History.xls? [Y]/N: ',true)
    ITERsave_hist(Problem,Constraints,Objectives,Spec,methodstr);
end

end


function Problem = pre_process(Problem)
activeX = Problem.activeX;

Problem.x0 = Problem.x0(activeX);
Problem.nvars = nnz(activeX);
Problem.lb = Problem.lb(activeX);
Problem.ub = Problem.ub(activeX);
Problem.XLabels=Problem.XLabels(activeX);

Problem.Bineq = Problem.bineq;
Problem.Beq = Problem.beq;
Problem.LB = Problem.lb;
Problem.UB = Problem.ub;

%set standard options
Problem.options = gaoptimset('PopulationSize',50,'Generations',50,...
    'TimeLimit',3600*1.5,'StallGenLimit',25,'StallTimeLimit',3600*.5,...
    'TolFun',1e-3,'TolCon',1e-4,...
    'Display','iter',...
    'InitialPopulation',Problem.x0');
Problem.options.TolX = 1e-3;
end

function Problem = single_solution_postprocess(Problem,sol,fval)
% let em know that it's done
beep;pause(.5);beep;pause(.5);beep;pause(.5);beep;pause(.5);beep;pause(.5);

% populate full X vector
solX = Problem.x0;
solX(Problem.activeX) = sol;

fprintf('New objective value: %f\n',fval)
if get_yes_or_no('Replace X0 with optimizer solution? [Y]/N: ',true)
    Problem.x0 = solX;
end
end
