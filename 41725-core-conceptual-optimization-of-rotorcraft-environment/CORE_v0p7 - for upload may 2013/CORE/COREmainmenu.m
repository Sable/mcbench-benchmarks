global CURRENT_PROJECT
projpath = 0;
while 1
    menulist = {'Keyboard input'
        'Quit'
        'Open help'
        'Choose/create project folder\n'};
    if any(projpath) && ~isempty(CURRENT_PROJECT)
        menulist(5) = {'Load specifications from Requirements.xls\n'};
        try %#ok<TRYNC>
            load ([projpath '\Requirements.mat'])
            menulist(6) = {'Iteration menu'};
        end
    end
    mainchoice = txtmenu(['Main Menu | Current Project: '....
        CURRENT_PROJECT],menulist);
    
    switch mainchoice
        case 0 % keyboard
            disp('Type ''return'' or hit F5 to exit keyboard mode and return to main menu')
            disp(' ')
            keyboard;
            
        case 1 %quit
            break
            
        case 2 %help
            open([CORE_PARENT_DIR '\CORE\core_help.html'])
            
        case 3 % Choose or create a project to work on
            [CURRENT_PROJECT projpath] = COREchooseproject();
            %sets current directory to project folder
            
        case 4 % Create mission parameters and objective functions
            try
                COREmkrequirements();
            catch ME
                disp('FAILURE: error creating requirements')
                disp(ME)
                beep;
            end
            
        case 5 % Iterate to find the best aircraft for the job
            CORE_ITERATE(Spec);
            
    end
    
end
