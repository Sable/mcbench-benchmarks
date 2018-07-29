function [CURRENT_PROJECT projpath] = COREchooseproject()
global CORE_PARENT_DIR 

noproject = true;
while noproject
    %display directory folders
    cd(CORE_PARENT_DIR)
    D = dir(CORE_PARENT_DIR);
    disp('Existing project folders:')        
    for ii = 1:length(D)
        if D(ii).isdir == 1 && D(ii).name(1)~='.' &&...
                ~strcmp(D(ii).name,'CORE') && ~strcmp(D(ii).name,'toolbox')
            disp(D(ii).name)
        end
    end
    disp(' ')
    CURRENT_PROJECT = '';
    while isempty(CURRENT_PROJECT)
        CURRENT_PROJECT = input('Enter project name: ','s');
    end
    if isdir(CURRENT_PROJECT)
        noproject = false;
    else
        createnew = get_yes_or_no(...
            'Project folder does not exist. Ok to create new project? Y/N [Y]: ',1);
        if createnew   
            mkdir(CURRENT_PROJECT)
            mkdir([CURRENT_PROJECT '\Autosaves'])
            copyfile([CORE_PARENT_DIR '\CORE\Requirements_template.xls'],...
                [CURRENT_PROJECT '\Requirements.xls'])
            noproject = 0;
            disp(' ')
            disp('      ***************************************')
            disp('      ***************************************')
            disp('      ***************************************')
            disp(' ')
            disp(['Carefully fill in fields in ' CURRENT_PROJECT '\Requirements.xls'])
            disp(' ')
            disp('      ***************************************')
            disp('      ***************************************')
            disp('      ***************************************')
            disp(' ')
            winopen([CURRENT_PROJECT '\Requirements.xls'])
            disp('Hit F5 to continue')
            keyboard;
        end
    end
end
projpath = [CORE_PARENT_DIR '\' CURRENT_PROJECT];

cd(projpath)
end

