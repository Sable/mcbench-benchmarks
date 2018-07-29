function [Problem] = ITERfix_decision_variables(Problem)
X0 = Problem.x0;
LB = Problem.lb;
UB = Problem.ub;
XLabels = Problem.XLabels;
activeX = Problem.activeX;

equalind = LB==UB;
if any(equalind)
    activeX(equalind) = false;
    disp('Variables fixed by equivalent LB and UB set to ''fixed''')
    if any(X0(equalind) ~= LB(equalind))
        disp('WARNING: Seed values outside of fixed bounds')
        beep; pause(1)
    end
end

listitems{1,1} = 'Done\n\n\t\t Status: X0 Value: Name:';
nXtot = length(activeX);
while 1
    home; pause(.0001);
    disp('Note: Fixed design variables take the seed X0 value')
    for ii = 1:nXtot
        if activeX(ii)
            firstbit = 'Variable'; 
        else
            firstbit = '   Fixed'; 
        end
        listitems{ii+1,1} = sprintf('%s %9.3g %s',...
            firstbit,X0(ii),XLabels{ii});
    end
    subchoice = txtmenu('Select decision variable to toggle',listitems);
    if subchoice == 0;
        break
    else
        if (LB(subchoice) == UB(subchoice)) && ~activeX(subchoice)
            beep;
            if get_yes_or_no('WARNING: UB=LB. Make variable? Y/[N]: ',0)
                activeX(subchoice) = ~activeX(subchoice);
            end
        else
            activeX(subchoice) = ~activeX(subchoice);
        end
    end
end

Problem.activeX = activeX;

end
