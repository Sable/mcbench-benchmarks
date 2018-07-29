function CORE_ITERATE(Spec)
load Requirements.mat
disp(' ')
disp('checking for recent problem setup...')

while 1
    itermenulist = {'Keyboard access to workspace'
            'Return / up menu\n\n\t\tITERATION SETUP:'
            'Create new or load'
            'Save current'
            'Save to iteration history\n\n\t\tMODIFY:'
            'Fixed/free design variables'
            'Constraint handling'
            'Composite objective'
            'Current point (manual iteration) and bounds\n\n\t\tITERATE:'
            'Run optimizer'
            'Visualize design space (constraint matrix)\n'
            'Evaluate current design point\n'};
    try
        load Recent.setup.mat Problem Constraints Objectives
    catch %#ok<CTCH>
        disp('Recent.setup.mat not found.')
        itermenulist = itermenulist(1:3);
    end

        optchoice = txtmenu('ITERATION MENU',itermenulist);
    switch optchoice
        case 0 %keyboard
            disp('Type ''return'' to exit keyboard mode')
            disp(' ')
            keyboard;

        case 1
            save Recent.setup.mat Problem Constraints Objectives
            break

        case 2 %create/load setup
            jnklist =  {'Return\n'
                'New default setup'
                'Load from .setup.mat file'
                'New default setup, retaining current design point'};
            if ~exist('Problem','var')
                jnklist(end) = [];
                jnklist{1} = '';
            end
            subchoice = txtmenu('Create/load iteration setup',jnklist);
            switch subchoice
                case 1 %new default
                    [Problem,Constraints,Objectives] = ITERoptimoptset(Spec);
                case 3 %new retaining
                    x0temp = Problem.x0;
                    [Problem,Constraints,Objectives] = ITERoptimoptset(Spec);
                    Problem.x0(1:length(x0temp)) = x0temp;
                    disp('check bounds');
                case 2 %open file
                    [setupfile,setupfilepath] = uigetfile({'*.setup.mat','Iteration Setup File'},...
                        'Choose .setup.mat file','Recent.setup.mat');
                    try
                        load([setupfilepath setupfile],'Problem',...
                            'Constraints','Objectives');
                    catch %#ok<CTCH>
                        disp('********************************')
                        disp('***** FAILED to load setup *****')
                        disp('********************************')
                        beep
                    end
            end

        case 3 %save setup
            try
                jnk=input('Enter new .setup.mat file name (overwrites) [Recent]: ','s');
                if isempty(jnk)
                    save Recent.setup.mat Problem Constraints Objectives
                else
                    save([jnk '.setup.mat'], 'Problem', ...
                        'Constraints', 'Objectives');
                end
            catch ME
                beep; disp('FAILed to write fully-defined setup')
                disp(ME)
            end
            
        case 4
            ITERsave_hist(Problem,Constraints,Objectives,Spec,'man.')
            
        case 5
            Problem = ITERfix_decision_variables(Problem);

        case 6 %modify constraint margins
            Constraints = ITERmodify_constraints(Constraints,Spec);

        case 7 %change obj func combo
            Objectives = ITERmodify_composite_obj(Objectives);
            
        case 8 % change bounds and seed
            Problem = ITERmodify_LB_X0_UB(Problem);
            
        case 9 %run an optimizer
            Problem=ITERrun_optimizer(Problem,Constraints,Objectives,Spec);

        case 10 %make the carpet matrix
            Problem =ITERmake_CON_MAT(Problem,Constraints,Objectives,Spec);
        
        case 11 %evaluate X0
            ITERevaluate_X0(Problem,Constraints,Spec,Objectives);
    end
    try
        save Recent.setup.mat Problem Constraints Objectives
    catch %#ok<CTCH>
    end
end
end