function Problem = ITERmodify_LB_X0_UB(Problem)
X0 = Problem.x0(:);
LB = Problem.lb(:);
UB = Problem.ub(:);
XLabels = Problem.XLabels;

repeat = true;
while repeat
    disp(' ')
    BOUNDS = {'Index', 'Parameter'};
    for ii = 1:length(X0)
        BOUNDS{ii+1,1} = ii;
        BOUNDS{ii+1,2} = XLabels{ii};
    end
    disp(BOUNDS);
    LB_X0_UB = [LB X0 UB];
    openvar('LB_X0_UB');
    disp (' ');
    disp('[LB X0 UB] available for editing in array editor.')
    disp('Close array editor and type ''return'' in command window when finished editing')
    keyboard;
    LB = LB_X0_UB(:,1); UB = LB_X0_UB(:,3); X0 = LB_X0_UB(:,2);
    disp('LB, X0, and UB overwritten by edited values')
    repeat = false;
    if any(UB<LB)
        disp('*******************')
        disp('UB < LB at indices:')
        disp(find(UB<LB))
        beep
        repeat = true;
    elseif any(X0<LB) || any(X0>UB)
        disp('One or more seed values outside bounds. What would you like to do?')
        k = txtmenu([],'Edit in array editor',...
            'Trim seed to bounds','Expand bounds to seed');
        if k
            lowind = X0<LB; hiind = X0>UB;
            if k == 1
                X0(lowind) = LB(lowind);
                X0(hiind) = UB(hiind);
            elseif k ==2
                LB(lowind) = X0(lowind);
                UB(hiind) = X0(hiind);
            end
        else
            repeat = true;
        end
    end
end

Problem.x0 =    X0;
Problem.lb =    LB;
Problem.ub =    UB;
